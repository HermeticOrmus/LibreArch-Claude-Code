# /cache

> Analyze caching needs, design a caching strategy, plan invalidation, or benchmark cache effectiveness. Produces Redis configuration, cache key design, TTL recommendations, and stampede prevention strategy.

## Usage

```
/cache analyze    - Analyze data access patterns and identify caching opportunities
/cache design     - Design cache topology, key schema, TTL, and write strategy
/cache invalidate - Design an invalidation strategy for a specific data type
/cache benchmark  - Interpret cache metrics and diagnose hit rate problems
```

## Trigger

Use this command when:
- Designing caching for a new service or data type
- A service has database load problems and caching is proposed as a solution
- Investigating cache stampede or thundering herd incidents
- Designing CDN caching strategy for API responses or static assets
- Choosing between in-process cache (Caffeine) and shared cache (Redis)
- Defining cache key schema to prevent namespace collisions

## Input

**For `/cache analyze`:**
- Data type and access pattern (read ratio, write frequency, dataset size)
- Current latency/load problem being solved
- Consistency requirements (tolerable staleness)

**For `/cache design`:**
- Data type, system (Redis / Memcached / CDN / in-process)
- Write strategy preference (cache-aside / write-through / write-behind)
- Multi-tenancy: yes/no (affects key namespace design)

**For `/cache invalidate`:**
- What triggers invalidation (write event, time, explicit request)
- Number of keys affected per invalidation event
- Risk of stampede (how many concurrent readers on this key?)

**For `/cache benchmark`:**
- Current hit rate, miss rate, eviction rate
- Redis `INFO stats` output (if available)
- `SLOWLOG GET 25` output (if available)

## Process

### /cache analyze
1. Identify data access pattern: read-heavy (>90% reads) vs write-heavy vs mixed
2. Estimate hit rate if cached: (unique items requested / total requests)
3. Calculate cache ROI: miss penalty (DB query time) vs cache overhead (Redis RTT + miss)
4. Identify consistency requirements: what is the tolerable staleness?
5. Identify invalidation trigger: write event, schedule, or pure TTL
6. Recommend: cache at this layer / use CDN / use in-process / don't cache (explain why)

### /cache design
1. Define key schema: `{namespace}:{resource_type}:{id}` — ensure uniqueness, include tenant ID if multi-tenant
2. Select write strategy based on write frequency and consistency needs
3. Set TTL based on tolerable staleness minus max refresh time
4. Recommend stampede prevention: jittered TTL for simple cases, PER algorithm for high-traffic keys
5. Define eviction policy: `allkeys-lru` for general caching; `volatile-lru` if mixing cached data with persistent keys; `noeviction` for session/lock data only
6. Size the cache: target 80%+ hit rate means cache needs to hold the "hot" working set (top 20% of data serving 80% of reads — Zipf distribution)

### /cache invalidate
1. Identify the invalidation trigger (write event or schedule)
2. Choose strategy: event-driven delete (lowest staleness), TTL (simplest), version-key (no explicit delete needed)
3. For event-driven: ensure invalidation happens in same transaction or via outbox pattern to prevent DB-updated/cache-stale gap
4. Assess stampede risk on high-traffic keys — recommend PER or lock-based refresh

### /cache benchmark
1. Compute effective hit rate from Redis INFO: `keyspace_hits / (keyspace_hits + keyspace_misses)`
2. Identify high eviction rate: `evicted_keys` increasing? Cache is too small or TTL is too short
3. Identify high memory fragmentation: `mem_fragmentation_ratio > 1.5` = fragmentation; `< 1.0` = swapping
4. Identify slow commands: SMEMBERS/KEYS on large sets block the server (Redis is single-threaded for commands)
5. Recommend: increase memory, adjust TTL, optimize key design, or shard (Redis Cluster)

## Examples

**Example: `/cache design`**

Input: "User profile data, read 50x per write, 100k users, 5-minute staleness acceptable, multi-tenant SaaS."

Output:
```
Cache strategy: Cache-aside (lazy loading)

Key schema:
  tenant:{tenant_id}:user:profile:{user_id}
  (tenant prefix prevents cross-tenant leak)

TTL: 280 seconds
  (5 min SLA - ~20s for DB read + cache populate on miss)

Stampede prevention:
  High-traffic keys (top 1% of tenants): PER algorithm with beta=1.0
  Long-tail keys: jittered TTL (base=280, jitter=±30s)

Write invalidation:
  On user profile update: DEL tenant:{tenant_id}:user:profile:{user_id}
  On tenant data change: SCAN + DEL tenant:{tenant_id}:user:profile:*
  (use SCAN not KEYS to avoid blocking)

Redis config:
  maxmemory-policy: allkeys-lru
  maxmemory: 2gb  (estimate: 100k users * ~5KB avg profile * 4 replicas)
```

**Example: `/cache benchmark`**

Input: Redis INFO showing hit rate 62%, evicted_keys 50k/hr

Output: Hit rate too low for effective caching (target >80%). Recommend: (1) increase maxmemory — eviction rate suggests cache is undersized for working set; (2) audit TTL — if many keys expire before reuse, TTL may be too short; (3) analyze key distribution with `redis-cli --hotkeys` to verify Zipf distribution assumption.

## Output Format

Produces one or more of:
- Cache key schema definition
- Redis configuration recommendations (`redis.conf` snippet or Docker env vars)
- Write strategy code example (Python/TypeScript/Java)
- Invalidation strategy with trigger definition
- Cache sizing estimate with reasoning
- Metrics interpretation and tuning recommendations
