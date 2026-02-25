# Advanced Learning Path: Distributed Systems and Architecture at Scale

> From single-process applications to systems that span machines, data centers, and failure domains. This path covers the hard problems: consistency, consensus, partitioning, and the fundamental trade-offs of distributed computing.

---

## Who This Is For

You have built systems using DDD, hexagonal architecture, and event-driven patterns. You are now facing problems that single-process solutions cannot handle:
- Data that must be consistent across multiple services
- Systems that must survive machine and network failures
- Workloads that exceed what one machine can handle
- Business processes that span multiple services and take hours or days
- Event streams with millions of events that must be processed correctly

---

## Phase 1: The Distributed Systems Reality Check

### The Eight Fallacies

Peter Deutsch and James Gosling identified eight assumptions developers make about networks that are all false:

1. The network is reliable
2. Latency is zero
3. Bandwidth is infinite
4. The network is secure
5. Topology does not change
6. There is one administrator
7. Transport cost is zero
8. The network is homogeneous

Every distributed system design must account for these realities. When someone says "just call the other service," they are assuming fallacies 1 and 2.

### CAP Theorem

In the presence of a network partition (P), a distributed system must choose between:
- **Consistency (C):** Every read receives the most recent write
- **Availability (A):** Every request receives a response (not necessarily the most recent data)

**CAP is often misunderstood.** You do not choose two of three. When there is no partition (the normal case), you can have both consistency and availability. CAP only forces a choice DURING a partition.

**Practical implication:** Design for the partition case explicitly. For each piece of data, decide: during a network partition, is it more important to return stale data (AP) or to refuse the request (CP)?

### PACELC Theorem

An extension of CAP that also considers the non-partition case:

- If Partition: choose Availability or Consistency
- Else (normal operation): choose Latency or Consistency

Most real systems make different trade-offs for different data:
- User authentication: CP (refuse access rather than use stale data)
- Product catalog: AP (show potentially stale prices rather than error)
- Shopping cart: AP (let users add items even if inventory count is stale)
- Financial transactions: CP (reject rather than allow inconsistency)

---

## Phase 2: Consistency Models

### Strong Consistency

All nodes see the same data at the same time. After a write completes, all subsequent reads return the new value.

**Mechanisms:** Two-phase commit (2PC), Raft/Paxos consensus, single-leader replication with synchronous followers.

**Cost:** Higher latency (must wait for acknowledgment from multiple nodes). Lower availability during partitions. Limited geographic distribution.

**When to use:** Financial transactions, inventory that must not oversell, anything where incorrect data causes real harm.

### Eventual Consistency

If no new updates are made, all nodes will eventually return the same value. There is a window of inconsistency.

**Mechanisms:** Asynchronous replication, gossip protocols, CRDTs, last-write-wins registers.

**Cost:** Application must handle stale reads. Conflict resolution needed for concurrent writes. More complex application logic.

**When to use:** Social media feeds, analytics, caches, any data where temporary staleness is acceptable.

### Causal Consistency

Causally related operations are seen in the same order by all nodes. Concurrent (unrelated) operations may be seen in different orders.

**Example:** If user A posts a message, then user B replies, all nodes must show the post before the reply. But two independent posts from different users may appear in any order.

**Mechanisms:** Vector clocks, Lamport timestamps, dependency tracking.

**When to use:** Collaborative editing, messaging systems, social interactions -- where the order of related events matters but total ordering is unnecessary.

### Read-Your-Writes Consistency

A user always sees their own writes. Other users may see stale data.

**Mechanisms:** Session affinity, routing reads to the write leader for the user's own data, client-side caching of recent writes.

**When to use:** User profiles, settings, any system where a user would be confused by not seeing their own recent changes.

---

## Phase 3: Consensus Protocols

### Why Consensus Matters

When multiple nodes must agree on a value (who is the leader, what is the committed state, what order did events occur), they need a consensus protocol. Without consensus, split-brain scenarios cause data corruption.

### Raft Protocol

Raft is the most accessible consensus protocol. It elects a leader, and all writes go through the leader.

**Three states:** Leader, Follower, Candidate

**Normal operation:**
1. Client sends write to leader
2. Leader appends to its log
3. Leader replicates to followers
4. Once a majority acknowledge, the entry is committed
5. Leader responds to client

**Leader election:**
1. Followers that do not hear from the leader become candidates
2. Candidates request votes from all nodes
3. First candidate to get a majority becomes leader
4. Term number prevents stale leaders

**Key property:** As long as a majority of nodes are available, the system makes progress. Minority partitions cannot accept writes.

