---
name: sync-dotfiles
description: Syncs ~/.claude with the lucasreydman/lloyd GitHub repo (L.L.O.Y.D.) - pulls latest commits, updates submodules, and reports required user actions (missing API keys, dependencies, restarts).
user-invocable: true
allowed-tools: Bash, Read, Write
---

# sync-dotfiles

Pulls the latest L.L.O.Y.D. config from `lucasreydman/lloyd` into `~/.claude`, initializes submodules, and produces a clear action report.

## Steps

Execute these in order:

### 1. Stash or discard local changes

```bash
cd ~/.claude
git status --short
```

- If only auto-generated files are modified (e.g. `plugins/known_marketplaces.json`, `plugins/installed_plugins.json`), discard them:
  ```bash
  git checkout -- plugins/known_marketplaces.json plugins/installed_plugins.json settings.json 2>/dev/null; true
  ```
- If real intentional local edits exist, commit them first before pulling.

### 2. Pull with submodules

```bash
git pull --recurse-submodules origin main
```

### 3. Check what changed

```bash
git log --oneline ORIG_HEAD..HEAD
```

Report each commit to the user as a bullet.

### 4. Audit dependencies and API keys

Run these checks in parallel:

```bash
# ruflo
ruflo --version 2>/dev/null || echo "MISSING: ruflo"

# yt-dlp
yt-dlp --version 2>/dev/null || echo "MISSING: yt-dlp"
```

> **MCP servers (ruflo, playwright, github, context7):** Use `/doctor` in Claude Code to confirm they are actually connected — not just installed. Installation alone does not guarantee the MCP server is running and reachable.

```bash
# API keys in ~/.bashrc
grep -E "GITHUB_PERSONAL_ACCESS_TOKEN|BRAVE_API_KEY|XAI_API_KEY" ~/.bashrc 2>/dev/null
```

```bash
# last30days .env
cat ~/.config/last30days/.env 2>/dev/null || echo "MISSING: ~/.config/last30days/.env"
```

### 5. Detect settings.json drift

Compare key sections of local `settings.json` with `git show origin/main:settings.json`. If local is missing `mcpServers`, `permissions.allow`, or `sandbox` blocks — flag it.

### 6. Report to user

Produce a summary with two sections:

**What changed:**
- Bullet each new commit

**Action required:**
- List only items that are actually missing or misconfigured
- If nothing is missing, say "All good — no actions required."

## Required User Actions (reference)

| Item | Where | Status check |
|------|-------|-------------|
| `GITHUB_PERSONAL_ACCESS_TOKEN` | `~/.bashrc` | `grep GITHUB_PERSONAL ~/.bashrc` |
| `BRAVE_API_KEY` | `~/.bashrc` | `grep BRAVE_API ~/.bashrc` |
| `XAI_API_KEY` | `~/.bashrc` + `~/.config/last30days/.env` | optional but enables X/Twitter |
| `ruflo` binary | PATH | `ruflo --version` |
| `yt-dlp` binary | PATH | `yt-dlp --version` |
| Restart Claude Code | — | Required after `settings.json` changes |

## Notes

- **`~/.claude` IS the dotfiles repo. Never clone it to `~/dev/` or anywhere else.** Git operations (`pull`, `push`, `commit`) always run in `~/.claude` directly — that is the working copy.
- `plugins/known_marketplaces.json` is excluded from git (auto-generated) — ignore drift there
- After pulling, if `settings.json` changed → tell user to **restart Claude Code**
