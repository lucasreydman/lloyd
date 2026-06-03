#!/bin/bash
set -euo pipefail

# Check if last30days has any configuration source available.
# Priority: .claude/last30days.env > ~/.config/last30days/.env > env vars

PROJECT_ENV=".claude/last30days.env"
GLOBAL_ENV="$HOME/.config/last30days/.env"

# Helper: warn if file permissions are too open
check_perms() {
  local file="$1"
  if [[ ! -f "$file" ]]; then return; fi
  # POSIX file modes are meaningless on Windows (NTFS uses ACLs; Git-Bash/MSYS
  # reports a constant 644 for every file), so the check can never pass there —
  # skip it to avoid a false-positive warning on every session start.
  case "$(uname -s 2>/dev/null)" in MINGW*|MSYS*|CYGWIN*) return ;; esac
  local perms
  # GNU stat (-c) first for Linux/Git-Bash; fall back to BSD stat (-f) on macOS.
  perms=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%Lp' "$file" 2>/dev/null || echo "")
  if [[ -n "$perms" && "$perms" != "600" && "$perms" != "400" ]]; then
    echo "/last30days: WARNING — $file has permissions $perms (should be 600)."
    echo "  Fix: chmod 600 $file"
  fi
}

# Check per-project config
if [[ -f "$PROJECT_ENV" ]]; then
  check_perms "$PROJECT_ENV"
  exit 0
fi

# Check global config
if [[ -f "$GLOBAL_ENV" ]]; then
  check_perms "$GLOBAL_ENV"
  exit 0
fi

# Check if OPENAI_API_KEY is set in environment (minimum requirement)
if [[ -n "${OPENAI_API_KEY:-}" ]]; then
  exit 0
fi

# Check if SCRAPECREATORS_API_KEY is set (also sufficient)
if [[ -n "${SCRAPECREATORS_API_KEY:-}" ]]; then
  exit 0
fi

# No config found — inform user
cat <<'EOF'
/last30days: No API keys configured.

Create .claude/last30days.env with your API keys, or create
~/.config/last30days/.env globally. At minimum, SCRAPECREATORS_API_KEY
or OPENAI_API_KEY is required. See the README for setup instructions.
EOF
