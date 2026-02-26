# Database Patterns Plugin

Designs, audits, and optimizes database access layers. Covers Repository pattern (Fowler 2002), Unit of Work transaction boundaries, Specification pattern, N+1 query prevention, read replica routing, connection pool sizing (HikariCP), and sharding strategies (consistent hashing).

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/db-architect/AGENT.md` | Expert in Repository, Unit of Work, Specification patterns (Fowler). N+1 prevention (JOIN FETCH, @EntityGraph, DTO projection). Read replica routing. Consistent hashing for sharding. HikariCP pool sizing formula. PostgreSQL/JPA/Prisma specifics. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/db-pattern/COMMAND.md` | `/db-pattern analyze|generate|optimize|test` — N+1 audit, repository interface generation, EXPLAIN ANALYZE interpretation, missing index detection, in-memory test doubles. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/db-arch-patterns/SKILL.md` | Named patterns with code: TypeScript repository with Specification, Java Unit of Work (Spring @Transactional), DTO projection SQL, HikariCP YAML config, consistent hashing sharding (Python). Anti-patterns with examples. |

## When to Use

- Designing the data access layer for a new service or bounded context
- Diagnosing N+1 queries (ORM logging shows many similar queries in a loop)
- Connection pool exhaustion under load — sizing and configuration
- Adding read replica routing for read-heavy workloads
- Choosing shard key strategy before implementing horizontal write scaling
- Adding tests: in-memory fakes vs Testcontainers for repository testing

## Key References

- Fowler, Martin. _Patterns of Enterprise Application Architecture_. Addison-Wesley, 2002. Repository, Unit of Work, Specification.
- Evans, Eric. _Domain-Driven Design_. Addison-Wesley, 2003. Repository in DDD.
- Petrov, Alex. _Database Internals_. O'Reilly, 2019.
- HikariCP: github.com/brettwooldridge/HikariCP. Pool sizing documentation.
- Karger, David, et al. "Consistent Hashing and Random Trees." ACM STOC 1997.
