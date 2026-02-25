# Intermediate Learning Path: Strategic Design and Structural Patterns

> From layered architecture to domain-driven boundaries. This path teaches the architectural patterns that handle real business complexity: DDD, hexagonal architecture, event-driven design, and API design that lasts.

---

## Who This Is For

You understand SOLID, design patterns, and layered architecture. You are starting to encounter problems that those foundations alone cannot solve:
- Business logic is scattered across services, controllers, and even the database
- The domain model is an anemic set of data classes with all logic in services
- Adding cross-cutting features requires touching every module
- Your API is hard to version and extend without breaking clients
- You sense that the system's structure does not match the business domain

---

## Phase 1: Domain-Driven Design Foundations

### Why DDD Exists

Domain-Driven Design is not a technology pattern. It is a way of thinking about software that puts the business domain at the center of all design decisions. Eric Evans introduced it to solve a specific problem: **complex business logic that does not fit neatly into CRUD operations**.

DDD is overkill for simple applications. If your system is mostly data in and data out, a well-structured layered architecture is sufficient. DDD earns its complexity when business rules are nuanced, domain experts disagree on terminology, and the system must model real-world processes with many edge cases.

### Ubiquitous Language

**The most valuable and most underrated part of DDD.**

Ubiquitous language is a shared vocabulary between developers and domain experts. When the code uses the same terms as the business, bugs caused by misunderstanding decrease dramatically.

**Bad:** A `User` entity with a `status` field that means different things in different contexts (active/inactive for auth, verified/unverified for KYC, trial/paid for billing).

**Good:** Separate concepts with precise names: `AuthCredential`, `IdentityVerification`, `Subscription`. Each has its own lifecycle and rules.

**Practice:** When a domain expert says something, listen to the nouns and verbs. Those become your entities and methods. When the code uses different words than the business, one of them is wrong.

### Bounded Contexts

A bounded context is a boundary within which a particular domain model is defined and applicable. The same real-world concept (e.g., "customer") may have different representations in different contexts.

**Example:** In an e-commerce system:
- **Sales context:** Customer has a cart, wishlist, order history, shipping address
- **Billing context:** Customer has payment methods, invoices, credit balance
- **Support context:** Customer has tickets, satisfaction score, communication preferences

These are NOT the same entity. They share a customer ID but have different attributes, different behaviors, and different invariants. Trying to put everything into one `Customer` class creates a god object that changes for every reason.

### Context Mapping

Once you identify bounded contexts, you need to define how they relate:

| Relationship | Description | When to Use |
|-------------|-------------|-------------|
| **Shared Kernel** | Two contexts share a subset of the domain model | Small teams, tightly coupled contexts |
| **Customer-Supplier** | Upstream context provides what downstream needs | Clear dependency direction |
| **Conformist** | Downstream context conforms to upstream's model | No leverage to negotiate |
| **Anti-Corruption Layer** | Downstream translates upstream's model | Protecting your model from external influence |
| **Published Language** | Shared language (often events) between contexts | Loosely coupled contexts |
| **Separate Ways** | No integration -- contexts are independent | Truly unrelated concerns |

### Entities, Value Objects, and Aggregates

**Entities** have identity. Two entities with the same attributes but different IDs are different objects. `User`, `Order`, `Product` are entities.

**Value Objects** have no identity. Two value objects with the same attributes are equal. `Money(100, "USD")`, `EmailAddress("user@example.com")`, `DateRange(start, end)` are value objects.

**Aggregates** are clusters of entities and value objects treated as a single unit for data changes. The aggregate root is the only entry point for modifications.

**Rules for aggregates:**
1. Only the aggregate root is referenced from outside the aggregate
2. Changes to the aggregate go through the root
3. The aggregate enforces its invariants
4. Aggregates are the unit of transactional consistency
5. Keep aggregates small -- prefer references (IDs) over direct object references between aggregates

### Domain Events

A domain event is a record of something that happened in the domain. Not a technical event -- a business event.

**Examples:** `OrderPlaced`, `PaymentReceived`, `InventoryReserved`, `ShipmentDispatched`

