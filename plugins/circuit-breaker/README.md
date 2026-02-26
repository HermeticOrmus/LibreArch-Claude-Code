# Circuit Breaker Plugin

Designs and configures circuit breakers, bulkheads, retry strategies, and timeout budgets for distributed services. Prevents cascading failures through state-machine-based failure detection and fallback hierarchies.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/resilience-engineer/AGENT.md` | Expert in Resilience4j, Hystrix (reference), Polly. Circuit breaker state machine (Closed/Open/Half-Open), bulkhead isolation, exponential backoff with jitter (Brooker 2015), cascading timeout budgets, health endpoint design. References Nygard's _Release It!_. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/circuit-breaker/COMMAND.md` | `/circuit-breaker configure|test|monitor|tune` — configuration generation, chaos test design, metrics/alert setup, threshold tuning based on false positive/negative analysis. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/resilience-patterns/SKILL.md` | Named patterns with code: Resilience4j full configuration (Java), bulkhead with semaphore, full-jitter backoff (Python), cascading timeout budget, health check endpoints (TypeScript + Kubernetes YAML). Production anti-patterns with incident types. |

## When to Use

- Adding resilience to a new downstream dependency (HTTP, gRPC, database)
- Post-incident: cascading failure revealed missing circuit breakers or misconfigured timeouts
- Designing the retry strategy for a service with intermittent failures
- Diagnosing thread pool exhaustion from a slow downstream service
- Setting up Kubernetes liveness/readiness probes integrated with circuit state
- Tuning circuit breaker thresholds to eliminate false positives or slow reaction

## Key References

- Nygard, Michael. _Release It!_ 2nd ed. Pragmatic Programmers, 2018.
- Resilience4j: resilience4j.readme.io.
- Netflix Tech Blog: "Making Netflix API More Resilient." 2012.
- Brooker, Marc. "Exponential Backoff and Jitter." AWS Architecture Blog, 2015.
- Polly (.NET): github.com/App-vNext/Polly.
