/**
 * rewind — Claude-Code-style file rollback for pi.
 *
 * Mirrors Claude Code's file-history engine (src/utils/fileHistory.ts,
 * from the @anthropic-ai/claude-code@2.1.88 npm sourcemap leak):
 *
 * - tool_call (write/edit): before the tool runs, if the target file isn't
 *   tracked in the most-recent snapshot, back up its current (pre-edit)
 *   content to ~/.pi/rewind/<session>/<hash>@v1. A missing source records a
 *   null backup (file-did-not-exist marker). v1 is the pre-first-edit state
 *   — the fallback used when rewinding to a checkpoint that predates the
 *   file being tracked.
 * - message_start (assistant): snapshot the current state of every tracked
 *   file, keyed by the user message id. Unchanged files reuse the previous
 *   backup (mtime COW); changed files get a new version. This pre-tools
 *   snapshot is what makes rewind correct: without it, rewinding to a later
 *   checkpoint would undo the previous turn's edits (the classic
 *   trackEdit-only bug the previous version had).
 * - agent_end: persist this run's trackEdit v1s (trackEdit itself doesn't
 *   save — one manifest rewrite per run, not per edit) and label the user
 *   message with THIS message's edits — diff between the current (post-run)
 *   state and the message_start snapshot (pre-tools). No "snap" prefix;
 *   omitted when there's no diff. Fires once per run (no multi-turn label
 *   bloat). (Renders [Nf +a/-b] before the message content in /tree — pi's
 *   tree-selector position is hardcoded; can't move to end from an extension.)
 * - restore (on /tree back to user message X / fork at X):
 *   applySnapshot — for each tracked file, restore the backup recorded for
 *   X, or the first version if X predates tracking; delete files whose backup
 *   is null (didn't exist at X).
 *
 * Persistence: append-only log at ~/.pi/rewind/<session>/manifest.jsonl —
 * trackEdit appends an "update" record (v1), makeSnapshot appends a
 * "snapshot" record (mirrors CC's appendEntry; O(record) per call, not
 * O(state)). On session_start the log is replayed, orphan backups GC'd, and
 * the log compacted to kept snapshots only. Backups are <hash>@v<version>.
 * (Migrates the old single-JSON manifest.json on first load.) Snapshots
 * survive reload/restart.
 *
 * Keyed by user message entry id (= /tree's preparation.targetId / /fork's
 * entryId). Pure filesystem, no git dependency. No-op for non-write/edit/bash
 * tools. bash `sed -i` IS intercepted (parseSedTargets mirrors CC's
 * parseSedEditCommand): target file(s) are pre-backed-up so rewind can restore
 * them. Other bash writes (echo>, cat>, python, …) stay untracked — same
 * limitation as CC (which only special-cases sed).
 *
 * ── pi event timing (why message_start(assistant) + agent_end) ───────
 * Traps that cost a lot of debugging — do NOT regress to these:
 *
 * - turn_start (turn 1): agent-core emits it (runAgentLoop, BEFORE the
 *   `for (prompt) message_start/end` loop) so the user message is NOT yet
 *   in the session → findLastUserEntry returns the PREVIOUS user message →
 *   snapshot is off-by-one. (turn 2+ turn_start is post-turn-1-tools, also
 *   wrong for a pre-tools snapshot.)
 * - message_end (user): two problems. (1) AgentMessage has NO `.id` — the
 *   session entry id is assigned by SessionManager.appendMessage, not on the
 *   message object, so `event.message.id` is undefined. (2) the host
 *   (agent-session _handleAgentEvent) runs extension handlers via
 *   _emitExtensionEvent FIRST, then calls appendMessage AFTER — so at the
 *   message_end handler the user message isn't in the session yet either.
 * - message_start (assistant): the FIRST event that is (a) after the user
 *   message is appended (message_end(user) + its append already ran, since
 *   runLoop starts after) and (b) before the turn's tool calls. So
 *   findLastUserEntry(ctx.sessionManager) here returns the correct current
 *   user message. This is the SNAPSHOT point (makeSnapshot).
 * - agent_end: post-run (all tools done), and the user message is in the
 *   session, so findLastUserEntry is correct here — use it to label with the
 *   diff (getDiffStats: current post-run vs the message_start pre-tools
 *   snapshot). No save needed — trackEdit/makeSnapshot append per-call now.
 *   Fires once per run (no multi-turn label bloat). (Earlier this used
 *   turn_end, which fired per-turn and bloated the session file with N labels
 *   per multi-turn message.)
 *
 * Differences from Claude Code: conversation rewind is handled by pi's own
 * /tree (this extension restores files only); no MessageSelector diff
 * preview (we label the /tree node with the inter-snapshot diff and prompt
 * Yes/No at restore, skipping when nothing would change); manifest-file
 * persistence instead of session storage; fork migrates the parent manifest
 * + hard-links backups (CC's copyFileHistoryForResume-style). Tracking keys
 * are absolute paths (cwd-independent) rather than cwd-relative.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { Stats } from "node:fs";
import { chmod, copyFile, link, mkdir, readFile, stat, unlink } from "node:fs/promises";
import { createHash } from "node:crypto";
import { dirname, join, resolve } from "node:path";
import {
	appendFileSync,
	copyFileSync,
	existsSync,
	mkdirSync,
	readFileSync,
	readdirSync,
	renameSync,
	rmSync,
	writeFileSync,
} from "node:fs";

const ROOT = join(process.env.HOME || process.env.USERPROFILE || "", ".pi", "rewind");
const MAX_SNAPSHOTS = 100;

// --- types (mirrors of Claude Code's fileHistory.ts) ---

/** null = the file did not exist at this version. */
type BackupFileName = string | null;

