# Service Discovery Plugin

Service registry patterns, DNS-based discovery, Kubernetes Services, Consul registration, health check design, and debugging DNS resolution failures in microservice deployments.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/discovery-engineer/AGENT.md` | Expert in service discovery patterns. Covers client-side (Eureka, Ribbon) vs server-side discovery (Kubernetes Services, ALB), DNS-based discovery (CoreDNS, Consul DNS), Consul service registration with health checks, Kubernetes headless services for StatefulSets, readiness vs liveness health check design, and self-registration vs third-party registration. References Newman 2021, HashiCorp Consul docs, Kubernetes docs. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/service-discovery/COMMAND.md` | `/service-discovery design|health|debug|configure` — discovery pattern selection, health check design for liveness/readiness separation, DNS resolution debugging, and Kubernetes Service YAML generation. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/discovery-patterns/SKILL.md` | Named patterns with code: Kubernetes Service with readiness-gated traffic, headless service for Kafka/StatefulSets, Consul service registration (Go), Kubernetes LoadBalancer for external traffic, Spring Boot composite readiness indicator. Anti-patterns: hardcoded IPs, remote service checks in liveness probe, missing startup probe, stale Eureka entries. |

## When to Use

- Setting up DNS-based service discovery between new microservices on Kubernetes
- Designing health check endpoints that correctly separate liveness from readiness
- Debugging connection refused errors that may be DNS resolution or readiness failures
- Exposing a service externally via cloud load balancer
- Setting up Consul for bare-metal or hybrid cloud service registration

## Key References

- Newman, Sam. _Building Microservices_, 2nd ed. O'Reilly, 2021. Chapter 9.
- Kubernetes Services and DNS: kubernetes.io/docs/concepts/services-networking
- Consul documentation: developer.hashicorp.com/consul/docs
- Spring Boot Actuator health: docs.spring.io/spring-boot/docs/current/actuator-api
