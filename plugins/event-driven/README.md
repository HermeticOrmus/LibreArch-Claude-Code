# Event-Driven Plugin

Event-driven architecture patterns covering Kafka, AWS SNS/SQS, Azure Service Bus, CloudEvents, choreography vs orchestration, outbox pattern, dead letter queues, and schema evolution.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/event-architect/AGENT.md` | Expert in event-driven systems at scale. Covers broker selection (Kafka vs SQS vs RabbitMQ), CloudEvents specification, outbox pattern, choreography vs orchestration decision criteria, DLQ strategy, Kafka partition key selection, and Avro schema evolution with Confluent Schema Registry. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/event-driven/COMMAND.md` | `/event-driven design|publish|consume|replay` — event topology design, outbox pattern for reliable publishing, consumer group configuration with idempotency, and Kafka offset replay for read model rebuilding. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/event-driven-patterns/SKILL.md` | Named patterns with code: CloudEvents envelope (TypeScript), Kafka producer with idempotent config, Kafka consumer with idempotency guard, Outbox pattern (Java + Spring), DLQ retry handler (Java), Avro schema evolution. Anti-patterns: publishing inside DB transaction, fat events, no DLQ monitoring. |

## When to Use

- Decoupling synchronous REST calls between services into async events
- Designing reliable event publishing from services that also write to a database
- Setting up Kafka consumer groups with proper offset management
- Choosing between choreography and orchestration for a multi-service saga
- Evolving event schemas without breaking existing consumers

## Key References

- Hohpe, Gregor, and Bobby Woolf. _Enterprise Integration Patterns_. Addison-Wesley, 2003.
- Newman, Sam. _Building Microservices_, 2nd ed. O'Reilly, 2021.
- CNCF CloudEvents specification: cloudevents.io
- Richardson, Chris. Outbox pattern: microservices.io/patterns/data/transactional-outbox.html
- Kleppmann, Martin. _Designing Data-Intensive Applications_. O'Reilly, 2017. Chapter 11.
