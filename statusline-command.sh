#!/usr/bin/env bash
# L.L.O.Y.D. Status Line — Logical Learning & Optimization Yield Director
#
# Output: ◈ L·L·O·Y·D  ⟩  .claude (main)  ⟩  fable-5.1  ⟩  ████████░░ 78%  ⟩  5h 34%  ⟩  7d 12%  ⟩  34m
#
# Everything comes from the JSON Claude Code pipes to stdin — no hooks, no state file.
# Fields: https://code.claude.com/docs/en/statusline

input=$(cat)

# ── ANSI codes ───────────────────────────────────────────────────────────────
R=$'\033[0m'
MAGENTA=$'\033[1;35m'   # brand
BLUE=$'\033[1;34m'      # folder / branch
CYAN_DIM=$'\033[2;36m'  # model
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
RED=$'\033[1;31m'
WHITE=$'\033[0;37m'
DIM=$'\033[2;37m'
SEP="${DIM} ⟩${R} "

# ── Parse stdin JSON (one jq call) ───────────────────────────────────────────
IFS=$'\t' read -r cwd model used_pct cost_usd dur_ms rl5 cache_on <<< "$(printf '%s' "$input" | jq -r '[
  (.workspace.current_dir // .cwd // ""),
  (.model.display_name // .model.name // ""),
  (.context_window.used_percentage // ""),
  (.cost.total_duration_ms // ""),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.seven_day.used_percentage // ""),
  (.prompt_cache.enabled // "")
] | @tsv' 2>/dev/null)"

color_for_pct() {
  local p=$1
  if   [ "$p" -ge 85 ]; then printf '%s' "$RED"
  elif [ "$p" -ge 60 ]; then printf '%s' "$YELLOW"
  else                       printf '%s' "$GREEN"; fi
}

# ── Location ─────────────────────────────────────────────────────────────────
folder=$(basename "${cwd:-.}")
branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null || true)
fi

# ── Model: "Claude Fable 5.1" → "fable-5.1" ──────────────────────────────────
short_model=""
[ -n "$model" ] && short_model=$(printf '%s' "$model" | sed 's/^[Cc]laude[- ]//' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# ── Context bar ──────────────────────────────────────────────────────────────
bar=""
if [ -n "$used_pct" ]; then
  pct=$(printf "%.0f" "$used_pct" 2>/dev/null || echo 0)
  filled=$(( pct * 10 / 100 )); [ "$filled" -gt 10 ] && filled=10
  bar_filled=$(printf '█%.0s' $(seq 1 $filled) 2>/dev/null)
  bar_empty=$(printf '░%.0s' $(seq 1 $((10 - filled))) 2>/dev/null)
  bar="$(color_for_pct "$pct")${bar_filled}${bar_empty} ${pct}%${R}"
fi

# ── Subscription rate limits (what actually meters usage) ────────────────────
rl_str="" rl7_str=""
if [ -n "$rl5" ]; then
  rlp=$(printf "%.0f" "$rl5" 2>/dev/null || echo 0)
  rl_str="$(color_for_pct "$rlp")5h ${rlp}%${R}"
fi
if [ -n "$rl7" ]; then
  rlp7=$(printf "%.0f" "$rl7" 2>/dev/null || echo 0)
  rl7_str="$(color_for_pct "$rlp7")7d ${rlp7}%${R}"
fi

# ── Elapsed ──────────────────────────────────────────────────────────────────
elapsed=""
if [ -n "$dur_ms" ]; then
  secs=$(( ${dur_ms%.*} / 1000 ))
  if   [ "$secs" -ge 3600 ]; then elapsed="$(( secs / 3600 ))h$(( (secs % 3600) / 60 ))m"
  elif [ "$secs" -ge 60 ];   then elapsed="$(( secs / 60 ))m"
  else                            elapsed="${secs}s"; fi
fi
[ "$cache_on" = "false" ] && elapsed="${elapsed} ${DIM}(no cache)${R}"

# ── Assemble ─────────────────────────────────────────────────────────────────
parts=("${MAGENTA}◈ L·L·O·Y·D${R}")
loc="${BLUE}${folder}${R}"; [ -n "$branch" ] && loc="${loc} ${DIM}(${branch})${R}"
parts+=("$loc")
[ -n "$short_model" ] && parts+=("${CYAN_DIM}${short_model}${R}")
[ -n "$bar" ]         && parts+=("$bar")
[ -n "$rl_str" ]      && parts+=("$rl_str")
[ -n "$rl7_str" ]     && parts+=("$rl7_str")
[ -n "$elapsed" ]     && parts+=("${WHITE}${elapsed}${R}")

printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do printf '%s%s' "$SEP" "$part"; done
printf '\n'
