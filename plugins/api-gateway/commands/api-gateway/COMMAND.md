# /api-gateway

> Design, configure, secure, or monitor an API gateway layer. Produces routing tables, Kong/Nginx/Envoy config snippets, rate limiting strategy, JWT validation setup, and circuit breaker tuning.

## Usage

```
/api-gateway design    - Design a gateway topology from system description
/api-gateway configure - Generate gateway config (Kong, Nginx, Traefik, Envoy)
/api-gateway secure    - Design auth strategy (JWT, API keys, mTLS, OAuth scopes)
/api-gateway monitor   - Define observability: metrics, alerts, access log fields
```

## Trigger

Use this command when:
- Designing an API gateway for a new or evolving microservices architecture
- Choosing between single gateway, BFF topology, or service mesh ingress
- Generating concrete Kong/Nginx/Traefik/Envoy configuration
- Designing a rate limiting strategy (algorithm selection, Redis config, tier definitions)
- Configuring JWT validation at the edge with JWKS caching
- Setting circuit breaker thresholds for gateway-to-service connections
- Planning API versioning with deprecation headers

## Input

**Required:**
- System description: what services exist, what clients consume them

**Optional per subcommand:**
- `design`: client types, traffic estimates (req/s, burst ratio), cloud provider
- `configure`: target technology (Kong, Nginx, Traefik, Envoy, AWS API GW)
- `secure`: auth method (JWT/OAuth, API key, mTLS), IdP (Auth0, Keycloak, Cognito)
- `monitor`: metrics stack (Prometheus, Datadog, CloudWatch), log format (JSON, combined)

## Process

### design
1. Identify client types and their API consumption patterns
2. Determine if clients need different response shapes → BFF vs single gateway decision
3. Map all service endpoints to gateway routes
4. Identify cross-cutting concerns: auth, rate limiting, CORS, tracing headers
5. Select gateway technology against constraints (cloud provider, team familiarity, plugin needs)
6. Design failure handling: per-backend timeout, circuit breaker, fallback response
7. Produce routing table and topology diagram

### configure
1. Confirm target technology
2. Generate route definitions with path patterns, methods, upstream service
3. Attach middleware/plugins: JWT authn, rate limiting, request ID injection, logging
4. Generate upstream/cluster health check config
5. Provide deployment command (`deck sync`, `kubectl apply`, `nginx -s reload`)

### secure
1. Identify authentication method and IdP
2. Generate JWT validation config (JWKS URI, claim validation, forwarded headers)
3. Design API key storage and rotation strategy
4. Define scope-based coarse routing rules
5. Specify what the gateway forwards to backends (never forward raw JWT by default)

### monitor
1. Define access log fields (request ID, client ID, route, upstream latency, status, bytes)
2. Specify key metrics: gateway p99 latency, upstream error rate, rate limit rejection rate, circuit open events
3. Define alert thresholds: upstream error rate > 5% for 2m, gateway p99 > 2s, circuit open
4. Produce Prometheus scrape config or log parsing rules

## Examples

**Example 1 — design:**
Input: "5 microservices (users, orders, products, payments, notifications), serving a React web app and an iOS app. Mobile needs compact payloads."

Output: BFF topology with two gateways. Web BFF (Node.js/Express) with full response shapes. Mobile BFF (Go/Gin) with compact responses. Both share an upstream services pool. JWT validated at both. Separate rate limit tiers. Kong declarative config for both.

**Example 2 — configure (Kong):**
```yaml
_format_version: "3.0"
services:
  - name: order-service
    url: http://orders.internal:8080
    connect_timeout: 3000
    write_timeout: 10000
    read_timeout: 10000

routes:
  - name: orders-v2
    service: order-service
    paths: ["/v2/orders"]
    methods: [GET, POST, PATCH]
    strip_path: false

plugins:
  - name: jwt
    route: orders-v2
    config:
      claims_to_verify: [exp, nbf]
      key_claim_name: kid
  - name: rate-limiting-advanced
    route: orders-v2
    config:
      limit: [1000]
      window_size: [60]
      window_type: sliding
      identifier: consumer
      strategy: redis
      redis: {host: redis.internal, port: 6379}
```

**Example 3 — secure:**
Input: "JWT from Auth0, need scopes per endpoint"

Output: Envoy JWT filter config with Auth0 JWKS URI, scope validation per route prefix, X-User-Id and X-User-Scopes headers forwarded to backends. mTLS between gateway and backends using internal CA.

**Example 4 — monitor:**
Output: Prometheus alert rules for gateway error rate and latency, nginx access log JSON format with all required fields, Grafana dashboard panel definitions for upstream latency by service.

## Output Format

Produces one or more of:
- Topology diagram (ASCII)
- Routing table (markdown table)
- Gateway config file (Kong YAML / Nginx conf / Envoy YAML / Traefik YAML)
- Rate limiting design document
- Alert rule definitions (PromQL or CloudWatch)
