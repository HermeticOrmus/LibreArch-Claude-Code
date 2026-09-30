# Troubleshooting

```bash
claude plugin list | grep -c '@libre-arch'  # 21 after a full ./setup.sh (20 plugins plus libre-arch-hooks)
```

Common scenarios:
- DDD bounded context identification → `/ddd`
- Microservice boundary decisions → `/microservices`
- Event-sourcing design → `/event-driven` + `/cqrs`
- Saga design → `/saga`
- Legacy modernization → `/migrate`

## Plugins installed but nothing shows up

Restart Claude Code after installing; plugins load at startup. Then check that each one is enabled:

```bash
claude plugin list
claude plugin details domain-driven-design@libre-arch
```

A disabled plugin can be turned back on with `claude plugin enable <plugin>@libre-arch`.

## Installed with an older setup.sh

Versions before 1.0.0 copied plugin folders into `~/.claude/plugins/libre-arch-*`. Claude Code does not load plugins from there, so those copies never ran. Remove them (`rm -rf ~/.claude/plugins/libre-arch-*`) and install again with `./setup.sh` or `/plugin install`.

## The hooks do nothing

`libre-arch-hooks` needs `jq` on the PATH. Without it the hooks exit quietly. The session-start line only appears in projects with architecture markers (layer folders, DDD or event-driven files, messaging libraries, or ADRs).
