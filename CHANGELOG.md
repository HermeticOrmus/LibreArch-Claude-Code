# Changelog

All notable changes to LibreArch-Claude-Code will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-24

### Added

- Initial release with 20 architecture plugins covering the full software design spectrum:
  - **Structure:** clean-architecture, hexagonal-architecture, monolith-patterns
  - **Modeling:** domain-driven-design, architecture-decision-records
  - **Data:** cqrs-event-sourcing, database-patterns, data-consistency, saga-patterns
  - **Messaging:** event-driven, message-queues
  - **Distributed:** distributed-systems, microservices
  - **Integration:** api-gateway, service-discovery
  - **Resilience:** circuit-breaker
  - **Performance:** caching-strategies, scalability-patterns
  - **Evolution:** migration-strategies
  - **Design:** system-design
- Learning paths organized by difficulty:
  - Beginner: SOLID principles, design patterns, layered architecture fundamentals
  - Intermediate: DDD, hexagonal architecture, event-driven design, API design
  - Advanced: Distributed systems, consensus protocols, CAP theorem, event sourcing at scale
- 3 automated hooks for architecture workflow integration:
  - session-start.sh: Detects architecture patterns, layering, DDD markers, project structure
  - pre-tool-use.sh: Validates dependency direction, checks coupling before edits
  - post-tool-use.sh: Verifies architecture fitness functions after code changes
- Architecture-focused CLAUDE.md template for project configuration
- Project infrastructure: MIT license, contributing guidelines, code of conduct, issue templates