**Why events matter:**
- They capture business-significant moments
- They decouple bounded contexts
- They enable audit trails
- They allow asynchronous processing
- They make the system's behavior explicit

### Domain Services

When business logic does not naturally belong to a single entity or value object, it belongs in a domain service. Domain services are stateless and operate on domain concepts.

**Example:** `TransferService.transfer(fromAccount, toAccount, amount)` -- the transfer logic involves two accounts and does not belong to either one.

**Warning:** If most of your logic is in domain services, you likely have an anemic domain model. Push logic into entities and value objects first.

---

## Phase 2: Hexagonal Architecture (Ports and Adapters)

### The Core Insight

Hexagonal architecture (Alistair Cockburn, 2005) takes the dependency inversion principle and applies it to the entire application structure. The result: your business logic has ZERO dependencies on frameworks, databases, or external services.

### The Structure

```
                    +-------------------+
                    |                   |
   +----------+    |     Domain        |    +----------+
   |  Driving  |-->|   (Business       |<--|  Driven   |
   |  Adapter  |   |    Logic)         |   |  Adapter  |
   +----------+    |                   |    +----------+
        ^          +-------------------+         |
        |                ^    ^                  |
        |                |    |                  |
   +----------+    +----------+----------+  +----------+
   |  Driving  |   |   Driving |  Driven |  |  Driven  |
   |   Port    |   |    Port   |   Port  |  |   Port   |
   +----------+    +----------+----------+  +----------+
```

**Ports** are interfaces defined by the application core:
- **Driving ports** (primary): How the outside world uses the application (`CreateOrderUseCase`, `GetOrderQuery`)
- **Driven ports** (secondary): What the application needs from the outside world (`OrderRepository`, `PaymentGateway`, `EmailSender`)

**Adapters** implement ports:
- **Driving adapters** (primary): REST controllers, CLI handlers, GraphQL resolvers, event consumers
- **Driven adapters** (secondary): PostgreSQL repository, Stripe payment adapter, SendGrid email adapter

### Why This Matters

1. **Testability:** You can test all business logic with in-memory fakes. No database, no HTTP server, no message broker.
2. **Swappability:** Replace PostgreSQL with MongoDB by writing a new adapter. Zero changes to business logic.
3. **Framework independence:** Your domain never imports Express, Spring, or Django. You can change frameworks without changing business rules.
4. **Clarity:** The dependency graph tells you exactly where business logic ends and infrastructure begins.

### Practical Implementation

```
src/
+-- domain/
|   +-- order/
|   |   +-- Order.ts                    # Aggregate root
|   |   +-- OrderItem.ts                # Entity within aggregate
|   |   +-- Money.ts                    # Value object
|   |   +-- OrderStatus.ts             # Value object (enum-like)
|   |   +-- OrderRepository.ts         # Driven port (interface)
|   |   +-- OrderPlacedEvent.ts        # Domain event
|   +-- payment/
|       +-- PaymentGateway.ts           # Driven port (interface)
+-- application/
|   +-- commands/
|   |   +-- PlaceOrderCommand.ts        # Driving port
|   |   +-- PlaceOrderHandler.ts        # Use case implementation
|   +-- queries/
|       +-- GetOrderQuery.ts            # Driving port
|       +-- GetOrderHandler.ts          # Query implementation
+-- infrastructure/
|   +-- persistence/
|   |   +-- PostgresOrderRepository.ts  # Driven adapter
|   +-- payment/
|   |   +-- StripePaymentGateway.ts     # Driven adapter
|   +-- api/
|       +-- OrderController.ts          # Driving adapter
```

---

## Phase 3: Event-Driven Architecture

### Beyond Request-Response

Most applications start with synchronous request-response: client sends request, server processes it, server sends response. This works until:
- Processing takes too long for a synchronous response
- Multiple services need to react to the same event
- You need to decouple the producer from consumers
- You need temporal decoupling (producer and consumer do not need to be online at the same time)

### Event Types

**Domain Events:** Something happened in the business domain. `OrderPlaced`, `PaymentFailed`, `UserRegistered`. These carry business meaning.

