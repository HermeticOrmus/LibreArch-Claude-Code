# /circuit-breaker

> Configure, test, monitor, or tune circuit breakers and resilience patterns. Produces Resilience4j/Polly configuration, timeout strategy, fallback hierarchy, and monitoring setup for service-to-service calls.

## Usage

```
/circuit-breaker configure - Generate circuit breaker + retry + bulkhead configuration
/circuit-breaker test      - Design chaos/failure injection tests for resilience validation
/circuit-breaker monitor   - Define metrics, alerts, and dashboards for circuit health
/circuit-breaker tune      - Analyze current config and recommend threshold adjustments
```

## Trigger

Use this command when:
- Adding circuit breaker protection to a new downstream dependency
- A cascading failure incident revealed missing or misconfigured resilience patterns
- Designing the retry strategy for a service with intermittent failures
- A downstream service is slow and thread pools are being exhausted
- Adding bulkhead isolation between multiple downstream dependencies
- Configuring Kubernetes liveness/readiness probes for a service

## Input

**For `/circuit-breaker configure`:**
- Technology stack (Java/Resilience4j, .NET/Polly, Python/tenacity, Node.js/cockatiel)
- Downstream service: protocol (HTTP, gRPC, database), expected p99 latency, criticality
- Error budget: what failure rate is acceptable? What is tolerable recovery time?

**For `/circuit-breaker test`:**
- Dependency to test, failure mode (timeout, error rate, complete outage)
- Testing framework (chaos engineering tool, mock server, testcontainers)

**For `/circuit-breaker tune`:**
- Current configuration (thresholds, window size, wait duration)
- Recent incident data: what triggered the circuit? Was it a true failure or false positive?
- Current metrics: error rate, p99 latency, circuit open events per day

## Process

### /circuit-breaker configure

1. Determine if dependency is **critical** (request fails if it fails) or **degradable** (partial functionality without it).
2. Set `slowCallDurationThreshold` to p99 latency * 1.5 — not the average.
3. Set `failureRateThreshold` based on the dependency's error budget. If it has a 99.9% SLA, threshold should be well above its expected error rate (50% is a common default).
4. Set `waitDurationInOpenState` to expected recovery time of the dependency. If the dependency restarts in ~30s, set open duration to 30–60s.
5. Configure `minimumNumberOfCalls` high enough to prevent opening on first-call anomalies (5–10 calls).
6. Design fallback hierarchy: cached → degraded → default → error.
7. Configure timeout budget: connection timeout, read timeout, and total call timeout.
8. Add bulkhead if there are multiple downstream dependencies that could interfere with each other.

### /circuit-breaker test

1. Simulate **latency injection**: delay responses to exceed `slowCallDurationThreshold`. Verify circuit transitions to OPEN.
2. Simulate **error injection**: return 500s at rate exceeding `failureRateThreshold`. Verify circuit opens.
3. Simulate **partial recovery**: after circuit opens, allow a subset of probe calls to succeed. Verify transition to CLOSED.
4. Verify **fallback behavior**: when circuit is OPEN, verify the fallback response is correct.
5. Verify **bulkhead isolation**: saturate one dependency's bulkhead. Verify other dependencies remain unaffected.

### /circuit-breaker monitor

1. Instrument circuit state transitions as metrics/events: `circuit_breaker_state_transition{name, from_state, to_state}`
2. Alert on: circuit open events (any circuit open for > 5 minutes is worth investigation).
3. Track: `circuit_breaker_calls_total{name, kind}` where kind = successful/failed/ignored/not_permitted.
4. Dashboard: circuit state timeline, call success rate by dependency, fallback activation rate.

### /circuit-breaker tune

1. **False positives** (circuit opens during acceptable service behavior): Increase `minimumNumberOfCalls`, widen `slidingWindowSize`, raise `failureRateThreshold`.
2. **Slow reaction** (circuit stays closed too long during real failure): Decrease `slidingWindowSize`, lower `failureRateThreshold`.
3. **Flapping** (circuit rapidly oscillates open/closed): Increase `waitDurationInOpenState`, decrease `permittedNumberOfCallsInHalfOpenState` to 1–2.
4. **Thread exhaustion despite circuit breaker**: Add bulkhead limiting concurrent calls to the slow dependency.

## Examples

**Example: `/circuit-breaker configure`**

Input: "Java service calling external payment API via REST. p99 latency = 800ms. Must not fail entire checkout if payment is unavailable — show 'pay later' option."

Output:
```java
CircuitBreakerConfig config = CircuitBreakerConfig.custom()
    .slidingWindowSize(10)
    .failureRateThreshold(50.0f)
    .slowCallRateThreshold(80.0f)
    .slowCallDurationThreshold(Duration.ofMillis(1200))  // p99 * 1.5
    .waitDurationInOpenState(Duration.ofSeconds(45))
    .permittedNumberOfCallsInHalfOpenState(2)
    .minimumNumberOfCalls(5)
    .ignoreExceptions(PaymentValidationException.class)
    .build();

// Fallback: "Pay Later" option when payment circuit is open
Supplier<PaymentResult> decorated = Decorators
    .ofSupplier(() -> paymentApi.charge(order))
    .withCircuitBreaker(breaker)
    .withFallback(
        CallNotPermittedException.class,
        ex -> PaymentResult.deferred("payment-service-unavailable")
    )
    .decorate();
```

**Example: `/circuit-breaker tune`**

Input: Circuit opens 5–10 times per day during normal operation. No corresponding service degradation observed. Current: slidingWindowSize=10, failureRateThreshold=50%, minimumNumberOfCalls=5.

Output: False positive diagnosis. With `minimumNumberOfCalls=5` and `slidingWindowSize=10`, a burst of 3 errors in 5 calls (60%) opens the circuit. Recommend: increase `minimumNumberOfCalls=10`, `slidingWindowSize=20`. This requires 10+ errors before evaluating. Also add `slowCallRateThreshold` — some "failures" may actually be slow calls treated as errors.

## Output Format

- Resilience4j/Polly configuration code block
- Timeout configuration (connection, read, call total)
- Fallback hierarchy definition
- Bulkhead configuration (if multiple dependencies)
- Prometheus metrics instrumentation
- Alert rule definitions
- Kubernetes liveness/readiness probe YAML
