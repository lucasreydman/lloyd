---
name: lloyd
description: Use when you want to see everything L.L.O.Y.D. can do — full capability overview including all skills by category, MCP servers, plugins, and agents.
user-invocable: true
allowed-tools: Bash, Read
---

# L.L.O.Y.D. — Full Capability Overview

**Logical Learning & Optimization Yield Director**
*Named after Lloyd Lee, Ari Gold's elite assistant in Entourage. Overqualified, unflappable, always delivers.*

Run these checks to show the live state of the config, then present the full summary.

## Step 1 — Read live config

```bash
# Skill count
ls ~/.claude/skills/ | wc -l

# MCP servers
cat ~/.claude/settings.json
```

## Step 2 — Present the full overview

Report everything below in a clean, grouped format.

---

## Plugins

_None currently installed._ (superpowers and oh-my-claudecode removed 2026-08-06; systematic-debugging survives as a local skill)

---

## MCP Servers

Always-on, available in every project session.

| Server | What it does | Requires |
|--------|-------------|---------|
| **context7** | Injects live, up-to-date library docs into context | Nothing |
| **playwright** | Browser automation and UI testing via natural language | Nothing |
| **github** | Read repos, open issues, create PRs, search code | `GITHUB_PERSONAL_ACCESS_TOKEN` in `~/.bashrc` |
| **ruflo** | Spawn Claude agent swarms, coordinate parallel tasks | `ruflo` installed globally |
| **context-mode** | Context switching between modes | Nothing |

Verify all are connected: run `/doctor` in Claude Code.

---

## Agents

Pre-built role definitions in `agents/`. Pass their path to the Agent tool when dispatching subagents.

| Agent | Role |
|-------|------|
| **agents/code-reader.md** | Read-only exploration — finding files, reading source, searching patterns. Use before implementation. |
| **agents/verifier.md** | Validation — runs tests, builds, linting. Use after implementation to confirm correctness. |
| **agents/searcher.md** | Research — web searches, documentation lookup. Use when gathering external context. |

These are role definitions, not skills — dispatch via the Agent tool, not the Skill tool.

---

## Skills

Invoke any skill via the `Skill` tool. Type `/` in Claude Code to browse all invocable skills.

Skills come from three places, all surfaced together in the `/` menu:
- **Local** — your own skills in `~/.claude/skills/`. Everything from *Workflow & Engineering* down through *Dev Tools & Infrastructure* below.
- **Plugin** — bundled by an enabled plugin (namespaced `plugin:skill`); none currently enabled.
- **Built-in** — ship with Claude Code itself (`verify`, `code-review`, `loop`, etc.). See *Built-in Skills*.

Only local skills count toward the skill total reported above.

### Workflow & Engineering
| Skill | When to use |
|-------|-------------|
| `systematic-debugging` | When hitting a gnarly bug or flaky test — root-cause tracing, condition-based waiting references |

### Dotfiles & Config
| Skill | When to use |
|-------|-------------|
| `sync-dotfiles` | Sync LLOYD to a new machine or pull latest updates |
| `skill-creator` | Guided workflow for building a new skill |

### Research & Intelligence
| Skill | When to use |
|-------|-------------|
| `last30days` | Deep research across Reddit, X, HN, YouTube, Polymarket, Brave (last 30 days) |

### Marketing & Growth
| Skill | When to use |
|-------|-------------|
| `copywriting` | Writing landing page / homepage copy |
| `copy-editing` | Improving existing copy |
| `content-strategy` | Planning content (blog, SEO topics) |
| `seo-audit` | SEO audit or technical SEO issues |
| `schema-markup` | Structured data / rich results |
| `ai-seo` | AI search optimization (ChatGPT, Perplexity) |
| `programmatic-seo` | Programmatic content at scale |
| `site-architecture` | Site structure / URL architecture |
| `paid-ads` | Paid ads (Google, Meta, LinkedIn) |
| `ab-test-setup` | A/B testing with statistical rigor |
| `signup-flow-cro` | Signup flow optimization |
| `onboarding-cro` | Onboarding flow optimization |
| `page-cro` | Landing page conversion optimization |
| `popup-cro` | Popup / modal optimization |
| `form-cro` | Form optimization |
| `paywall-upgrade-cro` | In-app paywall / upgrade screen optimization |
| `pricing-strategy` | Pricing / packaging decisions |
| `cold-email` | Cold outbound email sequences |
| `email-sequence` | Drip / nurture email sequences |
| `social-content` | Social media content |
| `ad-creative` | Ad creative (headlines, visuals, copy) |
| `launch-strategy` | Product launch planning |
| `churn-prevention` | SaaS churn analysis / retention |
| `referral-program` | Referral or affiliate programs |
| `competitor-alternatives` | Competitor comparison pages |
| `analytics-tracking` | Analytics / event tracking setup |
| `revops` | Revenue ops / lead lifecycle |
| `sales-enablement` | Sales collateral / battle cards |
| `marketing-psychology` | Behavioral psychology applied to UX |
| `marketing-ideas` | Brainstorming marketing tactics |
| `lead-magnets` | Lead magnet planning and creation |
| `free-tool-strategy` | Free tool for marketing / SEO |
| `product-marketing-context` | Product marketing context document |

