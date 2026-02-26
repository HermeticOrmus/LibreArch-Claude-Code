# /consistency

> Analyze consistency requirements, design consistency strategies, model failure scenarios, or prove consistency properties for distributed systems.

## Usage

```
/consistency analyze        - Identify what consistency guarantees a system actually needs
/consistency design         - Design consistency strategy (CRDT, quorum, saga, 2PC)
/consistency test-scenarios - Model consistency failure scenarios and their outcomes
/consistency prove          - Verify a design satisfies specified consistency properties
```

## Trigger

Use this command when:
- Choosing between eventual consistency and strong consistency for a new system
- Users are experiencing "stale read" problems or lost updates
- Designing a system with concurrent writes from multiple nodes or users
- Evaluating distributed transaction approaches (2PC vs Saga)
- Modeling what happens during a network partition
- Choosing Cassandra consistency levels for specific operations

## Input

**For `/consistency analyze`:**
- System description: what data, what operations, what users experience
- Current consistency problems or requirements

**For `/consistency design`:**
- Consistency requirement (read-your-writes / causal / sequential / linearizable)
- Technology: database with replication, multi-region, Cassandra, CRDTs
- Write pattern: single writer, multi-writer, concurrent updates to same data

**For `/consistency test-scenarios`:**
- System topology (N replicas, write/read paths)
- Failure scenario (partition between nodes, coordinator crash, slow replica)

**For `/consistency prove`:**
- System design (quorum values N/W/R, CRDT type, clock mechanism)
- Property to verify (convergence, monotonic reads, read-your-writes)

## Process

### /consistency analyze
1. Identify the minimum consistency guarantee each operation requires:
   - User-facing reads after own writes → read-your-writes
   - Collaborative editing → causal or stronger
   - Financial transactions → linearizable
   - Analytics counts → eventual
2. Map requirements to consistency models
3. Identify where the current system fails these requirements

### /consistency design
1. Select consistency model based on requirements
2. Choose implementation: quorum (Cassandra CL), synchronous replication (PostgreSQL synchronous_commit), CRDT (for convergent data), Saga (for distributed transactions)
3. Design conflict detection and resolution strategy
4. Define behavior during partition: fail-safe (reject) or available (accept and reconcile)
5. Address clock skew if using timestamp-based LWW

### /consistency test-scenarios
1. Model the scenario as a sequence of events across nodes
2. Identify which events are concurrent (no causal ordering)
3. Show the value each node would return for a read at time T
4. Identify conflicts and how they resolve
5. Show the final converged state

### /consistency prove
1. For quorum: verify R + W > N
2. For CRDT: verify operations are commutative, associative, and idempotent
3. For causal: verify vector clocks are propagated with all messages
4. For 2PC: verify coordinator failure scenarios and blocking analysis

## Examples

**Example: `/consistency analyze`**

Input: "E-commerce shopping cart. Users add/remove items. Cart is shared between web and mobile. Sometimes items appear that were already removed, or items disappear that were just added."

Output:
```
Consistency Analysis:

Required: Read-your-writes + Concurrent write resolution

Current symptoms:
- "Items appear after removal" = reading from replica before write propagates (AP system, no read-your-writes)
- "Items disappear" = concurrent write conflict resolved incorrectly (LWW with wrong winner)

Recommendation:
1. Short term: Route cart reads to primary for 5s after write (read-your-writes session token)
2. Long term: Model cart as OR-Set CRDT
   - OR-Set supports concurrent add/remove without conflict
   - Merges correctly regardless of operation order
   - No coordinator needed — each device holds its own replica

Cassandra implementation: use OR-Set CRDT column type or custom resolver
```

**Example: `/consistency test-scenarios`**

Input: "N=3, W=2, R=2. Node 2 is partitioned from nodes 1 and 3. Client A writes to node 1. Client B reads from node 2."

Output:
```
Scenario: Write during partition

Timeline:
T1: Client A writes value "X" to node 1
    Node 1 replicates to node 3 (quorum met: W=2)
    Node 2 is partitioned — does NOT receive the write
    Write succeeds (quorum W=2 = nodes 1+3)

T2: Client B reads from node 2
    Node 2 requests its replica + one other for R=2
    Node 2 + node 1 (or 3) respond
    If node 2 + node 1: node 1 has "X", node 2 has old value
    Conflict resolved by: timestamp (LWW) or read repair

T3: Partition heals
    Node 2 receives "X" via anti-entropy
    All nodes converge to "X"

Observation: During partition, node 2 may return stale value to Client B
because node 2's own copy is old but R=2 can be satisfied with node 2 + node 3.
If node 3 has the latest value, read returns "X" correctly.
If both node 2 and node 3 are partitioned from node 1, R=2 cannot be satisfied
(only node 2 responds) — read fails (consistency preserved at cost of availability).
```

## Output Format

- Consistency requirement classification table (operation → required consistency model)
- Implementation recommendation with technology-specific configuration
- Failure scenario timeline (event sequence with node states)
- Quorum proof (R + W > N verification)
- CRDT property verification (commutative/associative/idempotent proof)
- Conflict resolution strategy with code example
