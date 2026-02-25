# /api-gateway

> Design or analyze an API gateway architecture for a system, including routing, security, rate limiting, and cross-cutting concern placement.

## Trigger

Use this command when:
- Designing a new API gateway for a microservices architecture
- Evaluating whether your system needs a gateway
- Refactoring gateway routing or cross-cutting concerns
- Adding a Backend for Frontend (BFF) pattern
- Migrating from a monolith to services and need an API layer

## Input

Required:
- **System description**: What services exist, what clients consume them, current architecture

Optional:
- **Client types**: Web, mobile, third-party, IoT -- different clients may need different gateways
- **Traffic patterns**: Expected request volume, burst patterns, geographic distribution
- **Security requirements**: Authentication method, authorization model, API key management
- **Technology constraints**: Preferred gateway technology, cloud provider, existing infrastructure

## Process

### Step 1: Client Analysis
1. Identify all client types and their API consumption patterns
2. Determine if different clients need different API shapes (BFF candidates)
3. Map protocol requirements (REST, GraphQL, WebSocket, gRPC)

### Step 2: Gateway Architecture Selection
1. Evaluate: single gateway vs BFF vs no gateway
2. Consider team ownership: who owns the gateway, who owns the routes
3. Assess build vs buy decision for gateway technology

### Step 3: Routing Design
1. Map all routes to backend services
2. Define versioning strategy
3. Design path conventions

### Step 4: Cross-Cutting Concerns
1. Define authentication flow at the gateway
2. Design rate limiting strategy per client and per endpoint
3. Plan request/response logging and tracing
4. Configure CORS, compression, caching headers

### Step 5: Resilience & Operations
1. Configure timeouts and circuit breakers for each backend
2. Define fallback behavior for service failures
3. Plan gateway scaling and deployment strategy
4. Design health checks and monitoring

## Output

A complete gateway design document with routing table, security configuration, rate limiting strategy, failure handling, and deployment plan.

## Examples

**Input:** "We have 5 microservices (users, orders, products, payments, notifications) serving a web app and a mobile app. The mobile app needs different response shapes."

**Output:** BFF architecture with two gateways, detailed routing tables, JWT validation at the edge, per-client rate limits, and circuit breaker configuration for each backend service.
