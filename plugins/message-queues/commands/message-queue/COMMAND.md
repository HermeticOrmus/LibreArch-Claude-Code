# /message-queue

> Design message broker topology, configure consumer groups, set up dead letter queues, and diagnose message processing failures.

## Usage

```
/message-queue design    - Choose broker and design exchange/topic/queue topology
/message-queue configure - Configure consumer with delivery semantics and DLQ
/message-queue debug     - Diagnose message loss, duplicate processing, or consumer lag
/message-queue dlq       - Design DLQ handling workflow for failed messages
```

## Trigger

Use this command when:
- Choosing between RabbitMQ, Kafka, SQS, or Azure Service Bus for a new integration
- Designing a RabbitMQ exchange and queue topology with proper routing
- Configuring Kafka consumer group offset management
- Setting up DLQ with alerts and a replay workflow
- Debugging consumer lag, message loss, or duplicate processing

## Process

### /message-queue design
1. Identify producers and consumers: what data flows from where to where?
2. Classify requirements: replay needed? (→ Kafka); AWS-native? (→ SQS/SNS); complex routing? (→ RabbitMQ).
3. Design topic/exchange structure: one topic per event type, not one per service pair.
4. For RabbitMQ: choose exchange type (topic for wildcard routing, fanout for broadcast).
5. Determine partition key (Kafka) or message group ID (SQS FIFO) for ordering.
6. Plan DLQ for every consumer queue.

### /message-queue configure
1. Set delivery semantics: at-least-once (default) with idempotent consumer, or exactly-once (Kafka transactions).
2. Configure consumer prefetch/batch size to match processing capacity.
3. Set visibility timeout (SQS) or ACK timeout (RabbitMQ) to exceed max processing time.
4. Configure retry policy: max attempts + backoff before DLQ routing.
5. Enable manual offset commit (Kafka) or manual ACK (RabbitMQ) — never auto-commit under load.

### /message-queue debug
1. Check DLQ depth first — messages there indicate consumer failures.
2. Check consumer lag (Kafka: `kafka-consumer-groups --describe`, watch `LAG` column).
3. Check consumer error logs for exception patterns.
4. Verify idempotency — if consumer fails after processing but before ACK, message will be redelivered.
5. Check visibility timeout / lock duration: if processing takes longer than timeout, message becomes visible again and is processed twice.

### /message-queue dlq
1. Set up DLQ alert: CloudWatch / Prometheus alarm on DLQ message count > 0.
2. Create DLQ consumer that logs message contents with metadata (failure count, routing key).
3. Classify failure type: transient (code bug now fixed) vs permanent (bad message data).
4. For transient: replay from DLQ to main queue after deploying the fix.
5. For permanent: log, create incident, manually resolve, discard.

## Examples

**Example: `/message-queue design`**

Input: "Payment service needs to notify 3 downstream services when a payment succeeds: order service (to confirm order), ledger service (to record accounting entry), notification service (to email receipt)."

Output:
```
Broker: AWS SNS + SQS (AWS-native, fan-out required, no replay needed)

SNS Topic: payments.events
  Attribute filter on eventType for selective subscription

SQS Queues (each with DLQ):
  payments-to-orders          → DLQ: payments-to-orders-dlq
  payments-to-ledger          → DLQ: payments-to-ledger-dlq
  payments-to-notifications   → DLQ: payments-to-notifications-dlq

All 3 queues subscribe to SNS topic with filter:
  eventType = ["PaymentSucceeded", "PaymentFailed"]

Visibility timeout: 60s (must exceed max processing time of all consumers)
Max receive count: 3 (then to DLQ)

DLQ alarms: CloudWatch alarm on each DLQ, threshold = 1 message
```

**Example: `/message-queue debug`**

Input: "Kafka consumer lag on orders topic growing — was 0 last night, now 50,000."

Diagnosis steps:
```
1. kafka-consumer-groups.sh --describe --group inventory-service
   → Check LAG per partition. Is lag on all partitions (consumer down?) or one (slow consumer)?

2. Check consumer logs for errors — is processing failing and retrying?

3. Check consumer CPU/memory — GC pauses can halt processing

4. Check producer throughput — sudden spike in order volume?

5. Check processing time per message — did a downstream DB slow down?

Fix: if consumer is slow:
  - Scale consumer replicas (up to partition count = 12)
  - If single-threaded consumer: increase max-poll-records and add parallelism within consumer
  - If DB bottleneck: add read replica or cache for lookup queries
```

## Output Format

- Broker recommendation with justification
- Exchange/topic/queue topology diagram (text)
- Consumer configuration properties
- DLQ setup with alert thresholds
- Replay procedure for DLQ messages
- Debug checklist with specific commands
