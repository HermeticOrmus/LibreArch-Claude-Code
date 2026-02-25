# Architecture Configuration -- CLAUDE.md Template

> Paste this into your project's `CLAUDE.md` file and customize each section for your architecture.
> Remove sections that do not apply. Fill in every section you keep -- incomplete architecture
> documentation produces incomplete architectural thinking.

---

## Project Architecture Profile

- **Project Name:** [your-project-name]
- **Architecture Style:** [Monolith / Modular Monolith / Microservices / Serverless / Hybrid]
- **Domain Complexity:** [Simple CRUD / Moderate Business Logic / Complex Domain / Multiple Bounded Contexts]
- **Primary Language(s):** [TypeScript / Java / Go / Python / Rust / C# / etc.]
- **Framework(s):** [Next.js / Spring Boot / Express / Django / etc.]
- **Database(s):** [PostgreSQL / MongoDB / Redis / DynamoDB / etc.]
- **Messaging:** [None / RabbitMQ / Kafka / SQS / NATS / etc.]

---

## Architectural Principles

### Core Principles

```
# 1. Dependency Rule
# - Dependencies point inward: infrastructure -> application -> domain
# - Domain layer has no external dependencies
# - Use dependency inversion at boundaries
#
# 2. Bounded Context Boundaries
# - Each context owns its data and business rules
# - Communication between contexts via events or explicit APIs
# - No direct database sharing between contexts
#
# 3. Separation of Concerns
# - Business logic lives in the domain layer
# - Infrastructure concerns (DB, HTTP, messaging) live in adapters
# - Use cases orchestrate domain operations
```

### Layer Structure

```
src/
+-- domain/                     # Core business logic (no dependencies)
|   +-- entities/               # Business entities and aggregates
|   +-- value-objects/          # Immutable value types
|   +-- events/                 # Domain events
|   +-- repositories/           # Repository interfaces (ports)
|   +-- services/               # Domain services
+-- application/                # Use cases and application services
|   +-- commands/               # Command handlers (write operations)
|   +-- queries/                # Query handlers (read operations)
|   +-- services/               # Application services
|   +-- ports/                  # Input/output port interfaces
+-- infrastructure/             # External concerns
|   +-- persistence/            # Database implementations (adapters)
|   +-- messaging/              # Message broker implementations
|   +-- http/                   # HTTP client implementations
|   +-- config/                 # Configuration loading
+-- interfaces/                 # Entry points
|   +-- api/                    # REST/GraphQL controllers
|   +-- cli/                    # CLI commands
|   +-- events/                 # Event consumers
+-- shared/                     # Cross-cutting concerns
    +-- errors/                 # Error types
    +-- types/                  # Shared type definitions
    +-- utils/                  # Pure utility functions
```

---

## Domain Model

### Bounded Contexts

| Context | Responsibility | Communication |
|---------|---------------|---------------|
| [Context A] | [What it owns] | [Events / API / Shared Kernel] |
| [Context B] | [What it owns] | [Events / API / Shared Kernel] |

### Aggregates

```
# Aggregate: [Name]
# - Root entity: [Entity]
# - Invariants: [Business rules this aggregate enforces]
# - Events: [Domain events this aggregate produces]
# - Consistency: [Transactional / Eventual]
```

### Domain Events

| Event | Producer | Consumer(s) | Purpose |
|-------|----------|-------------|---------|
| [EventName] | [Context/Aggregate] | [Context(s)] | [What it signals] |

---

## Data Architecture

### Database Strategy

```
# Strategy: [Single DB / DB per Service / Polyglot Persistence]
#
# Primary database: [engine]
# - Purpose: [what it stores]
# - Access pattern: [read-heavy / write-heavy / balanced]
#
# Caching: [Redis / Memcached / Application-level / None]
# - Strategy: [Cache-aside / Read-through / Write-through / Write-behind]
# - Invalidation: [TTL / Event-driven / Manual]
```

### Data Consistency

```
# Consistency model: [Strong / Eventual / Mixed]
#
# Strong consistency required for:
# - [List operations requiring immediate consistency]
#
# Eventual consistency acceptable for:
# - [List operations where lag is acceptable]
# - Maximum acceptable lag: [time]
```

---

## Communication Patterns

### Synchronous

```
# Internal communication:
# - Protocol: [HTTP/REST / gRPC / GraphQL]
# - Timeout: [default timeout]
# - Retry policy: [exponential backoff / circuit breaker]
#
# External API:
# - Style: [REST / GraphQL / RPC]
# - Versioning: [URL / Header / Content negotiation]
```

### Asynchronous

```
# Event bus: [technology]
# - Delivery guarantee: [At-most-once / At-least-once / Exactly-once]
# - Ordering: [Ordered / Unordered / Partition-ordered]
# - Dead letter queue: [Yes/No]
```

---

## Architecture Decision Records

```
# ADR location: docs/architecture/decisions/
# Naming: NNNN-title-in-kebab-case.md
# Template: [Nygard / MADR / Custom]
# Status lifecycle: Proposed -> Accepted -> Deprecated -> Superseded
```

| ADR | Decision | Status | Date |
|-----|----------|--------|------|
| [ADR-0001] | [Architecture style choice] | [Accepted] | [date] |
| [ADR-0002] | [Database choice] | [Accepted] | [date] |

---

## Quality Attributes

### Performance

```
# Response time targets: p50=[x]ms, p95=[x]ms, p99=[x]ms
# Throughput: [requests per second]
# Concurrent users: [expected peak]
```

### Resilience

```
# Availability target: [99.9% / 99.95% / 99.99%]
# RTO: [time] | RPO: [time]
# Patterns: [Circuit breaker, Bulkhead, Retry, Timeout, Fallback]
```

---

## Testing Strategy

### Architecture Tests

```
# Fitness functions:
# - Dependency direction tests (no inward-to-outward dependencies)
# - Cycle detection (no circular dependencies between modules)
# - Layer violation tests (no infrastructure imports in domain)
# - Package coupling metrics (afferent/efferent coupling thresholds)
#
# Tools: [ArchUnit / ts-arch / Depend / Custom]
```

### Test Pyramid

| Level | Scope | Tool | Coverage Target |
|-------|-------|------|-----------------|
| Unit | Domain logic | [tool] | [target] |
| Integration | Adapters, repositories | [tool] | [target] |
| Contract | API contracts | [tool] | [target] |
| E2E | Critical paths | [tool] | [target] |

---

## Claude Code Architecture Directives

When working on this project, Claude Code must:

1. **Respect the dependency rule** -- Domain layer must not import from infrastructure or interfaces layers.
2. **Use dependency inversion at boundaries** -- Define interfaces (ports) in the domain/application layer, implement (adapters) in infrastructure.
3. **Keep business logic in the domain** -- Controllers and repositories must not contain business rules.
4. **Follow the aggregate pattern** -- Modifications to related entities must go through the aggregate root.
5. **Use value objects for domain concepts** -- Primitive obsession creates bugs. Wrap domain concepts in typed value objects.
6. **Emit domain events for side effects** -- Cross-context communication via events, not direct calls.
7. **Write architecture fitness tests** -- Every new module must have dependency direction tests.
8. **Document architectural decisions** -- Any significant choice must produce an ADR.
9. **Favor explicit over implicit** -- Make boundaries, dependencies, and data flows visible in the code structure.
10. **Consider evolution** -- Every architectural choice must account for how the system will change.
