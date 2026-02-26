# /scale

> Design scaling strategies, configure auto-scaling policies, identify bottlenecks, and capacity-plan for traffic growth.

## Usage

```
/scale analyze       - Identify the current scaling bottleneck (CPU, DB, I/O, state)
/scale design        - Design horizontal, vertical, or data partitioning strategy
/scale autoscale     - Configure HPA, KEDA, or Lambda auto-scaling policies
/scale capacity      - Capacity plan for a target traffic level using Little's Law
```

## Trigger

Use this command when:
- A service is struggling under load and you need to identify where to scale
- Designing a service that must handle 10x current traffic within 6 months
- Configuring Kubernetes HPA or KEDA for a new service
- Capacity planning for an anticipated traffic event (product launch, flash sale)
- Identifying whether the bottleneck is application servers or the database

## Process

### /scale analyze
1. Check CPU utilization per service pod — if CPU > 80% consistently, application is bottleneck.
2. Check database connection pool saturation — if all connections used, DB is bottleneck.
3. Check cache hit rate — if hit rate < 80%, cache is not absorbing reads effectively.
4. Check queue depth — if queues are growing, consumers are bottleneck.
5. Check p99 latency per service — the service with the highest p99 is the bottleneck.
6. Profile at the code level for CPU-bound bottlenecks (async profiler, py-spy).

### /scale design
1. Apply AKF Scale Cube to identify which axis addresses the bottleneck:
   - X-axis: add more identical pods (stateless services only)
   - Y-axis: split by function (extract high-traffic feature to dedicated service)
   - Z-axis: shard by data key (partition database by customerId, geography)
2. For database bottleneck: add read replicas before application pods.
3. For stateful services: identify what state can be moved to a shared store (Redis).
4. Design for statelessness: session in Redis/JWT, no local filesystem state.

### /scale autoscale
1. Define scaling metric: CPU utilization (compute-bound), RPS (request-rate-bound), queue lag (consumer).
2. Set target utilization: 70% CPU target leaves headroom for scale-up reaction time.
3. Set min replicas: never scale to zero for user-facing services (cold start latency).
4. Set max replicas: based on database connection pool limit and downstream service capacity.
5. Configure scale-up aggressively, scale-down conservatively (cooldown window 5 min).
6. Test: generate artificial load and verify pods scale up within 60s, down within 5 min.

### /scale capacity
1. Measure current: requests/sec, p99 latency, CPU per pod, current pod count.
2. Apply Little's Law: L = λ × W (L = concurrent requests, λ = arrival rate, W = avg response time).
3. Project target traffic: multiply by expected growth factor.
4. Calculate required pods: `pods = (target_rps × p99_latency_s) / (pods_cpu_cores × utilization_target)`.
5. Calculate database capacity: `connections = pods × connection_pool_size_per_pod`.
6. Identify infrastructure limits: max connections per RDS instance, max Lambda concurrency, max HPA replicas.

## Examples

**Example: `/scale capacity`**

Input: "Order service currently handles 500 req/s with p99 = 100ms on 5 pods. Flash sale expected to drive 5,000 req/s peak."

Capacity calculation:
```
Current:
  λ = 500 req/s
  W = 100ms = 0.1s
  L = 500 × 0.1 = 50 concurrent requests
  Pods = 5 → 10 concurrent requests per pod

Target:
  λ = 5,000 req/s (10x)
  W = 100ms (assume same latency with adequate capacity)
  L = 5,000 × 0.1 = 500 concurrent requests
  Required pods = 500 / 10 = 50 pods

Database connections:
  Each pod: HikariCP pool size = 10
  50 pods × 10 = 500 connections required
  RDS db.r6g.xlarge: max_connections = 300 → insufficient
  Option A: RDS db.r6g.2xlarge (max_connections ≈ 600)
  Option B: Add PgBouncer connection pooling (10 pods × 10 → PgBouncer → 50 DB connections)

Pre-scaling:
  Set HPA minReplicas = 15 (pre-warm 30 min before flash sale)
  Set HPA maxReplicas = 60 (20% headroom above calculated 50)
```

**Example: `/scale autoscale`**

Input: "Inventory consumer reads from Kafka orders.placed topic (12 partitions). Scale based on lag."

KEDA configuration:
```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
spec:
  minReplicaCount: 1    # Keep at least 1 for low but steady traffic
  maxReplicaCount: 12   # Cannot exceed partition count
  triggers:
    - type: kafka
      metadata:
        lagThreshold: "50"  # 1 pod per 50 messages of lag
        # At 12 partitions × 50 = 600 messages lag: 12 pods running
```

## Output Format

- Bottleneck identification with metric evidence
- AKF Scale Cube axis recommendation
- HPA or KEDA YAML configuration
- Capacity calculation with Little's Law workings
- Database connection budget at target scale
- Pre-scaling recommendation for anticipated traffic events
