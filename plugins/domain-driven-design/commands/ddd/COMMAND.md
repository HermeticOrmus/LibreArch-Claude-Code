# /ddd

> Model aggregates and bounded contexts, map context relationships, validate aggregate design, and generate DDD scaffolding.

## Usage

```
/ddd model          - Design an aggregate root with invariants from a domain description
/ddd map-contexts   - Map bounded context relationships and choose integration patterns
/ddd validate       - Audit existing code for DDD violations (anemic model, wrong references)
/ddd generate       - Scaffold aggregate root, value objects, domain events, repository interface
```

## Trigger

Use this command when:
- Starting a new domain model: identify aggregates, value objects, and domain events
- Integrating two bounded contexts: choose ACL, OHS, Conformist, or Shared Kernel
- Auditing a service for anemic domain model or cross-aggregate object references
- Scaffolding a new aggregate with full boilerplate (entity, value objects, events, repository)

## Process

### /ddd model
1. Identify the domain noun at the center of the business operation.
2. List the invariants: what must always be true about this entity?
3. Find the consistency boundary: which objects must change atomically to maintain those invariants?
4. Identify the aggregate root: the single entry point for all external access.
5. List value objects: immutable attributes identified by their value (Money, Address, EmailAddress).
6. List domain events: past-tense facts the aggregate emits after state changes.

### /ddd map-contexts
1. Name both bounded contexts and their core domain model concepts.
2. Identify which team owns each context (upstream/downstream, or partnership).
3. Choose integration pattern:
   - ACL: upstream has a bad or unstable model — translate at boundary
   - Conformist: upstream is a stable external system (payment provider, ERP)
   - OHS + Published Language: you are upstream with many consumers
   - Shared Kernel: two closely-aligned teams intentionally sharing model subset
   - Separate Ways: integration cost exceeds benefit
4. Design the translation layer or published contract.

### /ddd validate
1. Scan for entities with only getters/setters and no business methods → anemic model.
2. Check for object references across aggregate boundaries → should be ID references.
3. Check for business logic in service classes that should be in entities.
4. Verify domain events are registered in the aggregate (not in application services).
5. Verify repository interfaces live in the domain layer, not in infrastructure.

### /ddd generate
1. Generate aggregate root class with private constructor and factory method.
2. Generate value objects (immutable, equality by value, validation in constructor).
3. Generate domain event records (past-tense name, all state needed to react).
4. Generate repository interface (in domain layer, persistence-ignorant).
5. Generate application service stub (command handler + event collection).

## Examples

**Example: `/ddd model`**

Input: "An Order in our e-commerce system. Orders have line items, a status, and a customer. We need to prevent adding items to confirmed orders and enforce a minimum $10 total."

Output:
```
Aggregate Root: Order
  Identity: OrderId (UUID value object)

Invariants:
  1. Items can only be added when status = DRAFT
  2. Total must be >= $10.00 when items are added
  3. An order must have at least one item to be confirmed

Value Objects:
  - OrderId       (wraps UUID, equality by value)
  - CustomerId    (reference to Customer aggregate by ID only)
  - Money         (amount + currency, immutable, validates non-negative)
  - OrderStatus   (enum: DRAFT, CONFIRMED, SHIPPED, CANCELLED)

Entities within aggregate:
  - OrderItem     (ProductId, quantity, Money unitPrice — no identity outside Order)

Domain Events:
  - OrderPlacedEvent    (orderId, customerId, List<items>, Money total, Instant occurredAt)
  - OrderCancelledEvent (orderId, Instant occurredAt, String reason)

Repository interface (in domain layer):
  interface OrderRepository {
      Optional<Order> findById(OrderId id);
      void save(Order order);
  }
```

**Example: `/ddd map-contexts`**

Input: "Our Order context needs to trigger shipment via a 3rd-party logistics provider (ShipStation). ShipStation has its own data model."

Output:
```
Relationship: Order context (downstream) ← ShipStation (upstream, external)
Pattern: Anticorruption Layer (ACL)

Reason: ShipStation uses its own model (shipment_no, carrier_cd, prioty_lvl).
Conforming to it would pollute Order's ubiquitous language with external terms.

ACL design:
  ShippingServiceAcl.scheduleShipment(ShipmentRequest) → ShipmentConfirmation
  - Translates Order domain model → ShipStation API format
  - Translates ShipStation response → ShipmentConfirmation (domain model)
  - Lives in infrastructure layer; depends on ShipStation client
```

## Output Format

- Aggregate design: entity list with invariants, value objects, domain events, repository interface
- Context map: relationship type, rationale, translation layer design
- Validation report: violations by category with file locations and fix descriptions
- Generated code: Java or TypeScript based on project language