interface FileHistoryBackup {
	backupFileName: BackupFileName;
	version: number;
	backupTime: string; // ISO
}

interface FileHistorySnapshot {
	messageId: string;
	trackedFileBackups: Record<string, FileHistoryBackup>; // abs path -> backup
	timestamp: string; // ISO
}

interface FileHistoryState {
	snapshots: FileHistorySnapshot[];
	trackedFiles: Set<string>; // all paths ever tracked
	snapshotSequence: number; // monotonic activity counter (like CC)
}

// --- pure helpers ---

const hashPath = (p: string): string =>
	createHash("sha256").update(p).digest("hex").slice(0, 16);

const backupFileName = (filePath: string, version: number): string =>
	`${hashPath(filePath)}@v${version}`;

const resolveBackupPath = (name: string, sessionId: string): string =>
	join(ROOT, sessionId, name);

const errnoCode = (e: unknown): string | undefined =>
	e !== null && typeof e === "object" && "code" in e
		? String((e as { code: unknown }).code)
		: undefined;

const isENOENT = (e: unknown): boolean => errnoCode(e) === "ENOENT";

const nowIso = (): string => new Date().toISOString();

const readFileAsyncOrNull = async (path: string): Promise<string | null> => {
	try {
		return await readFile(path, "utf-8");
	} catch {
		return null;
	}
};

/** Line-level insertions/deletions between a and b via LCS. Capped at ~1M cells;
 *  above that, falls back to net line delta (bounded, approximate) so huge files
 *  can't OOM the preview. */
function lineDiffCounts(a: string, b: string): { ins: number; del: number } {
	const A = a.split("\n");
	const B = b.split("\n");
	const m = A.length;
	const n = B.length;
	if (m === 0) return { ins: n, del: 0 };
	if (n === 0) return { ins: 0, del: m };
	if ((m + 1) * (n + 1) > 1_000_000) {
		return { ins: Math.max(0, n - m), del: Math.max(0, m - n) };
	}
	const stride = n + 1;
	const dp = new Uint32Array((m + 1) * stride);
	for (let i = 1; i <= m; i++) {
		for (let j = 1; j <= n; j++) {
			dp[i * stride + j] =
				A[i - 1] === B[j - 1]
					? dp[(i - 1) * stride + (j - 1)] + 1
					: Math.max(dp[(i - 1) * stride + j], dp[i * stride + (j - 1)]);
		}
	}
	const lcs = dp[m * stride + n];
	return { ins: n - lcs, del: m - lcs };
}

/** Simple quote-aware shell tokenizer (no escape/$(...) handling — good enough
 *  for `sed -i 'script' file` forms; we bail on anything fancier). */
function shellTokenize(s: string): string[] {
	const tokens: string[] = [];
	let cur = "";
	let quote: string | null = null;
	for (const c of s) {
		if (quote) {
			if (c === quote) quote = null;
			else cur += c;
		} else if (c === '"' || c === "'") {
			quote = c;
		} else if (/\s/.test(c)) {
			if (cur) { tokens.push(cur); cur = ""; }
		} else {
			cur += c;
		}
	}
	if (cur) tokens.push(cur);
	return tokens;
}

/** Quote-aware split on top-level command separators (`;`, `&&`, `||`,
 *  `|`, `&`, newline) so a multi-statement bash command — the form the agent
 *  almost always emits (echo headers, && chains, ; sequences, newline blocks)
 *  — is parsed statement by statement instead of bailing wholesale. Quoted
 *  separators are skipped. */
