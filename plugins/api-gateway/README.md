# API Gateway Plugin

> Patterns for designing and implementing API gateways that handle routing, rate limiting, authentication, request aggregation, and protocol translation.

## Overview

The API Gateway plugin provides expertise in the gateway pattern -- a single entry point that sits between clients and backend services. API gateways handle cross-cutting concerns (authentication, rate limiting, logging, CORS) so individual services do not have to. This plugin covers gateway design decisions, routing strategies, and the trade-offs between different gateway architectures.

## Contents

### Agents

| Agent | File | Purpose |
|-------|------|---------|
| API Gateway Architect | `agents/api-gateway-architect/AGENT.md` | Designs gateway architectures, routing strategies, and cross-cutting concern implementations. |

### Commands

| Command | File | Purpose |
|---------|------|---------|
| `/api-gateway` | `commands/api-gateway/COMMAND.md` | Analyze or design an API gateway for a given system with routing, rate limiting, and security patterns. |

### Skills

| Skill | Directory | Purpose |
|-------|-----------|---------|
| Gateway Patterns | `skills/gateway-patterns/SKILL.md` | Knowledge base of gateway patterns: BFF, aggregation, protocol translation, edge functions. |

## Usage

Use `/api-gateway` when designing a new gateway layer or evaluating whether your system needs one. The agent helps with gateway type selection (API gateway vs BFF vs service mesh ingress), routing strategy, and cross-cutting concern placement.

## Related Plugins

| Plugin | Relationship |
|--------|-------------|
| `microservices` | Gateways are commonly used with microservices architectures |
| `service-discovery` | Gateways need to discover backend services |
| `circuit-breaker` | Gateways implement resilience patterns for downstream calls |
| `caching-strategies` | Gateways often implement response caching |
| `scalability-patterns` | Gateway scaling and load distribution |

## When to Use an API Gateway

| Scenario | Recommendation |
|----------|---------------|
| Multiple clients (web, mobile, IoT) with different needs | BFF pattern per client type |
| Cross-cutting concerns (auth, rate limiting) duplicated across services | Centralized gateway |
| Simple system with 2-3 services | Probably unnecessary -- use a load balancer |
| Need protocol translation (REST to gRPC) | Gateway with protocol adapters |
