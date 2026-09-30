#!/usr/bin/env bash
# libre-arch-hooks: SessionStart
#
# Looks at the project Claude Code just opened and, when it finds architecture
# markers, prints one line of context: the architecture style, the layers,
# DDD and event-driven markers, messaging libraries, whether ADRs exist, and
# which LibreArch plugins fit. Prints nothing for projects with no markers.
# Reads only; writes no files.
set -uo pipefail

input="$(cat)"
dir=""
command -v jq >/dev/null 2>&1 && dir="$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)"
[[ -n "$dir" && -d "$dir" ]] || dir="$PWD"

has_dir() { local n; for n in "$@"; do for root in src lib app; do [[ -d "$dir/$root/$n" ]] && return 0; done; done; return 1; }
found() { [[ -d "$dir/src" ]] && [[ -n "$(find "$dir/src" -maxdepth 4 "$@" -print -quit 2>/dev/null)" ]]; }

layers=(); dom=0; app=0; infra=0; ifc=0
has_dir domain core model entities && { layers+=(domain); dom=1; }
has_dir application use-cases usecases services && { layers+=(application); app=1; }
has_dir infrastructure infra adapters persistence repositories && { layers+=(infrastructure); infra=1; }
has_dir interfaces api controllers presentation web && { layers+=(interfaces); ifc=1; }

ddd=()
found -iname '*aggregate*' && ddd+=(aggregates)
found \( -iname '*value-object*' -o -iname '*valueobject*' -o -iname '*value_object*' \) && ddd+=("value objects")
found -ipath '*/domain/*event*' && ddd+=("domain events")
found -ipath '*/domain/*repositor*' && ddd+=("repository ports")
[[ -d "$dir/src/modules" || -d "$dir/src/contexts" || -d "$dir/src/bounded-contexts" ]] && ddd+=("module or context folders")

events=()
found \( -iname '*event-bus*' -o -iname '*eventbus*' -o -iname '*event_bus*' \) && events+=("event bus")
found \( -iname '*event-store*' -o -iname '*eventstore*' -o -iname '*event_store*' \) && events+=("event store")
found \( -iname '*command-handler*' -o -iname '*commandhandler*' -o -iname '*query-handler*' -o -iname '*queryhandler*' \) && events+=("CQRS handlers")
found -iname '*saga*' && events+=(sagas)

messaging=()
manifests=()
for m in package.json requirements.txt pyproject.toml go.mod pom.xml build.gradle build.gradle.kts; do
  [[ -f "$dir/$m" ]] && manifests+=("$dir/$m")
done
if (( ${#manifests[@]} > 0 )); then
  deps="$(cat "${manifests[@]}" 2>/dev/null)"
  grep -qE 'amqplib|amqp-connection-manager|pika|spring-rabbit|spring-boot-starter-amqp|amqp091-go' <<<"$deps" && messaging+=(RabbitMQ)
  grep -qE 'kafkajs|kafka-node|confluent-kafka|kafka-python|spring-kafka|kafka-go|sarama' <<<"$deps" && messaging+=(Kafka)
  grep -qE '@aws-sdk/client-sqs|sqs-consumer' <<<"$deps" && messaging+=(SQS)
  grep -qE '"nats"|nats-py|nats.go' <<<"$deps" && messaging+=(NATS)
  grep -qE '"bullmq"|"bull"' <<<"$deps" && messaging+=(BullMQ)
fi

adrs=0
[[ -d "$dir/docs/architecture/decisions" || -d "$dir/docs/adr" || -d "$dir/docs/adrs" || -d "$dir/adr" ]] && adrs=1
archdocs=0
[[ -d "$dir/docs/architecture" || -f "$dir/ARCHITECTURE.md" ]] && archdocs=1

if (( ${#layers[@]} == 0 && ${#ddd[@]} == 0 && ${#events[@]} == 0 && ${#messaging[@]} == 0 && adrs == 0 && archdocs == 0 )); then
  exit 0
fi

style=""
if [[ -d "$dir/src/modules" ]] && (( dom )); then style="modular monolith"
elif (( dom && app && infra )); then style="clean or hexagonal layering"
elif (( ifc && infra )); then style="layered architecture"
fi

join() { local IFS=','; echo "$*" | sed 's/,/, /g'; }
parts=()
(( ${#layers[@]} )) && parts+=("layers: $(join "${layers[@]}")")
(( ${#ddd[@]} )) && parts+=("DDD: $(join "${ddd[@]}")")
(( ${#events[@]} )) && parts+=("events: $(join "${events[@]}")")
(( ${#messaging[@]} )) && parts+=("messaging: $(join "${messaging[@]}")")
(( adrs )) && parts+=("ADRs present")
(( archdocs && ! adrs )) && parts+=("architecture docs present")

warn=""
if (( dom && infra )); then
  for d in src/domain lib/domain app/domain src/core lib/core; do
    if [[ -d "$dir/$d" ]]; then
      grep -rlE "from\s+['\"].*/(infrastructure|infra|adapters)" "$dir/$d" 2>/dev/null | head -1 | grep -q . \
        && warn=" Domain code appears to import infrastructure."
      break
    fi
  done
fi
(( dom && ! adrs )) && warn+=" No ADRs found yet."

plugins=()
(( dom )) && plugins+=(domain-driven-design)
(( dom && infra )) && plugins+=(clean-architecture hexagonal-architecture)
(( ${#events[@]} )) && plugins+=(event-driven cqrs-event-sourcing)
(( ${#messaging[@]} )) && plugins+=(message-queues)
plugins+=(architecture-decision-records)

line="LibreArch:"
[[ -n "$style" ]] && line+=" $style,"
line+=" $(IFS='|'; echo "${parts[*]}" | sed 's/|/; /g').${warn} Relevant plugins: $(join $(printf '%s\n' "${plugins[@]}" | sort -u))."
echo "$line"
exit 0
