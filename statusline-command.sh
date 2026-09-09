#!/usr/bin/env bash
# L.L.O.Y.D. Status Line — Logical Learning & Optimization Yield Director
#
# Output: ◈ L·L·O·Y·D  ⟩  .claude (main)  ⟩  fable-5.1  ⟩  context ████████░░ 78%  ⟩  session ███░░░░░░░ 34%  ⟩  weekly █░░░░░░░░░ 12%  ⟩  open 4h29m  working 52m
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
# US (0x1f) separator: not IFS-whitespace, so empty fields stay in place instead of shifting.
IFS=$'\x1f' read -r cwd model used_pct dur_ms api_ms rl5 rl5_reset rl7 cache_warm cache_exp <<< "$(printf '%s' "$input" | jq -r '[
  (.workspace.current_dir // .cwd // ""),
  (.model.display_name // .model.name // ""),
  (.context_window.used_percentage // ""),
  (.cost.total_duration_ms // ""),
  (.cost.total_api_duration_ms // ""),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.five_hour.resets_at // ""),
  (.rate_limits.seven_day.used_percentage // ""),
  (.prompt_cache.warm // ""),
  (.prompt_cache.expires_at // "")
] | map(tostring) | join("")' 2>/dev/null)"

now=$(date +%s)

fmt_dur() {  # ms → 4h29m / 12m / 45s
  local secs=$(( ${1%.*} / 1000 ))
  if   [ "$secs" -ge 3600 ]; then printf '%dh%02dm' $(( secs / 3600 )) $(( (secs % 3600) / 60 ))
  elif [ "$secs" -ge 60 ];   then printf '%dm' $(( secs / 60 ))
  else                            printf '%ds' "$secs"; fi
}

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

# When the session limit is yellow/red, show how long until the 5-hour window resets (↻ 1h12m).
if [ -n "$rl5" ] && [ -n "$rl5_reset" ]; then
  rl5_pct=$(printf "%.0f" "$rl5" 2>/dev/null || echo 0)
  left=$(( ${rl5_reset%.*} - now ))
  if [ "$rl5_pct" -ge 60 ] && [ "$left" -gt 0 ]; then
    rl_str="${rl_str} $(color_for_pct "$rl5_pct")↻ $(fmt_dur $(( left * 1000 )))${R}"
  fi
fi

# ── Time: "open" = wall-clock since launch, "working" = time spent in model calls ──
elapsed=""
[ -n "$dur_ms" ] && elapsed="${DIM}open${R} ${WHITE}$(fmt_dur "$dur_ms")${R}"
[ -n "$api_ms" ] && elapsed="${elapsed:+$elapsed  }${DIM}working${R} ${WHITE}$(fmt_dur "$api_ms")${R}"
# Prompt cache: warn in the last 5 minutes of the TTL (send anything to keep it warm); flag when cold.
if [ "$cache_warm" = "true" ] && [ -n "$cache_exp" ]; then
  left=$(( ${cache_exp%.*} - now ))
  if [ "$left" -gt 0 ] && [ "$left" -le 300 ]; then
    elapsed="${elapsed:+$elapsed  }${YELLOW}cache $(fmt_dur $(( left * 1000 )))${R}"
  fi
elif [ "$cache_warm" = "false" ]; then
  elapsed="${elapsed:+$elapsed  }${DIM}(no cache)${R}"
fi

# ── Assemble ─────────────────────────────────────────────────────────────────
parts=("${MAGENTA}◈ L·L·O·Y·D${R}")
loc="${BLUE}${folder}${R}"; [ -n "$branch" ] && loc="${loc} ${DIM}(${branch})${R}"
parts+=("$loc")
[ -n "$short_model" ] && parts+=("${CYAN_DIM}${short_model}${R}")
[ -n "$bar" ]         && parts+=("$bar")
[ -n "$rl_str" ]      && parts+=("$rl_str")
[ -n "$rl7_str" ]     && parts+=("$rl7_str")
[ -n "$elapsed" ]     && parts+=("$elapsed")

printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do printf '%s%s' "$SEP" "$part"; done
printf '\n'
