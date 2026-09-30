<p align="center">
  <img src="https://ormus.solutions/mascot/pixellab_liquid_to_bridge.gif" alt="LibreArch Claude Code" width="128" style="image-rendering: pixelated;" />
</p>

<h1 align="center">LibreArch Claude Code</h1>

<p align="center">
  <em>Software architecture with Claude Code — 20 plugins for DDD, microservices, distributed systems, event-driven design, and the architectural patterns that matter</em>
</p>

<p align="center">
  <a href="https://github.com/HermeticOrmus/LibreArch-Claude-Code/stargazers"><img src="https://img.shields.io/github/stars/HermeticOrmus/LibreArch-Claude-Code?style=flat-square&color=aa8142" alt="Stars" /></a>
  <img src="https://img.shields.io/badge/Architecture-aa8142?style=flat-square" alt="Architecture" />
  <img src="https://img.shields.io/badge/Claude_Code-aa8142?style=flat-square&logo=anthropic&logoColor=white" alt="Claude Code" />
</p>

---

> **Skills, agents, commands, and workflows for software architecture with Claude Code.**

Architecture decisions compound. The wrong choice at month 1 becomes a multi-quarter migration at month 18. Generic AI coding produces architecturally-defensible-looking code that hits walls at scale. **LibreArch gives Claude Code the architectural expertise to design systems that don't need rewriting in 18 months.**

## The 20 plugins

| Plugin | Domain | Command |
|---|---|---|
| **domain-driven-design** ⭐ | Bounded contexts, aggregates, value objects, domain events | `/ddd` |
| system-design | High-level architecture, capacity planning, technology selection | `/system-design` |
| microservices | Service boundaries, communication patterns, data ownership | `/microservices` |
| monolith-patterns | Modular monolith, when monoliths win, when to split | `/monolith` |
| event-driven | Event sourcing, event-carried state transfer, eventual consistency | `/event-driven` |
| cqrs-event-sourcing | Command Query Responsibility Segregation patterns | `/cqrs` |
| hexagonal-architecture | Ports and adapters, dependency direction | `/hex-arch` |
| clean-architecture | Layered architecture, dependency rule, use cases | `/clean-arch` |
| distributed-systems | CAP, consensus (Raft, Paxos), Byzantine fault tolerance | `/distributed` |
| data-consistency | Strong vs eventual, saga patterns, 2PC, idempotency | `/consistency` |
| saga-patterns | Choreography vs orchestration, compensation, failure recovery | `/saga` |
| api-gateway | BFF, routing, auth, rate limiting at the edge | `/api-gateway` |
| service-discovery | DNS-based, registry-based, sidecar (service mesh) | `/service-discovery` |
| message-queues | Kafka, RabbitMQ, SQS, NATS — when each fits | `/message-queue` |
| caching-strategies | Cache-aside, write-through, write-behind, invalidation | `/cache` |
| circuit-breaker | Resilience patterns, bulkheads, timeouts, retries | `/circuit-breaker` |
| database-patterns | Choice (RDBMS, document, K-V, graph, time-series), schema design | `/db-pattern` |
| scalability-patterns | Horizontal vs vertical, partitioning, sharding, replication | `/scale` |
| migration-strategies | Strangler fig, branch-by-abstraction, dark launching | `/migrate` |
| architecture-decision-records | ADR format, when to write, decision logs | `/adr` |

⭐ = depth-complete. Remaining 19 shell-improved.

Every plugin ships one agent, one slash command, and one skill: 20 agents, 20 commands, and 20 skills in all. A 21st plugin, `libre-arch-hooks`, is optional and adds hooks instead (see below).

## Quick start

### Install from Claude Code

```
/plugin marketplace add HermeticOrmus/LibreArch-Claude-Code
/plugin install domain-driven-design@libre-arch
```

The same from a terminal:

```bash
claude plugin marketplace add HermeticOrmus/LibreArch-Claude-Code
claude plugin install domain-driven-design@libre-arch
```

Install as many plugins as you need, then restart Claude Code to load them. `/plugin` inside Claude Code opens the plugin manager, where you can browse the rest of the pack.

### Install in Grok Build

Grok Build reads the same plugin folders. Add the marketplace, then install any plugin by name:

```bash
grok plugin marketplace add HermeticOrmus/LibreArch-Claude-Code
grok plugin install domain-driven-design@LibreArch-Claude-Code --trust
```

Or install one plugin straight from its folder, without adding the marketplace:

```bash
grok plugin install HermeticOrmus/LibreArch-Claude-Code#plugins/domain-driven-design --trust
```

`--trust` confirms you trust the source; without it Grok shows what the plugin would activate and stops. Start a new Grok session to load what you installed. From a clone, `./setup.sh --grok` installs the whole pack through the `grok` CLI. The `libre-arch-hooks` plugin uses a hook format Grok supports, but it has not been verified in a live Grok session (see the [ledger](LEDGER.md)).

