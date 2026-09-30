# Menu: LibreArch-Claude-Code

Queue: 2026-09-30-pantry-queue.md
Counts: open 8, in flight 0, shipped 0, parked 0, dropped 0, needs fixing 0

## Steer

- none

## Up next

**adr-folders**: Detect the ADR folders the pack writes (`adr-folders`) (queue #2, high, repo, since 2026-09-30)

- Done when: `plugins/libre-arch-hooks/hooks/session-start.sh`, fed `{"cwd":"<dir>"}` on stdin, prints a line containing `ADRs present` when `<dir>` holds only `docs/decisions/ADR-0001-use-postgres.md` (where `adr-curator` writes) and when it holds only `doc/adr/0001-record-architecture-decisions.md` (the adr-tools default); a folder with neither still prints nothing; the hook README lists the folders it checks
- Verify on: repo
- Evidence: map: ADR log management (Us: the curator writes `docs/decisions/`, the hook does not look there; adt default `doc/adr`); X: iamrexei
- Issue: none yet (promote after merge)
- Order: adr-folders, arch-tests, architecture-diagrams, hook-tests, adr-check, system-design-review, ddd-evals, codex-marketplace
- Tie: adr-folders over arch-tests, architecture-diagrams, hook-tests, by key order (jev off)

## Atoms

| Key | Title | State | Confidence | Class | Since | Queue # | Issue | Because |
|-----|-------|-------|------------|-------|-------|---------|-------|---------|
| adr-check | `/adr check` flags proposals that contradict accepted ADRs | open | medium | repo | 2026-09-30 | 6 | - | - |
| adr-folders | Detect the ADR folders the pack writes (`adr-folders`) | open | high | repo | 2026-09-30 | 2 | - | - |
| arch-tests | Architecture tests for TypeScript and Python (`arch-tests`) | open | high | repo | 2026-09-30 | 3 | - | - |
| architecture-diagrams | New plugin `architecture-diagrams` for C4 in Mermaid and Structurizr DSL | open | high | repo | 2026-09-30 | 1 | - | - |
| codex-marketplace | Codex marketplace manifest (`codex-marketplace`) | open | low | repo | 2026-09-30 | 8 | - | - |
| ddd-evals | Eval suite for domain-driven-design (`ddd-evals`) | open | medium | eval | 2026-09-30 | 7 | - | - |
| hook-tests | Fixture tests for the hook scripts (`hook-tests`) | open | high | repo | 2026-09-30 | 4 | - | - |
| system-design-review | Several reviewer roles for `/system-design review` | open | medium | repo | 2026-09-30 | 5 | - | - |

## Retired

| Key | Title | State | Since | Issue | Because |
|-----|-------|-------|-------|-------|---------|
| none | | | | | |

## Notes

- none
