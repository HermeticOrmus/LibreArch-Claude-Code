# System Design Plugin

Structured system design methodology: requirements clarification, back-of-envelope capacity estimation, component selection, trade-off analysis, and deep dives into caching, database, and API design.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/system-designer/AGENT.md` | Expert in holistic system design. Covers the 5-step design process (requirements, estimation, high-level, deep dive, trade-offs), back-of-envelope estimation with latency/throughput reference numbers, data store selection criteria, common system design patterns (URL shortener, rate limiter, news feed, distributed cache, autocomplete), SLA and availability math. References Kleppmann DDIA 2017, Xu System Design Interview 2020/2022. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/system-design/COMMAND.md` | `/system-design estimate|design|deep-dive|review` — capacity estimation with explicit assumptions, full structured design from requirements through trade-offs, component deep-dive (caching/database/API), and architecture review for gaps and failure modes. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/system-design-patterns/SKILL.md` | Named patterns with calculations and code: back-of-envelope estimation template, URL shortener with base62 encoding (Python), sliding window rate limiter (Redis Lua), news feed hybrid fan-out (Python), prefix autocomplete with Redis Sorted Sets (Python). Anti-patterns: single DB at scale, synchronous fan-out, wrong read/write ratio optimization, missing failure modes. |

## When to Use

- Preparing for or conducting a system design interview
- Capacity planning for a new system before starting implementation
- Architecture review: checking a proposed design for single points of failure or missing scale considerations
- Deep-diving into a specific design decision (which database, which caching strategy, how to handle fan-out)
- Estimating infrastructure costs or capacity requirements for a product launch

## Key References

- Kleppmann, Martin. _Designing Data-Intensive Applications_. O'Reilly, 2017.
- Xu, Alex. _System Design Interview — An Insider's Guide_, vols 1-2. ByteByteGo, 2020, 2022.
- Nygard, Michael T. _Release It!_, 2nd ed. Pragmatic Programmers, 2018.
- AWS Architecture Center: aws.amazon.com/architecture
- ByteByteGo blog: blog.bytebytego.com