### Install from a clone

```bash
git clone https://github.com/HermeticOrmus/LibreArch-Claude-Code.git ~/projects/LibreArch-Claude-Code
cd ~/projects/LibreArch-Claude-Code
./setup.sh
```

`./setup.sh` registers the clone as the `libre-arch` marketplace and installs all 21 plugins through the Claude Code CLI. `./setup.sh --list` shows them, `./setup.sh --only domain-driven-design,event-driven` installs a subset, and `./setup.sh --uninstall` removes them. Add `--grok` to install through Grok Build instead; it works with `--list`, `--only`, and `--uninstall`, and needs `grok` and `jq`.

### Optional hooks

`libre-arch-hooks` prints a one-line architecture summary when a session starts, asks before Claude reads or edits `.env`, key, or secrets files, and scans each edited source file for dependency-direction violations. Add it with `/plugin install libre-arch-hooks@libre-arch`. Details: [plugins/libre-arch-hooks](plugins/libre-arch-hooks/README.md).

### First prompt

```
/ddd identify bounded contexts for a marketplace platform: sellers list inventory, buyers browse + purchase, finance processes payouts, customer support handles disputes. Where are the seams?
```

See [QUICK_START.md](QUICK_START.md). Learning paths: [beginner](learning-paths/beginner.md), [intermediate](learning-paths/intermediate.md), [advanced](learning-paths/advanced.md).

## Feedback

