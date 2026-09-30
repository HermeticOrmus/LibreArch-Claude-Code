# libre-arch-hooks

> Optional hooks for LibreArch: an architecture summary when a session starts, a confirmation prompt before Claude reads or edits secrets files, and a dependency-direction scan after each code edit.

This plugin is separate from the other 20 so you choose whether hooks run in your sessions. Install it with:

```
/plugin install libre-arch-hooks@libre-arch
```

or from a terminal: `claude plugin install libre-arch-hooks@libre-arch`, or `./setup.sh --only libre-arch-hooks` from a clone.

## What each hook does

| Event | Script | Behavior |
|---|---|---|
| SessionStart | `hooks/session-start.sh` | Looks for layer folders (domain, application, infrastructure, interfaces), DDD markers (aggregates, value objects, domain events, repository ports), event-driven markers (event bus, event store, CQRS handlers, sagas), messaging libraries in `package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `pom.xml`, or Gradle files, and ADR folders. When it finds any, it prints one line of context naming the architecture style, what it found, and the LibreArch plugins that fit. Projects with no markers get no output. |
| PreToolUse (Read, Edit, Write, MultiEdit) | `hooks/pre-tool-use.sh` | When the target is a `.env` file (not `.env.example`, `.env.sample`, `.env.template`, `.env.dist`), a `.pem` or `.key` file, or a non-source file whose path names credentials or secrets, it asks you to confirm before the tool runs. Everything else passes silently. |
| PostToolUse (Edit, Write, MultiEdit) | `hooks/post-tool-use.sh` | Scans the edited source file (TypeScript, JavaScript, Python, Go, Java, Kotlin, Rust, Ruby, C#) for domain or application code importing infrastructure, web framework or ORM imports in the domain layer, imports from another bounded context's internals, and heavy conditional logic in the interfaces layer. Findings go back to Claude as context so it can correct course. Silent when the file is clean. |

The layer comes from the innermost folder on the file's path inside the project, so `src/orders/domain/order.ts` counts as domain code.

## Requirements

- `bash` and `jq` on the PATH. Without `jq` the hooks exit quietly and do nothing.

## Privacy

The hooks read the JSON Claude Code sends on stdin and the files in your project. They write nothing to disk and send nothing over the network.

## Origin

These scripts are ports of the original `hooks/*.sh` files at the root of this repository, which are kept for reference. The originals parsed hook input with `grep` and wrote log files next to the scripts; these versions read the JSON with `jq`, use the hook output format Claude Code expects, and keep no logs.
