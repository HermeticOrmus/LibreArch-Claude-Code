# Data Consistency Plugin

Designs consistency strategies for distributed systems. Covers CAP theorem (Brewer 2000), PACELC (Abadi 2012), consistency models (eventual → linearizable), CRDTs (G-Counter, OR-Set, LWW-Register), vector clocks, quorum configuration, distributed transactions (2PC, Saga), and conflict resolution strategies.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/consistency-engineer/AGENT.md` | Expert in CAP/PACELC, consistency models (linearizable to eventual), CRDTs (Shapiro 2011), vector clocks (Lamport 1978), Amazon Dynamo quorum model, 2PC blocking analysis, Cassandra consistency levels. |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/consistency/COMMAND.md` | `/consistency analyze|design|test-scenarios|prove` — requirement classification, consistency strategy design, partition failure modeling, quorum/CRDT property verification. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/consistency-patterns/SKILL.md` | Named patterns with code: G-Counter CRDT (Python), OR-Set CRDT (Python), read-your-writes session token (TypeScript), Cassandra quorum configuration, vector clock conflict detection (Java). Production anti-patterns. |

## When to Use

- Users experiencing stale reads or lost updates after concurrent writes
- Choosing consistency level for Cassandra operations
- Designing concurrent collaboration features (shared carts, co-editing)
- Evaluating distributed transaction approaches — 2PC vs Saga
- Modeling partition behavior and recovery strategies
- Proving that a quorum configuration provides the required guarantees

## Key References

- Brewer, Eric. "Towards Robust Distributed Systems." SOSP, 2000.
- Gilbert, Seth, and Nancy Lynch. "Brewer's Conjecture..." JACM 2002.
- Abadi, Daniel. PACELC. IEEE Computer, 2012.
- DeCandia, Giuseppe, et al. "Dynamo." SOSP 2007.
- Kleppmann, Martin. _Designing Data-Intensive Applications_. O'Reilly, 2017. Chapters 5, 9.
- Shapiro, Marc, et al. "CRDTs." INRIA 2011.
- Lamport, Leslie. "Time, Clocks..." CACM 1978.
