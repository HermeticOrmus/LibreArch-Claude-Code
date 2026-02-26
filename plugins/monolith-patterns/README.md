# Monolith Patterns Plugin

Modular monolith design, module boundary enforcement, vertical slicing, decomposition readiness assessment, and the case for staying on a monolith when teams and domains don't yet warrant microservices.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/monolith-architect/AGENT.md` | Expert in modular monolith architecture. Covers module structure by bounded context, public facade pattern, in-process events for decoupling, ArchUnit boundary enforcement, vertical slicing, data ownership per module, and decomposition readiness criteria. References Fowler MonolithFirst 2015, Newman 2021, Grzybek modular-monolith-with-ddd. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/monolith/COMMAND.md` | `/monolith design|enforce|assess|slice` — module structure design using bounded contexts, ArchUnit enforcement generation, decomposition readiness scoring, and horizontal-to-vertical slice reorganization. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/monolith-patterns/SKILL.md` | Named patterns with code: public module facade (Java), in-process events with Spring ApplicationEventPublisher, ArchUnit module boundary enforcement, vertical slice feature organization (TypeScript/NestJS), module-scoped integration test. Anti-patterns: shared database tables across modules, god facade, circular module dependencies. |

## When to Use

- Deciding whether to start a new project as a monolith or microservices (usually monolith)
- Refactoring a big ball of mud into modules with enforced package boundaries
- Evaluating whether specific modules are ready to extract as independent services
- Converting a horizontal layers codebase into vertical feature slices
- Adding ArchUnit tests to make implicit module contracts explicit and enforceable in CI

## Key References

- Fowler, Martin. "MonolithFirst." martinfowler.com/bliki/MonolithFirst.html, 2015.
- Newman, Sam. _Building Microservices_, 2nd ed. O'Reilly, 2021. Chapter 1.
- Grzybek, Kamil. Modular Monolith with DDD. github.com/kgrzybek/modular-monolith-with-ddd.
- ArchUnit: archunit.org
