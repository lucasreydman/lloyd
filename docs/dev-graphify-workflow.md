# Dev Projects — Graphify Workflow (updated 2026-09-09)

Graphify is opt-in per project. Only projects with a `graphify-out/` folder are graphed; Claude skips graphify everywhere else (rule in `CLAUDE.md`).

## Current graphs

| Project | graphify-out | Last built |
|---------|--------------|-----------|
| bvp-betting | ✓ | 2026-04 |
| cv | ✓ (report only, no graph.json) | 2026-04 |
| deskvitals-live | ✓ | 2026-04 |
| nba-dynasty-rankings | ✓ | 2026-04 |
| sharprfi | ✓ (report only) | 2026-07 |
| shielded-wheel | ✓ | 2026-04 |
| knowledge (master) | ✓ — junctions to bvp-betting, consensus-points-dynasty-ranking, cv, nba-dynasty-rankings, sharprfi | 2026-07 |

Active projects without graphs (fbi-basketball, sleeper-ff-manager, blakey-breakthrough-dashboard, cr-deck-finder, lucasreydman.xyz, simple-fitness, nfl-fantasy-draft-big-board) rely on their own `CLAUDE.md` + auto-memory instead. Graph them only if the codebase is large enough that the report earns its keep (graphify's own corpus check will tell you).

## Commands (graphifyy ≥ 0.9.57)

```bash
# Build / rebuild — via the skill, scoped to app code
/graphify <path>

# Incremental refresh after code changes (AST only, no LLM)
PYTHONUTF8=1 python -m graphify update .

# Query (low-token)
PYTHONUTF8=1 python -m graphify query "<question>" --graph graphify-out/graph.json --budget 1500
PYTHONUTF8=1 python -m graphify path "A" "B" --graph graphify-out/graph.json
PYTHONUTF8=1 python -m graphify explain "Node" --graph graphify-out/graph.json

# Optional: auto-rebuild on commit/checkout
python -m graphify hook install
```

`--update` and `--no-viz` are no longer flags on the build command; `update` is its own subcommand and always keeps the HTML. Re-export the Obsidian canvas after a rebuild (see `docs/graphify-obsidian-workflow.md`).

## Adding a project to the master graph

```powershell
New-Item -ItemType Junction -Path "C:\Users\lucas\dev\knowledge\<project>" -Target "C:\Users\lucas\dev\<project>"
```
Then `/graphify C:\Users\lucas\dev\knowledge`.
