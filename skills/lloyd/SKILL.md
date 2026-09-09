---
name: lloyd
description: Use when you want to see everything L.L.O.Y.D. can do — full capability overview including all skills by category, MCP servers, plugins, and memory.
user-invocable: true
allowed-tools: Bash, Read
---

# L.L.O.Y.D. — Full Capability Overview

**Logical Learning & Optimization Yield Director**
*Named after Lloyd Lee, Ari Gold's elite assistant in Entourage. Overqualified, unflappable, always delivers.*

## Step 1 — Read live state

```bash
ls ~/.claude/skills/                 # local skills
claude plugin list                   # marketplace plugins (last30days lives here)
claude mcp list                      # MCP servers actually connected
```

## Step 2 — Present the overview

Report the live output above, then the reference below in a clean, grouped format.

---

## Plugins (marketplace)

| Plugin | Marketplace | Purpose |
|--------|-------------|---------|
| **last30days** | `last30days-skill` (mvanhorn) | Deep 30-day research across X, YouTube, HN, Reddit, Polymarket, web. Keys in `~/.config/last30days/.env`. Update: `claude plugin update last30days@last30days-skill` |

## MCP Servers

| Server | Scope | What it does |
|--------|-------|-------------|
| **context7** | user (`~/.claude.json`) | Live library docs |
| **higgsfield** | project — `lucasreydman.xyz/.mcp.json` | Image/video generation for the portfolio site |
| **shadcn** | project — `lucasreydman.xyz/.mcp.json` | shadcn component registry |
| **claude.ai connectors** | account | Spotify (connected); Microsoft 365, Morningstar, S&P Global, IBKR (need auth — manage at claude.ai) |

GitHub, Vercel, Supabase, Stripe: **use the CLIs** (`gh`, `vercel`, `supabase`) — no MCP. See CLAUDE.md "prefer official CLIs".

## Agents

No custom agents. Use the built-ins: **Explore** (read-only search), **Plan**, **general-purpose**, **claude-code-guide**. Model routing rules live in CLAUDE.md.

## Skills (local, `~/.claude/skills/`)

### Workflow & Config
| Skill | When to use |
|-------|-------------|
| `systematic-debugging` | Any bug or flaky test — root cause before fixes |
| `sync-dotfiles` | Pull latest L.L.O.Y.D. onto this machine |
| `skill-creator` | Build or update a skill |
| `graphify` | Knowledge graph of a codebase (`/graphify`, `query`, `path`, `explain`) |
| `lloyd` | This overview |

### Design & Frontend
| Skill | When to use |
|-------|-------------|
| `frontend-design` | Production web UI |
| `impeccable` | Design/redesign, UX review, polish, design systems |
| `design-taste-frontend` | Anti-slop landing pages, portfolios, redesigns |
| `emil-design-eng` | UI polish, animation, component feel |
| `ui-ux-pro-max` | Styles, palettes, font pairings, stack-specific UI |
| `web-design-guidelines` | Accessibility / best-practice review |
| `web-artifacts-builder` | Multi-component HTML artifacts |
| `canvas-design` | Static posters / visual art |
| `webapp-testing` | Playwright testing of a local web app |

### Marketing & Growth (kept: the ones actually used or relevant to FBI/portfolio)
| Skill | When to use |
|-------|-------------|
| `copywriting` / `copy-editing` | Write or tighten page copy |
| `page-cro` / `paywall-upgrade-cro` | Landing page and upgrade-screen conversion |
| `pricing-strategy` | Tiers, packaging, price changes |
| `seo-audit` | Technical/on-page SEO |
| `launch-strategy` | Shipping something publicly |
| `social-content` | Social posts and repurposing |
| `analytics-tracking` | GA4 / event tracking plans |

Removed 2026-09-09 (zero uses in 6 months, restorable from git history or `coreyhaines31/marketingskills`): ab-test-setup, ad-creative, ai-seo, churn-prevention, cold-email, competitor-alternatives, content-strategy, email-sequence, form-cro, free-tool-strategy, lead-magnets, marketing-ideas, marketing-psychology, onboarding-cro, paid-ads, popup-cro, product-marketing-context, programmatic-seo, referral-program, revops, sales-enablement, schema-markup, signup-flow-cro, site-architecture, agent-sandboxes, algorithmic-art, brand-guidelines, slack-gif-creator, theme-factory, remotion-best-practices, mcp-builder, internal-comms, doc-coauthoring, docx, pdf.

### Documents
| Skill | When to use |
|-------|-------------|
| `xlsx` | Spreadsheets |
| `pptx` | Presentations |

## Built-in skills (ship with Claude Code)

`verify`, `code-review`, `simplify`, `security-review`, `run`, `init`, `loop`, `schedule`, `claude-api`, `update-config`, `keybindings-help`, `fewer-permission-prompts`, `skill-doctor` (finds unused skills), `dataviz`, `design`, `artifact-*`.

## Memory

Auto-memory at `~/.claude/projects/<project>/memory/` — `MEMORY.md` index (first 200 lines / 25 KB loaded per session) plus topic files. **Not synced to the repo** (repo is public). Orphaned memories from deleted projects are archived in `~/.claude/backups/memory-orphans-<date>/`.

## Status line

`statusline-command.sh` reads only the native JSON Claude Code provides: folder, branch, model, context bar, session cost, 5-hour rate-limit %, elapsed. No hooks.
