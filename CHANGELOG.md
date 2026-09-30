# Changelog

## [1.0.0] - 2026-09-30

The pack is now a Claude Code plugin marketplace. Before this release, `setup.sh` copied folders into `~/.claude/plugins`, where Claude Code does not load plugins from, so none of the agents, commands, or skills were reachable. From 1.0.0 every plugin installs and loads.

### Added
- Plugin marketplace `libre-arch` (`.claude-plugin/marketplace.json`) and a `plugin.json` for every plugin. Install with `/plugin marketplace add HermeticOrmus/LibreArch-Claude-Code`, then `/plugin install <plugin>@libre-arch`.
- Frontmatter with routing descriptions on all 20 agents, 20 commands, and 20 skills, so Claude Code knows when to use each one. Commands that take a mode carry an `argument-hint` listing the modes.
- `libre-arch-hooks`, an optional 21st plugin with three working hooks: a one-line architecture summary at session start, a confirmation prompt before Claude reads or edits `.env`, key, or secrets files, and a dependency-direction scan after each code edit.
- `/ddd` gains four focused modes (`model`, `map-contexts`, `validate`, `generate`) with worked examples, merged in from the older nested command.
- CI (`.github/workflows/validate.yml`) validates the marketplace and every plugin, then installs all of them into a clean config, on pushes to `main` and on pull requests.
- A feedback issue form and a Feedback section in the README.
- A Command column in the README plugin table.

### Changed
- Layout: agents moved from `agents/<name>/AGENT.md` to `agents/<name>.md`, commands from `commands/<name>/COMMAND.md` to `commands/<name>.md`, and the loose DDD skill to `skills/domain-driven-design/SKILL.md`. File contents moved with them.
- domain-driven-design: the older `ddd-architect` agent, nested `/ddd` command, and `ddd-patterns` skill covered the same ground as the newer `ddd-strategist` agent, `/ddd` command, and `domain-driven-design` skill. Their unique material (Java reference implementations, context-mapping guidance, literature references, the four `/ddd` modes, code patterns, and anti-patterns) now lives in the newer files, and the older copies are gone. If you called `ddd-architect` or the `ddd-patterns` skill by name, use `ddd-strategist` and `domain-driven-design`.
- `ddd-strategist` runs on the session's model (`model: inherit`) instead of pinning Sonnet.
- `setup.sh` installs through the Claude Code CLI (`claude plugin marketplace add`, `claude plugin install`). New flags: `--list`, `--scope`, `--uninstall`. `--plugins-dir` is still accepted and ignored with a note.
- QUICK_START and TROUBLESHOOTING cover the new install and use the real command names (`/cqrs`, `/saga`, `/migrate`).

### Fixed
- The repository hook scripts were never registered with Claude Code, parsed hook input with `grep`, and wrote log files next to themselves. The `libre-arch-hooks` versions read the hook JSON with `jq`, answer in the format Claude Code expects, and write nothing to disk. The originals stay in `hooks/` for reference.

### Upgrading from 0.2.0
- Remove the old copies, which never loaded: `rm -rf ~/.claude/plugins/libre-arch-*`
- Install again with `./setup.sh` or `/plugin install <plugin>@libre-arch`, then restart Claude Code.

## [0.2.0] — 2026-05-23
- LibreUIUX doc chrome
- **domain-driven-design** depth-complete
- 3-tier learning paths
- 20 plugins: 1 depth-complete, 19 shell-improved

### v0.3-v0.5 priorities
- v0.3: microservices, event-driven, system-design
- v0.4: distributed-systems, data-consistency, saga-patterns
- v0.5: clean-architecture, hexagonal-architecture, cqrs-event-sourcing
