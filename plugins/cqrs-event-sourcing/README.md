# CQRS/Event Sourcing Plugin

Designs and implements Command Query Responsibility Segregation (CQRS) and Event Sourcing systems. Covers command handlers with optimistic concurrency, event-sourced aggregate design, projection rebuilding, snapshot strategies, event schema versioning (upcasting), and EventStoreDB/Marten configuration.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/cqrs-architect/AGENT.md` | Expert in Greg Young's CQRS (2010), Martin Fowler's event sourcing, EventStoreDB, Marten, Axon Framework. Command handler pattern, optimistic concurrency via stream versioning, aggregate reconstitution, snapshot strategy, projection design, event upcasting. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/cqrs/COMMAND.md` | `/cqrs command|project|rebuild|snapshot` — command handler generation, projection design for specific query patterns, zero-downtime projection rebuild planning, snapshot threshold configuration. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/cqrs-patterns/SKILL.md` | Named patterns with code: event-sourced aggregate root (Java), command handler with optimistic concurrency (Java), read model projection (Java), snapshot with Marten (C#), event upcasting pipeline. Anti-patterns with analysis. |

## When to Use

- Domain has audit trail or regulatory history requirements
- Read and write load are asymmetric (10:1 reads:writes or more)
- Multiple views of the same data are needed in different shapes
- Domain events need to drive integration with downstream systems
- Temporal queries are required ("what was the state at time T?")

When NOT to use: simple CRUD, small teams, no audit requirements, simple domain. CQRS/ES adds significant complexity that must be justified.

## Key References

- Young, Greg. CQRS Documents. cqrs.files.wordpress.com, 2010.
- Fowler, Martin. "Event Sourcing." martinfowler.com/eaaDev/EventSourcing.html. 2005.
- Fowler, Martin. "CQRS." martinfowler.com/bliki/CQRS.html. 2011.
- Vernon, Vaughn. _Implementing Domain-Driven Design_. Addison-Wesley, 2013.
- EventStoreDB: developers.eventstore.com.
- Marten (PostgreSQL event store): martendb.io.
