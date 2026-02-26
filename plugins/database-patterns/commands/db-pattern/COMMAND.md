# /db-pattern

> Analyze, generate, optimize, or test database access patterns. Produces repository interfaces, Unit of Work boundaries, N+1 diagnostics, connection pool configuration, and shard key recommendations.

## Usage

```
/db-pattern analyze   - Audit existing data access code for anti-patterns (N+1, missing transactions, naked queries)
/db-pattern generate  - Generate repository interface and implementation for a domain entity
/db-pattern optimize  - Diagnose and fix query performance problems
/db-pattern test      - Generate repository tests with in-memory and integration test strategies
```

## Trigger

Use this command when:
- Designing data access layer for a new service or bounded context
- A service has database performance problems (slow queries, high latency)
- N+1 queries have been detected (ORM logging shows many similar queries)
- Connection pool exhaustion is occurring under load
- Choosing between sharding strategies for horizontal write scaling
- Adding read replica routing to reduce primary database load

## Input

**For `/db-pattern analyze`:**
- Repository or service class code to review
- ORM type (JPA/Hibernate, Prisma, SQLAlchemy, GORM)
- Observed problem (slow queries, high load, pool exhaustion)

**For `/db-pattern generate`:**
- Domain entity name and key fields
- Operations needed (CRUD + any custom queries)
- Technology stack (Java/JPA, TypeScript/Prisma, Python/SQLAlchemy)
- Multi-tenancy requirements

**For `/db-pattern optimize`:**
- Slow query log output or query execution plan (`EXPLAIN ANALYZE`)
- ORM-generated SQL (if available from debug logging)
- Table sizes and cardinality estimates

**For `/db-pattern test`:**
- Repository interface to test
- Testing preference: in-memory (fast, no DB), H2/SQLite (embedded), Testcontainers (real DB)

## Process

### /db-pattern analyze
1. Identify N+1 patterns: loop + repository call, `@OneToMany(fetch=EAGER)` on all associations.
2. Check transaction boundaries: are `@Transactional` annotations on service or repository? Repository-level is too fine-grained.
3. Check for unbounded queries: any `findAll()` without pagination.
4. Check connection pool config: missing pool size, no connection timeout, no leak detection.
5. Check for missing indexes: WHERE clauses on unindexed columns (requires schema review).
6. Report findings with severity and recommended fix.

### /db-pattern generate
1. Generate domain repository interface (speaking domain language, no ORM types in signatures).
2. Generate ORM entity/model.
3. Generate repository implementation with appropriate fetch strategies (JOIN FETCH or @EntityGraph for associations).
4. Generate domain ↔ persistence mapper.
5. Add pagination to collection queries.

### /db-pattern optimize
1. Parse `EXPLAIN ANALYZE` output: identify sequential scans (`Seq Scan`) on large tables — candidates for indexing.
2. Identify high row estimates vs actual rows — stale statistics (`ANALYZE` the table).
3. For N+1: suggest JOIN FETCH, @EntityGraph, or DTO projection.
4. For slow aggregations: suggest materialized view or denormalized summary table.
5. Generate missing index DDL.

### /db-pattern test
1. In-memory approach: generate fake repository implementation using `HashMap<Id, Entity>`.
2. Testcontainers approach: generate `@Container` setup with real PostgreSQL and schema migration.
3. Generate test cases: happy path, not found, duplicate insert, pagination, custom query scenarios.

## Examples

**Example: `/db-pattern analyze`**

Input: Repository method annotated `@Transactional` loading orders in a loop calling `getItems()` on each.

Output:
```
Issues found:

1. N+1 Query — HIGH
   OrderService.getRecentOrders() calls orderRepo.findByStatus()
   returning 50 orders, then calls order.getItems() on each.
   ORM generates 1 + 50 = 51 queries.
   Fix: Add JOIN FETCH to the query:
     @Query("SELECT o FROM Order o JOIN FETCH o.items WHERE o.status = :status")

2. Misplaced @Transactional — MEDIUM
   @Transactional on OrderRepository.save() is too fine-grained.
   If OrderService.fulfillOrder() calls save() and then inventory.reserve(),
   they are in separate transactions.
   Fix: Move @Transactional to OrderService.fulfillOrder().

3. Unbounded query — HIGH
   orderRepo.findAll() in OrderExportService — can return millions of rows.
   Fix: Use cursor-based batch: WHERE id > :lastId ORDER BY id LIMIT 1000.
```

**Example: `/db-pattern generate`**

Input: "Product entity, Java/Spring, need: findById, findByCategory (paginated), findAll (paginated), save, delete."

Output:
```java
// Domain interface
public interface ProductRepository {
    Optional<Product> findById(ProductId id);
    Page<Product> findByCategory(Category category, PageRequest page);
    Page<Product> findAll(PageRequest page);
    void save(Product product);
    void delete(ProductId id);
}

// JPA entity, mapper, Spring Data repository — generated code follows...
```

## Output Format

- Repository interface (domain language, no ORM types)
- JPA/Prisma/SQLAlchemy implementation
- Domain ↔ persistence mapper
- N+1 fix: JOIN FETCH or @EntityGraph annotation
- SQL for missing indexes: `CREATE INDEX CONCURRENTLY`
- Connection pool YAML configuration
- Test class with in-memory repository implementation
