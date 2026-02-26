# /distributed

> Design distributed system components, simulate failure scenarios, debug consistency issues, or prove properties of distributed algorithms.

## Usage

```
/distributed design    - Design a distributed system component (consensus, service mesh, data replication)
/distributed simulate  - Model a failure scenario and trace outcomes through the system
/distributed debug     - Diagnose distributed system problems (split-brain, stale reads, lock contention)
/distributed prove     - Verify that a distributed algorithm satisfies safety and liveness properties
```

## Trigger

Use this command when:
- Designing leader election for a stateful service
- Implementing distributed locks (choosing Redlock vs etcd vs ZooKeeper)
- Diagnosing split-brain or stale read incidents
- Designing cluster membership and failure detection
- Implementing consistent hashing for data sharding or request routing
- Understanding the consistency/availability tradeoff in a specific design

## Process

### /distributed design
1. Identify the coordination problem: leader election, distributed lock, consensus, data replication, membership.
2. Classify required properties: safety (nothing bad ever happens) + liveness (something good eventually happens).
3. Choose algorithm: Raft for consensus/leader election, Redlock/etcd for locks, consistent hashing for data placement, SWIM for membership/failure detection.
4. Design failure handling: what happens during partition? What is the recovery protocol?
5. Identify the consistency model provided.

### /distributed simulate
1. Define the initial cluster state (N nodes, data distribution, leader).
2. Introduce the failure (partition between groups, node crash, clock drift).
3. Trace what each node does: timeouts, retries, state transitions.
4. Identify divergence points: where do nodes disagree on state?
5. Describe the recovery: how does the cluster reconverge after partition heals?

### /distributed debug
1. Identify symptoms: split-brain indicators (two leaders), stale reads (replica lag), lock failures (multiple holders).
2. Trace the causal chain: what sequence of events led to this state?
3. Identify the violated invariant: was a safety property broken (two leaders = violated leader uniqueness)?
4. Recommend fix: typically involves strengthening a consistency guarantee or adding a fencing mechanism.

### /distributed prove
1. State the safety property formally: "At most one node believes it is leader at any time."
2. Identify the invariants the algorithm maintains.
3. Show by contradiction: if two nodes were leaders simultaneously, what preconditions would need to hold? Show they cannot hold simultaneously.
4. Address the liveness property: under what conditions does the algorithm make progress?

## Examples

**Example: `/distributed design`**

Input: "Stateful payment processor — need exactly-one-leader to prevent double processing. N=3 nodes."

Output:
```
Leader Election Design:
- Algorithm: Raft (etcd client library — do not implement from scratch)
- Configuration:
  election_timeout: 150-300ms (random per node)
  heartbeat_interval: 50ms
  quorum: 2 (N/2 + 1)

Fencing for payment processing:
- etcd lease-based lock with monotonic token
- Payment processor includes token in payment record
- Payment DB rejects writes with stale token (prevents double processing from deposed leader)

Failure modes:
- Leader crash: new election within 300ms max; in-flight payments either complete or time out
- Network partition (2+1 split): majority partition continues; minority stops processing
- GC pause on leader: heartbeat timeout triggers election; fencing prevents stale leader writes

etcd code:
  session, _ := concurrency.NewSession(client, concurrency.WithTTL(10))
  mutex := concurrency.NewMutex(session, "/payment-leader")
  mutex.Lock(ctx)
  token := session.Lease()  // Monotonic fencing token
  defer mutex.Unlock(ctx)
```

**Example: `/distributed simulate`**

Input: "3-node cluster (A, B, C). Network partition: A isolated from B and C. B and C can communicate. A is current leader."

Output:
```
Timeline:

T=0ms: A is leader (term 1). Cluster normal.
T=100ms: Network partition — A cannot reach B or C. B and C cannot reach A.

T=250ms (A's heartbeat not received by B and C within timeout):
  B and C start election timeout countdown (150-300ms each).

T=300ms: B's timeout fires first. B increments to term 2, requests votes.
  B votes for self (1 vote).
  C receives RequestVote from B: C hasn't voted in term 2, B's log ≥ C's log.
  C votes for B.
  B has 2 votes = quorum (N/2+1). B becomes Leader for term 2.

T=300ms: A is still alive, still thinks it's leader (term 1).
  A tries to replicate to B and C — both reject (term 2 > term 1).
  A receives rejection with term=2. A reverts to Follower, updates term.

T=400ms: Partition heals. A rejoins with term=2, follows B.
  No split-brain: Raft's term-based leader check prevented two simultaneous leaders.

Payments processed by A between T=100ms and T=300ms:
  If A used fencing tokens: B's storage rejects A's stale token writes.
  If A did not use fencing: potential for duplicate processing during 200ms window.
```

## Output Format

- Algorithm selection with justification
- Configuration parameters with reasoning
- Failure mode analysis (what happens when X fails)
- State transition trace for simulation scenarios
- Safety property proof by contradiction
- Code example (etcd client, Redlock, consistent hash ring)