function splitShellStatements(command: string): string[] {
	const parts: string[] = [];
	let cur = "";
	let quote: string | null = null;
	let i = 0;
	while (i < command.length) {
		const c = command[i]!;
		if (quote) {
			cur += c;
			if (c === quote) quote = null;
			i++;
			continue;
		}
		if (c === '"' || c === "'") {
			quote = c;
			cur += c;
			i++;
			continue;
		}
		const sep = command.slice(i).match(/^(\|\||&&|;|&|\||\n)/);
		if (sep) {
			if (cur.trim()) parts.push(cur);
			cur = "";
			i += sep[0].length;
			continue;
		}
		cur += c;
		i++;
	}
	if (cur.trim()) parts.push(cur);
	return parts;
}

/** Parse a SINGLE `sed -i ...` statement's file targets. Mirrors CC's
 *  parseSedEditCommand conservatism applied per-statement: canonical
 *  `sed -i[-suffix] [-e] 'script' file [file...]` form (starts with sed, no
 *  redirects, no unknown flags). Returns [] if this statement isn't a
 *  safe-to-parse sed in-place edit. */
function parseSedStatement(statement: string): string[] {
	const trimmed = statement.trim();
	const m = trimmed.match(/^sed\s+/);
	if (!m) return [];
	const args = shellTokenize(trimmed.slice(m[0].length));
	// bail on redirects within this statement — too ambiguous to parse safely
	for (const a of args) {
		if (a === ">" || a === ">>" || a === "<" || a === "<<" ||
			a.startsWith(">") || a.startsWith("<")) return [];
	}
	let hasI = false;
	let exprFound = false;
	const files: string[] = [];
	for (let i = 0; i < args.length; i++) {
		const a = args[i]!;
		if (a === "-i" || a === "--in-place") {
			hasI = true;
			const next = args[i + 1];
			if (next !== undefined && !next.startsWith("-") && (next === "" || next.startsWith("."))) i++; // macOS -i suffix
			continue;
		}
		if (a.startsWith("-i")) { hasI = true; continue; } // -i.bak
		if (a === "-e" || a === "--expression") { exprFound = true; i++; continue; }
		if (a.startsWith("--expression=")) { exprFound = true; continue; }
		if (a === "-E" || a === "-r" || a === "--regexp-extended") continue;
		if (a.startsWith("-")) return []; // unknown flag — bail
		if (!exprFound) { exprFound = true; continue; } // first non-flag = script
		files.push(a);
	}
	return hasI ? files : [];
}

/** Parse `sed -i ...` file targets from a (possibly compound) bash command.
 *  Splits on top-level `;`/`&&`/`||`/`|`/`&`/newline, then extracts targets
 *  from each `sed -i` statement so rewind can pre-back them up. Non-literal
 *  file args (shell variables / command substitution — can't resolve without
 *  running the shell) are skipped so no bogus null backup is recorded; same
 *  limitation as CC, which also can't track variable-path sed. Other bash
 *  writes (echo>, cat>, printf>, python, …) stay untracked. */
function parseSedTargets(command: string): string[] {
	const targets: string[] = [];
	for (const statement of splitShellStatements(command)) {
		for (const target of parseSedStatement(statement)) {
			if (target.includes("$") || target.includes("`")) continue;
			targets.push(target);
		}
	}
	return targets;
}

// --- the engine (mirrors Claude Code's fileHistory.ts) ---

/** Create a backup of filePath at `version`. ENOENT → null backup marker. */
async function createBackup(
	filePath: string,
	version: number,
	sessionId: string,
): Promise<FileHistoryBackup> {
	const name = backupFileName(filePath, version);
	const backupPath = resolveBackupPath(name, sessionId);

	let srcStats: Stats;
	try {
		srcStats = await stat(filePath);
	} catch (e: unknown) {
		if (isENOENT(e)) {
			// Source missing → record a null backup (file-did-not-exist marker).
			return { backupFileName: null, version, backupTime: nowIso() };
		}
		throw e;
	}

	// copyFile streams content; avoids OOM'ing on large tracked files (the
	// readFileSync+writeFileSync pipeline CC replaced). Lazy mkdir.
	try {
		await copyFile(filePath, backupPath);
	} catch (e: unknown) {
		if (!isENOENT(e)) throw e;
		await mkdir(dirname(backupPath), { recursive: true });
		await copyFile(filePath, backupPath);
	}
	await chmod(backupPath, srcStats.mode);

	return { backupFileName: name, version, backupTime: nowIso() };
}

/** Restore filePath from its backup. Returns false if the backup is missing. */
async function restoreBackup(
	filePath: string,
	name: string,
	sessionId: string,
): Promise<boolean> {
	const backupPath = resolveBackupPath(name, sessionId);
	let backupStats: Stats;
	try {
		backupStats = await stat(backupPath);
	} catch (e: unknown) {
		if (isENOENT(e)) return false; // backup missing — nothing to restore
		throw e;
	}
	try {
		await copyFile(backupPath, filePath);
	} catch (e: unknown) {
		if (!isENOENT(e)) throw e;
		await mkdir(dirname(filePath), { recursive: true });
		await copyFile(backupPath, filePath);
	}
	await chmod(filePath, backupStats.mode);
	return true;
}

