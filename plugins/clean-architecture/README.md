# Clean Architecture Plugin

Designs, audits, and enforces Clean Architecture (Robert C. Martin). Covers the dependency rule, use case interactor pattern, entity invariant enforcement, entity/DTO mapping at adapter boundaries, framework-free use case testing, and ArchUnit CI enforcement.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/clean-arch-engineer/AGENT.md` | Expert in Clean Architecture, Hexagonal Architecture (Cockburn), Onion Architecture (Palermo). Use case interactors, output port interfaces, presenter/view model separation, framework-free testing, ArchUnit fitness functions. References Martin (2017), Cockburn (2005), Hombergs (2023). |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/clean-arch/COMMAND.md` | `/clean-arch analyze|scaffold|check-deps|test` — violation audit, feature scaffolding with all layers, per-import dependency analysis, framework-free test generation. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/clean-arch-patterns/SKILL.md` | Named patterns with Java code: folder structure, entity with invariants, presenter/view model, framework-free use case test, ArchUnit rules. Anti-patterns: framework annotation in domain, use case that knows HTTP, Clean Architecture in name only. |

## When to Use

- Starting a new service or module that should follow Clean Architecture
- Reviewing code for dependency rule violations (framework annotations in domain entities)
- Adding a new business feature (use case) to an existing clean architecture project
- The test suite requires Spring or database — indicates business logic is coupled to infrastructure
- Adding ArchUnit CI enforcement to prevent dependency rule regression
- Evaluating whether Clean Architecture is the right fit (it adds overhead — not always justified)

## Key References

- Martin, Robert C. _Clean Architecture: A Craftsman's Guide to Software Structure and Design_. Prentice Hall, 2017.
- Martin, Robert C. "The Clean Architecture." blog.cleancoder.com, 2012.
- Cockburn, Alistair. "Hexagonal Architecture." alistair.cockburn.us, 2005.
- Palermo, Jeffrey. "The Onion Architecture." jeffreypalermo.com, 2008.
- Hombergs, Tom. _Get Your Hands Dirty on Clean Architecture_. 2nd ed., 2023.
- ArchUnit: archunit.org.
