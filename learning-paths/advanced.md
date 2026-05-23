# Advanced — distributed systems + migrations + evolutionary architecture

## Distributed systems realities

- **CAP**: pick 2 of consistency, availability, partition tolerance — partition is inevitable so really pick CP or AP
- **Consensus**: Raft + Paxos for strong-consistency replication; expensive
- **Byzantine fault tolerance**: only matters if you don't trust the nodes (rare in internal systems)
- **Time**: clocks drift; vector clocks or hybrid logical clocks for ordering

## Migration strategies

| Pattern | When |
|---|---|
| Strangler fig | Gradually replace; route traffic; retire old |
| Branch by abstraction | Refactor inside the codebase; flag-based switch |
| Dark launching | Run new alongside old without exposing; compare |
| Parallel run | Both produce output; compare; switch when confident |
| Re-platform | All at once; risky but sometimes needed |

Strangler fig is the default. The others have specific cases.

## Evolutionary architecture

- **Fitness functions**: automated checks that architectural properties hold (e.g., bounded contexts don't depend on each other in forbidden ways)
- **Architectural decision records**: capture decisions + their context for future-you
- **Continuous architectural review**: not a one-time thing; periodic re-examination

## What's still hard

- **Truly distributed transactions across services** (sagas are the workaround, not a solution)
- **Schema evolution across many consumers** (versioning, deprecation, contracts)
- **Multi-region with strong consistency** (CAP is real)
- **Microservices without operational maturity** (you become the operator team's bottleneck)
