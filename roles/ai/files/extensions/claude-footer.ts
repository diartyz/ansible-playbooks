/**
 * yuan-footer — claude-style single-line footer with ¥ cost.
 *
 * Replaces the built-in footer (ctx.ui.setFooter) with one line:
 *   model | ctx% of ctx | ↓in ↑out ✓hit% | ¥cost | thinking-level | v<version>
 *
 * Uses the model display name (ctx.model.name); the "ali" provider's model
 * is named "ali-...", so the dashscope prefix is inherent.
 *
 * Token/cost figures are cumulative across the session
 * (ctx.sessionManager.getEntries()). Cost uses pi's per-message
 * usage.cost.total, computed from the ¥ pricing in models.json — so ¥ is
 * honest, unlike the built-in footer's hardcoded `$`.
 *
 * Thinking level is initialized from settings `defaultThinkingLevel`
 * (~/.pi/agent/settings.json) and updated via the `thinking_level_select`
 * event (ctx does not expose it directly).
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import { VERSION, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const fmt = (n: number): string => {
	if (n < 1000) return `${n}`;
	if (n < 10000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1_000_000) return `${Math.round(n / 1000)}k`;
	if (n < 10_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
	return `${Math.round(n / 1_000_000)}M`;
};

function readDefaultThinkingLevel(): string {
	try {
		const home = process.env.HOME || process.env.USERPROFILE || "";
		const s = JSON.parse(readFileSync(`${home}/.pi/agent/settings.json`, "utf8"));
		return s?.defaultThinkingLevel || "off";
	} catch {
		return "off";
	}
}

export default function (pi: ExtensionAPI) {
	let thinkingLevel = readDefaultThinkingLevel();

	pi.on("thinking_level_select", async (e) => {
		thinkingLevel = e.level;
	});

	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());
			const dim = (s: string) => theme.fg("dim", s);
			const ellipsis = dim("...");

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					// cumulative token + cost totals
					let input = 0,
						output = 0,
						cacheRead = 0,
						cacheWrite = 0,
						cost = 0;
					for (const e of ctx.sessionManager.getEntries()) {
						if (e.type === "message" && e.message.role === "assistant") {
							const m = e.message as AssistantMessage;
							input += m.usage.input;
							output += m.usage.output;
							cacheRead += m.usage.cacheRead;
							cacheWrite += m.usage.cacheWrite;
							cost += m.usage.cost.total;
						}
					}

					const parts: string[] = [];
					parts.push(ctx.model?.name || ctx.model?.id || "no-model");

					const cu = ctx.getContextUsage();
					if (cu && cu.contextWindow) {
						const pct = cu.percent === null ? "?" : cu.percent.toFixed(1);
						parts.push(`${pct}% of ${fmt(cu.contextWindow)}`);
					}

					const tok: string[] = [];
					if (input || output) tok.push(`↓${fmt(input)} ↑${fmt(output)}`);
					if (cacheRead > 0 || cacheWrite > 0) {
						const req = input + cacheRead + cacheWrite;
						if (req > 0) tok.push(`✓${((cacheRead / req) * 100).toFixed(1)}%`);
					}
					if (tok.length) parts.push(tok.join(" "));

					if (cost > 0) parts.push(`¥${cost.toFixed(2)}`);

					if (ctx.model?.reasoning) {
						if (thinkingLevel && thinkingLevel !== "off") {
							parts.push(`${thinkingLevel} thinking`);
						} else {
							parts.push("fast");
						}
					}

					const version = dim(`v${VERSION}`);
					const left = dim(parts.join(" | "));
					const leftW = visibleWidth(left);
					const rightW = visibleWidth(version);
					let line: string;
					if (leftW + 2 + rightW <= width) {
						line = left + " ".repeat(width - leftW - rightW) + version;
					} else {
						line = truncateToWidth(left + dim(" | ") + version, width, ellipsis);
					}
					const lines = [line];
					const statuses = footerData.getExtensionStatuses?.();
					if (statuses?.size) {
						lines.push(dim([...statuses.entries()].map(([k, v]) => `${k}: ${v}`).join("  ")));
					}
					return lines;
				},
			};
		});
	});
}
