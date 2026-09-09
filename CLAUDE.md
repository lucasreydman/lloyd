Bias to action: implement directly without check-ins or planning artifacts unless the change is destructive or ambiguous.

## Tooling: prefer official CLIs

When a task touches an external service, use its official CLI before falling back to a web dashboard or asking me. Check availability first (e.g. `npx <cli> --version`); the CLI is usually already authenticated (token in env or Windows Credential Manager under `<Service> CLI:<service>`).

- **Supabase**: `supabase` / `npx supabase`, plus Management API at api.supabase.com — projects, migrations/SQL, API keys, seeding
- **GitHub**: `gh`
- **Vercel**: `vercel`
- Any other service CLI (stripe, etc.) when present

No MCP servers for these — CLIs are cheaper and more reliable. Only ask me for what you genuinely can't do (interactive browser login, a fresh secret). Surface account-level creation and destructive steps first.

## Model Routing (subagents)

Team premium seat — spend tokens freely for best results. Default to the best available model (Fable 5 / Opus-tier) wherever output quality matters: implementation, debugging, research, architecture. Route down to `haiku` only for purely mechanical grunt work where a smarter model adds nothing (file reads, grep, test runs, pass/fail checks) — that's about speed, not quota. Never Haiku for output I read directly. Use the built-in agents (Explore, Plan, general-purpose); there are no custom agent files.

## Skills

Run `/lloyd` for the full grouped skill reference. `last30days` is a marketplace plugin (`claude plugin update last30days@last30days-skill` to update).

## graphify — Knowledge Graph

Graphs exist only for some projects (`graphify-out/` present): bvp-betting, cv, deskvitals-live, nba-dynasty-rankings, sharprfi, shielded-wheel, plus the cross-project master at `C:\Users\lucas\dev\knowledge\graphify-out\`. Obsidian canvases live in `SecondBrain/graphify-vault/<project>/graph.canvas`.

- **If `graphify-out/` exists in the project**: read `graphify-out/GRAPH_REPORT.md` before exploring, then `PYTHONUTF8=1 python -m graphify query "<question>" --graph graphify-out/graph.json --budget 1500`. Never dump `graph.json` into context.
- **If it doesn't exist**: skip graphify entirely — don't go looking for a graph.
- **Cross-project questions**: `C:\Users\lucas\dev\knowledge\graphify-out\GRAPH_REPORT.md`.
- **After code changes in a graphed project**: `PYTHONUTF8=1 python -m graphify update .` (AST-only, no LLM), then re-export the Obsidian canvas (see memory `feedback_graphify_viz`).
- **New graphs**: use the `/graphify` skill, scope to app code (`src/ app/ lib/ components/` + README/CLAUDE.md), exclude logs, dumps, screenshots, fixtures, generated docs.
