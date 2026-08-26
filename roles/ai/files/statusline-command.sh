#!/usr/bin/env bash
esc=$'\x1b'
IFS='|' read -r model ctx_used ctx_total in_total out_total in_req cache_read cache_create fast effort thinking version < <(
  jq -r '[
    .model.display_name // "",
    .context_window.used_percentage // "",
    .context_window.context_window_size // "",
    .context_window.total_input_tokens // "",
    .context_window.total_output_tokens // "",
    .context_window.current_usage.input_tokens // "",
    .context_window.current_usage.cache_read_input_tokens // "",
    .context_window.current_usage.cache_creation_input_tokens // "",
    .fast_mode // "false",
    .effort.level // "",
    .thinking.enabled // "false",
    .version // ""
  ] | join("|")'
)

# If using Aliyun base URL, prefix model name with "ali-"
base_url="${ANTHROPIC_BASE_URL:-}"
if [[ "$base_url" == *"aliyuncs"* ]]; then
  model="ali-${model}"
fi

parts=()
[ -n "$model" ] && parts+=("$model")

ctx=""
[ -n "$ctx_used" ] && ctx="${ctx_used}%"
[ -n "$ctx_total" ] && ctx="${ctx:+$ctx of }$(( (ctx_total + 500) / 1000 ))k"
if [ -n "$ctx" ]; then
  ctx_int=${ctx_used%%.*}
  if [ -n "$ctx_int" ] && [ "$ctx_int" -gt 90 ] 2>/dev/null; then
    ctx=$'\033[38;2;204;102;102m'"${ctx}"$'\033[0m'
  fi
  parts+=("$ctx")
fi

tok=""
if [ -n "$in_total" ]; then
  tok="↓$(( (in_total + 500) / 1000 ))k"
fi
if [ -n "$out_total" ]; then
  tok="${tok:+$tok }↑$(( (out_total + 500) / 1000 ))k"
fi
if [ -n "$cache_read" ] || [ -n "$cache_create" ] || [ -n "$in_req" ]; then
  req_total=$((${in_req:-0} + ${cache_read:-0} + ${cache_create:-0}))
  if [ "$req_total" -gt 0 ]; then
    tok="${tok:+$tok }✓$(( (cache_read * 1000 / req_total + 5) / 10 ))%"
  fi
fi
[ -n "$tok" ] && parts+=("$tok")

# ¥/Mtok 单价 → nano¥/token = rate×1000 (1¥ = 1e9 nano¥)。
# DeepSeek 统一按 deepseek-v4-pro 高峰价计；累计输入全部按未命中(input)价，保守上界。
in_rate=9000 out_rate=27000   # pro 高峰: input 9 / output 27 (元/Mtok)
cost_nano=$(( ${in_total:-0} * in_rate + ${out_total:-0} * out_rate ))
if [ "$cost_nano" -gt 0 ]; then
  price=$(printf '¥%d.%02d' \
    $(( cost_nano / 1000000000 )) \
    $(( (cost_nano % 1000000000) / 10000000 )))
fi
[ -n "$price" ] && parts+=("$price")

flags=""
[ "$fast" = "true" ] && flags="fast"
[ -n "$effort" ] && flags="${flags:+$flags }$effort"
[ "$thinking" = "true" ] && flags="${flags:+$flags }thinking"
[ -n "$flags" ] && parts+=("$flags")

out=""
for p in "${parts[@]}"; do out="${out:+$out | }$p"; done

# Pin version to the right edge of the status line's content area. Claude
# Code exports COLUMNS but renders the statusline in a content area 4 cells
# narrower than COLUMNS (measured: a COLUMNS-wide ruler is clipped to
# COLUMNS-4 cells and '…' is appended on overflow), so target COLUMNS-4 with
# a cell-based gap. Sizing by byte width (wc -c) over-corrects here —
# multibyte glyphs (↓ ↑ ✓ ¥) cost bytes but one cell each, leaving the
# version ~7 cells left of the edge. -4 is the flush floor; lower chops it.
# Fall back to a plain segment on narrow/unknown widths.
if [ -n "$version" ]; then
  ver="v$version"
  if [ -n "${COLUMNS:-}" ] && [ "$COLUMNS" -gt 0 ] 2>/dev/null; then
    out_vis=$(printf '%s' "$out" | sed "s/$esc\[[0-9;]*m//g")
    gap=$(( COLUMNS - ${#out_vis} - ${#ver} - 4 ))
    if [ "$gap" -ge 1 ]; then
      printf '%s%*s%s\n' "$out" "$gap" "" "$ver"
    else
      printf '%s | %s\n' "$out" "$ver"
    fi
  else
    printf '%s | %s\n' "$out" "$ver"
  fi
else
  echo "$out"
fi
