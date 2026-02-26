# Caching Strategies Plugin

Designs, audits, and debugs caching layers for distributed systems. Covers Redis/Memcached/CDN topology selection, cache-aside/write-through/write-behind strategies, cache stampede prevention (PER algorithm), cache invalidation, Redis data structure selection, and CDN cache-control headers.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/caching-architect/AGENT.md` | Expert in Redis (data structures, Cluster, Sentinel), Memcached, CDN (Fastly, CloudFront, Cloudflare), Caffeine in-process cache. PER algorithm, write strategies, stampede prevention, connection pooling. References Fowler, Facebook Memcached paper, Vattani PER paper. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/cache/COMMAND.md` | `/cache analyze|design|invalidate|benchmark` — access pattern analysis, cache topology and key schema design, invalidation strategy, Redis metrics interpretation. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/caching-patterns/SKILL.md` | Named patterns with code: cache-aside (TypeScript), write-through (Java), write-behind counters (Python), PER stampede prevention (Python), Redis sorted set rate limiting, cache warming scripts. Production anti-patterns. |

## When to Use

- Diagnosing database overload that caching might reduce
- Designing cache key schema for multi-tenant systems (prevents data leakage)
- Choosing between in-process LRU and shared Redis cache
- Preventing cache stampede on high-traffic expiring keys
- Designing CDN caching strategy with proper cache-control headers and tag invalidation
- Interpreting Redis `INFO stats` and diagnosing low hit rates or high eviction

## Key References

- Fowler, Martin. _Patterns of Enterprise Application Architecture_. Addison-Wesley, 2002.
- Nishtala, Rajesh, et al. "Scaling Memcache at Facebook." NSDI 2013.
- Vattani, Andrea, et al. "Optimal Probabilistic Cache Stampede Prevention." VLDB 2015.
- Redis documentation: redis.io/docs.
- Ben-Manes, Ben. Caffeine: github.com/ben-manes/caffeine.
- RFC 7234: HTTP/1.1 Caching.
