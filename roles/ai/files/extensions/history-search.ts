/** Claude Code–style Ctrl+R prompt-history picker. History is global,
 * cross-session, append-only at ~/.pi/agent/prompt-history.jsonl; the current
 * session's prompts are merged in on open. ctrl+r is checked before app
 * keybindings, so it overrides `app.session.rename`; pi therefore emits a
 * benign "Extension shortcut conflict" warning at startup — expected. */

import { type ExtensionAPI, type ExtensionCommandContext, type ExtensionContext, getAgentDir, type KeybindingsManager, type Theme } from "@earendil-works/pi-coding-agent";
import { CURSOR_MARKER, type Focusable, matchesKey, renderFakeCursor, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { appendFileSync, promises as fs, type FileHandle } from "node:fs";
import { join } from "node:path";

interface HistEntry {
	text: string;
	ts: number;
}

const MAX_HISTORY = 2000;
const MAX_DISPLAY = 100;
/** Per-entry text cap, in UTF-8 bytes. */
const MAX_ENTRY_LENGTH = 8192;

/** Truncate to MAX_ENTRY_LENGTH UTF-8 bytes on a character boundary. */
function capText(s: string): string {
	if (Buffer.byteLength(s, "utf8") <= MAX_ENTRY_LENGTH) return s;
	const buf = Buffer.from(s, "utf8");
	let end = MAX_ENTRY_LENGTH;
	while (end > 0 && (buf[end]! & 0xc0) === 0x80) end--; // back to a lead byte
	return buf.subarray(0, end).toString("utf8") + " …[truncated]";
}

function flatten(s: string): string {
	return s.replace(/\r\n/g, "\n").replace(/\n/g, " ⏎ ");
}

const sleep = (ms: number): Promise<void> => new Promise((r) => setTimeout(r, ms));

function isAlive(pid: number): boolean {
	try {
		process.kill(pid, 0);
		return true;
	} catch (e: unknown) {
		return (e as NodeJS.ErrnoException)?.code !== "ESRCH";
	}
}

/** Cross-process critical section via a pid lockfile. A stale lock (holder
 * pid no longer alive) is stolen; after 100 attempts the body runs unlocked
 * (best-effort) so a wedged lock never blocks writes forever. */
async function withLock<T>(file: string, fn: () => Promise<T>): Promise<T> {
	const lock = `${file}.lock`;
	let acquired = false;
	for (let attempt = 0; attempt < 100 && !acquired; attempt++) {
		let handle: FileHandle | undefined;
		try {
			handle = await fs.open(lock, "wx", 0o600);
			await handle.writeFile(String(process.pid));
			acquired = true;
		} catch {
			// held, or write failed — fall through to steal check
		} finally {
			await handle?.close().catch(() => {});
		}
		if (acquired) break;
		// Steal a stale or invalid lock.
		try {
			const raw = (await fs.readFile(lock, "utf8")).trim();
			const pid = Number(raw);
			if (!raw || !Number.isInteger(pid) || pid <= 0 || (pid !== process.pid && !isAlive(pid))) {
				await fs.unlink(lock).catch(() => {});
				continue;
			}
		} catch {
			await fs.unlink(lock).catch(() => {});
			continue;
		}
		await sleep(20);
	}
	try {
		return await fn();
	} finally {
		if (acquired) await fs.unlink(lock).catch(() => {});
	}
}

/** Read lines newest-first. UTF-8 safe: splits on 0x0A, decodes whole spliced
 * buffers (multibyte chars straddling chunk boundaries survive), uses
 * bytesRead so a concurrently truncated file can't inject zero bytes. */
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

class HistoryStore {
	private file: string;
	entries: HistEntry[] = []; // newest first, deduped by text
	private byText = new Map<string, number>();
	// Disk-write queue (decoupled from the in-memory list).
	private pending: HistEntry[] = [];
	// In-flight drain, or null when idle.
	private flushPromise: Promise<void> | null = null;
	// Batch drain() is mid-writing, so flushSync() can recover it at exit.
	private inFlight: HistEntry[] | null = null;

	constructor(file: string) {
		this.file = file;
	}

	async load(): Promise<void> {
		const map = new Map<string, HistEntry>();
		let lineCount = 0;
		for await (const line of readLinesReverse(this.file)) {
			lineCount++;
			try {
				const obj = JSON.parse(line) as { text?: unknown; ts?: unknown };
				if (obj && typeof obj.text === "string" && typeof obj.ts === "number") {
					const text = capText(obj.text);
					const ex = map.get(text);
					if (!ex || obj.ts > ex.ts) map.set(text, { text, ts: obj.ts });
				}
			} catch {}
		}
		this.setEntries([...map.values()].sort((a, b) => b.ts - a.ts));
		if (lineCount > MAX_HISTORY * 2) await this.rewriteCompacted();
		// mode only applies on create, so fix pre-existing files.
		await fs.chmod(this.file, 0o600).catch(() => {});
	}

	private setEntries(arr: HistEntry[]): void {
		this.entries = arr.slice(0, MAX_HISTORY);
		this.byText.clear();
		this.entries.forEach((e, i) => this.byText.set(e.text, i));
	}

	/** Merge session entries; no-op rebuild if nothing changed. */
	mergeSession(sessionEntries: HistEntry[]): void {
		// Cheap changed-check via the index avoids a map+resort on every open.
		let changed = false;
		for (const e of sessionEntries) {
			const idx = this.byText.get(e.text);
			const ex = idx !== undefined ? this.entries[idx] : undefined;
			if (!ex || e.ts > ex.ts) {
				changed = true;
				break;
			}
		}
		if (!changed) return;
		const map = new Map<string, HistEntry>();
		for (const e of this.entries) map.set(e.text, e);
		for (const e of sessionEntries) {
			const ex = map.get(e.text);
			if (!ex || e.ts > ex.ts) map.set(e.text, e);
		}
		this.setEntries([...map.values()].sort((a, b) => b.ts - a.ts));
	}

	add(text: string, ts: number): void {
		text = capText(text);
		const idx = this.byText.get(text);
		if (idx !== undefined) this.entries.splice(idx, 1);
		this.entries.unshift({ text, ts });
		this.entries = this.entries.slice(0, MAX_HISTORY);
		this.byText.clear();
		this.entries.forEach((e, i) => this.byText.set(e.text, i));
		// Reuse bumps recency: always write so the reader (dedupes by text,
		// newest ts wins) surfaces reused prompts as recent after restart.
		// Drop a not-yet-flushed pending entry for the same text so one drain
		// batch doesn't write near-duplicate lines.
		const pIdx = this.pending.findIndex((e) => e.text === text);
		if (pIdx !== -1) this.pending.splice(pIdx, 1);
		this.pending.push({ text, ts });
		this.scheduleFlush();
	}

	private async writeBatch(batch: HistEntry[]): Promise<void> {
		const lines = batch.map((e) => JSON.stringify({ text: e.text, ts: e.ts }) + "\n").join("");
		await withLock(this.file, () => fs.appendFile(this.file, lines, { mode: 0o600 }));
	}

	private scheduleFlush(): void {
		if (this.flushPromise) return;
		this.flushPromise = this.drain(0)
			.catch(() => {})
			.finally(() => {
				this.flushPromise = null;
			});
	}

	/** Drain pending: splice all, write under lock, loop while items arrive.
	 * Failures reset on success (continuous input never exhausts retries);
	 * after 5 consecutive failures, stop and leave the batch in pending for
	 * shutdown()/add() to retry. */
	private async drain(failures: number): Promise<void> {
		while (this.pending.length > 0) {
			const batch = this.pending.splice(0, this.pending.length);
			this.inFlight = batch;
			try {
				await this.writeBatch(batch);
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

	/** Await the in-flight flush, then drain leftovers. Gives up on a wedged
	 * write so shutdown never hangs. */
	async shutdown(): Promise<void> {
		if (this.flushPromise) await this.flushPromise;
		while (this.pending.length > 0) {
			const batch = this.pending.splice(0, this.pending.length);
			this.inFlight = batch;
			try {
				await this.writeBatch(batch);
				this.inFlight = null;
			} catch {
				this.inFlight = null;
				this.pending.unshift(...batch);
				return; // don't hang on a wedged write
			}
		}
	}

	/** Sync drain for process exit, in case pi doesn't await session_shutdown
	 * (hard quit). Best-effort: no lock, errors swallowed. */
	flushSync(): void {
		const inFlight = this.inFlight;
		this.inFlight = null;
		const batch = this.pending.splice(0, this.pending.length);
		const all = inFlight ? [...inFlight, ...batch] : batch;
		if (all.length === 0) return;
		const lines = all.map((e) => JSON.stringify({ text: e.text, ts: e.ts }) + "\n").join("");
		try {
			appendFileSync(this.file, lines, { mode: 0o600 });
		} catch {}
	}

	/** Compact under the lock, re-reading first so concurrent appends from
	 * other sessions aren't clobbered. load()'s unlocked read may miss late
	 * appends; this re-reads inside the lock, then writes deduped+capped entries. */
	private async rewriteCompacted(): Promise<void> {
		await withLock(this.file, async () => {
			const map = new Map<string, HistEntry>();
			for await (const line of readLinesReverse(this.file)) {
				try {
					const obj = JSON.parse(line) as { text?: unknown; ts?: unknown };
					if (obj && typeof obj.text === "string" && typeof obj.ts === "number") {
						const text = capText(obj.text);
						const ex = map.get(text);
						if (!ex || obj.ts > ex.ts) map.set(text, { text, ts: obj.ts });
					}
				} catch {}
			}
			this.setEntries([...map.values()].sort((a, b) => b.ts - a.ts));
			const data = this.entries.map((e) => JSON.stringify({ text: e.text, ts: e.ts }) + "\n").join("");
			// Atomic replace (write tmp + rename) so a crash mid-write can't
			// truncate/corrupt the history file. Concurrent appends are blocked
			// by the surrounding lock; unlocked readers see old or new atomically.
			const tmp = `${this.file}.tmp`;
			try {
				await fs.writeFile(tmp, data, { mode: 0o600 });
				await fs.rename(tmp, this.file);
			} catch (err) {
				await fs.unlink(tmp).catch(() => {});
				throw err;
			}
		});
	}

	async clear(): Promise<void> {
		if (this.flushPromise) await this.flushPromise;
		this.pending = [];
		this.setEntries([]);
		await withLock(this.file, () => fs.writeFile(this.file, "", { mode: 0o600 }));
	}

	search(query: string): string[] {
		const q = query.trim().toLowerCase();
		if (!q) return this.entries.slice(0, MAX_DISPLAY).map((e) => e.text);
		const out: string[] = [];
		for (const e of this.entries) {
			if (e.text.toLowerCase().includes(q)) {
				out.push(e.text);
				if (out.length >= MAX_DISPLAY) break;
			}
		}
		return out;
	}
}

/** Extract user prompt texts+ts from session entries. For array content,
 * only `text` parts are joined (tool_result etc. skipped). */
function extractUserPrompts(entries: ReadonlyArray<unknown>): HistEntry[] {
	const out: HistEntry[] = [];
	for (const raw of entries) {
		const e = raw as {
			type?: string;
			timestamp?: string;
			message?: { role?: string; content?: unknown; timestamp?: number };
		};
		if (e.type !== "message" || e.message?.role !== "user") continue;
		const content = e.message.content;
		let text: string | undefined;
		if (typeof content === "string") {
			text = content;
		} else if (Array.isArray(content)) {
			const parts = content
				.filter(
					(p): p is { type: "text"; text: string } =>
						typeof p === "object" && p !== null && (p as { type?: string }).type === "text" && typeof (p as { text?: unknown }).text === "string",
				)
				.map((p) => p.text);
			text = parts.length > 0 ? parts.join("\n") : undefined;
		}
		if (!text || !text.trim()) continue;
		const ts = e.message.timestamp ?? (e.timestamp ? Date.parse(e.timestamp) : 0);
		out.push({ text: capText(text), ts: Number.isFinite(ts) ? ts : 0 });
	}
	return out;
}

interface PickerDone {
	accept: boolean;
	text?: string;
}

function highlightQuery(text: string, query: string, theme: Theme): string {
	const q = query.trim();
	if (!q) return theme.fg("text", text);
	const needle = q.toLowerCase();
	const lower = text.toLowerCase();
	let pos = lower.indexOf(needle);
	if (pos === -1) return theme.fg("text", text);
	let last = 0;
	let out = "";
	while (pos !== -1) {
		out += theme.fg("text", text.slice(last, pos));
		out += theme.fg("accent", text.slice(pos, pos + q.length));
		last = pos + q.length;
		pos = lower.indexOf(needle, last);
	}
	out += theme.fg("text", text.slice(last));
	return out;
}

class HistoryPicker implements Focusable {
	focused = false;

	private query = "";
	private cursor = 0;
	private items: string[] = [];
	private selected = 0;
	private cachedLines: string[] | undefined;
	private cachedWidth: number | undefined;
	private cachedRows: number | undefined;

	constructor(
		private readonly tui: { requestRender(): void },
		private readonly theme: Theme,
		private readonly store: HistoryStore,
		private readonly keybindings: KeybindingsManager,
		private readonly done: (result: PickerDone) => void,
	) {
		this.recompute();
	}

	private recompute(): void {
		this.items = this.store.search(this.query);
		if (this.selected >= this.items.length) this.selected = Math.max(0, this.items.length - 1);
		this.rerender();
	}

	private rerender(): void {
		this.cachedLines = undefined;
		this.cachedWidth = undefined;
		this.cachedRows = undefined;
		this.tui.requestRender();
	}

	handleInput(data: string): void {
		if (this.keybindings.matches(data, "tui.select.cancel") || matchesKey(data, "ctrl+c")) {
			this.done({ accept: false });
			return;
		}
		if (this.keybindings.matches(data, "tui.select.confirm") || matchesKey(data, "tab")) {
			this.done({ accept: true, text: this.items[this.selected] });
			return;
		}
		if (matchesKey(data, "up") || matchesKey(data, "ctrl+p") || matchesKey(data, "ctrl+r")) {
			if (this.items.length > 0) {
				this.selected = (this.selected - 1 + this.items.length) % this.items.length;
				this.rerender();
			}
			return;
		}
		if (matchesKey(data, "down") || matchesKey(data, "ctrl+n") || matchesKey(data, "ctrl+s")) {
			if (this.items.length > 0) {
				this.selected = (this.selected + 1) % this.items.length;
				this.rerender();
			}
			return;
		}
		if (matchesKey(data, "backspace") || matchesKey(data, "ctrl+h")) {
			if (this.cursor > 0) {
				this.query = this.query.slice(0, this.cursor - 1) + this.query.slice(this.cursor);
				this.cursor--;
				this.recompute();
			}
			return;
		}
		if (matchesKey(data, "ctrl+w")) {
			const m = this.query.slice(0, this.cursor).match(/\s*\S+\s*$/);
			if (m) {
				this.query = this.query.slice(0, this.cursor - m[0].length) + this.query.slice(this.cursor);
				this.cursor -= m[0].length;
				this.recompute();
			}
			return;
		}
		if (matchesKey(data, "ctrl+u")) {
			this.query = "";
			this.cursor = 0;
			this.recompute();
			return;
		}
		if (matchesKey(data, "home") || matchesKey(data, "ctrl+a")) {
			this.cursor = 0;
			this.rerender();
			return;
		}
		if (matchesKey(data, "end") || matchesKey(data, "ctrl+e")) {
			this.cursor = this.query.length;
			this.rerender();
			return;
		}
		if (matchesKey(data, "left") || matchesKey(data, "ctrl+b")) {
			this.cursor = Math.max(0, this.cursor - 1);
			this.rerender();
			return;
		}
		if (matchesKey(data, "right") || matchesKey(data, "ctrl+f")) {
			this.cursor = Math.min(this.query.length, this.cursor + 1);
			this.rerender();
			return;
		}
		// Printable; skip escape/control sequences.
		if (data.length > 0 && data.charCodeAt(0) !== 0x1b && data.charCodeAt(0) >= 32) {
			this.query = this.query.slice(0, this.cursor) + data + this.query.slice(this.cursor);
			this.cursor += data.length;
			this.recompute();
		}
	}

	render(width: number): string[] {
		const termRows = typeof process.stdout.rows === "number" && process.stdout.rows > 0 ? process.stdout.rows : 24;
		if (this.cachedLines && this.cachedWidth === width && this.cachedRows === termRows) return this.cachedLines;
		const th = this.theme;
		const w = Math.max(36, width);
		const pad = (s: string, len: number): string => s + " ".repeat(Math.max(0, len - visibleWidth(s)));
		const rule = () => th.fg("border", "─".repeat(w));
		const lines: string[] = [];

		const title = " prompt history ";
		const tlen = visibleWidth(title);
		const lead = Math.max(1, Math.floor((w - tlen) / 2));
		const trail = Math.max(0, w - tlen - lead);
		lines.push(th.fg("border", "─".repeat(lead)) + th.fg("dim", title) + th.fg("border", "─".repeat(trail)));

		// Scrolling viewport sized to terminal height; selected row kept visible.
		if (this.items.length === 0) {
			lines.push(pad(` ${th.fg("dim", this.query.trim() ? "No matches" : "No history yet")}`, w));
		} else {
			const overlayRows = Math.max(1, Math.floor(termRows * 0.9));
			// 4 chrome lines; reserve 2 marker rows only when the list overflows.
			const fits = this.items.length <= overlayRows - 4;
			const listHeight = Math.max(1, Math.min(this.items.length, overlayRows - 4 - (fits ? 0 : 2)));
			let start = this.selected - Math.floor(listHeight / 2);
			if (start < 0) start = 0;
			if (start + listHeight > this.items.length) start = Math.max(0, this.items.length - listHeight);
			const end = start + listHeight;
			if (start > 0) lines.push(pad(th.fg("dim", ` ↑ ${start} more`), w));
			for (let i = start; i < end; i++) {
				const sel = i === this.selected;
				const text = flatten(this.items[i]!);
				const display = truncateToWidth(text, w - 2);
				const content = ` ${display}`;
				if (sel) {
					lines.push(th.style(pad(content, w), { bg: "selectedBg", fg: "text" }));
				} else {
					lines.push(highlightQuery(content, this.query, th));
				}
			}
			if (end < this.items.length) lines.push(pad(th.fg("dim", ` ↓ ${this.items.length - end} more`), w));
		}

		lines.push(rule());

		const before = this.query.slice(0, this.cursor);
		const cursorChar = this.cursor < this.query.length ? this.query[this.cursor] : " ";
		const after = this.query.slice(this.cursor + 1);
		const marker = this.focused ? CURSOR_MARKER : "";
		lines.push(` ${before}${marker}${renderFakeCursor(cursorChar)}${after}`);

		lines.push(rule());

		this.cachedLines = lines;
		this.cachedWidth = width;
		this.cachedRows = termRows;
		return lines;
	}

	invalidate(): void {
		this.cachedLines = undefined;
		this.cachedWidth = undefined;
		this.cachedRows = undefined;
	}

	dispose(): void {}
}

export default function (pi: ExtensionAPI): void {
	const store = new HistoryStore(join(getAgentDir(), "prompt-history.jsonl"));

	const openPicker = async (ctx: ExtensionContext): Promise<void> => {
		if (ctx.mode !== "tui") return;
		// Merge on open: session_start's merge may run before entries are ready
		// right after /reload.
		store.mergeSession(extractUserPrompts(ctx.sessionManager.getEntries()));
		// setEditorText doesn't schedule a render, and the overlay's close-time
		// requestRender fires before this await resumes — force a repaint or the
		// chosen prompt stays invisible until the next keystroke.
		let tuiHandle: { requestRender(): void } | undefined;
		const result = await ctx.ui.custom<PickerDone>(
			(tui, theme, keybindings, done) => {
				tuiHandle = tui as { requestRender(): void };
				return new HistoryPicker(tui as { requestRender(): void }, theme as Theme, store, keybindings as KeybindingsManager, done);
			},
			{ overlay: true, overlayOptions: { width: "100%", maxHeight: "90%", anchor: "bottom-center" } },
		);
		if (result?.accept && result.text !== undefined && result.text !== "") {
			ctx.ui.setEditorText(result.text);
			tuiHandle?.requestRender();
		}
	};

	pi.on("session_start", async (_event, ctx) => {
		await store.load();
		store.mergeSession(extractUserPrompts(ctx.sessionManager.getEntries()));
	});

	pi.on("input", async (event) => {
		if (event.source === "extension") return;
		const text = event.text;
		if (!text || !text.trim()) return;
		store.add(text, Date.now());
	});

	// Clean shutdown (reload/new/etc.) runs the async drain; the exit handler
	// is a safety net for hard quits where pi may not await session_shutdown.
	const onExit = () => store.flushSync();
	process.on("exit", onExit);
	pi.on("session_shutdown", async () => {
		await store.shutdown();
		process.off("exit", onExit);
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
			const sessionPrompts = extractUserPrompts(ctx.sessionManager.getEntries());
			ctx.ui.notify(`history: ${store.entries.length} in memory, ${sessionPrompts.length} in current session`, "info");
		},
	});

	pi.registerCommand("history-clear", {
		description: "Clear the saved prompt history",
		handler: async (_args, ctx: ExtensionCommandContext) => {
			await store.clear();
			ctx.ui.notify("Prompt history cleared", "info");
		},
	});
}
