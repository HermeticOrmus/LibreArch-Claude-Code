# Intermediate — microservices + events + sagas

## When to go microservices

Signals you should:
- Multiple teams need to ship independently
- Different parts have wildly different scale requirements
- Different parts need different tech stacks
- Bounded contexts are large + stable

Signals you shouldn't:
- Team < 20 engineers
- Domain is still being discovered
- No DevOps maturity
- "We heard microservices is the right answer"

## Event-driven patterns

- **Event-carried state transfer**: events carry full state changes; consumers project their own views
- **Event notification**: events trigger consumer queries back to producer
- **Event sourcing**: events ARE the state (CQRS often pairs with this)
- **Outbox pattern**: write event to DB transactionally, ship to broker asynchronously; avoids the dual-write problem

## Sagas

For cross-aggregate transactions:
- **Choreography**: each service reacts to events; no central coordinator
- **Orchestration**: central orchestrator drives the saga forward
- **Compensation**: on failure, run compensating actions to undo

Most real sagas are orchestration. Pure choreography hides flow.

## Next: [Advanced](advanced.md)
