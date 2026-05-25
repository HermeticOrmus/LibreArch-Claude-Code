<p align="center">
  <img src="https://ormus.solutions/mascot/chain_braces_to_swan.gif" alt="LibreArch Claude Code" width="128" style="image-rendering: pixelated;" />
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

| Plugin | Domain |
|---|---|
| **domain-driven-design** ⭐ | Bounded contexts, aggregates, value objects, domain events |
| system-design | High-level architecture, capacity planning, technology selection |
| microservices | Service boundaries, communication patterns, data ownership |
| monolith-patterns | Modular monolith, when monoliths win, when to split |
| event-driven | Event sourcing, event-carried state transfer, eventual consistency |
| cqrs-event-sourcing | Command Query Responsibility Segregation patterns |
| hexagonal-architecture | Ports and adapters, dependency direction |
| clean-architecture | Layered architecture, dependency rule, use cases |
| distributed-systems | CAP, consensus (Raft, Paxos), Byzantine fault tolerance |
| data-consistency | Strong vs eventual, saga patterns, 2PC, idempotency |
| saga-patterns | Choreography vs orchestration, compensation, failure recovery |
| api-gateway | BFF, routing, auth, rate limiting at the edge |
| service-discovery | DNS-based, registry-based, sidecar (service mesh) |
| message-queues | Kafka, RabbitMQ, SQS, NATS — when each fits |
| caching-strategies | Cache-aside, write-through, write-behind, invalidation |
| circuit-breaker | Resilience patterns, bulkheads, timeouts, retries |
| database-patterns | Choice (RDBMS, document, K-V, graph, time-series), schema design |
| scalability-patterns | Horizontal vs vertical, partitioning, sharding, replication |
| migration-strategies | Strangler fig, branch-by-abstraction, dark launching |
| architecture-decision-records | ADR format, when to write, decision logs |

⭐ = depth-complete. Remaining 19 shell-improved.

## Quick start

```bash
git clone https://github.com/HermeticOrmus/LibreArch-Claude-Code.git ~/projects/LibreArch-Claude-Code
cd ~/projects/LibreArch-Claude-Code
./setup.sh
```

```
/ddd identify bounded contexts for a marketplace platform: sellers list inventory, buyers browse + purchase, finance processes payouts, customer support handles disputes. Where are the seams?
```

See [QUICK_START.md](QUICK_START.md). Learning paths: [beginner](learning-paths/beginner.md), [intermediate](learning-paths/intermediate.md), [advanced](learning-paths/advanced.md).

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
- [explore-code-skills](https://github.com/HermeticOrmus/explore-code-skills) — Understand an unfamiliar codebase fast
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
