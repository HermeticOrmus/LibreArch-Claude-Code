# Saga Patterns Plugin

Distributed saga design for orchestration (Temporal, Conductor, Axon) and choreography patterns, compensating transactions, saga isolation anomalies, semantic lock countermeasures, and failure recovery.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/saga-architect/AGENT.md` | Expert in saga design and failure modes. Covers orchestration vs choreography decision criteria, compensating transaction design (idempotency, commutativity), Temporal durable execution model, isolation anomalies (dirty read, lost update, fuzzy read), semantic lock and other countermeasures, and saga failure recovery. References Richardson 2018, Garcia-Molina/Salem 1987, Temporal docs. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/saga/COMMAND.md` | `/saga design|compensate|debug|isolation` — saga step and compensation design, idempotent compensation definition, stuck saga diagnosis, and isolation anomaly countermeasure selection. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/saga-patterns/SKILL.md` | Named patterns with code: orchestrated saga with Temporal (Java), choreography saga with Kafka compensating events (Java), semantic lock countermeasure (Java), idempotent compensating transaction (Java). Anti-patterns: saga without compensations, long choreography chains, non-idempotent compensations, saga for local transactions. |

## When to Use

- A business operation spans multiple services and needs all-or-nothing semantics
- Replacing a distributed 2PC transaction with an eventually consistent saga
- Designing the compensation tree for a partially-implemented saga
- Debugging a Temporal workflow stuck in a failed/compensating state
- Identifying concurrent saga isolation problems causing dirty reads or lost updates

## Key References

- Richardson, Chris. _Microservices Patterns_. Manning, 2018. Chapter 4.
- Garcia-Molina, Hector, and Kenneth Salem. "Sagas." ACM SIGMOD 1987.
- Temporal.io documentation: docs.temporal.io
- Ruecker, Bernd. _Practical Process Automation_. O'Reilly, 2021.
- Richardson, Chris. microservices.io/patterns/data/saga.html