**Integration Events:** Messages published to communicate between bounded contexts or services. May be a transformation of domain events for external consumption.

**Command Events:** Instructions to do something. `ProcessPayment`, `SendNotification`. Unlike domain events (which are facts), commands can be rejected.

### Choreography vs Orchestration

**Choreography:** Each service listens for events and decides what to do. No central coordinator. Services are loosely coupled but the overall flow is implicit.

```
OrderService --[OrderPlaced]--> PaymentService --[PaymentReceived]--> InventoryService --[InventoryReserved]--> ShippingService
```

**Orchestration:** A central coordinator (orchestrator) directs the workflow. The flow is explicit but the orchestrator is a coupling point.

```
OrderOrchestrator:
  1. Tell PaymentService to charge
  2. If payment succeeds, tell InventoryService to reserve
  3. If reservation succeeds, tell ShippingService to ship
  4. If any step fails, compensate previous steps
```

**Trade-offs:**

| Aspect | Choreography | Orchestration |
|--------|-------------|---------------|
| Coupling | Low (no coordinator) | Medium (coordinator knows services) |
| Visibility | Hard to trace flow | Easy to see workflow |
| Complexity | Distributed across services | Centralized in orchestrator |
| Failure handling | Each service handles its own | Coordinator handles compensation |
| Best for | Simple, few-step flows | Complex, multi-step workflows |

### Event Sourcing Preview

Instead of storing the current state, store the sequence of events that produced the current state. The current state is derived by replaying events.

Traditional: `account.balance = 150`
Event-sourced: `[Deposited(200), Withdrawn(50)]` -> replay -> `balance = 150`

This is covered in depth in the advanced path. For now, know that event sourcing is not required for event-driven architecture. You can use events for communication without storing them as your source of truth.

---

## Phase 4: API Design That Lasts

### API as Architecture Boundary

Your API is an architectural boundary. It is a contract between your system and its consumers. Breaking that contract breaks trust and forces coordinated changes.

### RESTful Design Principles

**Resources, not actions.** URLs represent nouns, not verbs:
- Good: `POST /orders` (create an order)
- Bad: `POST /createOrder`

**HTTP methods carry semantics:**
- `GET` -- Read (safe, idempotent)
- `POST` -- Create (not idempotent)
- `PUT` -- Replace (idempotent)
- `PATCH` -- Partial update (not necessarily idempotent)
- `DELETE` -- Remove (idempotent)

**Status codes communicate meaning:**
- `200` OK -- Success
- `201` Created -- Resource created
- `400` Bad Request -- Client error (validation)
- `404` Not Found -- Resource does not exist
- `409` Conflict -- State conflict
- `422` Unprocessable Entity -- Semantically invalid
- `429` Too Many Requests -- Rate limited
- `500` Internal Server Error -- Server failed

### API Versioning Strategies

| Strategy | Example | Trade-offs |
|----------|---------|------------|
| URL path | `/v1/orders` | Simple, explicit. Hard to share code between versions. |
| Header | `Accept: application/vnd.api.v1+json` | Clean URLs. Less discoverable. |
| Query param | `/orders?version=1` | Simple. Optional feels wrong for something mandatory. |

**Recommendation:** URL path versioning for external APIs (simplest for consumers). Header versioning for internal APIs (cleaner evolution).

### Pagination, Filtering, Sorting

**Cursor-based pagination** for real-time data (no gaps or duplicates):
```
GET /orders?cursor=abc123&limit=20
Response: { data: [...], nextCursor: "def456" }
```

**Offset-based pagination** for stable datasets:
```
GET /orders?offset=40&limit=20
Response: { data: [...], total: 157 }
```

### Error Responses

