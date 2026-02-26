# API Gateway Plugin

Designs, configures, and audits API gateway layers for microservices architectures. Covers gateway topology selection (single gateway vs BFF vs service mesh ingress), rate limiting algorithm design, JWT/OAuth 2.0 validation at the edge, circuit breaking, and API versioning strategy.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/api-gateway-architect/AGENT.md` | Deep expertise in Kong, AWS API Gateway, Traefik, Envoy, Nginx/OpenResty. Token bucket/sliding window/leaky bucket algorithms. JWT validation with JWKS caching. BFF topology design. Circuit breaking at the edge. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/api-gateway/COMMAND.md` | `/api-gateway design|configure|secure|monitor` — topology design, technology-specific config generation (Kong YAML, Nginx conf, Envoy YAML), auth strategy, observability setup. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/gateway-patterns/SKILL.md` | Named patterns with code: token bucket in Redis Lua, Envoy JWT filter, Kong declarative config, BFF response shaping in TypeScript, API versioning with RFC 8594 Sunset headers. Production anti-patterns. |

## When to Use

- Choosing between API gateway, BFF, or service mesh for a new architecture
- Generating production-ready Kong, Nginx, Traefik, or Envoy configuration
- Designing rate limiting with distributed counters and Redis failure modes
- Setting up JWT validation at the edge with JWKS caching and claim forwarding
- Planning API versioning with deprecation lifecycle (Sunset headers, parallel routes)
- Debugging gateway latency, rate limit tuning, circuit breaker threshold calibration

## Related Plugins

| Plugin | Relationship |
|--------|-------------|
| `microservices` | Gateways are the entry point for microservice topologies |
| `service-discovery` | Gateways discover backends via Consul, DNS, or k8s service |
| `circuit-breaker` | Circuit breaking at the gateway protects connection pools |
| `caching-strategies` | Gateway-level response caching with cache-control headers |
| `scalability-patterns` | Gateway horizontal scaling, upstream load balancing |

## Key References

- Chris Richardson: _Microservices Patterns_, Chapter 8 (API Gateway pattern). Manning, 2018.
- Sam Newman: _Building Microservices_ 2nd ed., Chapter 14 (BFF). O'Reilly, 2021.
- Sam Newman: "Pattern: Backends For Frontends." samnewman.io, 2015.
- Kong Gateway docs: docs.konghq.com
- Envoy Proxy docs: envoyproxy.io/docs
- RFC 8594: The Sunset HTTP Header Field (deprecation signaling)
- RFC 6749: OAuth 2.0 Authorization Framework
