# DDD pattern library

## Strategic patterns

### Context map relationships

| Pattern | Relationship | When |
|---|---|---|
| Partnership | Equal teams, mutual dependency | Sister teams in a single product |
| Customer-Supplier | Downstream depends on upstream | Common; upstream prioritizes downstream needs |
| Conformist | Downstream conforms to upstream | Downstream has no negotiating power |
| Anti-Corruption Layer | Translation layer | Integrating legacy / external systems |
| Shared Kernel | Small shared model | Rare; high coordination cost |
| Open Host Service | Well-defined API for many consumers | Platform / shared services |
| Published Language | Shared schema (events, formats) | Cross-context integration |
| Separate Ways | No integration | Independent contexts |

### When bounded contexts mismatch teams

If two contexts span one team, the team has internal coordination overhead. If one context spans two teams, you have Shared Kernel costs.

Ideal: one team per context (Conway's Law inverse).

## Tactical patterns

### Aggregate rules

1. **One transaction = one aggregate**
2. **Reference other aggregates by ID**
3. **Aggregate root enforces all internal invariants**
4. **Use domain events for cross-aggregate coordination**

### Aggregate sizing

When in doubt, smaller. Big aggregates cause:
- Lock contention
- Large transactions
- Slow loads (load everything for one change)
- Difficult tests

If invariants don't span objects, they belong in separate aggregates with eventual consistency.

### Value object vs entity

| | Entity | Value object |
|---|---|---|
| Identity | Has it (persistent ID) | None; defined by attributes |
| Mutability | Lifecycle of attribute changes | Immutable |
| Equality | By ID | By attributes |
| Examples | Customer, Order, Account | Money, Address, DateRange |

Most things are value objects. Entity is the lifecycle exception.

### Domain event guidelines

- **Past tense**: `OrderConfirmed`, not `ConfirmOrder`
- **Business-meaningful**: not `CustomerRecordUpdated`
- **Immutable**: a fact, not a state
- **Self-contained**: include the data downstream needs
- **Versioned**: schema evolves

## Common mistakes catalog

### Anemic domain model

```python
# Bad: data class with no behavior
class Order:
    id: str
    status: str
    line_items: list

# Business logic scattered in services:
def confirm_order(order: Order):
    if order.status != "pending":
        raise ...
    order.status = "confirmed"
```

Behavior should live in the aggregate, not in service classes that orchestrate it from the outside.

### God aggregate

```python
class Customer:
    orders: list[Order]
    payment_methods: list[PaymentMethod]
    addresses: list[Address]
    support_tickets: list[Ticket]
    # ...
```

This holds too much. Loading a Customer loads everything. Breaking into separate aggregates (Customer, Order, PaymentMethod, etc.) is correct.

### Object references between aggregates

```python
# Bad
class Order:
    customer: Customer  # full object

# Good
class Order:
    customer_id: CustomerId  # just the ID
```

Object references invite traversal; traversal breaks aggregate boundaries.

### Same word, conflated meaning

If "Customer" means "person who placed an order" in one place and "person with a support account" in another, you have two bounded contexts. Force-fitting them into one model produces conflicting requirements.

## Event storming output format

Sticky-note color convention:
- ORANGE = domain events
- BLUE = commands
- YELLOW = aggregates
- PINK = external systems
- PURPLE = policies (when X, do Y)
- GREEN = read models / projections

## Cross-references
- `microservices` plugin — for service boundaries from bounded contexts
- `event-driven` plugin — for event design at scale
- `cqrs-event-sourcing` plugin — for the event-sourcing variant
- `migration-strategies` plugin — for strangler-fig + ACL patterns
