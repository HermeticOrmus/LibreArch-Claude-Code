# Scalability Patterns Plugin

Horizontal and vertical scaling, AKF Scale Cube, load balancing, auto-scaling (HPA, KEDA), stateless service design, database read/write splitting, queue-based load leveling, and capacity planning with Little's Law.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/scalability-architect/AGENT.md` | Expert in scaling strategy and capacity planning. Covers AKF Scale Cube (X/Y/Z axis), load balancing algorithms, stateless session design (Redis vs JWT), Kubernetes HPA and KEDA, database read replica routing, queue-based load leveling, and Little's Law for capacity calculation. References Abbott/Fisher 2015, Kleppmann DDIA, AWS Well-Architected, Google SRE Book. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/scale/COMMAND.md` | `/scale analyze|design|autoscale|capacity` — bottleneck identification, AKF-based scaling strategy, HPA/KEDA configuration, and capacity calculation for target traffic levels. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/scalability-patterns/SKILL.md` | Named patterns with code: Kubernetes HPA with custom metrics YAML, KEDA Kafka consumer auto-scaling, Redis session for stateless horizontal scaling (Node.js), database read/write splitting with Spring, SQS queue-based load leveling. Anti-patterns: stateful horizontal scaling, scaling app servers when DB is bottleneck, thundering herd, no scale-down cooldown. |

## When to Use

- Designing a service that must handle 10x current load
- Configuring Kubernetes HPA or KEDA for a new microservice deployment
- Identifying whether to scale application pods or database first
- Capacity planning for a product launch or flash sale event
- Moving session state out of application memory to enable horizontal scaling

## Key References

- Abbott, Martin, and Michael Fisher. _The Art of Scalability_, 2nd ed. Addison-Wesley, 2015.
- Kleppmann, Martin. _Designing Data-Intensive Applications_. O'Reilly, 2017.
- AWS Well-Architected Framework, Performance Efficiency Pillar. aws.amazon.com/architecture/well-architected.
- KEDA: keda.sh
- Kubernetes HPA: kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale
