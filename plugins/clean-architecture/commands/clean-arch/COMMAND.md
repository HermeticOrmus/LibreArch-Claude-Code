# /clean-arch

> Analyze, scaffold, check dependency violations, or generate tests for Clean Architecture implementations. Enforces the dependency rule and use case pattern.

## Usage

```
/clean-arch analyze    - Review existing code for dependency rule violations
/clean-arch scaffold   - Generate folder structure and boilerplate for a new feature
/clean-arch check-deps - Identify specific dependency direction violations
/clean-arch test       - Generate framework-free use case tests
```

## Trigger

Use this command when:
- Starting a new service or module using Clean Architecture
- Reviewing an existing codebase that claims to follow Clean Architecture
- Adding a new use case (business feature) to an existing clean architecture project
- Framework annotations are appearing inside domain entities (common violation)
- The test suite requires a running database or Spring context for business logic tests
- Adding ArchUnit tests to enforce the dependency rule in CI

## Input

**For `/clean-arch analyze`:**
- Package structure or key class examples
- Technology stack (Java/Spring, TypeScript/NestJS, Python, Go)

**For `/clean-arch scaffold`:**
- Feature name (e.g., "place order", "cancel subscription")
- Technology stack
- Existing package structure to conform to

**For `/clean-arch check-deps`:**
- Specific class or package to audit
- Direction of violation (inner depends on outer, or outer depends on wrong inner)

**For `/clean-arch test`:**
- Use case interactor class
- Required repositories and their interfaces
- Happy path and key failure scenarios to cover

## Process

### /clean-arch analyze

1. Identify the layer each class belongs to based on package names, annotations, and imports.
2. Check for dependency rule violations: inner layers importing from outer layers.
3. Check for framework annotations in domain entities (`@Entity`, `@Component`, `@JsonProperty`).
4. Check for use cases that know about HTTP (import `HttpServletRequest`, return `ResponseEntity`).
5. Check for controllers that contain business logic (complex conditionals, domain calculations).
6. Check whether use cases can be tested without starting the framework.
7. Report: violations found, severity (blocks testing / minor style / acceptable tradeoff), recommended fix.

### /clean-arch scaffold

1. Generate folder structure for the requested feature.
2. Generate input port (use case interface).
3. Generate request and response models (plain records/classes, no framework deps).
4. Generate use case interactor skeleton with output port dependencies injected.
5. Generate output port interfaces (repository, event publisher).
6. Generate controller adapter skeleton.
7. Generate in-memory repository for testing.
8. Generate use case test class with 3 scenarios (happy path, entity not found, business rule violated).

### /clean-arch check-deps

1. Identify the class in question and its layer.
2. List all imports that violate the dependency rule.
3. For each violation: explain why it is a violation and how to fix it.
4. Suggest ArchUnit rule that would catch this in CI.

### /clean-arch test

1. Generate in-memory implementations for each required repository.
2. Generate test class that instantiates the interactor directly (no Spring context).
3. Generate test methods for: happy path, key failure scenarios (entity not found, business rule violation, concurrent modification).
4. Use AssertJ for fluent assertions.

## Examples

**Example: `/clean-arch scaffold`**

Input: "Feature: Cancel Order. Java/Spring. Package root: com.example.shop."

Output:
```
Generated files:

domain/model/Order.java                          (existing — add cancel() method)
application/usecase/CancelOrderUseCase.java       (input port)
application/usecase/CancelOrderRequest.java       (request model)
application/usecase/CancelOrderResponse.java      (response model)
application/usecase/CancelOrderInteractor.java    (implementation)
adapter/web/OrderController.java                  (add DELETE /orders/{id} endpoint)
adapter/web/CancelOrderApiRequest.java            (HTTP request body)

Tests:
test/application/usecase/CancelOrderInteractorTest.java
  - cancels pending order successfully
  - rejects cancellation of dispatched order
  - throws when order not found
```

**Example: `/clean-arch check-deps`**

Input: `OrderService.java` that imports `javax.persistence.EntityManager` and `org.springframework.http.ResponseEntity`.

Output:
```
Violations found in OrderService.java:

1. CRITICAL: Imports javax.persistence.EntityManager
   Layer: Application (use case)
   Violation: Application layer depends on persistence framework (outer layer)
   Fix: Create OrderRepository interface in application/domain layer.
        Inject OrderRepository, not EntityManager.
        Move EntityManager usage to JpaOrderRepository in adapter/persistence.

2. MODERATE: Imports org.springframework.http.ResponseEntity
   Layer: Application (use case)
   Violation: Use case knows about HTTP delivery mechanism
   Fix: Use case should return a plain PlaceOrderResponse record.
        ResponseEntity construction belongs in the controller (adapter/web).

ArchUnit rule to catch future violations:
  noClasses().that().resideInAPackage("..application..")
    .should().dependOnClassesThat()
    .resideInAnyPackage("org.springframework.http..", "javax.persistence..");
```

## Output Format

- `/clean-arch analyze`: Violation report with severity and fix for each
- `/clean-arch scaffold`: Complete list of generated files with package path + skeleton code for each
- `/clean-arch check-deps`: Per-import violation analysis with ArchUnit rule
- `/clean-arch test`: Complete JUnit 5 test class with in-memory stubs
