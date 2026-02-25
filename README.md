<p align="center">
  <h1 align="center">LibreArch-Claude-Code</h1>
  <p align="center">
    <img src="https://img.shields.io/badge/plugins-20-268bd2?style=flat-square" alt="Plugins: 20" />
    <img src="https://img.shields.io/badge/license-MIT-268bd2?style=flat-square" alt="License: MIT" />
    <img src="https://img.shields.io/badge/claude--code-plugins-268bd2?style=flat-square" alt="Claude Code Plugins" />
  </p>
</p>

A curated collection of Claude Code plugins for software architecture and system design. From DDD to microservices, CQRS to event sourcing, clean architecture to distributed systems.

---

## What This Is

LibreArch is a **plugin collection** that gives Claude Code deep expertise in software architecture and system design. Each plugin provides an **agent** (specialized persona), a **command** (slash command interface), and a **skill** (knowledge base and patterns) -- all designed for principled, production-grade architectural work.

This is not textbook summaries. Every pattern, trade-off, and recommendation accounts for real-world complexity: team coordination, evolutionary architecture, operational cost, and the messy reality of systems that must change over time.

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/HermeticOrmus/LibreArch-Claude-Code.git
```

### 2. Copy a plugin into your project

```bash
# Example: Add Domain-Driven Design patterns to your project
cp -r LibreArch-Claude-Code/plugins/domain-driven-design/.claude/ your-project/.claude/

# Or cherry-pick specific components
cp LibreArch-Claude-Code/plugins/domain-driven-design/agents/ddd-architect/AGENT.md \
   your-project/.claude/agents/ddd-architect.md
