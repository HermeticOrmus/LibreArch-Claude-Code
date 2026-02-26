# /migrate

> Plan and execute system migrations: strangler fig extraction, expand-contract schema changes, parallel run validation, and canary deployment.

## Usage

```
/migrate plan        - Choose migration strategy and design the execution sequence
/migrate strangle    - Extract a slice from a monolith using strangler fig pattern
/migrate schema      - Design an expand-contract database migration
/migrate validate    - Design parallel run to verify new implementation before cutover
```

## Trigger

Use this command when:
- Extracting a service from a monolith with minimal disruption to existing clients
- Renaming or restructuring a database column or table in a live production system
- Replacing a legacy calculation engine and needing correctness validation
- Planning a zero-downtime deployment strategy for a major version change
- Deprecating an API version with a defined Sunset timeline

## Process

### /migrate plan
1. Identify the type of migration: code extraction, data schema change, system replacement.
2. Identify rollback constraints: can you roll back at any step? What is the rollback procedure?
3. Choose strategy: strangler fig (service extraction), branch by abstraction (library swap), expand-contract (schema), parallel run (algorithm replacement).
4. Sequence phases: each phase must be independently deployable and independently rollbackable.
5. Define cutover criteria: what metrics indicate the new system is production-ready?

### /migrate strangle
1. Install a facade/proxy between clients and the legacy system.
2. Identify the first slice to extract: choose a bounded, low-risk path (e.g., read-only endpoint).
3. Implement the slice in the new system with feature parity.
4. Route the slice to the new system at the proxy layer.
5. Verify: compare error rates, latency, and business metrics for 1 week.
6. Remove the corresponding code from the legacy system.
7. Repeat for the next slice.

### /migrate schema
1. Identify the change: rename, split, type change, constraint addition.
2. Expand phase: add new column/table alongside old. Deploy code that writes both.
3. Backfill: update existing rows to populate new column.
4. Transition phase: deploy code that reads from new column only. Verify in production.
5. Contract phase: drop the old column. Verify no remaining references.
6. Each phase is a separate Flyway/Liquibase migration + code deployment.

### /migrate validate
1. Implement the new algorithm/system behind the same interface.
2. Deploy parallel run code: invoke both old and new, log discrepancies, return old result.
3. Run in shadow mode until discrepancy rate = 0% for 1 week (or 100K samples).
4. Investigate and fix every discrepancy found.
5. Set `shadow_mode = false` to route production traffic to new system.
6. Monitor for 1 week. Remove old implementation.

## Examples

**Example: `/migrate strangle`**

Input: "Extract the Order API from a Rails monolith. New system is a Java Spring Boot service."

Migration sequence:
```
Phase 0: Install Nginx proxy in front of Rails monolith (transparent to clients)
  - All traffic: Nginx → Rails
  - No behavior change. Validate proxy layer in production.
  - Rollback: remove Nginx, clients call Rails directly.

Phase 1: Implement GET /api/orders/:id in Java service
  - Nginx routes GET /api/orders/:id → Java service
  - All other paths → Rails
  - Run for 1 week. Compare error rates.
  - Rollback: remove routing rule.

Phase 2: Implement POST /api/orders in Java service
  - Requires: shared database readable by both, or event sync
  - Nginx routes POST /api/orders → Java service
  - Data must be consistent between old and new (if still using shared DB)
  - Rollback: remove routing rule.

Phase 3: Implement remaining order endpoints
  - After all order paths migrate: remove order code from Rails
  - Rails codebase is smaller; Java owns order data

Cutover criteria per phase:
  - Error rate new ≤ error rate legacy for 7 days
  - p99 latency new ≤ p99 latency legacy × 1.2
  - No data inconsistencies detected
```

**Example: `/migrate schema`**

Input: "Rename column `user_id` to `customer_id` in the orders table."

Zero-downtime migration sequence:
```
Migration V5 (Expand):
  ALTER TABLE orders ADD COLUMN customer_id VARCHAR(36);
  UPDATE orders SET customer_id = user_id;
  ALTER TABLE orders ALTER COLUMN customer_id SET NOT NULL;

Code deployment A: write to BOTH user_id and customer_id. Read from user_id.
  -- Old code continues to work. New code is safe.

Code deployment B: read from customer_id. Still write to both.
  -- Validate in production for 1 deployment cycle.

Migration V6 (Contract):
  ALTER TABLE orders DROP COLUMN user_id;
  -- Safe: no code reads user_id anymore.
```

## Output Format

- Migration strategy selection with justification
- Phase-by-phase execution plan with rollback procedure for each phase
- SQL migration scripts with dual-write application code
- Parallel run configuration and cutover criteria
- Deprecation timeline with Sunset header configuration