/** Has the origin file diverged from its backup? stat (mode/size/mtime) then
 *  content. originalStatsHint skips a second stat when the caller already has one. */
async function checkOriginFileChanged(
	originalFile: string,
	name: string,
	sessionId: string,
	originalStatsHint?: Stats,
): Promise<boolean> {
	const backupPath = resolveBackupPath(name, sessionId);

	let originalStats: Stats | null = originalStatsHint ?? null;
	if (!originalStats) {
		try {
			originalStats = await stat(originalFile);
		} catch (e: unknown) {
			if (!isENOENT(e)) return true;
		}
	}
	let backupStats: Stats | null = null;
	try {
		backupStats = await stat(backupPath);
	} catch (e: unknown) {
		if (!isENOENT(e)) return true;
	}

	// one exists, one missing → changed
	if ((originalStats === null) !== (backupStats === null)) return true;
	if (originalStats === null || backupStats === null) return false; // both missing
	if (originalStats.mode !== backupStats.mode || originalStats.size !== backupStats.size) {
		return true;
	}
	// mtime optimization: if the origin predates the backup's creation, unchanged
	if (originalStats.mtimeMs < backupStats.mtimeMs) return false;
	// fall back to content comparison
	const [a, b] = await Promise.all([
		readFile(originalFile, "utf-8"),
		readFile(backupPath, "utf-8"),
	]);
	return a !== b;
}

/** First version's backup name for a path (fallback when the target snapshot
 *  predates the file being tracked). null = didn't exist in v1; undefined =
 *  no v1 found at all. */
function getBackupFileNameFirstVersion(
	trackingPath: string,
	state: FileHistoryState,
): BackupFileName | undefined {
	for (const snapshot of state.snapshots) {
		const backup = snapshot.trackedFileBackups[trackingPath];
		if (backup !== undefined && backup.version === 1) {
			return backup.backupFileName;
		}
	}
	return undefined;
}

function findSnapshot(
	state: FileHistoryState,
	messageId: string,
): FileHistorySnapshot | undefined {
	for (let i = state.snapshots.length - 1; i >= 0; i--) {
		if (state.snapshots[i]!.messageId === messageId) return state.snapshots[i];
	}
	return undefined;
}

/** Apply a snapshot to disk: restore each tracked file, delete null-marked
 *  files. Returns the list of changed file paths. */
async function applySnapshot(
	state: FileHistoryState,
	target: FileHistorySnapshot,
	sessionId: string,
): Promise<string[]> {
	const filesChanged: string[] = [];
	for (const trackingPath of state.trackedFiles) {
		try {
			const targetBackup = target.trackedFileBackups[trackingPath];
			const name: BackupFileName | undefined = targetBackup
				? targetBackup.backupFileName
				: getBackupFileNameFirstVersion(trackingPath, state);

			if (name === undefined) continue; // couldn't resolve — leave untouched
			if (name === null) {
				// file did not exist at the target → delete it if present
				try {
					await unlink(trackingPath);
					filesChanged.push(trackingPath);
				} catch (e: unknown) {
					if (!isENOENT(e)) throw e; // already absent — nothing to do
				}
				continue;
			}
			// restore only if the on-disk content has diverged from the backup
			if (await checkOriginFileChanged(trackingPath, name, sessionId)) {
				if (await restoreBackup(trackingPath, name, sessionId)) {
					filesChanged.push(trackingPath);
				}
			}
		} catch {
			// one bad file shouldn't abort the whole rewind
		}
	}
	return filesChanged;
}

/** What would rewinding to this message change on disk? Returns file count +
 *  line insertions/deletions. stat-fast for unchanged files (mtime short-
 *  circuit), line-diff only for changed ones. Mirrors Claude Code's
 *  fileHistoryGetDiffStats (CC uses the `diff` npm package; we hand-roll LCS
 *  to stay dependency-free). */
