# Beginner Learning Path: Architecture Fundamentals

> From writing code that works to writing code that lasts. This path builds the foundational understanding you need before tackling complex architectural patterns.

---

## Who This Is For

You can write working code but are starting to notice problems at scale:
- Changes in one place break things elsewhere
- New features take longer and longer to add
- You are not sure where new code should live
- The codebase feels harder to understand over time

This path teaches you WHY these problems happen and the foundational principles that prevent them.

---

## Phase 1: Why Architecture Matters

### The Cost of Change

Architecture is the set of decisions that are **expensive to change later**. Database choice, communication style, module boundaries, deployment topology -- these decisions shape every future decision.

Good architecture does not mean complex architecture. It means the right trade-offs for your context.

**Key insight:** The goal is not to prevent all change. The goal is to make the system easy to change in the directions it is most likely to change.

### Technical Debt Is Not Just Bad Code

Technical debt is the difference between the current design and the design you need. Sometimes taking on debt is the right choice (ship faster, learn from users). The problem is **unintentional** debt -- mess that accumulates because nobody thought about structure.

### Exercise 1: Identify Structural Pain

Look at a codebase you work on. Answer these questions:
1. Where does a new feature go? Is the answer obvious from the structure?
2. Can you change the database without rewriting business logic?
3. Can you test business rules without starting a web server?
4. How many files do you touch to add a simple feature?

These answers reveal your architecture's fitness for change.

---

## Phase 2: SOLID Principles

SOLID is not a set of rules to memorize. Each principle addresses a specific structural problem.

### Single Responsibility Principle (SRP)

**The problem it solves:** A class that does too many things changes for too many reasons. Every change risks breaking something unrelated.

**The principle:** A class should have only one reason to change. "Reason to change" means one stakeholder or business concern.

**Example:** A `UserService` that handles authentication, profile updates, AND email notifications has three reasons to change. Split into `AuthService`, `ProfileService`, `NotificationService`.

**Warning:** Do not take this to the extreme. A class that does only one tiny thing creates an explosion of classes that are hard to navigate. Balance cohesion (things that belong together) with separation.

### Open/Closed Principle (OCP)

**The problem it solves:** Every time you add a new case, you modify existing code and risk breaking it.

**The principle:** Software should be open for extension but closed for modification. You should be able to add new behavior without changing existing code.

**How:** Use abstractions (interfaces, abstract classes) and polymorphism. New cases implement the interface rather than adding `if/else` branches.

**Example:** Instead of a `calculateDiscount` function with `if (type === 'student') ... else if (type === 'senior')`, define a `DiscountStrategy` interface and create `StudentDiscount`, `SeniorDiscount` implementations.

### Liskov Substitution Principle (LSP)

**The problem it solves:** Subtypes that break the contract of their parent type cause bugs in code that uses the parent type.

**The principle:** Objects of a supertype should be replaceable with objects of a subtype without breaking the program.

**Classic violation:** A `Square` extending `Rectangle`. Setting width on a Rectangle should not change height, but a Square must keep them equal. The Square breaks the Rectangle contract.

**Practical test:** If you need to check the concrete type before using it, you are probably violating LSP.

### Interface Segregation Principle (ISP)

**The problem it solves:** Fat interfaces force implementors to depend on methods they do not use.

**The principle:** No client should be forced to depend on methods it does not use. Prefer many small, focused interfaces over one large one.

**Example:** Instead of one `UserRepository` with `findById`, `save`, `delete`, `findByEmail`, `updateLastLogin`, `bulkImport`, split into `UserReader`, `UserWriter`, and `UserBulkOperations`.

### Dependency Inversion Principle (DIP)

**The problem it solves:** High-level business logic depends on low-level details (database, HTTP, file system), making it hard to test and change.

**The principle:** High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions.

**This is the most important principle for architecture.** It is the foundation of clean architecture, hexagonal architecture, and every serious structural pattern.

**Example:** Your `OrderService` should not import `PostgresOrderRepository`. Instead, `OrderService` depends on an `OrderRepository` interface. `PostgresOrderRepository` implements that interface. The dependency arrow points from infrastructure toward the domain, not the other way.

---

## Phase 3: Design Patterns That Matter

There are 23 GoF patterns. You do not need all of them. These are the ones that come up constantly in real architectural work.

### Strategy Pattern

**When:** You need to swap algorithms or behaviors at runtime or across configurations.

**Structure:** Define an interface for the behavior. Create concrete implementations. Inject the appropriate implementation.

**Architecture connection:** This is the OCP and DIP in action. New strategies extend behavior without modifying existing code.

### Repository Pattern

**When:** You need to decouple domain logic from data access.

**Structure:** Define an interface in the domain layer (`UserRepository`). Implement it in the infrastructure layer (`PostgresUserRepository`). Domain code uses the interface, never the implementation.

**Architecture connection:** This is the gateway to clean architecture. Your domain layer becomes testable without a database.

### Observer / Event Pattern

**When:** You need to notify multiple parts of the system that something happened, without the producer knowing about the consumers.

**Structure:** Producer emits events. Consumers subscribe to events. Neither knows about the other.

**Architecture connection:** This is the foundation of event-driven architecture. It decouples bounded contexts and enables eventual consistency.

### Factory Pattern

**When:** Object creation is complex, involves conditional logic, or needs to be centralized.

