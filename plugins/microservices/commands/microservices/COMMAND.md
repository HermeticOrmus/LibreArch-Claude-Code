# /microservices

> Decompose services, design inter-service communication, audit data isolation, and plan observability for microservice architectures.

## Usage

```
/microservices decompose    - Identify service boundaries from a domain description
/microservices communicate  - Design synchronous or async inter-service communication
/microservices audit        - Check for shared databases, coupling, and anti-patterns
/microservices observe      - Design observability strategy (traces, metrics, logs)
```

## Trigger

Use this command when:
- Deciding how to split a monolith or design a new system as microservices
- Choosing between REST, gRPC, or async events for a service interaction
- Auditing an existing microservice system for shared database or tight coupling
- Setting up distributed tracing and structured logging for a service fleet
- Evaluating whether microservices are the right choice for a new project

## Process

### /microservices decompose
1. Map the domain to business capabilities or DDD bounded contexts.
2. Apply team topology: which teams exist? Each team should own 1-3 services maximum.
3. Identify data ownership: what aggregate does each service own exclusively?
4. Validate boundaries: services that always deploy together, or always call each other, should merge.
5. Define service contracts: what does each service expose (API, events)?

### /microservices communicate
1. Classify the interaction: query (caller needs data now) or command (caller triggers side effect)?
2. For queries: use synchronous REST or gRPC. Add timeouts and circuit breakers.
3. For commands: prefer async messaging if the caller doesn't need the result immediately.
4. For long sagas: use orchestration (Temporal, Conductor) not synchronous chain calls.
5. Design API contract: OpenAPI for REST, Protobuf for gRPC. Version it from day one.

### /microservices audit
1. Check for shared databases: any two services sharing a database or schema are coupled.
2. Check call chains: how many synchronous hops does a user request traverse?
3. Check deployment coupling: can services be deployed independently?
4. Check for anemic services: services with 1-2 endpoints that are just DB proxies — likely wrong boundary.
5. Check data consistency model: are there cross-service transactions? (Should be saga instead.)

### /microservices observe
1. Add OpenTelemetry SDK to each service. Export to OTLP collector.
2. Propagate W3C `traceparent` header through all synchronous calls.
3. Add structured JSON logging with `trace_id` and `span_id` fields (correlates logs to traces).
4. Define RED metrics per service: Rate (requests/s), Errors (error rate %), Duration (p50/p95/p99).
5. Set alerts on: p99 latency > SLO, error rate > 1%, DLQ depth > 0, pod restarts > 0.

## Examples

**Example: `/microservices decompose`**

Input: "E-commerce platform. Operations: browse catalog, add to cart, place order, process payment, ship order, manage returns."

Output:
```
Service Boundaries (by business capability):

Catalog Service
  Owns: Product, Category, Price, Search index
  Exposes: GET /products, GET /products/{id}, GET /search

Cart Service
  Owns: Cart, CartItem
  Exposes: PUT /carts/{userId}/items, GET /carts/{userId}
  Data: Redis (ephemeral sessions)

Order Service
  Owns: Order, OrderItem
  Exposes: POST /orders, GET /orders/{id}
  Publishes: OrderPlaced, OrderCancelled

Payment Service
  Owns: PaymentRecord, Refund
  Subscribes to: OrderPlaced → initiates payment
  Publishes: PaymentSucceeded, PaymentFailed

Fulfillment Service
  Owns: Shipment, Tracking
  Subscribes to: PaymentSucceeded → initiates shipment
  Publishes: ShipmentDispatched, ShipmentDelivered

Returns Service
  Owns: ReturnRequest, ReturnItem
  Subscribes to: ShipmentDelivered (to enable returns window)

Teams: 3 teams of 2-3 engineers each can own 2 services each.
```

**Example: `/microservices audit`**

Findings on an existing system:
```
CRITICAL: OrderService and InventoryService share PostgreSQL database "orders_inventory_db"
  → Schema changes require coordination. Independent deployment impossible.
  Fix: migrate InventoryService to its own schema. Use OrderPlaced events for data sync.

HIGH: Request path: Client → Gateway → OrderService → InventoryService → ProductService → PricingService
  → 4 synchronous hops. Combined availability = 0.999^4 = 99.6%. Each adds latency.
  Fix: OrderService should maintain local copies of product+pricing data via events.

MEDIUM: NotificationService has 2 endpoints: POST /emails and POST /sms. 100 lines total.
  → Likely too fine-grained. Consider merging into a single Communication service.
```

## Output Format

- Service list with name, owned aggregate, API surface, events published/subscribed
- Communication diagram (text) showing sync vs async interactions
- Audit report with violation severity and fix description
- Observability checklist with specific OpenTelemetry configuration