async function getDiffStats(
	state: FileHistoryState,
	messageId: string,
	sessionId: string,
): Promise<{ filesChanged: string[]; insertions: number; deletions: number } | undefined> {
	const target = findSnapshot(state, messageId);
	if (!target) return undefined;
	const filesChanged: string[] = [];
	let insertions = 0;
	let deletions = 0;
	for (const trackingPath of state.trackedFiles) {
		try {
			const targetBackup = target.trackedFileBackups[trackingPath];
			const name: BackupFileName | undefined = targetBackup
				? targetBackup.backupFileName
				: getBackupFileNameFirstVersion(trackingPath, state);
			if (name === undefined) continue;
			if (name === null) {
				// file did not exist at the checkpoint; present now = pure insertion
				const cur = await readFileAsyncOrNull(trackingPath);
				if (cur !== null) {
					filesChanged.push(trackingPath);
					insertions += cur.split("\n").length;
				}
				continue;
			}
			// stat-fast: skip the line diff when on-disk content matches the backup
			if (!(await checkOriginFileChanged(trackingPath, name, sessionId))) continue;
			const cur = await readFileAsyncOrNull(trackingPath);
			const bak = await readFileAsyncOrNull(resolveBackupPath(name, sessionId));
			if (cur === null && bak === null) continue;
			if (cur === null || bak === null) {
				// deleted since checkpoint (cur null) or backup missing (bak null)
				const lines = (cur ?? bak ?? "").split("\n").length;
				if (cur === null) deletions += lines;
				else insertions += lines;
				filesChanged.push(trackingPath);
				continue;
			}
			const { ins, del } = lineDiffCounts(bak, cur);
			if (ins || del) filesChanged.push(trackingPath);
			insertions += ins;
			deletions += del;
		} catch {
			// skip this file
		}
	}
	return { filesChanged, insertions, deletions };
}

function replaceLast<T>(arr: T[], item: T): T[] {
	const copy = arr.slice();
	if (copy.length) copy[copy.length - 1] = item;
	return copy;
}

// --- pi extension wiring ---

