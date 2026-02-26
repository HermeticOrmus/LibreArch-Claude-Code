# /event-driven

> Design event-driven architectures, publish events reliably, configure consumers with idempotency, and replay historical events.

## Usage

```
/event-driven design    - Choose broker, choreography vs orchestration, topic/queue structure
/event-driven publish   - Design reliable event publishing with outbox pattern
/event-driven consume   - Configure consumer group, idempotency, DLQ handling
/event-driven replay    - Design event replay strategy for projections or recovery
```

## Trigger

Use this command when:
- Decoupling two services that currently call each other synchronously
- Choosing between Kafka, SQS/SNS, RabbitMQ, or Azure Service Bus
- Designing reliable event publishing from a service that also writes to a database
- Configuring consumer groups with proper offset management and DLQ handling
- Rebuilding a read model or recovering a service from historical events

## Process

### /event-driven design
1. Identify the domain events: what happened (past tense, e.g., OrderPlaced, PaymentFailed)?
2. Choose broker: Kafka for high throughput + replay; SQS/SNS for AWS-native fan-out; RabbitMQ for routing flexibility.
3. Decide choreography vs orchestration: use orchestration if the process has compensation steps or more than 3 services involved.
4. Design topic/queue structure: one topic per event type, not one topic per service.
5. Choose partition key (Kafka): use aggregate ID for per-aggregate ordering.
6. Define CloudEvents envelope for each event type.

### /event-driven publish
1. Identify the dual-write problem: service writes to DB and needs to emit event.
2. Implement outbox pattern: write OutboxMessage in same DB transaction as domain state.
3. Choose relay mechanism: Debezium CDC (preferred — log-based, low latency) or scheduled polling.
4. Set producer acknowledgment: `acks=all` (Kafka) or `MessageDeduplicationId` (SQS FIFO).
5. Enable idempotent producer (`enable.idempotence=true` in Kafka) to prevent duplicates.

### /event-driven consume
1. Define consumer group ID per consumer application (not per instance).
2. Implement idempotency check: store processed event IDs in Redis or DB before processing.
3. Configure max retries and retry backoff before DLQ routing.
4. Set up DLQ: separate queue/topic that receives messages after N failed retries.
5. Alert on DLQ depth > 0.
6. Commit offset only after successful processing (manual offset commit in Kafka).

### /event-driven replay
1. Identify replay trigger: new consumer needs history, read model rebuild, recovery.
2. For Kafka: seek consumer group offset to earliest or specific timestamp.
3. Ensure consumer handles idempotency (replay delivers duplicates of already-processed events).
4. Isolate replay consumer group from production to avoid offset interference.
5. Monitor replay lag: `kafka-consumer-groups --describe` shows lag per partition.

## Examples

**Example: `/event-driven design`**

Input: "Order service places orders. Inventory service needs to reserve stock. Notification service needs to email the customer. Currently both are synchronous REST calls from Order service."

Output:
```
Event: OrderPlaced
Topic: orders.placed (Kafka) or orders-placed SNS topic
CloudEvents type: com.example.orders.v1.OrderPlaced
Partition key: orderId (ordering per order guaranteed)

Consumers:
  inventory-service  consumer group: inventory-order-consumer
    → Listens to orders.placed
    → Reserves stock, publishes InventoryReserved or InventoryInsufficient

  notification-service  consumer group: notification-order-consumer
    → Listens to orders.placed
    → Sends confirmation email

Pattern: Choreography (2 independent consumers, no compensation needed)

If inventory reservation fails: publish InventoryInsufficient event
  → Order service listens, cancels order, publishes OrderCancelled
  → Notification service listens to OrderCancelled, sends cancellation email
```

**Example: `/event-driven consume`**

Input: "Kafka consumer for inventory reservation. Orders topic has 12 partitions."

Output:
```
Consumer configuration (application.yml):
  spring.kafka.consumer:
    group-id: inventory-order-consumer
    auto-offset-reset: earliest
    enable-auto-commit: false   # Manual commit after processing
    max-poll-records: 50
    isolation-level: read_committed  # Only read fully committed messages

Idempotency:
  Table: processed_events (event_id VARCHAR PK, processed_at TIMESTAMP)
  Before processing: SELECT 1 FROM processed_events WHERE event_id = ?
  After processing: INSERT INTO processed_events ...

DLQ: orders.placed.dlq (separate topic)
  Retry: 3 attempts with 1s, 5s, 30s backoff
  After 3 failures: send to DLQ with failure metadata headers

Scale: 12 consumers max (one per partition). Start with 4, scale with lag metric.
```

## Output Format

- Broker selection with justification
- Topic/queue structure diagram
- CloudEvents type definitions
- Outbox table schema and relay configuration
- Consumer group configuration YAML
- DLQ setup and alert thresholds
- Replay procedure steps
