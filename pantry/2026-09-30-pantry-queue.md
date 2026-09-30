# Pantry queue: LibreArch-Claude-Code

## How this fills

1. Read the latest competitor map, X mine and people mine.
2. Propose 5 to 8 Goal atoms that answer their themes. The Menu needs at least 3.
3. Each atom needs a Done predicate someone else can check on this repo, a surface, the evidence rows it answers, and a confidence (high, medium or low).
4. Save as `YYYY-MM-DD-pantry-queue.md`; the Menu reads the newest one.
5. Retire an atom only with a bullet under "Explicitly not stocked" of the form `<Title>: shipped, PR #N` or `<Title>: parked, <reason>`.

Sources for this run: [competitor map](2026-09-30-competitor-map.md), [X mine](2026-09-30-x-mine.md), [people mine](2026-09-30-people-mine.md) (no outside voices yet).

## Atoms

| # | Title | Done predicate | Surface | Evidence | Confidence |
|---|-------|----------------|---------|----------|------------|
| 1 | New plugin `architecture-diagrams` for C4 in Mermaid and Structurizr DSL | `claude plugin validate plugins/architecture-diagrams` passes; after a clean-config install, `claude plugin details architecture-diagrams@libre-arch` lists one agent and a command and a skill under Skills; the skill has Mermaid `C4Context` and `C4Container` examples and the same system in Structurizr DSL; the command has a mode that takes a code path and writes a C4 container diagram; the plugin is listed in `.claude-plugin/marketplace.json` and in the README plugin table | repo | map: Diagrams as code (Us P; wsh, arc, szr Y); map: Architecture recovered from existing code (Us P; wsh, arc Y) | high |
| 2 | Detect the ADR folders the pack writes (`adr-folders`) | `plugins/libre-arch-hooks/hooks/session-start.sh`, fed `{"cwd":"<dir>"}` on stdin, prints a line containing `ADRs present` when `<dir>` holds only `docs/decisions/ADR-0001-use-postgres.md` (where `adr-curator` writes) and when it holds only `doc/adr/0001-record-architecture-decisions.md` (the adr-tools default); a folder with neither still prints nothing; the hook README lists the folders it checks | repo | map: ADR log management (Us: the curator writes `docs/decisions/`, the hook does not look there; adt default `doc/adr`); X: iamrexei | high |
| 3 | Architecture tests for TypeScript and Python (`arch-tests`) | `plugins/clean-architecture/skills/clean-arch-patterns/SKILL.md` gains a section with a dependency-cruiser `forbidden` rule and an import-linter `layers` contract that both enforce the domain, application, infrastructure direction, each with the command that runs it in CI; `claude plugin validate plugins/clean-architecture` passes | repo | X: mjovanovictech; map: Architecture tests in CI (Us P, ArchUnit examples only; aru Y; map row TNG/ArchUnit names dependency-cruiser and import-linter) | high |
| 4 | Fixture tests for the hook scripts (`hook-tests`) | `tests/hooks/run.sh` feeds fixture hook JSON and small source trees to `session-start.sh`, `pre-tool-use.sh` and `post-tool-use.sh` and compares each output with an expected file: a domain file importing infrastructure (flagged), an ORM import in domain code (flagged), a clean domain file (prints nothing), a `.env` read (ask), `.env.example` (passes); `bash tests/hooks/run.sh` exits 0; `.github/workflows/validate.yml` runs it on every pull request | repo | map: Tests or evals of the pack itself (Us P; wsh Y); map: Dependency-rule checks while Claude edits (Us Y, unproven by tests) | high |
| 5 | Several reviewer roles for `/system-design review` | the `review` mode in `plugins/system-design/commands/system-design.md` runs named perspectives (operations, security, cost, the engineer who maintains it, a skeptic), prints one findings table per role and a list of findings that two or more roles share, and a worked example in the file shows that output for a sample proposal; `claude plugin validate plugins/system-design` passes | repo | map: Multi-perspective review of a design (Us P; cek, arc Y); X: Hesamation, samlambert, unclebobmartin | medium |
| 6 | `/adr check` flags proposals that contradict accepted ADRs | `plugins/architecture-decision-records/commands/adr.md` lists `check` in `argument-hint`; the mode reads the ADR folder, and a worked example in the file shows a proposal that contradicts an accepted ADR flagged with that ADR's number and title; `claude plugin validate plugins/architecture-decision-records` passes | repo | X: iamrexei, MikeCodeur; map: ADR writing and ADR log management (Us Y, no check against existing decisions) | medium |
| 7 | Eval suite for domain-driven-design (`ddd-evals`) | `plugins/domain-driven-design/evals/` holds cases that `claude plugin eval plugins/domain-driven-design` loads and scores, with graders that check a `/ddd map-contexts` answer for named bounded contexts, a context map with relationship types, and an aggregate with its invariants | repo | map: Tests or evals of the pack itself (Us P; wsh Y) | medium |
| 8 | Codex marketplace manifest (`codex-marketplace`) | `.agents/plugins/marketplace.json` lists the same 21 plugin names as `.claude-plugin/marketplace.json`, every plugin folder has `.codex-plugin/plugin.json`, the README documents the Codex install, and a CI step fails when the two manifests list different plugin names | repo | map: Installs in other agents (Us N; wsh, cek, cdr Y) | low |

## Explicitly not stocked (and why)

- A spec, plan and tasks workflow of our own: Spec Kit, Conductor, context-engineering-kit and `architect` already cover it (map row), and the X mine shows mixed results for them; the pack stays on architecture knowledge and checks.
- A standalone ADR CLI: adr-tools already manages numbered ADR files; the `adr-folders` atom makes the hooks recognize its folder instead.
