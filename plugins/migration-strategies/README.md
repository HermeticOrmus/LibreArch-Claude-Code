# Migration Strategies Plugin

System migration patterns for extracting services from monoliths, zero-downtime database schema changes, parallel run validation, and canary deployment. Covers strangler fig, branch by abstraction, expand-contract, blue-green, and API deprecation.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/migration-architect/AGENT.md` | Expert in low-risk migration execution. Covers strangler fig (proxy layer, incremental path migration), branch by abstraction (interface-driven replacement), parallel run (shadow mode, reconciliation), expand-contract schema migration (zero-downtime rename/split), blue-green and canary deployment, and API deprecation with RFC 8594 Sunset headers. References Newman 2019, Fowler, Sadalage/Fowler 2006. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/migrate/COMMAND.md` | `/migrate plan|strangle|schema|validate` — strategy selection, strangler fig phase sequencing, expand-contract SQL migration design, and parallel run with cutover criteria. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/migration-patterns/SKILL.md` | Named patterns with code: strangler fig proxy (TypeScript/Express), expand-contract SQL + dual-write Java, parallel run with reconciliation (Python), branch by abstraction (Java), canary with Argo Rollouts YAML. Anti-patterns: big bang migration, column rename in one step, schema before code. |

## When to Use

- Extracting a new service from a monolith without breaking existing clients
- Renaming or restructuring a column in a live production database
- Replacing a legacy pricing or calculation engine with confidence
- Planning a major version rollout with gradual traffic increase
- Deprecating an old API version with a scheduled Sunset date

## Key References

- Newman, Sam. _Monolith to Microservices_. O'Reilly, 2019.
- Fowler, Martin. "Strangler Fig Application." martinfowler.com, 2004.
- Fowler, Martin. "Branch by Abstraction." martinfowler.com, 2014.
- Sadalage, Pramod, and Martin Fowler. _Refactoring Databases_. Addison-Wesley, 2006.
- RFC 8594: The Sunset HTTP Header Field.
