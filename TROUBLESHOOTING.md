# Troubleshooting

```bash
ls ~/.claude/plugins/ | grep -c '^libre-arch-'  # should print 20
```

Common scenarios:
- DDD bounded context identification → `/ddd`
- Microservice boundary decisions → `/microservices` (v0.3)
- Event-sourcing design → `/event-driven` + `/cqrs-event-sourcing` (v0.5)
- Saga design → `/saga-patterns` (v0.4)
- Legacy modernization → `/migration-strategies` (v0.5)
