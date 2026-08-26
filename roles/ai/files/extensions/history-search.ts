import { type ExtensionAPI, type ExtensionCommandContext, type ExtensionContext, getAgentDir, type KeybindingsManager, type Theme } from "@earendil-works/pi-coding-agent";
import { type Component, CURSOR_MARKER, type Focusable, matchesKey, renderFakeCursor, sliceByColumn, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { appendFileSync, promises as fs } from "node:fs";
import type { FileHandle } from "node:fs/promises";
import { join } from "node:path";

interface HistEntry {
	text: string;
	ts: number;
}

const MAX_HISTORY = 2000;
const MAX_DISPLAY = 100;
const MAX_ENTRY_LENGTH = 8192;
const TRUNC_SUFFIX = " …[truncated]";
const TRUNC_CAP = MAX_ENTRY_LENGTH - Buffer.byteLength(TRUNC_SUFFIX, "utf8");

// ── text helpers ──

function capText(s: string): string {
	if (Buffer.byteLength(s, "utf8") <= MAX_ENTRY_LENGTH) return s;
	const buf = Buffer.from(s, "utf8");
	let end = TRUNC_CAP;
	while (end > 0 && (buf[end]! & 0xc0) === 0x80) end--;
	return buf.subarray(0, end).toString("utf8") + TRUNC_SUFFIX;
}

function flatten(s: string): string {
	return s.replace(/\r\n/g, "\n").replace(/\n/g, " ⏎ ");
}

function truncateLeftToWidth(s: string, width: number): string {
	const w = visibleWidth(s);
	if (w <= width) return s;
	if (width <= 1) return "…";
	return "…" + sliceByColumn(s, w - (width - 1), width - 1);
}

// ── misc helpers ──

const sleep = (ms: number): Promise<void> => new Promise((r) => setTimeout(r, ms));

function isAlive(pid: number): boolean {
	try {
		process.kill(pid, 0);
		return true;
	} catch (e: unknown) {
		return (e as NodeJS.ErrnoException)?.code !== "ESRCH";
	}
}

// ── file locking ──

class LockNotAcquiredError extends Error {}

async function withLock<T>(file: string, fn: () => Promise<T>): Promise<T> {
	const lock = `${file}.lock`;
	const myPid = String(process.pid);
	let acquired = false;
	for (let attempt = 0; attempt < 100; attempt++) {
		let handle: FileHandle | undefined;
		try {
			handle = await fs.open(lock, "wx", 0o600);
			await handle.writeFile(myPid);
			await handle.close();
			handle = undefined;
			acquired = true;
			break;
		} catch {} finally {
			await handle?.close().catch(() => {});
		}
		try {
			const raw = (await fs.readFile(lock, "utf8")).trim();
			const pid = Number(raw);
			if (raw && Number.isInteger(pid) && pid > 0 && pid !== process.pid && isAlive(pid)) {
				await sleep(20);
				continue;
			}
		} catch {}
		await fs.unlink(lock).catch(() => {});
		await sleep(10 + Math.floor(Math.random() * 20));
	}
	if (!acquired) throw new LockNotAcquiredError(`could not acquire lock: ${lock}`);
	try {
		return await fn();
	} finally {
		await fs.unlink(lock).catch(() => {});
	}
}

// Reads non-empty lines from a file in reverse byte order, oldest-eligible
// line yielded last. ENOENT yields nothing; other read errors propagate.
async function* readLinesReverse(path: string): AsyncGenerator<string> {
	let fd: FileHandle | undefined;
	try {
		fd = await fs.open(path, "r");
		const { size } = await fd.stat();
		if (size === 0) return;
		const CHUNK = 64 * 1024;
		let pos = size;
		let pending = Buffer.alloc(0);
		while (pos > 0) {
			const readSize = Math.min(CHUNK, pos);
			pos -= readSize;
			const buf = Buffer.alloc(readSize);
			const { bytesRead } = await fd.read(buf, 0, readSize, pos);
			const combined = Buffer.concat([buf.subarray(0, bytesRead), pending]);
			pending = Buffer.alloc(0);
			let end = combined.length;
			for (let i = combined.length - 1; i >= 0; i--) {
				if (combined[i] === 0x0a) {
					if (i + 1 < end) {
						const line = combined.subarray(i + 1, end).toString("utf8");
						if (line.length > 0) yield line;
					}
					end = i;
				}
			}
			pending = combined.subarray(0, end);
		}
		if (pending.length > 0) {
			const line = pending.toString("utf8");
			if (line.length > 0) yield line;
		}
	} catch (e: unknown) {
		const code = (e as NodeJS.ErrnoException)?.code;
		if (code !== "ENOENT") throw e;
	} finally {
		await fd?.close().catch(() => {});
	}
}

// ── entry helpers ──

function serializeEntries(entries: HistEntry[]): string {
	return entries.map((e) => JSON.stringify({ text: e.text, ts: e.ts }) + "\n").join("");
}

// Merge two entry sets by text, keeping the newest ts per text, newest-first.
function mergeHistEntries(a: HistEntry[], b: HistEntry[]): HistEntry[] {
	const map = new Map<string, HistEntry>();
	const pick = (e: HistEntry): void => {
		const ex = map.get(e.text);
		if (!ex || e.ts > ex.ts) map.set(e.text, e);
	};
	for (const e of a) pick(e);
	for (const e of b) pick(e);
	return [...map.values()].sort((x, y) => y.ts - x.ts);
}

// Escaped literal regex for a query; null means "match everything".
// Every regex metacharacter is escaped, so the pattern cannot fail to compile.
function buildSearchRegex(query: string, flags: string): RegExp | null {
	const q = query.trim();
	if (!q) return null;
	return new RegExp(q.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"), flags);
}

// ── persistence ──

class HistoryFile {
	constructor(private readonly path: string) {}

	async readAll(): Promise<{ entries: HistEntry[]; lineCount: number }> {
		const entries: HistEntry[] = [];
		let lineCount = 0;
		for await (const line of readLinesReverse(this.path)) {
			lineCount++;
			try {
				const obj = JSON.parse(line) as { text?: unknown; ts?: unknown };
				if (obj && typeof obj.text === "string" && typeof obj.ts === "number") {
					entries.push({ text: capText(obj.text), ts: obj.ts });
				}
			} catch {}
		}
		return { entries, lineCount };
	}

	async append(batch: HistEntry[]): Promise<void> {
		await withLock(this.path, () => fs.appendFile(this.path, serializeEntries(batch), { mode: 0o600 }));
	}

	async clear(): Promise<void> {
		await withLock(this.path, () => fs.writeFile(this.path, "", { mode: 0o600 }));
	}

	// Re-read under lock, merge with in-memory entries, and atomically rewrite
	// a compacted file capped at MAX_HISTORY. Returns the merged set so callers
	// can refresh their in-memory copy. Throws (leaving the file untouched) on
	// write failure.
	async compact(extra: HistEntry[]): Promise<HistEntry[]> {
		return withLock(this.path, async () => {
			const { entries } = await this.readAll();
			const merged = mergeHistEntries(entries, extra).slice(0, MAX_HISTORY);
			const tmp = `${this.path}.tmp`;
			try {
				await fs.writeFile(tmp, serializeEntries(merged), { mode: 0o600 });
				await fs.rename(tmp, this.path);
				return merged;
			} catch (err) {
				await fs.unlink(tmp).catch(() => {});
				throw err;
			}
		});
	}

	appendSync(batch: HistEntry[]): void {
		appendFileSync(this.path, serializeEntries(batch), { mode: 0o600 });
	}

	async chmod(): Promise<void> {
		await fs.chmod(this.path, 0o600).catch(() => {});
	}
}

// ── coalesced writer ──
// Batches pending entries into single appends with retry/backoff. `frozen`
// pauses draining for clear/shutdown; `flushSync` is the process-exit path
// that bypasses the async lock entirely.

class FlushQueue {
	private pending: HistEntry[] = [];
	private inFlight: HistEntry[] | null = null;
	private flushPromise: Promise<void> | null = null;
	private frozen = false;

	constructor(
		private readonly write: (batch: HistEntry[]) => Promise<void>,
		private readonly writeSync: (batch: HistEntry[]) => void,
	) {}

	push(entry: HistEntry): void {
		const idx = this.pending.findIndex((e) => e.text === entry.text);
		if (idx !== -1) this.pending.splice(idx, 1);
		this.pending.push(entry);
		this.schedule();
	}

	clearPending(): void {
		this.pending = [];
	}

	freeze(): void {
		this.frozen = true;
	}

	unfreeze(): void {
		this.frozen = false;
		if (this.pending.length > 0) this.schedule();
	}

	idle(): Promise<void> {
		return this.flushPromise ?? Promise.resolve();
	}

	flushSync(): void {
		const inFlight = this.inFlight;
		this.inFlight = null;
		const batch = this.pending.splice(0, this.pending.length);
		const all = inFlight ? [...inFlight, ...batch] : batch;
		if (all.length === 0) return;
		try {
			this.writeSync(all);
		} catch {}
	}

	// Single-attempt drain (no retry) for graceful shutdown.
	async shutdown(): Promise<boolean> {
		this.frozen = true;
		try {
			if (this.flushPromise) await this.flushPromise;
			while (this.pending.length > 0) {
				const batch = this.pending.splice(0, this.pending.length);
				this.inFlight = batch;
				try {
					await this.write(batch);
					this.inFlight = null;
				} catch {
					this.inFlight = null;
					this.pending.unshift(...batch);
					return false;
				}
			}
			return true;
		} finally {
			this.frozen = false;
			if (this.pending.length > 0) this.schedule();
		}
	}

	private schedule(): void {
		if (this.frozen || this.flushPromise) return;
		this.flushPromise = this.drain(0)
			.catch(() => {})
			.finally(() => {
				this.flushPromise = null;
			});
	}

	private async drain(failures: number): Promise<void> {
		while (this.pending.length > 0) {
			const batch = this.pending.splice(0, this.pending.length);
			this.inFlight = batch;
			try {
				await this.write(batch);
				this.inFlight = null;
				failures = 0;
			} catch {
				this.inFlight = null;
				this.pending.unshift(...batch);
				if (++failures > 5) return;
				await sleep(500);
			}
		}
	}
}

// ── in-memory store ──

class HistoryStore {
	entries: HistEntry[] = [];
	loadDone: Promise<void> | null = null;
	private readonly file: HistoryFile;
	private readonly queue: FlushQueue;
	private byText = new Map<string, number>();

	constructor(path: string) {
		this.file = new HistoryFile(path);
		this.queue = new FlushQueue(
			(batch) => this.file.append(batch),
			(batch) => this.file.appendSync(batch),
		);
	}

	async load(): Promise<void> {
		const { entries, lineCount } = await this.file.readAll();
		this.setEntries(mergeHistEntries(entries, this.entries));
		if (lineCount > MAX_HISTORY * 2) {
			try {
				await this.queue.idle();
				this.setEntries(await this.file.compact(this.entries));
			} catch {}
		}
		await this.file.chmod();
	}

	private setEntries(arr: HistEntry[]): void {
		this.entries = arr.slice(0, MAX_HISTORY);
		this.reindex();
	}

	private reindex(): void {
		this.byText.clear();
		for (let i = 0; i < this.entries.length; i++) this.byText.set(this.entries[i]!.text, i);
	}

	add(text: string, ts: number): void {
		text = capText(text);
		const idx = this.byText.get(text);
		if (idx !== undefined) this.entries.splice(idx, 1);
		this.entries.unshift({ text, ts });
		if (this.entries.length > MAX_HISTORY) this.entries.length = MAX_HISTORY;
		this.reindex();
		this.queue.push({ text, ts });
	}

	search(query: string): string[] {
		const re = buildSearchRegex(query, "i");
		const out: string[] = [];
		for (const e of this.entries) {
			if (!re || re.test(e.text)) {
				out.push(e.text);
				if (out.length >= MAX_DISPLAY) break;
			}
		}
		return out;
	}

	async clear(): Promise<void> {
		this.queue.freeze();
		try {
			await this.queue.idle();
			await this.file.clear();
			this.queue.clearPending();
			this.setEntries([]);
		} finally {
			this.queue.unfreeze();
		}
	}

	async shutdown(): Promise<boolean> {
		return this.queue.shutdown();
	}

	flushSync(): void {
		this.queue.flushSync();
	}
}

// ── TUI ──

interface PickerDone {
	accept: boolean;
	text?: string;
}

function highlightQuery(text: string, re: RegExp | null, theme: Theme): string {
	if (!re) return theme.fg("text", text);
	let out = "";
	let last = 0;
	for (const m of text.matchAll(re)) {
		const pos = m.index ?? 0;
		out += theme.fg("text", text.slice(last, pos));
		out += theme.fg("accent", text.slice(pos, pos + m[0].length));
		last = pos + m[0].length;
	}
	out += theme.fg("text", text.slice(last));
	return out;
}

class QueryField {
	private text = "";
	private cursor = 0;

	get value(): string {
		return this.text;
	}

	insert(data: string): void {
		if (data.length === 0 || data.charCodeAt(0) === 0x1b || data.charCodeAt(0) < 32) return;
		const esc = data.indexOf("\x1b");
		const segment = esc === -1 ? data : data.slice(0, esc);
		const cleaned = segment.replace(/[\x00-\x1f\x7f]/g, "");
		if (cleaned.length === 0) return;
		const cps = Array.from(this.text);
		const insertCps = Array.from(cleaned);
		cps.splice(this.cursor, 0, ...insertCps);
		this.text = cps.join("");
		this.cursor += insertCps.length;
	}

	backspace(): void {
		if (this.cursor <= 0) return;
		const cps = Array.from(this.text);
		cps.splice(this.cursor - 1, 1);
		this.text = cps.join("");
		this.cursor--;
	}

	deleteWord(): void {
		const cps = Array.from(this.text);
		const m = cps.slice(0, this.cursor).join("").match(/\s*\S+\s*$/);
		if (!m) return;
		const removed = Array.from(m[0]).length;
		cps.splice(this.cursor - removed, removed);
		this.text = cps.join("");
		this.cursor -= removed;
	}

	clear(): void {
		this.text = "";
		this.cursor = 0;
	}

	moveHome(): void {
		this.cursor = 0;
	}

	moveEnd(): void {
		this.cursor = Array.from(this.text).length;
	}

	moveLeft(): void {
		this.cursor = Math.max(0, this.cursor - 1);
	}

	moveRight(): void {
		this.cursor = Math.min(Array.from(this.text).length, this.cursor + 1);
	}

	renderInput(width: number, focused: boolean): string {
		const cps = Array.from(this.text);
		const before = cps.slice(0, this.cursor).join("");
		const cursorChar = this.cursor < cps.length ? cps[this.cursor]! : " ";
		const after = cps.slice(this.cursor + 1).join("");
		const marker = focused ? CURSOR_MARKER : "";
		const avail = Math.max(0, width - 1);
		const cursorW = Math.max(1, visibleWidth(cursorChar));
		let beforeStr = before;
		let afterStr = after;
		if (visibleWidth(beforeStr) + cursorW + visibleWidth(afterStr) > avail) {
			let beforeBudget = avail - cursorW;
			if (beforeBudget < 0) beforeBudget = 0;
			if (visibleWidth(beforeStr) > beforeBudget) beforeStr = truncateLeftToWidth(beforeStr, beforeBudget);
			const afterBudget = Math.max(0, avail - cursorW - visibleWidth(beforeStr));
			if (visibleWidth(afterStr) > afterBudget) afterStr = truncateToWidth(afterStr, afterBudget, "…");
		}
		return ` ${beforeStr}${marker}${renderFakeCursor(cursorChar)}${afterStr}`;
	}
}

class HistoryPicker implements Component, Focusable {
	focused = false;

	private query = new QueryField();
	private items: string[] = [];
	private selected = 0;
	private listHeight = 0;
	private pasteActive = false;
	private cache: { lines: string[]; width: number; rows: number } | undefined;

	constructor(
		private readonly tui: { requestRender(): void },
		private readonly theme: Theme,
		private readonly store: HistoryStore,
		private readonly keybindings: KeybindingsManager,
		private readonly done: (result: PickerDone) => void,
	) {
		this.recompute();
	}

	private termRows(): number {
		return typeof process.stdout.rows === "number" && process.stdout.rows > 0 ? process.stdout.rows : 24;
	}

	private recompute(): void {
		this.items = this.store.search(this.query.value);
		if (this.selected >= this.items.length) this.selected = Math.max(0, this.items.length - 1);
		this.listHeight = this.computeListHeight(this.items.length);
		this.rerender();
	}

	private computeListHeight(itemCount: number): number {
		const overlayRows = Math.max(1, Math.floor(this.termRows() * 0.9));
		const fits = itemCount <= overlayRows - 4;
		return Math.max(1, Math.min(itemCount, overlayRows - 4 - (fits ? 0 : 2)));
	}

	private rerender(): void {
		this.cache = undefined;
		this.tui.requestRender();
	}

	private moveBy(delta: number, wrap: boolean): void {
		if (this.items.length === 0) return;
		if (wrap) {
			this.selected = (this.selected + delta + this.items.length) % this.items.length;
		} else if (delta < 0) {
			this.selected = Math.max(0, this.selected + delta);
		} else {
			this.selected = Math.min(this.items.length - 1, this.selected + delta);
		}
		this.rerender();
	}

	handleInput(data: string): void {
		if (this.pasteActive || data.startsWith("\x1b[200~")) {
			if (data.startsWith("\x1b[200~")) {
				data = data.slice(6);
				this.pasteActive = true;
			}
			const endIdx = data.indexOf("\x1b[201~");
			if (endIdx !== -1) {
				data = data.slice(0, endIdx) + data.slice(endIdx + 6);
				this.pasteActive = false;
			}
			this.query.insert(data);
			this.recompute();
			return;
		}
		if (data.includes("\x1b[201~")) data = data.replace(/\x1b\[201~/g, "");

		const kb = this.keybindings;
		if (kb.matches(data, "tui.select.cancel") || matchesKey(data, "ctrl+c")) {
			this.done({ accept: false });
			return;
		}
		if (kb.matches(data, "tui.select.confirm") || matchesKey(data, "tab")) {
			this.done({ accept: true, text: this.items[this.selected] });
			return;
		}
		if (kb.matches(data, "tui.select.up") || matchesKey(data, "ctrl+p") || matchesKey(data, "ctrl+s")) {
			this.moveBy(-1, true);
			return;
		}
		if (kb.matches(data, "tui.select.down") || matchesKey(data, "ctrl+n") || matchesKey(data, "ctrl+r")) {
			this.moveBy(1, true);
			return;
		}
		if (kb.matches(data, "tui.select.pageUp") || matchesKey(data, "pageUp")) {
			this.moveBy(-Math.max(1, this.listHeight), false);
			return;
		}
		if (kb.matches(data, "tui.select.pageDown") || matchesKey(data, "pageDown")) {
			this.moveBy(Math.max(1, this.listHeight), false);
			return;
		}
		if (matchesKey(data, "backspace") || matchesKey(data, "ctrl+h")) {
			this.query.backspace();
			this.recompute();
			return;
		}
		if (matchesKey(data, "ctrl+w")) {
			this.query.deleteWord();
			this.recompute();
			return;
		}
		if (matchesKey(data, "ctrl+u")) {
			this.query.clear();
			this.recompute();
			return;
		}
		if (matchesKey(data, "home") || matchesKey(data, "ctrl+a")) {
			this.query.moveHome();
			this.rerender();
			return;
		}
		if (matchesKey(data, "end") || matchesKey(data, "ctrl+e")) {
			this.query.moveEnd();
			this.rerender();
			return;
		}
		if (matchesKey(data, "left") || matchesKey(data, "ctrl+b")) {
			this.query.moveLeft();
			this.rerender();
			return;
		}
		if (matchesKey(data, "right") || matchesKey(data, "ctrl+f")) {
			this.query.moveRight();
			this.rerender();
			return;
		}
		this.query.insert(data);
		this.recompute();
	}

	render(width: number): string[] {
		const termRows = this.termRows();
		if (this.cache && this.cache.width === width && this.cache.rows === termRows) return this.cache.lines;
		const th = this.theme;
		const w = Math.max(1, width);
		const pad = (s: string, len: number): string => s + " ".repeat(Math.max(0, len - visibleWidth(s)));
		const rule = (): string => th.fg("border", "─".repeat(w));
		const lines: string[] = [];

		const title = " prompt history ";
		const tlen = visibleWidth(title);
		const lead = Math.max(1, Math.floor((w - tlen) / 2));
		const trail = Math.max(0, w - tlen - lead);
		lines.push(th.fg("border", "─".repeat(lead)) + th.fg("dim", title) + th.fg("border", "─".repeat(trail)));

		if (this.items.length === 0) {
			this.listHeight = 0;
			lines.push(pad(` ${th.fg("dim", this.query.value.trim() ? "No matches" : "No history yet")}`, w));
		} else {
			const listHeight = this.computeListHeight(this.items.length);
			this.listHeight = listHeight;
			let start = this.selected - Math.floor(listHeight / 2);
			if (start < 0) start = 0;
			if (start + listHeight > this.items.length) start = Math.max(0, this.items.length - listHeight);
			const end = start + listHeight;
			const re = buildSearchRegex(this.query.value, "gi");
			if (start > 0) lines.push(pad(th.fg("dim", ` ↑ ${start} more`), w));
			for (let i = start; i < end; i++) {
				const sel = i === this.selected;
				const text = flatten(this.items[i]!);
				const display = truncateToWidth(text, w - 2, "…");
				const content = ` ${display}`;
				const highlighted = highlightQuery(content, re, th);
				const padded = pad(highlighted, w);
				lines.push(sel ? th.style(padded, { bg: "selectedBg", fg: "text" }) : padded);
			}
			if (end < this.items.length) lines.push(pad(th.fg("dim", ` ↓ ${this.items.length - end} more`), w));
		}

		lines.push(rule());
		lines.push(this.query.renderInput(w, this.focused));
		lines.push(rule());

		this.cache = { lines, width, rows: termRows };
		return lines;
	}

	invalidate(): void {
		this.cache = undefined;
	}

	dispose(): void {}
}

export default function (pi: ExtensionAPI): void {
	const store = new HistoryStore(join(getAgentDir(), "prompt-history.jsonl"));

	const openPicker = async (ctx: ExtensionContext): Promise<void> => {
		if (ctx.mode !== "tui") return;
		if (store.loadDone) await store.loadDone.catch(() => {});
		let tuiHandle: { requestRender(): void } | undefined;
		const result = await ctx.ui.custom<PickerDone>(
			(tui, theme, keybindings, done) => {
				tuiHandle = tui;
				return new HistoryPicker(tui, theme, store, keybindings, done);
			},
			{ overlay: true, overlayOptions: { width: "100%", maxHeight: "90%", anchor: "bottom-center" } },
		);
		if (result?.accept && result.text !== undefined && result.text !== "") {
			ctx.ui.setEditorText(result.text);
			tuiHandle?.requestRender();
		}
	};

	pi.on("session_start", async () => {
		store.loadDone = store.load();
		await store.loadDone;
	});

	pi.on("input", async (event) => {
		if (event.source !== "interactive") return;
		const text = event.text;
		if (!text || !text.trim()) return;
		store.add(text, Date.now());
	});

	const onExit = () => store.flushSync();
	process.on("exit", onExit);
	pi.on("session_shutdown", async (event) => {
		await store.shutdown();
		if (event.reason === "reload") process.off("exit", onExit);
	});

	pi.registerShortcut("ctrl+r", {
		description: "Search prompt history",
		handler: (ctx) => openPicker(ctx),
	});

	pi.registerCommand("history", {
		description: "Search prompt history (Ctrl+R)",
		handler: (_args, ctx) => openPicker(ctx),
	});

	pi.registerCommand("history-stats", {
		description: "Show prompt-history counts (diagnostic)",
		handler: async (_args, ctx: ExtensionCommandContext) => {
			ctx.ui.notify(`history: ${store.entries.length} prompts`, "info");
		},
	});

	pi.registerCommand("history-clear", {
		description: "Clear the saved prompt history",
		handler: async (_args, ctx: ExtensionCommandContext) => {
			try {
				await store.clear();
				ctx.ui.notify("Prompt history cleared", "info");
			} catch {
				ctx.ui.notify("Could not clear history (lock busy); try again", "error");
			}
		},
	});
}
