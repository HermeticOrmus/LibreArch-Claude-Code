# /cqrs

> Design, implement, debug, or manage projections for CQRS and Event Sourcing systems. Produces command handlers, event store configurations, projection code, and snapshot strategies.

## Usage

```
/cqrs command   - Design a command handler with aggregate load, validation, and event persistence
/cqrs project   - Design or fix a read model projection for a set of domain events
/cqrs rebuild   - Plan a safe projection rebuild without downtime
/cqrs snapshot  - Design a snapshot strategy for long-lived aggregates
```

## Trigger

Use this command when:
- Implementing a new command in an event-sourced system
- Adding a new read model/projection for a specific query requirement
- A projection is inconsistent and needs to be rebuilt
- Aggregate event streams are growing long (10k+ events) and load latency is increasing
- An event schema needs to change without breaking existing event consumers (upcasting)
- Evaluating whether CQRS/Event Sourcing is appropriate for a use case

## Input

**For `/cqrs command`:**
- Command name and the business operation it represents
- Aggregate type and what invariants it enforces
- Events that should be raised on success
- Expected error cases (business rule violations, concurrency conflicts)

**For `/cqrs project`:**
- Domain events to project
- Query pattern the projection must support (e.g., "list orders by customer sorted by date")
- Technology (PostgreSQL, Elasticsearch, Redis sorted set, MongoDB)

**For `/cqrs rebuild`:**
- Current projection state (how stale/corrupted it is)
- Event store size (how many streams, how many events total)
- Can the system tolerate downtime during rebuild?

**For `/cqrs snapshot`:**
- Aggregate type and typical event count per aggregate lifetime
- Current load latency for high-event-count aggregates
- Snapshot storage (same event store, separate database, in-memory for tests)

## Process

### /cqrs command
1. Define command record (plain data, no behavior).
2. Design command handler: validate → load aggregate → execute business logic → persist events.
3. Identify optimistic concurrency strategy (expected version check).
4. Define aggregate `apply(event)` method additions for new events.
5. Generate command handler test with happy path and conflict scenario.

### /cqrs project
1. Identify the specific query pattern(s) the projection must serve.
2. Design the projection schema (denormalized table, search index, cache) optimized for those queries.
3. Write event handler methods for each relevant event.
4. Handle out-of-order events if projection is built asynchronously.
5. Add idempotency: if the same event is received twice, the projection remains consistent.

### /cqrs rebuild
1. Assess rebuild approach: (a) rebuild in background, swap when complete; (b) rebuild from last consistent checkpoint; (c) rebuild with dual-write while keeping old projection live.
2. Estimate rebuild time: event count / processing rate.
3. Handle in-flight commands during rebuild: pause writes, or accept eventual consistency.
4. Verify projection consistency after rebuild (spot-check samples, compare counters).

### /cqrs snapshot
1. Identify threshold: snapshot every N events (typically 50–200).
2. Decide snapshot trigger: on save after every Nth event, or on-demand for cold aggregates.
3. Design snapshot storage: same event store (EventStoreDB metadata), or separate table.
4. Ensure snapshot includes version for correct post-snapshot event replay.
5. Handle missing snapshot gracefully (cold start — replay full stream).

## Examples

**Example: `/cqrs command`**

Input: "Command: DispatchOrder. Order aggregate. Raises OrderDispatched event. Cannot dispatch if not confirmed or already dispatched."

Output:
```java
// Command
public record DispatchOrderCommand(String orderId, String trackingId, String dispatchedBy) {}

// Handler
@CommandHandler
public class DispatchOrderCommandHandler {
    public void handle(DispatchOrderCommand command) {
        String streamId = "order-" + command.orderId();
        var events = eventStore.readStream(streamId);
        var order = Order.reconstitute(events.stream().map(this::deserialize).toList());
        var currentVersion = events.get(events.size()-1).getStreamRevision().getValueUnsigned();

        var newEvents = order.dispatch(command.trackingId(), command.dispatchedBy());

        eventStore.appendToStream(streamId, ExpectedRevision.expectedRevision(currentVersion), ...);
    }
}

// Aggregate method
public List<DomainEvent> dispatch(String trackingId, String dispatchedBy) {
    if (this.status != OrderStatus.CONFIRMED)
        throw new DomainException("Order must be confirmed before dispatch");
    var event = new OrderDispatchedEvent(this.id, trackingId, dispatchedBy, Instant.now());
    this.applyEvent(event);
    return List.of(event);
}
```

**Example: `/cqrs rebuild`**

Input: "OrderSummary projection is corrupt — counts are wrong. 500k events across 50k streams. System cannot have downtime."

Output: Rebuild-in-background strategy:
1. Create `order_summary_v2` table with same schema as `order_summary`.
2. Start background rebuild job processing all `order-*` streams into `v2`.
3. New events are written to both tables during rebuild (dual-write via event handler fork).
4. When rebuild complete, verify: `SELECT COUNT(*) FROM order_summary` vs `order_summary_v2`.
5. Atomic rename: `order_summary → order_summary_old`, `order_summary_v2 → order_summary`.
6. Remove dual-write after verification period. Drop `order_summary_old`.

## Output Format

- Command class definition (Java record)
- Command handler implementation
- Aggregate state transition method
- Projection event handler methods
- Schema SQL or index definition
- Snapshot configuration
- Test scenarios with in-memory infrastructure
