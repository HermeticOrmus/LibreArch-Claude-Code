# Message Queues Plugin

Message broker architecture for RabbitMQ, Kafka, AWS SQS/SNS, and Azure Service Bus. Covers exchange/topic topology design, delivery semantics, competing consumers, dead letter queues, consumer lag debugging, and idempotent message processing.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/messaging-architect/AGENT.md` | Expert in broker selection and messaging patterns. Covers RabbitMQ exchange types (direct, topic, fanout, headers), Kafka partition strategy and consumer groups, SQS/SNS fan-out, delivery semantics (at-most-once, at-least-once, exactly-once), DLQ design, prefetch/backpressure, and competing consumers. References Hohpe/Woolf EIP 2003, Kleppmann DDIA Chapter 11. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/message-queue/COMMAND.md` | `/message-queue design|configure|debug|dlq` — broker and topology selection, consumer delivery configuration, consumer lag debugging, and DLQ workflow design with replay procedures. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/messaging-patterns/SKILL.md` | Named patterns with code: RabbitMQ topic exchange with DLQ (Python), SQS+SNS fan-out with CDK (TypeScript), Kafka consumer group with idempotency (Java), competing consumers with prefetch (Python). Anti-patterns: queue-per-service-pair, synchronous wait after publish, no DLQ, unlimited prefetch. |

## When to Use

- Choosing between RabbitMQ, Kafka, and SQS for a new async integration
- Designing a fan-out topology where multiple consumers receive the same event
- Configuring consumer groups to scale processing with Kafka partitions
- Setting up DLQs and alerting on failed message delivery
- Debugging consumer lag or duplicate processing incidents

## Key References

- Hohpe, Gregor, and Bobby Woolf. _Enterprise Integration Patterns_. Addison-Wesley, 2003.
- Kleppmann, Martin. _Designing Data-Intensive Applications_. O'Reilly, 2017. Chapter 11.
- RabbitMQ AMQP concepts: rabbitmq.com/tutorials/amqp-concepts.html
- AWS SQS Developer Guide: docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide
