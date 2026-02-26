# /monolith

> Design modular monolith structure, enforce module boundaries, assess decomposition readiness, and organize code by vertical slices.

## Usage

```
/monolith design        - Design module structure using DDD bounded contexts
/monolith enforce       - Add ArchUnit boundary enforcement for existing module structure
/monolith assess        - Evaluate decomposition readiness of a modular monolith
/monolith slice         - Reorganize a horizontal layer structure into vertical slices
```

## Trigger

Use this command when:
- Starting a new application and deciding between monolith and microservices
- Refactoring a big ball of mud monolith into modules with enforced boundaries
- Evaluating whether the current monolith is ready to extract its first service
- Converting a horizontal layers structure (controllers/services/repos) into vertical slices
- Adding ArchUnit tests to enforce existing module contracts in CI

## Process

### /monolith design
1. Map domain to business capabilities or DDD bounded contexts.
2. Define each module's public API: commands, queries, events (not domain objects).
3. Identify shared kernel: primitive value objects needed by all modules (Money, Address, UserId).
4. Design module communication: direct facade calls for sync; in-process events for async.
5. Define data ownership: each module owns specific tables; no cross-module direct table access.
6. Write ArchUnit tests enforcing the boundary before writing implementation.

### /monolith enforce
1. Identify current package structure and map packages to modules.
2. Define the allowed dependency graph: which module may depend on which.
3. Generate ArchUnit test class with rules for each inter-module boundary.
4. Run ArchUnit in CI (add to build.gradle / pom.xml test suite).
5. Fix violations by moving code or creating proper API interfaces.

### /monolith assess
1. Check module API purity: do modules expose DTOs (not domain objects) at their boundary?
2. Check data isolation: can each module's data be separated into its own schema without joins in business logic?
3. Check communication mode: are inter-module calls through well-defined facades and events?
4. Check deployment unit: are there reasons a specific module needs independent deployment?
5. Check team boundaries: do team structures align with modules? (Conway's Law)
6. Output: readiness score per module and recommended extraction sequence if needed.

### /monolith slice
1. Identify current horizontal layer packages (controllers, services, repositories).
2. Group all classes related to one feature/domain concept together.
3. Create a module package for each domain concept with api/domain/infrastructure sub-packages.
4. Move classes into the new structure. Verify all tests pass.
5. Add ArchUnit enforcement for the new boundaries.
6. Delete the old horizontal layer packages.

## Examples

**Example: `/monolith design`**

Input: "Building an HR platform for a 6-person engineering team. Features: employee management, time tracking, payroll, leave management."

Output:
```
Modules (by business capability):

employees/
  api/
    EmployeeFacade.java       → findById(EmployeeId), listAll(), hire(HireCommand)
    EmployeeDto.java
    HireCommand.java
    EmployeeHiredEvent.java
  domain/
    Employee.java, EmployeeId.java, Department.java
  infrastructure/
    JpaEmployeeRepository.java

time-tracking/
  api/
    TimeTrackingFacade.java   → recordEntry(RecordTimeCommand), getEntries(EmployeeId, DateRange)
    TimeEntryDto.java
  domain/
    TimeEntry.java, TimeSheet.java
  infrastructure/
    JpaTimeEntryRepository.java

payroll/
  api/
    PayrollFacade.java        → runPayroll(Month), getPayslip(EmployeeId, Month)
  domain/
    PayrollRun.java, Payslip.java, Salary.java
  infrastructure/
    JpaPayrollRepository.java
  listens-to: EmployeeHiredEvent (to create initial salary record)

leave/
  api/
    LeaveFacade.java          → requestLeave(LeaveCommand), approve(ApproveCommand)
  domain/
    LeaveRequest.java, LeaveBalance.java
  listens-to: EmployeeHiredEvent (to initialize leave balance)

shared/
  Money.java, EmployeeId.java (shared value objects)

Database: single PostgreSQL database, separate schemas per module
  Schema: employees, time_tracking, payroll, leave
  No cross-schema JOINs in business logic — use events for data sync
```

**Example: `/monolith assess`**

Decomposition readiness assessment:
```
Module: orders         READY ✓
  - Clean facade API (3 methods)
  - Own schema (orders, order_items tables)
  - Communicates via OrderPlacedEvent in-process event
  - Has module-scoped integration tests

Module: notifications  NOT READY ✗
  - Directly queries orders table via JOIN
  - No facade — other modules call NotificationService directly
  - No module-scoped tests
  Fix: migrate cross-module JOIN to event-driven, add facade

Recommendation: extract orders module first (highest readiness, isolated data).
```

## Output Format

- Module list with public API surface, data ownership, and communication paths
- ArchUnit test class for the designed boundary rules
- Dependency graph (text): module A → module B (allowed) or module A ✗→ module B (blocked)
- Decomposition readiness scorecard per module
- Vertical slice reorganization plan with file move list
