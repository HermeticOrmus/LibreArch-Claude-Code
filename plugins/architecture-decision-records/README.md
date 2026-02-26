# Architecture Decision Records Plugin

Creates, maintains, supersedes, and audits Architecture Decision Records. Covers Nygard format, MADR (Markdown Architectural Decision Records), Y-Statements, ADR status lifecycle, fitness functions for enforcement, and linking decisions to code.

## Contents

### Agents

| Agent | Purpose |
|-------|---------|
| `agents/adr-curator/AGENT.md` | Expert in ADR formats (Nygard, MADR, Y-Statement, RFC-style), decision lifecycle, reversibility assessment, fitness function design. References Nygard (2011), Kopp (MADR), Ford/Parsons/Kua (_Building Evolutionary Architectures_). |

### Commands

| Command | Purpose |
|---------|---------|
| `commands/adr/COMMAND.md` | `/adr new|list|supersede|export` — structured process for writing ADRs with Y-Statement summaries, auditing decision inventory, managing supersession, and exporting decision indexes. |

### Skills

| Skill | Purpose |
|-------|---------|
| `skills/adr-patterns/SKILL.md` | Complete MADR and Nygard templates, Y-Statement examples, fitness functions in ArchUnit (Java), code annotation patterns, rejected ADR examples, anti-patterns (stale ADR, no-alternatives ADR). |

## When to Use

- Making a significant architectural decision (database engine, messaging, architecture style, public API shape)
- Reversing or updating a previous architectural decision
- Onboarding engineers who need to understand the history of decisions
- Running an architecture review — inventory what decisions have been made and which are stale
- Enforcing a structural constraint with a fitness function tied to an ADR

## Key References

- Nygard, Michael. "Documenting Architecture Decisions." cognitect.com/blog, 2011.
- Kopp, Oliver. MADR — Markdown Architectural Decision Records. adr.github.io/madr.
- Ford, Neal, Rebecca Parsons, Patrick Kua. _Building Evolutionary Architectures_. O'Reilly, 2017.
- npryce/adr-tools: github.com/npryce/adr-tools — CLI for managing ADRs.
- Thoughtworks Technology Radar Vol. 19: Architecture Decision Records (Adopt).
