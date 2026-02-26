# Distributed Systems Plugin

Designs and analyzes distributed system algorithms. Covers Raft consensus (Ongaro/Ousterhout 2014), Paxos comparison, distributed locks (Redlock + fencing tokens), gossip/SWIM failure detection, consistent hashing with virtual nodes, CAP/PACELC theorem, and partition handling strategies.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/distributed-systems-architect/AGENT.md` | Expert in Raft leader election, Paxos, Redlock (and its critiques), SWIM gossip protocol, consistent hashing with virtual nodes, CAP/PACELC, fencing tokens, partition handling. References Ongaro/Ousterhout (2014), Lamport, Kleppmann, Kingsbury (Jepsen). |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/distributed/COMMAND.md` | `/distributed design|simulate|debug|prove` — component design with algorithm selection, partition failure simulation with traced outcomes, split-brain debugging, safety/liveness property verification. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/distributed-patterns/SKILL.md` | Named patterns with code: consistent hash ring (Python), Raft leader election state machine (Go), Redlock implementation (Python), fencing token storage (Java), SWIM failure detection protocol description. Anti-patterns with analysis. |

## When to Use

- Implementing leader election for a stateful service
- Choosing between Redlock, etcd, and ZooKeeper for distributed locks
- Debugging split-brain or two-leader incidents
- Designing cluster membership and failure detection (replacing heartbeat-to-coordinator)
- Implementing consistent hashing for database sharding or request routing
- Understanding what consistency guarantees a consensus algorithm actually provides

## Key References

- Ongaro, Diego, and John Ousterhout. "In Search of an Understandable Consensus Algorithm." USENIX ATC 2014.
- Lamport, Leslie. "Paxos Made Simple." ACM SIGACT News 2001.
- Kleppmann, Martin. _Designing Data-Intensive Applications_. O'Reilly, 2017. Chapters 8–9.
- Kleppmann, Martin. "How to do distributed locking." martin.kleppmann.com, 2016.
- Das, Abhinandan, et al. "SWIM Protocol." DSN 2002.
- Kingsbury, Kyle. Jepsen analyses: jepsen.io.
