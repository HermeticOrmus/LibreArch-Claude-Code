# /system-design

> Work through system design problems with structured methodology: requirements, estimation, high-level design, deep dives, and trade-off analysis.

## Usage

```
/system-design estimate   - Run back-of-envelope capacity estimation for a system
/system-design design     - Full structured design (requirements → architecture → trade-offs)
/system-design deep-dive  - Analyze a specific component: caching, database, API
/system-design review     - Critique an existing design proposal for gaps and trade-offs
```

## Trigger

Use this command when:
- Working through a system design problem for an interview or architecture review
- Need to estimate capacity (QPS, storage, bandwidth) for a new system
- Deep-diving into a specific architectural decision (database selection, caching strategy)
- Reviewing a proposed architecture for failure modes, single points of failure, or missing scale considerations

## Process

### /system-design estimate
1. Clarify assumptions: DAU, read/write ratio, object size, retention period.
2. Calculate QPS: DAU × requests_per_user_per_day ÷ 86,400.
3. Calculate storage: entities_per_day × bytes_per_entity × retention_days.
4. Calculate bandwidth: QPS × average_payload_size.
5. Calculate cache size: apply 80/20 rule — 20% of data serves 80% of reads.
6. State all assumptions explicitly.

### /system-design design
1. Requirements (clarify, don't assume):
   - Functional: core operations the system must perform
   - Non-functional: scale, latency SLA, availability, consistency model
   - Out of scope: explicitly exclude
2. Estimation: QPS, storage, bandwidth (5 minutes, rough order of magnitude)
3. High-level design: API → service components → data stores → external integrations
4. Data model: key entities, storage format, primary + secondary indexes
5. API design: 3-5 most important endpoints with request/response shapes
6. Scale: identify bottleneck → caching / sharding / async / CDN for each
7. Failure modes: what fails? What is the fallback?
8. Trade-offs: what did you trade and why?

### /system-design deep-dive
Caching:
  - What to cache (hot data, computed results)
  - Cache topology (in-process, Redis, CDN)
  - Cache invalidation strategy (TTL, event-driven, write-through)
  - Stampede prevention

Database:
  - Relational (ACID, joins) vs. NoSQL (scale, flexibility)
  - Schema design and indexes
  - Sharding key selection
  - Replication and read replicas

### /system-design review
1. Check for single points of failure (single DB, single region).
2. Check for missing caching at obvious hot paths.
3. Check for synchronous operations that should be async.
4. Check data model against stated query patterns.
5. Check for missing rate limiting, authentication, and authorization.
6. Check failure modes: what happens when component X fails?

## Examples

**Example: `/system-design design`**

Input: "Design a distributed rate limiter that works across 100 application server instances."

Output:
```
Requirements:
  Functional: limit requests per user per time window (e.g., 100 req/min)
  Non-functional: < 5ms added latency, works across all instances, handles Redis failure
  Out of scope: per-endpoint limits, multi-tier limiting

Estimation:
  10M active users, each makes 10 req/s max
  100M Redis operations/s (one INCR per request)
  Rate limiter data: 10M users × 100 bytes = 1 GB (fits in Redis)

High-level design:
  Request → API Gateway → [Rate Limit Check: Redis] → Service
  Redis Cluster: 3 nodes (1 primary + 2 replicas per shard)

Algorithm: Sliding window with Lua script (atomic, avoids TOCTOU race)
  ZADD key current_timestamp current_timestamp
  ZREMRANGEBYSCORE key -inf (now - window_ms)
  ZCARD key → compare to limit

Headers on every response:
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 87
  X-RateLimit-Reset: 1735689600

Redis failure fallback:
  Option A: Fail open (allow all requests) — risk: abuse during outage
  Option B: Fail closed (reject all) — risk: service unavailable
  Recommended: Fail open with local in-memory fallback (per-instance limiter at 2x the global limit)

Trade-offs:
  Sliding window is more accurate than fixed window but uses more Redis memory.
  Lua script is atomic but limits horizontal sharding of a single key.
  For extreme scale (>1M users/s): use local in-memory token bucket + periodic Redis sync.
```

**Example: `/system-design estimate`**

Input: "Instagram-scale photo storage. 500M DAU, each uploads 3 photos/day."

```
Writes:
  500M DAU × 3 photos/day = 1.5B photos/day
  1.5B ÷ 86,400 = ~17,360 writes/s

Reads (photos viewed):
  Read:write ratio = 50:1 (Instagram is read-heavy)
  17,360 × 50 = ~870,000 reads/s
  Serve from CDN — only cache misses hit origin

Storage:
  Photo size (compressed): 3 MB average
  1.5B photos/day × 3 MB = 4.5 PB/day
  5-year retention: 4.5 PB × 365 × 5 = 8.2 EB
  → Use tiered storage: hot tier (S3 Standard, 90 days), cold tier (S3 Glacier)

Bandwidth (CDN egress):
  870,000 reads/s × 3 MB = 2.6 TB/s
  → Requires global CDN (CloudFront, Fastly) — 90%+ cache hit rate reduces origin load to ~260 GB/s
```

## Output Format

- Requirement table (functional, non-functional, out of scope)
- Capacity estimation with explicit assumptions
- Architecture diagram (text): components, data flow arrows, external systems
- Data model: entities, storage choice, key indexes
- Scale and failure analysis per component
- Explicit trade-off statement for major decisions
