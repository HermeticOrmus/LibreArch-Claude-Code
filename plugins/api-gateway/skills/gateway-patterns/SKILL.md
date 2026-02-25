# Gateway Patterns

> Knowledge base of API gateway patterns, anti-patterns, and implementation strategies for different architectural contexts.

## Knowledge Base

### Gateway Types

| Type | Description | Best For |
|------|-------------|----------|
| **API Gateway** | Single entry point for all clients | Simple service landscapes, uniform client needs |
| **Backend for Frontend (BFF)** | One gateway per client type | Multiple client types with different data needs |
| **Edge Functions** | Serverless functions at the CDN edge | Simple transformations, A/B testing, personalization |
| **Service Mesh Ingress** | Mesh-aware gateway (Istio, Linkerd) | Kubernetes environments with service mesh |
| **GraphQL Gateway** | Schema federation across services | Graph-shaped data needs, multiple data sources |

### Routing Patterns

- **Path-based routing**: `/api/v1/users -> user-service`, `/api/v1/orders -> order-service`
- **Header-based routing**: Route based on `X-API-Version`, `Accept` headers
- **Weight-based routing**: Send 90% to v1, 10% to v2 (canary deployment)
- **Content-based routing**: Route based on request body content

### Rate Limiting Algorithms

| Algorithm | Behavior | Best For |
|-----------|----------|----------|
| **Token bucket** | Allows bursts up to bucket size | APIs with variable traffic, burst tolerance |
| **Sliding window** | Smooths rate over time window | Fair distribution, no burst tolerance |
| **Leaky bucket** | Fixed output rate regardless of input | Consistent throughput requirements |
| **Fixed window** | Simple counter per time window | Simple implementations, slight burst at boundaries |

### Request Aggregation

Combine multiple backend calls into a single client response:
1. Client sends one request to gateway
2. Gateway fans out to multiple services in parallel
3. Gateway combines responses and returns to client
4. Handle partial failures (return available data with error indicators)

## Patterns

- **Edge authentication**: Validate JWT/API key at the gateway, forward user context to services via headers. Services trust the gateway for identity, enforce their own authorization.
- **Rate limiting cascade**: Global rate limit at gateway, per-service rate limit at service level. Gateway prevents floods, services protect their own resources.
- **Protocol bridging**: Gateway accepts REST from clients, communicates with backend via gRPC. Clients get familiar REST, services get efficient binary protocol.
- **Response caching**: Gateway caches responses with appropriate cache-control headers. Reduces backend load for read-heavy, cacheable endpoints.

## Anti-Patterns

- **Gateway as business logic layer**: The gateway should route and handle cross-cutting concerns, not implement business rules. Business logic in the gateway creates a coupling bottleneck.
- **Gateway team bottleneck**: If every service team needs the gateway team to deploy routing changes, the gateway becomes an organizational bottleneck. Prefer self-service routing configuration.
- **Overly fat gateway**: A gateway that does authentication, authorization, transformation, aggregation, caching, rate limiting, logging, and validation is doing too much. Distribute some concerns to sidecars or service-level middleware.
- **Single point of failure**: A single gateway instance without redundancy takes down all services. Deploy multiple instances behind a load balancer.
- **Tight coupling to backend schemas**: The gateway should not deeply understand backend response structures. Prefer transparent proxying unless aggregation is explicitly needed.

## References

- [API Gateway Pattern - microservices.io](https://microservices.io/patterns/apigateway.html)
- [Backend for Frontend - Sam Newman](https://samnewman.io/patterns/architectural/bff/)
- [Kong Gateway Documentation](https://docs.konghq.com/)
- [Envoy Proxy Documentation](https://www.envoyproxy.io/docs)
- [Building Microservices - Chapter 4: Integration](https://www.oreilly.com/library/view/building-microservices-2nd/9781492034018/)
