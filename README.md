# L.L.O.Y.D.
### Logical Learning & Optimization Yield Director

> *The configuration layer that turns Claude Code into a persistent, opinionated, always-improving co-pilot.*

The name has two references, and both are intentional.

**The obvious one:** J.A.R.V.I.S. — Tony Stark's AI in Iron Man. Not just a tool, but an intelligence that knew his systems, anticipated his needs, and made him sharper. L.L.O.Y.D. is that layer for Claude Code.

**The better one:** Lloyd Lee — Ari Gold's assistant in HBO's *Entourage*. Stanford MBA. Overqualified by design. Absorbs chaos without breaking composure. The one person Ari genuinely cannot operate without. He pushes back when it matters, stays when others would quit, and by the end runs the TV division of a top Hollywood agency. He didn't get there through charm — he got there through patience, intelligence, and strategic endurance.

That's the model. Not a yes-machine. An operator who handles everything, gets better over time, and earns the trust session by session.

**L** — *Logical* — CLI-first tooling, root-cause debugging, verification before "done"
**L** — *Learning* — persistent auto-memory across sessions, lessons captured after every correction
**O** — *Optimization* — a curated set of skills that replace generic answers with expert-guided ones
**Y** — *Yield* — every session produces better output than the last, compounding over time
**D** — *Director* — orchestrates built-in agents, MCP servers, tools, and context to get things done

---

> **`~/.claude` IS the repo.** Never clone this to `~/dev/` or any other directory. All git operations (`pull`, `push`, `commit`) happen directly inside `~/.claude`. That folder is both the live Claude config and the git working copy.

## Design principles (2026-09 audit)

- **Lean context.** ~26 local skills, one user-scope MCP server, no per-tool-call hooks. Skill descriptions are loaded every session, so unused skills are removed rather than kept "just in case" (`/skill-doctor` shows what's idle).
- **CLIs over MCP.** `gh`, `vercel`, `supabase` instead of their MCP servers — fewer tokens, no purchase tools exposed under bypass permissions.
- **Project-scoped MCP.** Servers that only one project needs (higgsfield, shadcn) live in that project's `.mcp.json`, not globally.
- **CLAUDE.md under 200 lines.** Global file is ~40 lines; project specifics live in each project's `CLAUDE.md` and auto-memory.
- **Memory stays local.** This repo is public; `~/.claude/projects/*/memory/` is gitignored on purpose.

## What's synced
- `CLAUDE.md` — global instructions (tooling, model routing, graphify rules)
- `settings.json` — model, permission mode, status line, TUI/voice prefs. **No MCP servers here** (Claude Code ignores that key).
- `statusline-command.sh` — L.L.O.Y.D. status bar, driven purely by Claude Code's native status JSON
- `skills/` — local skills (design/frontend, a few marketing, docs, graphify, dotfiles)
- `docs/` — graphify workflow notes
- `gitignore_global` — keeps `graphify-out/` out of every repo

## What's NOT synced
- `.credentials.json`, `~/.claude.json` (MCP servers, OAuth, per-project state)
- `projects/` (session transcripts **and** auto-memory), `history.jsonl`, caches, backups
- `plugins/` caches and marketplaces (re-fetched on install)
- `settings.local.json`

---

## Setup on a new machine

> Replace `YOUR_USERNAME`, `YOUR_GITHUB_USERNAME`, `YOUR_DEV_FOLDER`, `YOUR_OBSIDIAN_VAULT` with your own values.

### 0. Fork
Fork [github.com/lucasreydman/lloyd](https://github.com/lucasreydman/lloyd).

### 1. Clone your fork into `~/.claude`
```bash
cd ~/.claude
git init
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/lloyd.git
git fetch origin
git checkout -b main --track origin/main   # or: git reset --hard origin/main
```

### 2. Dependencies
```bash
# yt-dlp (YouTube source for last30days)
winget install yt-dlp.yt-dlp        # Windows
brew install yt-dlp                 # Mac

# graphify (knowledge graphs)
pip install graphifyy
python -m graphify install --platform claude

# jq (status line)
winget install jqlang.jq            # Windows
```

### 3. API keys in `~/.bashrc` (or `~/.zshrc`)
```bash
export PYTHONUTF8=1
export GITHUB_PERSONAL_ACCESS_TOKEN=""   # used by gh if not logged in
export BRAVE_API_KEY=""                  # api.search.brave.com — free tier
export XAI_API_KEY=""                    # console.x.ai — X search for last30days
```
Then `mkdir -p ~/.config/last30days && printf 'BRAVE_API_KEY=\nXAI_API_KEY=\n' > ~/.config/last30days/.env` and fill in the values.

### 4. Plugins and MCP (not in the repo — run once per machine)
```bash
claude plugin marketplace add mvanhorn/last30days-skill
claude plugin install last30days@last30days-skill
claude mcp add --scope user context7 -- cmd /c npx -y @upstash/context7-mcp@latest   # Windows
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp@latest          # Mac/Linux
```

### 5. Global gitignore
```bash
git config --global core.excludesFile ~/.claude/gitignore_global
```

### 6. Verify
`claude mcp list`, `claude plugin list`, `/lloyd`.

---

## Status line

```
◈ L·L·O·Y·D  ⟩  .claude (main)  ⟩  fable-5.1  ⟩  context ████████░░ 78%  ⟩  session ███░░░░░░░ 34%  ⟩  weekly █░░░░░░░░░ 12%  ⟩  open 4h29m  working 52m
```

| Field | Source |
|-------|--------|
| folder (branch) | `workspace.current_dir` + git |
| model | `model.display_name` |
| `context` meter | `context_window.used_percentage` |
| `weekly` meter | `rate_limits.seven_day.used_percentage` |
| `session` meter | `rate_limits.five_hour.used_percentage`; when ≥60% adds `↻ 1h12m` until the window resets (`resets_at`) |
| `open 4h29m` | `cost.total_duration_ms` — wall-clock since launch |
| `working 52m` | `cost.total_api_duration_ms` — time in model calls |
| `cache 4m` | shown only in the last 5 min of the prompt-cache TTL (`prompt_cache.expires_at`); send anything to keep it warm. `(no cache)` when `prompt_cache.warm` is false |

No hooks and no state file — earlier versions tracked tool calls with PreToolUse/PostToolUse hooks, which cost ~0.5 s per tool call on Windows.

## Skills

Run `/lloyd` for the grouped list. Highlights:
- **Design/frontend**: `frontend-design`, `impeccable`, `design-taste-frontend`, `emil-design-eng`, `ui-ux-pro-max`, `web-design-guidelines`, `webapp-testing`
- **Marketing** (kept to what's actually used): `copywriting`, `copy-editing`, `page-cro`, `paywall-upgrade-cro`, `pricing-strategy`, `seo-audit`, `launch-strategy`, `social-content`, `analytics-tracking`
- **Workflow**: `systematic-debugging`, `graphify`, `sync-dotfiles`, `skill-creator`
- **Plugin**: `last30days` (marketplace)

## Graphify

See `docs/dev-graphify-workflow.md` and `docs/graphify-obsidian-workflow.md`. Short version: graphs are opt-in per project; if `graphify-out/` exists Claude reads `GRAPH_REPORT.md` and runs `graphify query` before touching raw files; refresh with `python -m graphify update .`.