**Structure:** A factory method or class encapsulates creation logic. Clients ask the factory for objects instead of constructing them directly.

**Architecture connection:** Factories hide infrastructure details from domain code. A `RepositoryFactory` can return different implementations based on configuration.

### Decorator Pattern

**When:** You need to add behavior to an object without modifying its class. Cross-cutting concerns like logging, caching, and authorization.

**Structure:** A decorator implements the same interface as the wrapped object and delegates to it after adding its behavior.

**Architecture connection:** Decorators enable the open/closed principle for cross-cutting concerns.

---

## Phase 4: Layered Architecture

Layered architecture is where most developers start with architecture. It separates code into horizontal layers with rules about which layers can depend on which.

### The Classic Three Layers

```
+-------------------+
|   Presentation    |   Controllers, views, API endpoints
+-------------------+
|   Business Logic  |   Services, domain rules, use cases
+-------------------+
|   Data Access     |   Repositories, ORMs, database queries
+-------------------+
```

**Rules:**
1. Each layer only depends on the layer directly below it
2. No layer depends on a layer above it
3. Presentation never talks directly to data access

### Why This Works (Initially)

- Clear separation of concerns
- Easy to understand for new team members
- Straightforward testing strategy
- Familiar to most developers

### Why This Breaks Down

**The dependency direction problem:** Business logic depends on data access. This means your most important code (business rules) depends on your least important code (database choice).

**The "service" problem:** Business logic layers tend to become bloated "service" classes that are just transaction scripts -- procedural code wrapped in a class.

**The leaking abstractions problem:** ORM entities leak into the business layer. Business decisions get made based on database column names instead of domain concepts.

### The Fix: Dependency Inversion

Flip the dependency direction. Make the data access layer depend on the business logic layer, not the other way around.

```
+-------------------+
|   Presentation    |   Depends on Business Logic
+-------------------+
|   Business Logic  |   Defines interfaces (ports)
+-------------------+
       ^
       |  implements
+-------------------+
|   Data Access     |   Implements business logic interfaces
+-------------------+
```

This is the key insight that leads to clean architecture and hexagonal architecture (covered in the intermediate path).

---

## Phase 5: Package Structure and Cohesion

### Package by Layer vs Package by Feature

**Package by layer** groups code by technical role:
```
src/
+-- controllers/
+-- services/
+-- repositories/
+-- models/
```

**Package by feature** groups code by business capability:
```
src/
+-- orders/
|   +-- order-controller.ts
|   +-- order-service.ts
|   +-- order-repository.ts
+-- users/
    +-- user-controller.ts
    +-- user-service.ts
    +-- user-repository.ts
```

**Package by feature is almost always better.** When you add or modify a feature, all related code is in one place. When you eventually need to extract a service, the boundary is already clear.

### Cohesion: The Right Things Together

Cohesion measures how related the elements within a module are. High cohesion means everything in the module serves the same purpose.

Signs of low cohesion:
- A `utils` folder with 50 unrelated functions
- A service class with methods that share no data
- A module that every other module depends on

### Coupling: The Right Things Apart

Coupling measures how much one module depends on another. Low coupling means modules can change independently.

Signs of high coupling:
- Changing one module requires changes in five others
- Circular dependencies between modules
- Modules importing internal details of other modules

**The goal is high cohesion within modules and low coupling between modules.**

---

## Phase 6: Practical Exercises

### Exercise 2: Refactor to SOLID

Take a controller or service class from your project that does too much. Apply SRP to split it. Apply DIP to introduce an interface between the business logic and the database.

### Exercise 3: Introduce the Repository Pattern

Pick one entity in your project. Create a repository interface in your domain/business layer. Move the database queries behind that interface. Verify you can test the business logic with a fake repository.

### Exercise 4: Restructure by Feature

If your project is organized by layer, reorganize one feature to be packaged by feature. Move the controller, service, repository, and types for one feature into a single directory.

### Exercise 5: Draw the Dependency Graph

Sketch the dependency graph of your modules. Arrows point from the module that imports to the module that is imported. Look for:
- Circular dependencies (modules that depend on each other)
- God modules (one module everything depends on)
- Inverted dependencies (domain depending on infrastructure)

---

## What Comes Next

Once you are comfortable with SOLID, design patterns, layered architecture, and package structure, you are ready for the intermediate path:

- **Domain-Driven Design** -- Modeling complex business domains
- **Hexagonal Architecture** -- The "ports and adapters" evolution of layered architecture
- **Event-Driven Design** -- Decoupling through asynchronous communication
- **API Design** -- Building boundaries that last

---

## Key Books and References

- **Clean Code** by Robert C. Martin -- Code-level quality
- **Head First Design Patterns** by Freeman & Robson -- Accessible pattern introduction
- **A Philosophy of Software Design** by John Ousterhout -- Practical complexity management
- **Fundamentals of Software Architecture** by Richards & Ford -- Breadth-first architecture overview

---

## Core Takeaways

1. **Architecture is about trade-offs**, not best practices. Every choice has a cost.
2. **Dependencies point inward** -- Business logic should not depend on infrastructure.
3. **Cohesion and coupling** are the fundamental metrics of structural quality.
4. **Package by feature**, not by layer.
5. **Start simple.** Do not add architectural complexity before you understand the forces that require it.
