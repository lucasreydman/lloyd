---
name: sync-dotfiles
description: Syncs ~/.claude with the lucasreydman/lloyd GitHub repo (L.L.O.Y.D.) - pulls latest commits and reports required user actions (missing API keys, plugins, dependencies, restarts).
user-invocable: true
allowed-tools: Bash, Read, Write
---

# sync-dotfiles

Pulls the latest L.L.O.Y.D. config from `lucasreydman/lloyd` into `~/.claude` and produces a clear action report.

## Steps

### 1. Check local state

```bash
cd ~/.claude && git status --short
```

- Runtime files are gitignored, so anything listed is an intentional local edit. Commit it before pulling; never discard `settings.json` or `CLAUDE.md`.

### 2. Pull

```bash
cd ~/.claude && git pull --ff-only origin main && git log --oneline ORIG_HEAD..HEAD
```

Report each new commit as a bullet.

### 3. Audit dependencies, plugins, keys (run in parallel)

```bash
claude plugin list | grep -A2 last30days || echo "MISSING: run: claude plugin marketplace add mvanhorn/last30days-skill && claude plugin install last30days@last30days-skill"
claude mcp list
yt-dlp --version 2>/dev/null || echo "MISSING: yt-dlp (winget install yt-dlp.yt-dlp)"
python -m pip show graphifyy 2>/dev/null | grep -i version || echo "MISSING: pip install graphifyy"
grep -E "GITHUB_PERSONAL_ACCESS_TOKEN|BRAVE_API_KEY|XAI_API_KEY" ~/.bashrc 2>/dev/null || echo "MISSING: API keys in ~/.bashrc"
cat ~/.config/last30days/.env 2>/dev/null >/dev/null || echo "MISSING: ~/.config/last30days/.env"
git config --global core.excludesFile || echo "MISSING: global gitignore (see README step 6)"
```

Expected MCP: `context7` (user scope in `~/.claude.json`). `higgsfield`/`shadcn` appear only inside `lucasreydman.xyz`.

### 4. Report

**What changed:** one bullet per commit.
**Action required:** only items actually missing. If `settings.json` or `statusline-command.sh` changed, say **restart Claude Code**. If nothing is missing: "All good — no actions required."

## Notes

- **`~/.claude` IS the dotfiles repo. Never clone it anywhere else.**
- MCP servers are NOT in `settings.json` (Claude Code ignores that key). User-scope servers live in `~/.claude.json` via `claude mcp add --scope user`; project servers in `<project>/.mcp.json`.
- Auto-memory (`projects/*/memory/`) is deliberately not synced — the repo is public.