### Practical Consensus Systems

You rarely implement consensus yourself. You use systems built on it:

| System | Consensus For | Protocol |
|--------|--------------|----------|
| etcd | Key-value store, K8s config | Raft |
| ZooKeeper | Coordination, config, locking | ZAB (Zookeeper Atomic Broadcast) |
| CockroachDB | Distributed SQL | Raft |
| FoundationDB | Distributed key-value | Paxos variant |

---

## Phase 4: Event Sourcing at Scale

### Beyond Simple Events

Event sourcing stores all changes as an immutable sequence of events. The current state is derived by replaying events from the beginning (or from a snapshot).

**Event store properties:**
- Append-only (events are never modified or deleted)
- Ordered per aggregate (events for one aggregate have a total order)
- Versioned (each event has a version number for optimistic concurrency)

### Projections

Projections transform event streams into read-optimized views (read models). They are the "query" side of CQRS.

**Types of projections:**
- **Live projections:** Process events as they arrive, maintaining an up-to-date read model
- **Catch-up projections:** Rebuild from the beginning of the event stream
- **Temporal projections:** Build a view as of a specific point in time

**Projection rebuilds:** One of event sourcing's superpowers. If you discover a bug in a projection, fix the code and replay all events. The read model is corrected without touching the write model.

### Snapshots

For aggregates with many events, replaying from the beginning is slow. Snapshots capture the aggregate state at a point in time. Replay starts from the snapshot instead of from event zero.

**Snapshot strategies:**
- Every N events (e.g., snapshot every 100 events)
- Time-based (snapshot daily)
- On-demand (snapshot when load time exceeds threshold)

### Event Versioning

Events are immutable but their schema evolves. Strategies for handling schema changes:

**Upcasting:** Transform old event formats to new formats at read time. The event store contains the original events, but readers see the current schema.

**Weak schema:** Use a flexible format (JSON) and handle missing fields with defaults. Simpler but less type-safe.

**Event version field:** Include a version number in each event. Consumers branch based on version. Explicit but verbose.

### Idempotent Event Handling

In distributed systems, events may be delivered more than once. Every event handler must be idempotent -- processing the same event twice produces the same result as processing it once.

**Techniques:**
- Deduplication by event ID (store processed event IDs)
- Idempotent operations (SET operations are naturally idempotent; INCREMENT is not)
- Idempotency keys for external calls

---

## Phase 5: CQRS (Command Query Responsibility Segregation)

### The Fundamental Split

CQRS separates the write model (commands) from the read model (queries). They can use different data stores, different schemas, and different scaling strategies.

```
             +-------------+
Command ---> | Write Model | --[Events]--> | Read Model | <--- Query
             | (Normalized |               | (Denormalized |
             |  for writes)|               |  for reads)   |
             +-------------+               +---------------+
```

### When CQRS Earns Its Complexity

- Read and write workloads have different scaling requirements
- The optimal data model for reading differs significantly from the model for writing
- You need multiple read representations of the same data
- Writes involve complex validation; reads need fast denormalized access

### When CQRS Is Overkill

- Simple CRUD applications
- Read and write patterns are similar
- The team is small and does not need the extra architectural complexity
- Eventual consistency between read and write models is not acceptable

### CQRS Without Event Sourcing

CQRS and event sourcing are frequently paired but are independent concepts. You can use CQRS with a traditional database:
- Write side: normalized relational tables
- Read side: denormalized views or materialized views
- Synchronization: change data capture, database triggers, or application-level events

---

## Phase 6: Saga Patterns for Distributed Transactions

### The Problem

In a microservices architecture, a business process often spans multiple services. Traditional ACID transactions cannot span service boundaries (no distributed transaction coordinator). You need a different approach.

### Choreography-Based Sagas

Each service listens for events and publishes its own events. No central coordinator.

```
OrderService:  OrderCreated -->
PaymentService:  --> PaymentCharged -->
InventoryService:  --> InventoryReserved -->
ShippingService:  --> ShipmentCreated
```

**Compensation on failure:**
```
PaymentService:  PaymentFailed -->
OrderService:  --> OrderCancelled
```

**Trade-offs:**
- Low coupling between services
- Hard to understand the complete flow
- Hard to handle complex compensation logic
- Risk of cyclic dependencies in event flows

### Orchestration-Based Sagas

A central orchestrator coordinates the saga steps.

