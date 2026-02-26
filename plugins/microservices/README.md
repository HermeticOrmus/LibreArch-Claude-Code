# Microservices Plugin

Microservice decomposition, inter-service communication, data isolation, service mesh, distributed tracing, and the boundaries between microservices and well-structured monoliths.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/microservices-architect/AGENT.md` | Expert in service decomposition by business capability and DDD bounded context, REST vs gRPC vs async events, data isolation (no shared databases), service mesh (Istio/Linkerd mTLS), OpenTelemetry distributed tracing, health checks (liveness/readiness), and when not to use microservices. References Newman 2021, Richardson 2018, Fowler MonolithFirst 2015. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/microservices/COMMAND.md` | `/microservices decompose|communicate|audit|observe` — boundary identification from domain capabilities, sync vs async communication design, shared database and coupling auditing, and OpenTelemetry observability setup. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/microservices-patterns/SKILL.md` | Named patterns with code: Spring Boot health checks + Kubernetes probes, OpenTelemetry distributed tracing (Java), Nginx API versioning with Sunset headers, gRPC Protobuf service definition, Istio mTLS PeerAuthentication. Anti-patterns: shared database, synchronous call chains, chatty services, no observability. |

## When to Use

- Decomposing a monolith: identify correct service boundaries before writing code
- Designing a new integration between services: choose sync vs async
- Auditing an existing microservice system for shared databases or excessive coupling
- Adding distributed tracing to a service fleet with OpenTelemetry
- Evaluating whether a project warrants microservices vs a modular monolith

## Key References

- Newman, Sam. _Building Microservices_, 2nd ed. O'Reilly, 2021.
- Richardson, Chris. _Microservices Patterns_. Manning, 2018.
- Fowler, Martin. "Microservices." martinfowler.com, 2014.
- Fowler, Martin. "MonolithFirst." martinfowler.com, 2015.
- OpenTelemetry: opentelemetry.io