```

### 3. Copy the Architecture CLAUDE.md template

```bash
cp LibreArch-Claude-Code/templates/CLAUDE.md your-project/CLAUDE.md
# Edit to match your architecture and domain
```

### 4. Install hooks (optional)

```bash
cp LibreArch-Claude-Code/hooks/*.sh your-project/.claude/hooks/
chmod 755 your-project/.claude/hooks/*.sh
```

---

## Plugins

| # | Plugin | Description | Category |
|---|--------|-------------|----------|
| 1 | [api-gateway](plugins/api-gateway/) | API gateway patterns, routing, rate limiting, aggregation | Integration |
| 2 | [architecture-decision-records](plugins/architecture-decision-records/) | ADR creation, templates, decision tracking | Governance |
| 3 | [caching-strategies](plugins/caching-strategies/) | Cache patterns, invalidation, distributed caching, CDN | Performance |
| 4 | [circuit-breaker](plugins/circuit-breaker/) | Circuit breaker, bulkhead, retry, timeout patterns | Resilience |
| 5 | [clean-architecture](plugins/clean-architecture/) | Clean/onion architecture, dependency rule, use cases | Structure |
| 6 | [cqrs-event-sourcing](plugins/cqrs-event-sourcing/) | CQRS, event sourcing, projections, event stores | Data |
| 7 | [database-patterns](plugins/database-patterns/) | Repository pattern, unit of work, sharding, replication | Data |
| 8 | [data-consistency](plugins/data-consistency/) | Eventual consistency, strong consistency, conflict resolution | Data |
| 9 | [distributed-systems](plugins/distributed-systems/) | Consensus, partitioning, replication, CAP theorem | Distributed |
| 10 | [domain-driven-design](plugins/domain-driven-design/) | Bounded contexts, aggregates, value objects, ubiquitous language | Modeling |
| 11 | [event-driven](plugins/event-driven/) | Event bus, pub/sub, event choreography vs orchestration | Messaging |
| 12 | [hexagonal-architecture](plugins/hexagonal-architecture/) | Ports and adapters, dependency inversion, testability | Structure |
| 13 | [message-queues](plugins/message-queues/) | RabbitMQ, Kafka, SQS, dead letter queues, message patterns | Messaging |
| 14 | [microservices](plugins/microservices/) | Service decomposition, communication, data management | Distributed |
| 15 | [migration-strategies](plugins/migration-strategies/) | Strangler fig, parallel run, database migration, API versioning | Evolution |
| 16 | [monolith-patterns](plugins/monolith-patterns/) | Modular monolith, monolith-first, decomposition readiness | Structure |
| 17 | [saga-patterns](plugins/saga-patterns/) | Saga orchestration, choreography, compensation, long-running processes | Data |
| 18 | [scalability-patterns](plugins/scalability-patterns/) | Horizontal/vertical scaling, load balancing, auto-scaling | Performance |
| 19 | [service-discovery](plugins/service-discovery/) | Service registry, client/server-side discovery, health checks | Integration |
| 20 | [system-design](plugins/system-design/) | System design interviews, capacity planning, trade-off analysis | Design |

---

## Architecture

```
LibreArch-Claude-Code/
|
|-- plugins/                    # 20 architecture domain plugins
|   |-- {plugin-name}/
|   |   |-- README.md           # Plugin overview and usage
|   |   |-- agents/             # Specialized agent definitions
|   |   |   +-- {name}/AGENT.md
|   |   |-- commands/           # Slash command definitions
|   |   |   +-- {name}/COMMAND.md
|   |   +-- skills/             # Knowledge base and patterns
|   |       +-- {name}/SKILL.md
|   +-- ...
|
|-- learning-paths/             # Progressive skill building
|   |-- beginner.md             # SOLID, design patterns, layered architecture
|   |-- intermediate.md         # DDD, hexagonal, event-driven, API design
|   +-- advanced.md             # Distributed systems, consensus, CAP theorem
|
|-- hooks/                      # Session automation
|   |-- session-start.sh        # Architecture pattern detection
|   |-- pre-tool-use.sh         # Dependency direction validation
|   +-- post-tool-use.sh        # Architecture fitness function verification
|
|-- templates/                  # Project configuration templates
|   +-- CLAUDE.md               # Architecture-focused CLAUDE.md template
|
+-- .github/                    # Repository management
    |-- FUNDING.yml
    |-- PULL_REQUEST_TEMPLATE.md
    +-- ISSUE_TEMPLATE/
```

### Plugin Anatomy

Each plugin provides three components that work together:

- **Agent** (`AGENT.md`) -- A specialized persona with defined expertise, behavior patterns, and output formats. Use when you need deep domain knowledge and structured guidance.
- **Command** (`COMMAND.md`) -- A slash command interface for common operations. Use for quick, repeatable tasks.
- **Skill** (`SKILL.md`) -- A knowledge base of patterns, anti-patterns, and references. Use as a reference library for best practices.

### How Plugins Compose

Plugins are designed to be used individually or combined. A typical architecture project might use:

- `domain-driven-design` + `hexagonal-architecture` for strategic modeling
- `cqrs-event-sourcing` + `event-driven` for event-centric systems
- `microservices` + `service-discovery` + `api-gateway` for distributed architectures
- `clean-architecture` + `database-patterns` for well-structured monoliths

---

## Learning Paths

| Path | Audience | Topics |
|------|----------|--------|
| [Beginner](learning-paths/beginner.md) | New to architecture | SOLID principles, design patterns, layered architecture |
| [Intermediate](learning-paths/intermediate.md) | Working developers | DDD, hexagonal architecture, event-driven design, API design |
| [Advanced](learning-paths/advanced.md) | Senior engineers | Distributed systems, consensus, CAP theorem, event sourcing at scale |

---

## Hooks

The hooks directory contains automation scripts for Claude Code sessions:

| Hook | Purpose |
|------|---------|
| `session-start.sh` | Detects architecture patterns in codebase -- layering, DDD markers, event patterns |
| `pre-tool-use.sh` | Validates dependency direction, checks for coupling violations before edits |
| `post-tool-use.sh` | Verifies architecture fitness functions after code changes |

Install by copying to `.claude/hooks/` in your project and making executable.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. Key principles:

- **Architecture-aware only** -- No patterns presented without trade-off analysis
- **Context over dogma** -- Every recommendation must state when it does NOT apply
- **Test what you contribute** -- Validate patterns in real codebases
- **Document the forces** -- State the architectural forces that drive each decision

---

## License

[MIT](LICENSE) -- Copyright (c) 2025-2026 Hermetic Ormus

---

**Build what elevates. Reject what degrades. Share what empowers.**
