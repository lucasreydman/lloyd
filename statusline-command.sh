#!/usr/bin/env bash
# L.L.O.Y.D. Status Line — Logical Learning & Optimization Yield Director
#
# Output: ◈ L·L·O·Y·D  ⟩  .claude (main)  ⟩  fable-5.1  ⟩  context ████████░░ 78%  ⟩  session ███░░░░░░░ 34%  ⟩  weekly █░░░░░░░░░ 12%  ⟩  34m
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
IFS=$'\t' read -r cwd model used_pct dur_ms rl5 rl7 cache_on <<< "$(printf '%s' "$input" | jq -r '[
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

# meter <label> <percentage>  →  "label ████░░░░░░ 43%" coloured by threshold
meter() {
  local label=$1 raw=$2 pct filled empty bar_filled="" bar_empty="" i
  pct=$(printf "%.0f" "$raw" 2>/dev/null || echo 0)
  [ "$pct" -lt 0 ] && pct=0; [ "$pct" -gt 100 ] && pct=100
  filled=$(( pct * 10 / 100 )); empty=$(( 10 - filled ))
  for ((i=0; i<filled; i++)); do bar_filled="${bar_filled}█"; done
  for ((i=0; i<empty;  i++)); do bar_empty="${bar_empty}░";  done
  printf '%s%s %s%s%s %s%%%s' "$DIM" "$label" "$(color_for_pct "$pct")" "$bar_filled" "$bar_empty" "$pct" "$R"
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

# ── Meters: context window, 5-hour session limit, 7-day weekly limit ────────
bar=""    ; [ -n "$used_pct" ] && bar=$(meter context "$used_pct")
rl_str="" ; [ -n "$rl5" ]      && rl_str=$(meter session "$rl5")
rl7_str=""; [ -n "$rl7" ]      && rl7_str=$(meter weekly "$rl7")

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