Use a consistent error format across all endpoints:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Order validation failed",
    "details": [
      { "field": "quantity", "message": "must be greater than 0" }
    ]
  }
}
```

### API Evolution Without Breaking Changes

**Additive changes are safe:** New fields, new endpoints, new optional parameters.

**Breaking changes require versioning:** Removing fields, changing types, changing semantics, removing endpoints.

**Deprecation process:**
1. Mark deprecated in documentation and response headers
2. Log usage of deprecated features to identify affected consumers
3. Communicate timeline to consumers
4. Remove after migration period

---

## Phase 5: Putting It Together

### Architecture Decision Records (ADRs)

Every significant architectural decision should be documented with:
1. **Context:** What situation are we in?
2. **Decision:** What did we decide?
3. **Consequences:** What are the trade-offs?
4. **Status:** Proposed / Accepted / Deprecated / Superseded

ADRs are a conversation artifact. They record WHY decisions were made, so future developers (including your future self) do not reverse them without understanding the original reasoning.

### The Modular Monolith

Before jumping to microservices, consider the modular monolith: a single deployable unit with clear module boundaries that could become separate services later.

**Structure:**
```
src/
+-- modules/
|   +-- orders/                 # Could become a service
|   |   +-- domain/
|   |   +-- application/
|   |   +-- infrastructure/
|   |   +-- api/
|   +-- inventory/              # Could become a service
|   |   +-- domain/
|   |   +-- application/
|   |   +-- infrastructure/
|   |   +-- api/
+-- shared/                     # Shared kernel
    +-- events/
    +-- types/
```

**Rules:**
1. Modules communicate through defined interfaces (not direct imports of internal classes)
2. No shared database tables between modules
3. Each module has its own persistence
4. Cross-module communication via events or public APIs

This gives you the organizational benefits of microservices (clear boundaries, independent development) without the operational cost (distributed systems complexity, network latency, deployment orchestration).

---

## Phase 6: Exercises

### Exercise 1: Identify Bounded Contexts

Take your current project. List all the major business capabilities. For each capability, identify:
- What data does it own?
- What business rules does it enforce?
- What events does it produce?
- How does it communicate with other capabilities?

Draw the context map showing relationships between contexts.

### Exercise 2: Implement Hexagonal Architecture

Pick one feature and restructure it using ports and adapters:
1. Define the driving port (use case interface)
2. Define the driven ports (repository interface, external service interface)
3. Implement the use case in the application layer
4. Implement adapters in the infrastructure layer
5. Write a test using in-memory adapter implementations

### Exercise 3: Design an Event Flow

Choose a business process that spans multiple concerns (e.g., order fulfillment). Design it twice:
1. As a choreographed event flow (each service reacts independently)
2. As an orchestrated workflow (central coordinator)

Compare the trade-offs for your specific case.

### Exercise 4: API Review

Take an existing API in your project and evaluate it against the principles in Phase 4. Identify:
- Are resources properly modeled?
- Is the error format consistent?
- How would you version it without breaking clients?
- Is pagination cursor-based or offset-based? Which is appropriate?

---

## What Comes Next

With DDD, hexagonal architecture, event-driven design, and API design under your belt, the advanced path covers:

- **Distributed Systems** -- CAP theorem, consensus, partitioning
- **CQRS and Event Sourcing** -- Separating reads from writes at the architectural level
- **Saga Patterns** -- Managing distributed transactions
- **Consistency Models** -- Strong, eventual, and everything in between

---

## Key Books and References

- **Domain-Driven Design** by Eric Evans -- The foundational text
- **Implementing Domain-Driven Design** by Vaughn Vernon -- Practical DDD implementation
- **Get Your Hands Dirty on Clean Architecture** by Tom Hombergs -- Hexagonal architecture in practice
- **Building Evolutionary Architectures** by Ford, Parsons & Kua -- Architecture that adapts
- **Designing Data-Intensive Applications** by Martin Kleppmann -- Essential for data architecture

---

## Core Takeaways

1. **DDD is a modeling approach**, not a technology choice. Use it when the domain is complex enough to justify it.
2. **Bounded contexts are boundaries of meaning.** The same word can mean different things in different contexts.
3. **Hexagonal architecture protects your domain** from infrastructure concerns. Dependencies always point inward.
4. **Events decouple contexts** but add complexity. Start with synchronous communication and add events when you need them.
5. **Your API is a promise.** Design it carefully and evolve it without breaking consumers.
6. **Consider the modular monolith** before microservices. Get the boundaries right first.
