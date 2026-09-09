# Graphify + Obsidian Workflow

Graphify indexes the Obsidian vault into a persistent knowledge graph. Claude reads the graph summary before searching raw notes — saving tokens on every session.

## Paths (this machine)

| Purpose | Path |
|---------|------|
| Obsidian vault | `C:\Users\lucas\Documents\Obsidian\SecondBrain` |
| Graph output | `C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-out\` |
| Graph report | `graphify-out\GRAPH_REPORT.md` |
| Graph data | `graphify-out\graph.json` |

## Install (new machine)

```bash
pip install graphifyy
python -m graphify install --platform claude   # registers the /graphify skill in ~/.claude/skills
# (do NOT run 'graphify claude install' — L.L.O.Y.D.'s CLAUDE.md already carries the graphify rules, and the PreToolUse hook is not wanted)
```

## Build / refresh the graph

```bash
# Full build (first time or major changes)
cd "C:\Users\lucas\Documents\Obsidian\SecondBrain"
python -m graphify . --no-viz

# Incremental update (after adding notes)
python -m graphify . --update --no-viz
```

## Query without opening raw files

```bash
python -m graphify query "your question" \
  --graph "C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-out\graph.json" \
  --budget 1500
```

## Low-token rules for Claude

1. Read `graphify-out/GRAPH_REPORT.md` first — god nodes + community structure.
2. Run a focused `graphify query` for specific questions — don't scan raw folders.
3. Never dump `graph.json` into context — it's for programmatic traversal only.
4. Open raw notes only when graph summaries are insufficient.
5. Rebuild with `--update`, not full re-index, unless the vault changed significantly.

## Optional: MCP server (live graph queries)

```bash
python -m graphify.serve "C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-out\graph.json"
```

Exposes tools: `query_graph`, `get_node`, `get_neighbors`, `god_nodes`, `shortest_path`. Add to `settings.json` mcpServers if you want it always-on.