```
OrderSagaOrchestrator:
  Step 1: Command -> PaymentService.Charge()
    Success: proceed to Step 2
    Failure: compensate (cancel order)
  Step 2: Command -> InventoryService.Reserve()
    Success: proceed to Step 3
    Failure: compensate (refund payment, cancel order)
  Step 3: Command -> ShippingService.CreateShipment()
    Success: saga complete
    Failure: compensate (release inventory, refund payment, cancel order)
```

**Trade-offs:**
- Easy to understand the flow
- Complex compensation logic is centralized
- Orchestrator is a single point of coupling
- Can become a god service if not carefully scoped

### Compensation Design

Compensation is not "undo" -- it is a new action that logically reverses the effect. Not all operations can be perfectly reversed.

**Designing compensatable operations:**
- Reservation-based: Reserve resources, confirm later. Compensation = release reservation.
- Idempotent cancellation: Cancel operations must be safe to call multiple times.
- Time limits: Reservations expire if not confirmed within a window.

### Saga State Management

The saga's current state must be persisted. If the orchestrator crashes mid-saga, it must be able to resume.

**State storage options:**
- Database (simple, reliable)
- Event store (replay to reconstruct state)
- Saga state machine (explicit state transitions)

---

## Phase 7: Partitioning and Sharding

### Why Partition Data

When data exceeds what one node can handle (storage, throughput, or memory), you split it across multiple nodes.

### Partitioning Strategies

**Range partitioning:** Assign contiguous ranges of the key to different partitions. `A-M` on node 1, `N-Z` on node 2.
- Pro: Range queries are efficient
- Con: Hot partitions if data is not uniformly distributed

**Hash partitioning:** Hash the key and assign to partitions based on hash value.
- Pro: Even distribution regardless of key distribution
- Con: Range queries must hit all partitions

**Composite partitioning:** Partition by one key, then sort by another within each partition. Common in time-series data: partition by entity, sort by timestamp.

### Rebalancing

When nodes are added or removed, data must be redistributed.

**Fixed partition count:** Create many more partitions than nodes. When nodes change, move whole partitions. Used by Kafka, Elasticsearch.

**Consistent hashing:** Map both data and nodes to a hash ring. Data is assigned to the nearest node clockwise. Adding a node affects only adjacent partitions.

**Dynamic partitioning:** Split partitions that grow too large, merge partitions that shrink. Used by HBase, MongoDB.

---

## Phase 8: Exercises

### Exercise 1: Consistency Analysis

Take a system you work on. For each piece of data:
1. What consistency model does it currently use?
2. What consistency model does it actually need?
3. What happens during a network partition?
4. What is the cost of getting it wrong?

### Exercise 2: Design a Saga

Choose a multi-step business process. Design it as a saga:
1. Identify all services involved
2. Define the happy path steps
3. Define compensation for each step
4. Choose choreography or orchestration and justify the choice
5. Design the failure scenarios and recovery procedures

### Exercise 3: Event Sourcing a Domain

Pick an aggregate with complex business rules. Redesign it with event sourcing:
1. Define the domain events
2. Implement the aggregate with event-based state changes
3. Design two projections for different read requirements
4. Handle a schema change (add a field to an event)
5. Implement a snapshot strategy

### Exercise 4: Partition Strategy

Given a dataset with 10TB of data and 50,000 requests per second:
1. Choose a partitioning strategy and justify it
2. Determine the number of partitions
3. Design the rebalancing approach when adding nodes
4. Handle hot partitions (uneven access patterns)
5. Design cross-partition queries

---

## Key Books and References

- **Designing Data-Intensive Applications** by Martin Kleppmann -- The essential distributed systems book
- **Building Microservices** by Sam Newman -- Practical microservices architecture
- **Patterns of Enterprise Application Architecture** by Martin Fowler -- Foundational patterns
- **Database Internals** by Alex Petrov -- How databases actually work
- **The Raft Consensus Paper** by Diego Ongaro and John Ousterhout -- Readable consensus algorithm
- **Versioning in an Event Sourced System** by Greg Young -- Event sourcing evolution

---

## Core Takeaways

1. **Distributed systems trade simplicity for capability.** Do not distribute unless you must.
2. **CAP is about partitions.** During normal operation, you can have both consistency and availability.
3. **Choose consistency per data item**, not per system. Different data has different requirements.
4. **Event sourcing stores facts, not state.** The current state is always derivable from the event history.
5. **Sagas replace transactions** in distributed systems. Design compensation carefully.
6. **Consensus is expensive.** Use it for coordination, not for every operation.
7. **Partition for scale.** Choose the strategy based on your access patterns, not the technology's defaults.
8. **The hardest problems are not technical** -- they are choosing the right trade-offs for your specific context.
