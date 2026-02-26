# Domain-Driven Design Plugin

Aggregate root design, bounded context mapping, value objects, domain events, ubiquitous language, and context integration patterns.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/ddd-architect/AGENT.md` | Expert in Eric Evans' blue book and Vaughn Vernon's red book. Covers aggregate design rules, bounded context identification, value objects, domain events, context mapping patterns (ACL, OHS, Conformist, Partnership), and ubiquitous language enforcement. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/ddd/COMMAND.md` | `/ddd model|map-contexts|validate|generate` — aggregate root design from invariants, context relationship mapping with pattern selection, anemic model detection, and full DDD scaffold generation. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/ddd-patterns/SKILL.md` | Named patterns with code: aggregate root with invariant enforcement (Java), Money value object (TypeScript), domain event publishing via Outbox (Java), Anticorruption Layer (TypeScript). Anti-patterns: anemic domain model, cross-aggregate object references, one-aggregate-for-everything. |

## When to Use

- Designing a new service: identify aggregate boundaries from business invariants
- Refactoring a service with logic scattered across service classes into a rich domain model
- Integrating with an external system: design the Anticorruption Layer
- Reviewing bounded context boundaries when teams step on each other's models
- Choosing between ACL, Conformist, OHS, or Shared Kernel for a cross-context integration

## Key References

- Evans, Eric. _Domain-Driven Design: Tackling Complexity in the Heart of Software_. Addison-Wesley, 2003. (blue book)
- Vernon, Vaughn. _Implementing Domain-Driven Design_. Addison-Wesley, 2013. (red book)
- Vernon, Vaughn. _Domain-Driven Design Distilled_. Addison-Wesley, 2016.
- Brandolini, Alberto. _Introducing Event Storming_. Leanpub, 2021.
- DDD Crew context mapping patterns: github.com/ddd-crew/context-mapping
