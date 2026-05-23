# Beginner — architecture mindset

## Mindset shifts

1. **Architecture is decision-making.** It's not "the diagram"; it's the decisions encoded in the diagram.
2. **The most important property: ability to change.** Optimize for evolvability, not for current optimum.
3. **Conway's Law is real.** Software structure mirrors team structure. Plan for it.
4. **Distributed systems are hard.** Network partitions, partial failures, eventual consistency — assume them, don't hope around them.
5. **Boring is good.** Choose proven tech for the core; novel tech for differentiation only.

## Your first architecture exercise

Use `/ddd` on a system you understand. Identify bounded contexts. The result is decisions about what's separate from what.

## Read

- *Domain-Driven Design* (Eric Evans) — the classic
- *Implementing Domain-Driven Design* (Vaughn Vernon) — practical follow-on
- *Building Evolutionary Architectures* (Ford, Parsons, Kua) — modern angle
- *Designing Data-Intensive Applications* (Martin Kleppmann) — distributed systems primer