Starred this? Tell us what worked and what is missing: [open a feedback issue](https://github.com/HermeticOrmus/LibreArch-Claude-Code/issues/new?template=feedback.yml). Every piece of feedback gets an answer, and changes that come from it are credited in the release notes.

Cracks we found and sealed: [LEDGER.md](LEDGER.md).

## Contribute

- Pick up the next piece of work from the [Menu](pantry/MENU.md): each item has a Done-when anyone can check, and the research behind it lives in [`pantry/`](pantry/README.md).
- New here? Start with the [good first issues](https://github.com/HermeticOrmus/LibreArch-Claude-Code/contribute).
- Use the forms: [feedback](https://github.com/HermeticOrmus/LibreArch-Claude-Code/issues/new?template=feedback.yml), [routing miss](https://github.com/HermeticOrmus/LibreArch-Claude-Code/issues/new?template=routing-miss.yml) when Claude picks the wrong plugin, and [plugin proposal](https://github.com/HermeticOrmus/LibreArch-Claude-Code/issues/new?template=plugin-proposal.yml).
- Questions and show-and-tell go in [Discussions](https://github.com/HermeticOrmus/LibreArch-Claude-Code/discussions).

## Contributing

PRs are welcome for plugin depth, architecture case studies, and language-specific examples. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT.

---

## Part of the Libre Open-Source Stack for Claude Code

This repository is part of a growing family of open-source toolkits for Claude Code.

### Libre suite — comprehensive plugin bundles

- [LibreUIUX-Claude-Code](https://github.com/HermeticOrmus/LibreUIUX-Claude-Code) — UI/UX development (152 agents, 70 plugins, 76 commands, 74 skills)
- [LibreCopy-Claude-Code](https://github.com/HermeticOrmus/LibreCopy-Claude-Code) — Technical writing and documentation engineering
- [LibreDevOps-Claude-Code](https://github.com/HermeticOrmus/LibreDevOps-Claude-Code) — DevOps engineering and infrastructure automation
- [LibreEmbed-Claude-Code](https://github.com/HermeticOrmus/LibreEmbed-Claude-Code) — Embedded systems, firmware, and IoT development
- [LibreFinTech-Claude-Code](https://github.com/HermeticOrmus/LibreFinTech-Claude-Code) — Financial technology development
- [LibreGEO-Claude-Code](https://github.com/HermeticOrmus/LibreGEO-Claude-Code) — AI-search optimization (ChatGPT, Perplexity, Gemini, Google AI Overviews)
- [LibreGameDev-Claude-Code](https://github.com/HermeticOrmus/LibreGameDev-Claude-Code) — Game development across Godot, Unity, Unreal
- [LibreMLOps-Claude-Code](https://github.com/HermeticOrmus/LibreMLOps-Claude-Code) — ML engineering and AI operations
- [LibreMobileDev-Claude-Code](https://github.com/HermeticOrmus/LibreMobileDev-Claude-Code) — Mobile app development (Flutter, React Native, native iOS, native Android)
- [LibreSecOps-Claude-Code](https://github.com/HermeticOrmus/LibreSecOps-Claude-Code) — Security operations
- [LibreSessionFlow-Claude-Code](https://github.com/HermeticOrmus/LibreSessionFlow-Claude-Code) — Session lifecycle: handoff, pickup, absorb, explore, close

### Skills mini-repos — single CLAUDE.md drop-ins

- [vibe-engineer-skills](https://github.com/HermeticOrmus/vibe-engineer-skills) — Direct AI codegen well: hypothesis before help, scoped prompts, validate before accepting
- [markdown-discipline-skills](https://github.com/HermeticOrmus/markdown-discipline-skills) — Strip AI-slop from markdown (no em dashes, no marketing fluff)
- [shell-safety-skills](https://github.com/HermeticOrmus/shell-safety-skills) — `set -euo pipefail` discipline plus 15 failure-mode examples
- [commit-standard-skills](https://github.com/HermeticOrmus/commit-standard-skills) — Ormus Commit Standard v1.0 plus commit-msg hook and commitlint
- [unwoke-skills](https://github.com/HermeticOrmus/unwoke-skills) — Strip AI theater (ten sins to eliminate, symmetric engagement)
- [python-conventions-skills](https://github.com/HermeticOrmus/python-conventions-skills) — Modern Python 3.11+ (types, pathlib, async, ruff, mypy, uv)
- [typescript-conventions-skills](https://github.com/HermeticOrmus/typescript-conventions-skills) — TypeScript strict mode, discriminated unions, Result types
- [hermetic-laws-skills](https://github.com/HermeticOrmus/hermetic-laws-skills) — Seven Hermetic Principles applied to engineering
- [riper-workflow-skills](https://github.com/HermeticOrmus/riper-workflow-skills) — Research / Innovate / Plan / Execute / Review systematic dev
- [six-day-cycle-skills](https://github.com/HermeticOrmus/six-day-cycle-skills) — Sustainable shipping cadence with mandatory rest
- [token-optimization-skills](https://github.com/HermeticOrmus/token-optimization-skills) — Claude Code token and context optimization
- [osint-skills](https://github.com/HermeticOrmus/osint-skills) — OSINT research methodology (multi-wave investigative spiral)
- [calcinate-skills](https://github.com/HermeticOrmus/calcinate-skills) — Stage 1 of the Magnum Opus (burn project bloat)
- [claude-md-overhaul-skills](https://github.com/HermeticOrmus/claude-md-overhaul-skills) — Audit CLAUDE.md and MEMORY.md against caps
- [session-handoff-skills](https://github.com/HermeticOrmus/session-handoff-skills) — Session handoff and pickup discipline
- [naming-skills](https://github.com/HermeticOrmus/naming-skills) — Product naming methodology (mine the brand's vocabulary)
- [magnum-opus-skills](https://github.com/HermeticOrmus/magnum-opus-skills) — Seven-stage alchemy applied to project transformation
- [mem-search-skills](https://github.com/HermeticOrmus/mem-search-skills) — Search claude-mem cross-session memory: search, filter, fetch
- [hypothesis-debugging-skills](https://github.com/HermeticOrmus/hypothesis-debugging-skills) — Hypothesis-driven debugging: reproduce, isolate, test, fix
- [vibe-proof-skills](https://github.com/HermeticOrmus/vibe-proof-skills) — Security hardening for vibe-coded full-stack apps
- [tdd-skills](https://github.com/HermeticOrmus/tdd-skills) — Test-driven development (Red-Green-Refactor) for JS/TS and Python
- [mars-skills](https://github.com/HermeticOrmus/mars-skills) — Production-readiness audit: the five mortal sins of vibe-coded MVPs
- [git-workflow-skills](https://github.com/HermeticOrmus/git-workflow-skills) — Clean git workflow: branch, atomic commits, reviewable PRs
- [code-review-skills](https://github.com/HermeticOrmus/code-review-skills) — Domain-aware code review: classify the code, then focus
- [code-comprehension-skills](https://github.com/HermeticOrmus/code-comprehension-skills) — Understand an unfamiliar codebase fast
- [dx-audit-skills](https://github.com/HermeticOrmus/dx-audit-skills) — Audit developer experience: docs, onboarding, tooling friction
- [setup-env-skills](https://github.com/HermeticOrmus/setup-env-skills) — Set up a project's development environment
- [automate-skills](https://github.com/HermeticOrmus/automate-skills) — Turn repetitive tasks into reliable automation scripts
- [quick-fix-skills](https://github.com/HermeticOrmus/quick-fix-skills) — Fast troubleshooting for common issues
- [prime-context-skills](https://github.com/HermeticOrmus/prime-context-skills) — Prime project context at the start of a session
- [auto-docs-skills](https://github.com/HermeticOrmus/auto-docs-skills) — Generate and maintain project documentation
- [learning-skills](https://github.com/HermeticOrmus/learning-skills) — Learn any technology: roadmaps, explanations, practice, cheatsheets, comparisons
- [linux-sysadmin-skills](https://github.com/HermeticOrmus/linux-sysadmin-skills) — Linux system administration: security, performance, diagnostics, monitoring, maintenance

### Template source

- [andrej-karpathy-skills](https://github.com/HermeticOrmus/andrej-karpathy-skills) — the canonical single-file CLAUDE.md pattern (fork of jiayuan_jy's original)

Star the family, not just one — that's how the suite stays coherent.
