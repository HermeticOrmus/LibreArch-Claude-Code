# /saga

> Design orchestrated and choreography sagas, define compensating transactions, identify isolation anomalies, and debug stuck sagas.

## Usage

```
/saga design          - Choose orchestration vs choreography and design the saga steps
/saga compensate      - Define compensating transactions for each saga step
/saga debug           - Diagnose a stuck or partially-compensated saga
/saga isolation       - Identify and apply countermeasures for saga isolation anomalies
```

## Trigger

Use this command when:
- A business process spans multiple services and requires all-or-nothing semantics
- Replacing a distributed transaction (2PC) with a saga pattern
- Designing compensating transactions for a partially-implemented saga
- Debugging a saga stuck in a compensating state or with inconsistent data
- Identifying dirty read or lost update anomalies in an existing saga

## Process

### /saga design
1. List all saga steps as local transactions: each step is one database write in one service.
2. For each step, identify: the service, the command, the success event, the failure event.
3. Choose orchestration (Temporal, Conductor) or choreography (event-driven):
   - Orchestration: more than 3 steps, compensation required, need process visibility
   - Choreography: 1-2 steps, no compensation, services are truly independent
4. Design the success path: Step 1 → Step 2 → ... → Final Step.
5. Design the failure paths: for each possible failure point, list which prior steps need compensation.
6. Document compensation transactions (step 6 below).

### /saga compensate
1. For each step that modifies external state, define its compensating transaction.
2. Verify each compensation is idempotent: calling it twice produces the same result as calling it once.
3. Verify each compensation accounts for the case where the forward step partially completed.
4. Define the compensation ordering: reverse order of the forward steps.
5. Ensure compensations themselves have retry logic with DLQ for permanent failures.

### /saga debug
1. Identify the saga's current state: which step completed, which failed?
2. Check the orchestrator's state (Temporal UI, database saga_state table) for the stuck workflow.
3. Check compensation step logs: did the compensation execute? Did it succeed?
4. Identify the blocking resource: is a service down? Is a database lock held?
5. Options: manually trigger compensation via admin API, terminate the stuck saga and compensate manually, or wait for the blocking resource to recover.

### /saga isolation
1. Identify concurrent sagas that operate on the same data.
2. Check for dirty reads: can Saga B see Saga A's intermediate state?
3. Check for lost updates: can two sagas overwrite each other's changes?
4. Apply countermeasures:
   - Semantic lock: set status flag to indicate saga in progress (PENDING_PAYMENT, RESERVING)
   - Pessimistic lock: acquire database lock for the duration of a step (use sparingly)
   - Optimistic lock: version field + retry on conflict
   - Commutativity: design operations to be commutative so order doesn't matter

## Examples

**Example: `/saga design`**

Input: "Order fulfillment: charge customer's card, reserve inventory, schedule shipping. If any step fails, undo all previous steps."

Output:
```
Saga: OrderFulfillment (Orchestrated — 3 steps with full compensation required)
Orchestrator: Temporal workflow

Step 1: AuthorizePayment
  Service: PaymentService
  Command: AuthorizePaymentCmd(orderId, customerId, amount)
  Success: Returns authorizationId
  Failure: PaymentDeclinedException, PaymentGatewayException
  Compensation: VoidAuthorization(authorizationId)

Step 2: ReserveInventory
  Service: InventoryService
  Command: ReserveStockCmd(orderId, items)
  Success: Returns reservationId
  Failure: OutOfStockException
  Compensation: ReleaseReservation(reservationId)

Step 3: ScheduleShipment
  Service: ShippingService
  Command: ScheduleShipmentCmd(orderId, address)
  Success: Returns shipmentId
  Failure: NoCarrierAvailableException
  Compensation: CancelShipment(shipmentId)

Failure compensation matrix:
  Step 1 fails: No compensation needed (nothing succeeded)
  Step 2 fails: Compensate Step 1 (void payment auth)
  Step 3 fails: Compensate Step 2 (release inventory) + Compensate Step 1 (void auth)
```

**Example: `/saga isolation`**

Scenario: "Two sagas can both try to reserve the same inventory item simultaneously."

Countermeasure: Semantic Lock + Optimistic Concurrency
```java
// When reserving: set reservation_status = 'RESERVING' (semantic lock)
// Use optimistic locking (version column) to prevent concurrent reservations

@Version
private int version;  // JPA optimistic lock

public void beginReservation(String sagaId) {
    if (this.reservationStatus != null && !this.reservationStatus.equals("AVAILABLE")) {
        throw new InventoryLockedException("Item already being reserved by saga " + this.lockingSagaId);
    }
    this.reservationStatus = "RESERVING";
    this.lockingSagaId = sagaId;
    // JPA will increment version — concurrent saga will get OptimisticLockException and retry
}
```

## Output Format

- Saga step table: step number, service, command, success outcome, failure, compensation
- Compensation matrix: which compensations run for each failure point
- Temporal workflow skeleton or Kafka choreography event flow diagram
- Isolation anomaly list with countermeasure per anomaly
- Debug checklist with orchestrator state check and manual recovery procedure
