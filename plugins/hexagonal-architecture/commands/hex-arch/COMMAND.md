# /hex-arch

> Analyze hexagonal architecture compliance, scaffold new ports and adapters, check dependencies, and generate in-memory test adapters.

## Usage

```
/hex-arch analyze       - Audit existing code for hexagonal violations
/hex-arch scaffold      - Generate driving port, use case interactor, and adapter stubs
/hex-arch check-deps    - Verify dependency directions (inner ← outer only)
/hex-arch test-adapter  - Generate in-memory adapter implementation for a driven port
```

## Trigger

Use this command when:
- Reviewing a service to ensure framework annotations don't appear in domain objects
- Generating the boilerplate for a new use case (driving port + interactor + REST adapter)
- Verifying that your application layer doesn't import from infrastructure packages
- Creating a fast in-memory test double for a repository or event publisher port

## Process

### /hex-arch analyze
1. Scan domain and application packages for framework imports (`@Entity`, `@RestController`, `@Autowired`).
2. Verify port interfaces reside in domain or application layers (not in adapter packages).
3. Check that adapters implement ports (not that domain classes implement adapter interfaces).
4. Identify any direct calls from web adapters to persistence adapters (bypassing use cases).
5. Report violations by layer with severity and fix suggestions.

### /hex-arch scaffold
1. Identify the use case name (verb + noun, e.g., PlaceOrder, CancelShipment).
2. Generate driving port interface: `PlaceOrderUseCase` with `PlaceOrderCommand` record.
3. Generate use case interactor: `PlaceOrderInteractor implements PlaceOrderUseCase`.
4. Generate driving adapter stub: `OrderController` calling the driving port.
5. Generate driven port interface: `OrderRepository` with the operations needed.
6. Generate driven adapter stub: `JpaOrderRepositoryAdapter implements OrderRepository`.
7. Generate entity mapper skeleton: `OrderEntityMapper` (domain ↔ JPA entity).

### /hex-arch check-deps
1. Verify domain layer imports: only java.*, standard library, domain-internal.
2. Verify application layer imports: domain layer + standard library only.
3. Verify adapter layer imports: may use framework + application ports.
4. Flag any case where domain/application imports from adapter packages.
5. Suggest ArchUnit test class to enforce these rules in CI.

### /hex-arch test-adapter
1. Identify the driven port interface to implement.
2. Generate in-memory implementation using a HashMap or ArrayList backing store.
3. Add test-helper methods (e.g., `size()`, `findAll()`) that are not part of the port.
4. Show usage in a unit test setup block.

## Examples

**Example: `/hex-arch scaffold`**

Input: "Need a PlaceOrder use case for an order service. Order is placed by customerId + list of items. Needs to check customer exists and save the order."

Output:
```java
// application/port/in/PlaceOrderUseCase.java
public interface PlaceOrderUseCase {
    record PlaceOrderCommand(CustomerId customerId, List<OrderItemDto> items) {}
    OrderId placeOrder(PlaceOrderCommand command);
}

// application/service/PlaceOrderInteractor.java
@Service
@Transactional
public class PlaceOrderInteractor implements PlaceOrderUseCase {
    // Constructor injection of: CustomerRepository, OrderRepository, EventPublisher
    // 1. Load customer (throw if not found)
    // 2. Create Order aggregate
    // 3. Save via repository
    // 4. Publish domain events
    // 5. Return OrderId
}

// adapter/web/OrderController.java
@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {
    @PostMapping
    public ResponseEntity<OrderResponse> placeOrder(@Valid @RequestBody OrderRequest req) {
        // Map req → PlaceOrderCommand
        // Call placeOrderUseCase.placeOrder(command)
        // Return 201 Created with Location header
    }
}
```

**Example: `/hex-arch check-deps`**

Violation report:
```
VIOLATION [HIGH]: domain/model/Order.java imports org.springframework.data.annotation.Id
  → Remove @Id from domain entity. Use a separate OrderJpaEntity in the persistence adapter.

VIOLATION [HIGH]: application/service/PlaceOrderInteractor.java imports adapter.persistence.JpaOrderRepository
  → Interactor must depend only on the port interface OrderRepository, not on the JPA implementation.
    Use constructor injection with the interface type.

VIOLATION [MEDIUM]: adapter/web/OrderController.java imports adapter.persistence.JpaOrderRepository
  → Web adapter must call use case port, not persistence adapter directly.
```

## Output Format

- Violation report with layer, file, import, severity, and fix
- Scaffolded code files with package declarations and method stubs
- ArchUnit test class to enforce violations in CI
- In-memory test adapter with test-helper methods
