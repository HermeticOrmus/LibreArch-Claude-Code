# Kintsugi ledger: LibreArch-Claude-Code

Kintsugi mends broken pottery with gold, so the repair is the part you see. Here it means every crack we found in LibreArch is written down with its evidence and the seal that closed it, so you can check the gold yourself.

A row is `hallmarked` when its seal shipped in a release that was verified by installing from GitHub into a clean config. Grades: `hairline` is copy or cosmetic, `fracture` is wrong behavior with a workaround, `break` means it did not work or broke a safety promise. IDs are never reused.

| ID | Crack | Evidence | Grade | Tracker | Seal | State |
|----|-------|----------|-------|---------|------|-------|
| K-01 | Nothing installed: the repo had no marketplace or plugin manifests, and the old `setup.sh` copied folders into `~/.claude/plugins`, where Claude Code does not load plugins from. | [PR #2][pr2], [CHANGELOG 1.0.0 L5][a5], [L8][a8], [L20][a20] | break | filed #1 | `marketplace.json` plus a `plugin.json` per plugin; `setup.sh` installs through `claude plugin`; large | hallmarked |
| K-02 | Agents and commands lived in `agents/<name>/AGENT.md` and `commands/<name>/COMMAND.md`, and the DDD skill was a loose `.md` file: layouts Claude Code does not load. | [PR #2][pr2], [CHANGELOG 1.0.0 L17][a17] | break | filed #1 | Moved with `git mv` to `agents/<name>.md`, `commands/<name>.md`, and `skills/domain-driven-design/SKILL.md`, content kept; medium | hallmarked |
| K-03 | 62 of the 63 agent, command, and skill files had no frontmatter, so Claude Code could not route to them. | [PR #2][pr2], [CHANGELOG 1.0.0 L9][a9]; count taken from `main` before the release (`7c07850`) | break | filed #1 | A routing description on every file, and an `argument-hint` on every command that takes a mode; large | hallmarked |
| K-04 | domain-driven-design carried two copies of each component: `ddd-architect` next to `ddd-strategist`, two `/ddd` commands, and `ddd-patterns` next to `domain-driven-design`. | [PR #2][pr2], [CHANGELOG 1.0.0 L18][a18] | fracture | filed #1 | The unique material of the older copies merged into the newer files, then the older copies removed; medium | hallmarked |
| K-05 | `ddd-strategist` was pinned to Sonnet instead of the session's model. | [PR #2][pr2], [CHANGELOG 1.0.0 L19][a19] | fracture | filed #1 | `model: inherit`; small | hallmarked |
| K-06 | The repository hook scripts were never registered with Claude Code, so they never ran. | [PR #2][pr2], [CHANGELOG 1.0.0 L24][a24] | break | filed #1 | The `libre-arch-hooks` plugin wires them through `hooks/hooks.json` and `${CLAUDE_PLUGIN_ROOT}`; medium | hallmarked |
| K-07 | The hook scripts answered in a shape Claude Code does not read: an `additionalContext` array of text objects. | [PR #2][pr2], `hooks/pre-tool-use.sh:152` (the original, kept for reference), [CHANGELOG 1.0.0 L24][a24] | break | filed #1 | The plugin scripts answer through `hookSpecificOutput`; small | hallmarked |
| K-08 | The hook scripts parsed the hook JSON with `grep`. | [PR #2][pr2], `hooks/pre-tool-use.sh:22`, [CHANGELOG 1.0.0 L24][a24] | fracture | filed #1 | The plugin scripts read the JSON with `jq`; small | hallmarked |
| K-09 | The hook scripts wrote log files next to themselves. | [PR #2][pr2], `hooks/post-tool-use.sh:41`, [CHANGELOG 1.0.0 L24][a24] | fracture | filed #1 | The plugin scripts write nothing to disk; small | hallmarked |
| K-10 | QUICK_START and TROUBLESHOOTING described the old install and used command names that do not exist. | [PR #2][pr2], [CHANGELOG 1.0.0 L21][a21] | hairline | filed #1 | Both cover the plugin install and use the real names (`/cqrs`, `/saga`, `/migrate`); small | hallmarked |
| K-11 | The session-start hook does not detect ADRs in `docs/decisions/`, where the pack's own `adr-curator` writes them, or in `doc/adr/`, the adr-tools default. | `plugins/libre-arch-hooks/hooks/session-start.sh:53` checks `docs/architecture/decisions`, `docs/adr`, `docs/adrs`, and `adr` only; `plugins/architecture-decision-records/agents/adr-curator.md:58`; [pantry queue][queue] atom 2 | fracture | Menu atom `adr-folders` | Check `docs/decisions/` and `doc/adr/` too, and list the folders in the hook README; small | open |
| K-12 | The `libre-arch-hooks` plugin has not run inside a live Grok Build session, so its runtime behavior there is unverified. | `grok plugin validate plugins/libre-arch-hooks` passes and lists hooks (grok 1.0.44). *Inferred*: Grok's hooks guide shows a camelCase stdin envelope (`toolName`, `toolInput`, Grok tool names); fed that envelope for a `.env` edit, `pre-tool-use.sh` prints nothing, while the Claude Code envelope gets `ask`. | hairline | new | Read both envelopes (`.tool_name // .toolName`, `.tool_input // .toolInput`) and Grok tool names, then record each hook's output in a live Grok session; small | open |

[pr2]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/pull/2
[a5]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L5
[a8]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L8
[a9]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L9
[a17]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L17
[a18]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L18
[a19]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L19
[a20]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L20
[a21]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L21
[a24]: https://github.com/HermeticOrmus/LibreArch-Claude-Code/blob/c4939847c5c341a4b92b82fce885dbf5af59ffe3/CHANGELOG.md?plain=1#L24
[queue]: pantry/2026-09-30-pantry-queue.md

<p align="center"><img src="https://brand.ormus.solutions/assets/marks/kintsugi-mark.svg" alt="Kintsugi mark" width="48" /></p>
