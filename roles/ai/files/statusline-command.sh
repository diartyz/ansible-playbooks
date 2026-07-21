#!/usr/bin/env bash
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
[ -n "$ctx" ] && parts+=("$ctx")

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

if [ -n "$in_total" ] && [ -n "$out_total" ]; then
  cost_milli=$(( (in_total * 3 + out_total * 6) * 1000 / 1000000 ))
  if [ "$cost_milli" -gt 0 ]; then
    yuan=$((cost_milli / 1000))
    frac=$((cost_milli % 1000))
    if [ "$yuan" -gt 0 ]; then
      price="¥${yuan}.$((frac / 10))$((frac % 10))"
    else
      price="¥0.${frac}"
    fi
  fi
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
# Code exports COLUMNS (v2.1.153+). The -3 absorbs the UI's built-in left
# indent plus glyph-width slack (¥ etc. render wider than ${#out}'s char
# count); the UI also reserves 1 col on the right that the script can't
# occupy, so 3 is the flush floor — lowering it truncates the version.
# Fall back to a plain segment on narrow/unknown widths.
if [ -n "$version" ]; then
  ver="v$version"
  if [ -n "${COLUMNS:-}" ] && [ "$COLUMNS" -gt 0 ] 2>/dev/null; then
    gap=$(( COLUMNS - ${#out} - ${#ver} - 3 ))
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
