# Hexagonal Architecture Plugin

Ports and adapters architecture (Alistair Cockburn 2005): driving ports, driven ports, adapter implementations, dependency inversion, framework-free domain testing, and ArchUnit enforcement.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/hex-arch-engineer/AGENT.md` | Expert in hexagonal architecture. Covers driving ports (input), driven ports (output), adapter pattern, dependency rule enforcement, framework-free domain model, ArchUnit fitness functions, and relationship to Clean Architecture and DDD bounded contexts. References Cockburn 2005, Hombergs 2023, Vernon IDDD. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/hex-arch/COMMAND.md` | `/hex-arch analyze|scaffold|check-deps|test-adapter` — compliance audit, use case scaffolding (driving port + interactor + adapter), dependency direction verification, and in-memory test adapter generation. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/hex-arch-patterns/SKILL.md` | Named patterns with code: canonical folder structure, driving port + interactor (Java), driven port + JPA adapter (Java), in-memory test adapter (Java), ArchUnit fitness tests. Anti-patterns: port interface in infrastructure, JPA annotations on domain objects, controller calling repository directly. |

## When to Use

- Starting a new service: establish hexagonal folder structure from the beginning
- Reviewing a Spring Boot service for framework contamination of domain objects
- Creating fast unit tests by swapping JPA adapters for in-memory implementations
- Enforcing the dependency rule in CI with ArchUnit
- Explaining the difference between ports (interfaces) and adapters (implementations) to a team

## Key References

- Cockburn, Alistair. "Hexagonal Architecture." alistair.cockburn.us/hexagonal-architecture, 2005.
- Hombergs, Tom. _Get Your Hands Dirty on Clean Architecture_, 2nd ed. Packt, 2023.
- Vernon, Vaughn. _Implementing Domain-Driven Design_. Addison-Wesley, 2013.
- Graca, Herberto. "DDD, Hexagonal, Onion, Clean, CQRS." herbertograca.com, 2017.
