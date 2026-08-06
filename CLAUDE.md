Bias to action: implement directly without check-ins or planning artifacts unless the change is destructive or ambiguous.

## Tooling: prefer official CLIs

When a task touches an external service, use its official CLI before falling back to a web dashboard or asking me. Check availability first (e.g. `npx <cli> --version`); the CLI is usually already authenticated (token in env or Windows Credential Manager under `<Service> CLI:<service>`).

- **Supabase**: `supabase` / `npx supabase`, plus Management API at api.supabase.com — projects, migrations/SQL, API keys, seeding
- **GitHub**: `gh`
- **Vercel**: `vercel`
- Any other service CLI (stripe, etc.) when present

Only ask me for what you genuinely can't do (interactive browser login, a fresh secret). Surface account-level creation and destructive steps first.

## Model Routing (subagents)

Team premium seat — spend tokens freely for best results. Default to the best available model (Fable 5 / Opus-tier) wherever output quality matters: implementation, debugging, research, architecture. Route down to `haiku` only for purely mechanical grunt work where a smarter model adds nothing (file reads, grep, test runs, pass/fail checks) — that's about speed, not quota. Never Haiku for output I read directly.

## Skills

Run `/lloyd` for the full grouped skill reference.

## graphify — Knowledge Graph

All dev projects and the Obsidian vault are graphified. Use the graph before searching raw files.

### Knowledge sources (in priority order)

| Scope | GRAPH_REPORT.md | graph.json | Obsidian canvas |
|-------|----------------|------------|-----------------|
| Current project | `<project>/graphify-out/GRAPH_REPORT.md` | `<project>/graphify-out/graph.json` | `SecondBrain/graphify-vault/<project>/graph.canvas` |
| Cross-project | `C:\Users\lucas\dev\knowledge\graphify-out\GRAPH_REPORT.md` | `...\knowledge\graphify-out\graph.json` | `SecondBrain/graphify-vault/_master/graph.canvas` |
| Obsidian vault | `C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-out\GRAPH_REPORT.md` | — | — |

### Rules
- **Before exploring any codebase**: read that project's `graphify-out/GRAPH_REPORT.md` first
- **Cross-project questions**: read `C:\Users\lucas\dev\knowledge\graphify-out\GRAPH_REPORT.md`
- **Focused queries** (prefer over raw grep): `PYTHONUTF8=1 python -m graphify query "<question>" --graph <path>/graph.json --budget 1500`
- **Never dump graph.json into context** — use `graphify query` for traversal
- **After code changes**: `PYTHONUTF8=1 python -m graphify . --update --no-viz` in the project dir
- **Smart scope (always)**: graph the app's structure, not runtime artifacts. Exclude logs/, data dumps, screenshots/, crash dumps, recorded fixtures, generated docs — even if `detect` doesn't filter them. If noise dominates the top-level dirs, propose a code-only scope (`src/ app/ lib/ engine/ dashboard/ components/` + `README.md`/`CLAUDE.md`/`AGENTS.md`) and confirm.
- **Projects with graphs**: bvp-betting, csci3172, cv, fantasy-draft-lottery-simulator, mlb-cfr, nba-dynasty-rankings, pride-stem-combined, sharprfi (formerly yrfi), tpdl-lottery, valentine, what-do-i-need-on-my-final
