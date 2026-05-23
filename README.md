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