export default function (pi: ExtensionAPI) {
	let sessionId = "default";
	let state: FileHistoryState = {
		snapshots: [],
		trackedFiles: new Set(),
		snapshotSequence: 0,
	};

	const findLastUserEntry = (sm: any): any => {
		const entries: any[] = sm?.getBranch?.() ?? sm?.getEntries?.() ?? [];
		for (let i = entries.length - 1; i >= 0; i--) {
			const e = entries[i];
			if (e?.message?.role === "user") return e;
		}
		return undefined;
	};

	const resolveSessionId = (ctx: any): string => {
		const sf = ctx?.sessionManager?.getSessionFile?.();
		return sf ? sf.replace(/[^a-zA-Z0-9_-]/g, "_") : "default";
	};

	const manifestPath = () => join(ROOT, sessionId, "manifest.jsonl");
	const oldManifestPath = () => join(ROOT, sessionId, "manifest.json");

	// Append-only persistence (mirrors CC's session-storage appendEntry): each
	// trackEdit/makeSnapshot appends ONE record line (O(record), not O(state)).
	// Compaction (rewrite to kept snapshots only) happens once per session_start.
	const appendRecord = (rec: unknown) => {
		try {
			mkdirSync(join(ROOT, sessionId), { recursive: true });
			appendFileSync(manifestPath(), JSON.stringify(rec) + "\n");
		} catch {}
	};

	const loadManifest = (): boolean => {
		try {
			const data = readFileSync(manifestPath(), "utf8");
			const snapshots: FileHistorySnapshot[] = [];
			const trackedFiles = new Set<string>();
			for (const line of data.split("\n")) {
				if (!line.trim()) continue;
				let rec: any;
				try { rec = JSON.parse(line); } catch { continue; }
				if (rec.op === "snapshot" && rec.snapshot) {
					snapshots.push(rec.snapshot);
				} else if (rec.op === "update" && rec.path && rec.backup) {
					// apply trackEdit v1 to the most-recent snapshot (in log order)
					const last = snapshots.at(-1);
					if (last) {
						last.trackedFileBackups = { ...last.trackedFileBackups, [rec.path]: rec.backup };
						trackedFiles.add(rec.path);
					}
				}
			}
			state = {
				snapshots: snapshots.length > MAX_SNAPSHOTS ? snapshots.slice(-MAX_SNAPSHOTS) : snapshots,
				trackedFiles,
				snapshotSequence: snapshots.length,
			};
			return true;
		} catch {
			return migrateOldManifest();
		}
	};

	// One-time migration from the pre-append-only single-JSON manifest.json.
	const migrateOldManifest = (): boolean => {
		if (!existsSync(oldManifestPath())) return false;
		try {
			const m = JSON.parse(readFileSync(oldManifestPath(), "utf8"));
			const snaps: FileHistorySnapshot[] = m.snapshots ?? [];
			mkdirSync(join(ROOT, sessionId), { recursive: true });
			// old snapshots already have v1s applied → one self-contained record each
			writeFileSync(
				manifestPath(),
				snaps.map((s) => JSON.stringify({ op: "snapshot", snapshot: s }) + "\n").join(""),
			);
			state = {
				snapshots: snaps.length > MAX_SNAPSHOTS ? snaps.slice(-MAX_SNAPSHOTS) : snaps,
				trackedFiles: new Set<string>(m.trackedFiles ?? []),
				snapshotSequence: m.snapshotSequence ?? snaps.length,
			};
			try { rmSync(oldManifestPath(), { force: true }); } catch {}
			return true;
		} catch {
			return false;
		}
	};

	// Rewrite the log as one self-contained record per kept snapshot (drops
	// evicted records + folded-in updates). Once per session_start — bounds the
	// log so it doesn't grow unbounded across a long session.
	const compactLog = () => {
		try {
			const lines = state.snapshots
				.map((s) => JSON.stringify({ op: "snapshot", snapshot: s }) + "\n")
				.join("");
			const tmp = manifestPath() + ".tmp";
			writeFileSync(tmp, lines);
			renameSync(tmp, manifestPath());
		} catch {}
	};

	// Delete file copies not referenced by the manifest (e.g. a backup made
	// just before a crash that prevented the appendRecord from completing).
	const cleanOrphans = () => {
		const dir = join(ROOT, sessionId);
		if (!existsSync(dir)) return;
		const valid = new Set<string>();
		for (const snap of state.snapshots) {
			for (const b of Object.values(snap.trackedFileBackups)) {
				if (b.backupFileName) valid.add(b.backupFileName);
			}
		}
		for (const name of readdirSync(dir)) {
			if (name === "manifest.jsonl" || name === "manifest.json") continue;
			if (name.endsWith(".tmp") || !valid.has(name)) {
				try { rmSync(join(dir, name), { force: true }); } catch {}
			}
		}
	};

	// Fork/clone starts a new session file branched from the parent. Copy the
	// parent's manifest (jsonl or legacy json) + hard-link its backups into the
	// new session's dir so rewind history carries over (mirrors CC's
	// copyFileHistoryForResume). loadManifest on the new session handles either.
	const migrateFromParent = async (previousSessionFile: string) => {
		const oldSessionId = previousSessionFile.replace(/[^a-zA-Z0-9_-]/g, "_");
		if (oldSessionId === sessionId) return; // same session — no-op
		const oldDir = join(ROOT, oldSessionId);
		const oldJsonl = join(oldDir, "manifest.jsonl");
		const oldJson = join(oldDir, "manifest.json");
		const srcManifest = existsSync(oldJsonl) ? oldJsonl : existsSync(oldJson) ? oldJson : undefined;
		if (!srcManifest) return; // parent had no rewind history
		const newDir = join(ROOT, sessionId);
		const dstManifest = join(newDir, srcManifest === oldJsonl ? "manifest.jsonl" : "manifest.json");
		if (existsSync(dstManifest)) return; // don't clobber existing
		try {
			// collect backup names referenced by the parent manifest (jsonl or json)
			let snapshots: FileHistorySnapshot[] = [];
			if (srcManifest === oldJsonl) {
				for (const line of readFileSync(oldJsonl, "utf8").split("\n")) {
					if (!line.trim()) continue;
					let r: any;
					try { r = JSON.parse(line); } catch { continue; }
					if (r.op === "snapshot" && r.snapshot) snapshots.push(r.snapshot);
					else if (r.op === "update" && r.path) {
						const l = snapshots.at(-1);
						if (l) l.trackedFileBackups = { ...l.trackedFileBackups, [r.path]: r.backup };
					}
				}
			} else {
				snapshots = (JSON.parse(readFileSync(oldJson, "utf8"))).snapshots ?? [];
			}
			const names = new Set<string>();
			for (const snap of snapshots)
				for (const b of Object.values(snap.trackedFileBackups ?? {}))
					if (b?.backupFileName) names.add(b.backupFileName);
			await mkdir(newDir, { recursive: true });
			await Promise.all(
				Array.from(names, async (name) => {
					const s = join(oldDir, name);
					const d = join(newDir, name);
					try {
						await link(s, d);
					} catch (e: unknown) {
						const code = errnoCode(e);
						if (code === "EEXIST") return; // already migrated
						if (code === "ENOENT") return; // parent lost this backup
						try { await copyFile(s, d); } catch {} // cross-device → copy
					}
				}),
			);
			// manifest copied verbatim; backup names are path-hashed + stable
			copyFileSync(srcManifest, dstManifest);
		} catch {}
	};

	// --- engine entry points (stateful wrappers over the pure engine) ---

	/** Before write/edit: back up pre-edit content as v1 if not already tracked
	 *  in the most-recent snapshot. 3-phase: check → async backup → commit. */
	const trackEdit = async (filePath: string) => {
		// Phase 1: is a backup needed?
		const mostRecent = state.snapshots.at(-1);
		if (!mostRecent) return; // no snapshot to attach v1 to yet
		if (mostRecent.trackedFileBackups[filePath]) return; // already tracked

		// Phase 2: async backup (outside any state mutation).
		let backup: FileHistoryBackup;
		try {
			backup = await createBackup(filePath, 1, sessionId);
		} catch {
			return;
		}

		// Phase 3: commit with re-check (a concurrent trackEdit may have raced
		// and a makeSnapshot may have advanced the most-recent snapshot). Append ONE
		// "update" record (O(record), not O(state)) — persists the v1 immediately,
		// no batched rewrite needed.
		const latest = state.snapshots.at(-1);
		if (!latest || latest.trackedFileBackups[filePath]) return;
		state = {
			...state,
			snapshots: replaceLast(state.snapshots, {
				...latest,
				trackedFileBackups: { ...latest.trackedFileBackups, [filePath]: backup },
			}),
			trackedFiles: new Set(state.trackedFiles).add(filePath),
		};
		appendRecord({ op: "update", path: filePath, backup });
	};

	/** message_start (assistant): snapshot the current state of every tracked
	 *  file, keyed by the user message id. COW reuses unchanged backups;
	 *  MAX_SNAPSHOTS cap + evicted-backup prune. Does NOT label (agent_end
	 *  does). */
	const makeSnapshot = async (messageId: string): Promise<void> => {
		// idempotent: keep the first snapshot for this message (state-at-send)
		if (state.snapshots.at(-1)?.messageId === messageId) return;

		const mostRecent = state.snapshots.at(-1);
		const tracked = state.trackedFiles;
		const trackedFileBackups: Record<string, FileHistoryBackup> = {};

		if (mostRecent) {
			await Promise.all(
				Array.from(tracked, async (trackingPath) => {
					try {
						const latestBackup = mostRecent.trackedFileBackups[trackingPath];
						const nextVersion = latestBackup ? latestBackup.version + 1 : 1;

						let fileStats: Stats | undefined;
						try {
							fileStats = await stat(trackingPath);
						} catch (e) {
							if (!isENOENT(e)) throw e;
						}

						if (!fileStats) {
							// tracked file was deleted since the last snapshot
							trackedFileBackups[trackingPath] = {
								backupFileName: null,
								version: nextVersion,
								backupTime: nowIso(),
							};
							return;
						}

						// reuse if unchanged since the last backup (mtime COW)
						if (
							latestBackup &&
							latestBackup.backupFileName !== null &&
							!(await checkOriginFileChanged(
								trackingPath,
								latestBackup.backupFileName,
								sessionId,
								fileStats,
							))
						) {
							trackedFileBackups[trackingPath] = latestBackup;
							return;
						}

						trackedFileBackups[trackingPath] = await createBackup(
							trackingPath,
							nextVersion,
							sessionId,
						);
					} catch {
						// skip this file
					}
				}),
			);
		}

		// Inherit any tracked file not backed up above (e.g. one added by a
		// racing trackEdit during the async window).
		const lastSnapshot = state.snapshots.at(-1);
		if (lastSnapshot) {
			for (const p of state.trackedFiles) {
				if (p in trackedFileBackups) continue;
				const inherited = lastSnapshot.trackedFileBackups[p];
				if (inherited) trackedFileBackups[p] = inherited;
			}
		}

		const newSnapshot: FileHistorySnapshot = {
			messageId,
			trackedFileBackups,
			timestamp: nowIso(),
		};
		const all = [...state.snapshots, newSnapshot];
		const evicted = all.length > MAX_SNAPSHOTS ? all.slice(0, all.length - MAX_SNAPSHOTS) : [];
		state = {
			...state,
			snapshots: all.length > MAX_SNAPSHOTS ? all.slice(-MAX_SNAPSHOTS) : all,
			snapshotSequence: state.snapshotSequence + 1,
		};
		// C: delete backups referenced ONLY by evicted snapshots (not by any
		// remaining one). Without this they'd linger until the next session_start
		// cleanOrphans — CC never cleans these at all.
		if (evicted.length) {
			const remaining = new Set<string>();
			for (const s of state.snapshots)
				for (const b of Object.values(s.trackedFileBackups))
					if (b.backupFileName) remaining.add(b.backupFileName);
			for (const s of evicted)
				for (const b of Object.values(s.trackedFileBackups))
					if (b.backupFileName && !remaining.has(b.backupFileName))
						try { rmSync(resolveBackupPath(b.backupFileName, sessionId), { force: true }); } catch {}
		}
		appendRecord({ op: "snapshot", snapshot: newSnapshot });
	};

	const rewind = async (messageId: string): Promise<string[]> => {
		const target = findSnapshot(state, messageId);
		if (!target) return [];
		return applySnapshot(state, target, sessionId);
	};

	// --- pi event wiring ---

	// Reload state from disk on load/reload/restart/resume/fork. Fork/clone
	// starts a new session file branched from the parent; migrate the parent's
	// manifest + backups so rewind history survives the fork.
	pi.on("session_start", async (event: any, ctx: any) => {
		sessionId = resolveSessionId(ctx);
		state = { snapshots: [], trackedFiles: new Set(), snapshotSequence: 0 };
		if (event?.reason === "fork" && event?.previousSessionFile) {
			await migrateFromParent(event.previousSessionFile);
		}
		// Only GC orphans when the manifest loaded cleanly; otherwise skip
		// to avoid wiping valid copies if the manifest is missing/corrupt.
		if (loadManifest()) {
			cleanOrphans();
			compactLog();
		}
	});

	// Before write/edit runs, snapshot the target file's pre-edit content (v1).
	// bash `sed -i` is also intercepted: target file(s) are pre-backed-up so
	// rewind can restore them (mirrors CC's parseSedEditCommand/applySedEdit,
	// but we only pre-backup — bash runs sed itself). Tracked files are skipped
	// by trackEdit's guard (makeSnapshot already captured pre-sed at
	// message_start); this covers sed on UN-tracked files.
	pi.on("tool_call", async (event: any, ctx: any) => {
		if (event.toolName === "write" || event.toolName === "edit") {
			const raw = event.input?.path;
			if (!raw || typeof raw !== "string") return;
			await trackEdit(resolve(ctx?.cwd ?? ".", raw));
		} else if (event.toolName === "bash") {
			const cmd = event.input?.command;
			if (typeof cmd !== "string") return;
			for (const target of parseSedTargets(cmd)) {
				await trackEdit(resolve(ctx?.cwd ?? ".", target));
			}
		}
	});

	// message_start (assistant): snapshot the current state of all tracked
	// files, keyed by the user message id. Fires AFTER the user message is
	// appended (the host appends in its message_end(user) handler, which runs
	// before runLoop) and BEFORE the turn's tool calls — so findLastUserEntry
	// is the correct current message. (message_end(user) is too early —
	// event.message.id is undefined and the message isn't appended yet; turn_start
	// fires before the append too.) No label here.
	pi.on("message_start", async (event: any, ctx: any) => {
		try {
			if (event.message?.role !== "assistant") return;
			const userEntry = findLastUserEntry(ctx.sessionManager);
			const id = userEntry?.id;
			if (!id || findSnapshot(state, id)) return; // already checkpointed
			await makeSnapshot(id);
		} catch {}
	});

	// agent_end: label the user message with THIS message's edits — diff between
	// current (post-run) state and the message_start pre-tools snapshot. No
	// saveManifest (trackEdit/makeSnapshot append per-call now; persistence is
	// already done). Fires once per run (no multi-turn label bloat).
	pi.on("agent_end", async (_event, ctx) => {
		try {
			const userEntry = findLastUserEntry(ctx.sessionManager);
			if (!userEntry || !findSnapshot(state, userEntry.id)) return; // no snapshot to diff against
			const stats = await getDiffStats(state, userEntry.id, sessionId);
			if (!stats) return;
			const fc = stats.filesChanged.length;
			if (fc === 0 && stats.insertions === 0 && stats.deletions === 0) return; // no diff
			try {
				(ctx.sessionManager as any).appendLabelChange?.(
					userEntry.id,
					`${fc}f +${stats.insertions}/-${stats.deletions}`,
				);
			} catch {}
		} catch {}
	});

	const restore = async (ctx: any, entryId: string, label: string) => {
		const stats = await getDiffStats(state, entryId, sessionId);
		if (!stats) {
			if (ctx.hasUI)
				ctx.ui.notify(
					`rewind: no snapshot for entry ${entryId.slice(0, 8)} (have ${state.snapshots.length}) [${label}]`,
					"warning",
				);
			return;
		}
		// Skip the prompt (and the restore) when nothing on disk would change.
		const anyChange =
			stats.filesChanged.length > 0 || stats.insertions > 0 || stats.deletions > 0;
		if (!anyChange) {
			if (ctx.hasUI) ctx.ui.notify("rewind: files already match this checkpoint", "info");
			return;
		}
		if (!ctx.hasUI) return; // non-interactive: can't confirm, leave files untouched
		const fc = stats.filesChanged.length;
		const lines = stats.insertions + stats.deletions;
		const summary = ` (${fc} file${fc === 1 ? "" : "s"}, +${stats.insertions}/-${stats.deletions} line${
			lines === 1 ? "" : "s"
		})`;
		const choice = await ctx.ui.select(`Restore code state? (${label})${summary}`, [
			"Yes, restore code to that point",
			"No, keep current code",
		]);
		if (!choice?.startsWith("Yes")) return;
		const changed = await rewind(entryId);
		ctx.ui.notify(
			`Code restored to checkpoint (${changed.length} file${changed.length === 1 ? "" : "s"} changed)`,
			"info",
		);
	};

	pi.on("session_before_fork", async (event, ctx) => {
		await restore(ctx, event.entryId, "fork");
	});

	pi.on("session_before_tree", async (event, ctx) => {
		await restore(ctx, event.preparation.targetId, "tree");
	});
}