### Design & Frontend
| Skill | When to use |
|-------|-------------|
| `frontend-design` | Building production web UI |
| `impeccable` | Design / redesign, UX review, polish, reusable design systems |
| `design-taste-frontend` | Anti-slop landing pages, portfolios, redesigns |
| `emil-design-eng` | UI polish, animation, component design (Emil Kowalski philosophy) |
| `ui-ux-pro-max` | UI/UX decisions, color, typography |
| `web-design-guidelines` | Reviewing UI for accessibility / best practices |
| `web-artifacts-builder` | Multi-component HTML artifacts |
| `algorithmic-art` | Generative / algorithmic art (p5.js) |
| `canvas-design` | Static poster / visual art (.png, .pdf) |
| `theme-factory` | Applying a visual theme to an artifact |
| `brand-guidelines` | Applying Anthropic brand colors and typography |
| `slack-gif-creator` | Animated GIFs optimized for Slack |
| `remotion-best-practices` | Video creation in React (Remotion) |

### Documents & Spreadsheets
| Skill | When to use |
|-------|-------------|
| `docx` | Creating or editing Word documents |
| `pdf` | PDF manipulation (merge, split, extract) |
| `pptx` | Creating PowerPoint presentations |
| `xlsx` | Spreadsheet creation or analysis |

### Dev Tools & Infrastructure
| Skill | When to use |
|-------|-------------|
| `mcp-builder` | Building an MCP server |
| `webapp-testing` | Testing a local web app with Playwright |
| `agent-sandboxes` | Running code in a secure cloud sandbox |
| `graphify` | Build a knowledge graph from code/docs → clustered communities + audit report |
| `internal-comms` | Internal docs, status updates, newsletters |
| `doc-coauthoring` | Co-authoring a spec or proposal |

---

## Built-in Skills

Not in `~/.claude/skills/` — these ship with Claude Code itself. They appear in the `/` menu alongside the custom skills above.

| Skill | When to use |
|-------|-------------|
| `deep-research` | Multi-source, fact-checked, cited research report |
| `verify` | Run the app and observe behavior to confirm a change works |
| `code-review` | Review the current diff for bugs / cleanups (`--comment`, `--fix`) |
| `simplify` | Apply reuse / simplification / efficiency cleanups to the diff |
| `security-review` | Security review of pending branch changes |
| `review` | Review a pull request |
| `run` | Launch and drive the project's app to see a change live |
| `init` | Initialize a project `CLAUDE.md` with codebase docs |
| `loop` | Run a prompt / slash command on a recurring interval |
| `schedule` | Create / manage scheduled cloud agents (cron routines) |
| `claude-api` | Reference for Claude API / Anthropic SDK (models, pricing, params) |
| `update-config` | Configure the harness via `settings.json` (hooks, permissions, env) |
| `keybindings-help` | Customize keyboard shortcuts in `~/.claude/keybindings.json` |
| `fewer-permission-prompts` | Scan transcripts → add a read-only Bash/MCP allowlist |

---

## Memory

LLOYD maintains persistent memory at `~/.claude/projects/*/memory/`. Each project gets its own memory directory. Memories are recalled automatically at session start when relevant.

Types stored: user profile, feedback/corrections, project context, external references.

---

## Verify current skill count

```bash
echo "Skills: $(ls ~/.claude/skills/ | wc -l)"
echo "MCP servers: $(cat ~/.claude/settings.json | python -c "import sys,json; print(len(json.load(sys.stdin).get('mcpServers', {})))")"
```
