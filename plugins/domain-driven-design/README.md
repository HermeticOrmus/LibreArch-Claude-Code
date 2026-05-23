# Domain-Driven Design

> Bounded contexts, aggregates, value objects, domain events, anti-corruption layers, ubiquitous language. The patterns that align software structure to business reality.

## Contents
- **Agent**: `ddd-strategist` — designs DDD-aligned architectures
- **Command**: `/ddd` — context mapping, aggregate design, event identification
- **Skill**: pattern library for tactical + strategic DDD

## Key capabilities

- **Strategic DDD**: bounded contexts, context maps (partnership, customer-supplier, conformist, anti-corruption layer, shared kernel, open host, published language, separate ways)
- **Tactical DDD**: aggregates (consistency boundaries, invariants), value objects, entities, domain services, domain events, repositories
- **Ubiquitous language**: glossary per bounded context, alignment with business
- **Aggregate design rules**: small aggregates, ID references between aggregates, eventual consistency between aggregates
- **Event storming**: workshop format for discovering events, commands, aggregates
- **Anti-corruption layer**: when adapting legacy/external systems, translation layer prevents domain pollution

## When to use

- New system design (DDD pays back at scale; overkill for simple CRUD)
- Refactoring a "big ball of mud" — DDD provides decomposition strategy
- Microservices boundaries — DDD bounded contexts often map well to service boundaries
- Legacy modernization — anti-corruption layer pattern bounds the legacy mess
- Cross-team coordination — context maps express team boundaries

## When NOT to use

- Simple CRUD apps (overkill)
- Throwaway prototypes
- Domains where the team has no business expert / domain SME access

## Compatibility

Language-agnostic. Patterns translate across object-oriented, functional, mixed paradigms. Heavier in OO communities (Java, C#) historically.
