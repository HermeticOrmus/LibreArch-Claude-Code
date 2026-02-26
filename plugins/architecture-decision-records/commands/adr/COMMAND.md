# /adr

> Create, list, supersede, or export Architecture Decision Records. Produces complete ADRs in Nygard or MADR format with Y-Statement summaries, fitness function suggestions, and code reference locations.

## Usage

```
/adr new       - Write a new ADR from a description of the decision
/adr list      - Audit existing ADRs for staleness and coverage gaps
/adr supersede - Update an old ADR and produce its replacement
/adr export    - Generate an ADR index or summary document
```

## Trigger

Use this command when:
- A significant architectural decision is being made (database, messaging, architecture style, auth pattern, API contract)
- An existing architectural decision is being reversed or updated
- Onboarding a new team member who needs to understand past decisions
- Conducting an architecture review and needing a decision inventory
- A fitness function is needed to enforce a structural constraint from an ADR

## Input

**For `/adr new`:**
- The decision being made (what is changing or being chosen)
- The problem context (what situation motivated this decision)
- Alternatives considered (at least 2, including status quo)
- The chosen option and primary reason
- What is accepted as a trade-off (the "accepting" clause)

**For `/adr supersede`:**
- The ADR number being superseded
- The new decision and what changed in the context

**For `/adr list`:**
- Path to `docs/decisions/` directory (or provide file listing)

**For `/adr export`:**
- Format: index (table with status), summary (Y-Statements only), full (all ADRs concatenated)

## Process

### /adr new

1. Write Y-Statement first. If "accepting" clause is unclear, clarify the trade-off before proceeding.
2. Determine format: Nygard (quick/internal), MADR (multi-option comparison), RFC (cross-team/API-contract).
3. Assign next sequential ADR number from existing directory listing.
4. Write full ADR with all required sections.
5. Assess reversibility (Easy / Medium / Hard / Practically irreversible).
6. Suggest inline code comment locations.
7. If decision describes a structural constraint, propose ArchUnit fitness function.

### /adr supersede

1. Produce updated status section for the old ADR: `Status: Superseded by ADR-{N} — {date}`.
2. Write the new ADR with `Supersedes: ADR-{old}` in Links section.
3. State what changed in the context that made the old decision no longer appropriate.

### /adr list

1. Parse all ADR files in the decisions directory.
2. Report: total count, status distribution (Proposed/Accepted/Rejected/Superseded/Deprecated).
3. Flag: Accepted ADRs older than 2 years with no review date.
4. Flag: Proposed ADRs older than 30 days (stale drafts).
5. Identify coverage gaps: are there major infrastructure components with no ADR?

### /adr export

1. Index: markdown table of all ADRs — Number, Title, Status, Date, Decision drivers (1-line).
2. Summary: one Y-Statement per ADR — useful for architecture onboarding.

## Examples

**Example: `/adr new`**

Input: "We are choosing between PostgreSQL and MongoDB for storing order data. We need ACID transactions. MongoDB was proposed to avoid schema migrations."

Output:
```markdown
# Y-Statement
In the context of an order management system requiring multi-table ACID
transactions, facing a proposal to use MongoDB to reduce schema migration
overhead, we decided to use PostgreSQL with Flyway migrations, to achieve
ACID transaction guarantees across orders and line_items tables, accepting
that schema changes require explicit Flyway migration scripts and a
deployment step.

---

# ADR-0034: Use PostgreSQL for Order Storage

Status: Proposed
Date: 2024-09-12
Deciders: [team]

## Context and Problem Statement
[...]

## Considered Options
1. PostgreSQL (relational, ACID, Flyway for migrations)
2. MongoDB (document, flexible schema, multi-doc transactions since 4.0)
3. Status quo: no dedicated order store (not viable beyond MVP)

[...full MADR continues...]

## Reversibility
Hard — migrating stored order data to a different engine requires
a full ETL with downtime window or dual-write migration period.
```

**Example: `/adr supersede`**

Input: "ADR-0012 chose UUID v4. We are switching to UUID v7 for index performance."

Output: Two files — ADR-0012 with updated status line ("Superseded by ADR-0023, 2024-03-15"), and complete ADR-0023 in MADR format with the full UUID v7 rationale.

**Example: `/adr list`**

Output:
```
ADR Audit — docs/decisions/ (34 records)

Status: 28 Accepted, 3 Superseded, 2 Rejected, 1 Proposed

Warnings:
- ADR-0003 (Accepted, 2021-06-01): No review date. 33 months old. Verify currency.
- ADR-0019 (Proposed, 2024-01-15): 60+ days without acceptance. Close or accept.

Coverage gaps (no ADR found for):
- Logging infrastructure (structured logs decision?)
- CI/CD pipeline choice
- Secret management approach
```

## Output Format

- `/adr new`: Y-Statement + full ADR in Nygard or MADR format + reversibility assessment + suggested code locations
- `/adr supersede`: Updated status block for old ADR + complete new ADR
- `/adr list`: Audit table with warnings and coverage gaps
- `/adr export`: Markdown index table or Y-Statement summary list
