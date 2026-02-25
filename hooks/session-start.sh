#!/bin/bash
# =============================================================================
# LibreArch Session Start Hook
# =============================================================================
# Runs when a Claude Code session starts in a project.
# Detects architecture patterns, project structure, and domain markers.
# Recommends relevant LibreArch plugins based on detected patterns.
#
# What this hook does:
# 1. Detects layer structure (domain, application, infrastructure)
# 2. Identifies DDD markers (aggregates, value objects, bounded contexts)
# 3. Finds event-driven patterns (event bus, event store, pub/sub)
# 4. Detects architecture style (monolith, microservices, modular monolith)
# 5. Checks for ADRs and architecture documentation
# 6. Identifies messaging infrastructure (RabbitMQ, Kafka, SQS)
# 7. Recommends relevant LibreArch plugins
# 8. Warns about common architecture anti-patterns
# =============================================================================

set -euo pipefail

HOOK_INPUT=$(cat)
CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")

HOOKS_LOG_DIR="${LIBREARCH_HOOKS_DIR:-$(dirname "$0")}/logs"
mkdir -p "$HOOKS_LOG_DIR"

echo "$(date '+%Y-%m-%d %H:%M:%S') - LibreArch Session started in $CURRENT_DIR" >> "$HOOKS_LOG_DIR/sessions.log"

CONTEXT_MESSAGES=()
ARCH_CONTEXT=()
WARNINGS=()

# =============================================================================
# LAYER STRUCTURE DETECTION
# =============================================================================

LAYERS=()
HAS_DOMAIN_LAYER=false
HAS_APPLICATION_LAYER=false
HAS_INFRASTRUCTURE_LAYER=false
HAS_INTERFACES_LAYER=false

for layer_name in "domain" "core" "model" "entities"; do
    if [ -d "$CURRENT_DIR/src/$layer_name" ] || [ -d "$CURRENT_DIR/lib/$layer_name" ] || [ -d "$CURRENT_DIR/app/$layer_name" ]; then
        HAS_DOMAIN_LAYER=true
        LAYERS+=("Domain")
        break
    fi
done

for layer_name in "application" "use-cases" "usecases" "services"; do
    if [ -d "$CURRENT_DIR/src/$layer_name" ] || [ -d "$CURRENT_DIR/lib/$layer_name" ] || [ -d "$CURRENT_DIR/app/$layer_name" ]; then
        HAS_APPLICATION_LAYER=true
        LAYERS+=("Application")
        break
    fi
done

for layer_name in "infrastructure" "infra" "adapters" "persistence" "repositories"; do
    if [ -d "$CURRENT_DIR/src/$layer_name" ] || [ -d "$CURRENT_DIR/lib/$layer_name" ] || [ -d "$CURRENT_DIR/app/$layer_name" ]; then
        HAS_INFRASTRUCTURE_LAYER=true
        LAYERS+=("Infrastructure")
        break
    fi
done

for layer_name in "interfaces" "api" "controllers" "presentation" "web"; do
    if [ -d "$CURRENT_DIR/src/$layer_name" ] || [ -d "$CURRENT_DIR/lib/$layer_name" ] || [ -d "$CURRENT_DIR/app/$layer_name" ]; then
        HAS_INTERFACES_LAYER=true
        LAYERS+=("Interfaces")
        break
    fi
done

if [ ${#LAYERS[@]} -gt 0 ]; then
    ARCH_CONTEXT+=("Architecture layers detected: ${LAYERS[*]}")
fi

# =============================================================================
# DDD MARKER DETECTION
# =============================================================================

DDD_MARKERS=()

if find "$CURRENT_DIR/src" -maxdepth 4 -iname "*aggregate*" -print -quit 2>/dev/null | grep -q .; then
    DDD_MARKERS+=("Aggregates")
fi

if find "$CURRENT_DIR/src" -maxdepth 4 -iname "*value-object*" -o -iname "*valueobject*" -o -iname "*value_object*" -print -quit 2>/dev/null | grep -q .; then
    DDD_MARKERS+=("Value Objects")
fi

if find "$CURRENT_DIR/src" -maxdepth 4 -path "*/domain/*event*" -print -quit 2>/dev/null | grep -q .; then
    DDD_MARKERS+=("Domain Events")
fi

if find "$CURRENT_DIR/src" -maxdepth 4 -path "*/domain/*repository*" -print -quit 2>/dev/null | grep -q .; then
    DDD_MARKERS+=("Repository Interfaces")
fi

if find "$CURRENT_DIR/src" -maxdepth 2 -iname "*context*" -type d -print -quit 2>/dev/null | grep -q .; then
    DDD_MARKERS+=("Bounded Contexts")
fi

if [ -d "$CURRENT_DIR/src/modules" ] || [ -d "$CURRENT_DIR/src/contexts" ] || [ -d "$CURRENT_DIR/src/bounded-contexts" ]; then
    DDD_MARKERS+=("Module Structure")
fi

if [ ${#DDD_MARKERS[@]} -gt 0 ]; then
    ARCH_CONTEXT+=("DDD markers detected: ${DDD_MARKERS[*]}")
fi

# =============================================================================
# EVENT-DRIVEN PATTERN DETECTION
# =============================================================================

EVENT_PATTERNS=()

if find "$CURRENT_DIR/src" -maxdepth 4 -iname "*event-bus*" -o -iname "*eventbus*" -o -iname "*event_bus*" -print -quit 2>/dev/null | grep -q .; then
    EVENT_PATTERNS+=("Event Bus")
fi

if find "$CURRENT_DIR/src" -maxdepth 4 -iname "*event-store*" -o -iname "*eventstore*" -print -quit 2>/dev/null | grep -q .; then
    EVENT_PATTERNS+=("Event Store")
fi

if find "$CURRENT_DIR/src" -maxdepth 4 -iname "*command-handler*" -o -iname "*query-handler*" -print -quit 2>/dev/null | grep -q .; then
    EVENT_PATTERNS+=("CQRS Handlers")
fi

if find "$CURRENT_DIR/src" -maxdepth 4 -iname "*saga*" -print -quit 2>/dev/null | grep -q .; then
    EVENT_PATTERNS+=("Saga")
fi

if [ ${#EVENT_PATTERNS[@]} -gt 0 ]; then
    ARCH_CONTEXT+=("Event-driven patterns: ${EVENT_PATTERNS[*]}")
fi

# =============================================================================
# MESSAGING INFRASTRUCTURE DETECTION
# =============================================================================

MESSAGING=()

if [ -f "$CURRENT_DIR/package.json" ]; then
    PKG=$(cat "$CURRENT_DIR/package.json" 2>/dev/null || echo "{}")
    if echo "$PKG" | grep -q '"amqplib"\|"amqp-connection-manager"'; then MESSAGING+=("RabbitMQ"); fi
    if echo "$PKG" | grep -q '"kafkajs"\|"kafka-node"'; then MESSAGING+=("Kafka"); fi
    if echo "$PKG" | grep -q '"@aws-sdk/client-sqs"\|"sqs-consumer"'; then MESSAGING+=("AWS SQS"); fi
    if echo "$PKG" | grep -q '"nats"'; then MESSAGING+=("NATS"); fi
    if echo "$PKG" | grep -q '"bullmq"\|"bull"'; then MESSAGING+=("BullMQ"); fi
fi

if [ ${#MESSAGING[@]} -gt 0 ]; then
    ARCH_CONTEXT+=("Messaging infrastructure: ${MESSAGING[*]}")
fi

# =============================================================================
# ARCHITECTURE DOCUMENTATION DETECTION
# =============================================================================

HAS_ADRS=false
HAS_ARCH_DOCS=false

if [ -d "$CURRENT_DIR/docs/architecture/decisions" ] || [ -d "$CURRENT_DIR/docs/adr" ] || [ -d "$CURRENT_DIR/adr" ]; then
    HAS_ADRS=true
    ARCH_CONTEXT+=("Architecture Decision Records found")
fi

if [ -d "$CURRENT_DIR/docs/architecture" ] || [ -f "$CURRENT_DIR/ARCHITECTURE.md" ]; then
    HAS_ARCH_DOCS=true
    ARCH_CONTEXT+=("Architecture documentation found")
fi

# =============================================================================
# ARCHITECTURE STYLE DETECTION
# =============================================================================

ARCH_STYLE="Unknown"

if [ -d "$CURRENT_DIR/src/modules" ] && [ "$HAS_DOMAIN_LAYER" = true ]; then
    ARCH_STYLE="Modular Monolith"
elif [ "$HAS_DOMAIN_LAYER" = true ] && [ "$HAS_APPLICATION_LAYER" = true ] && [ "$HAS_INFRASTRUCTURE_LAYER" = true ]; then
    ARCH_STYLE="Clean/Hexagonal Architecture"
elif [ "$HAS_INTERFACES_LAYER" = true ] && [ "$HAS_INFRASTRUCTURE_LAYER" = true ]; then
    ARCH_STYLE="Layered Architecture"
fi

if [ "$ARCH_STYLE" != "Unknown" ]; then
    CONTEXT_MESSAGES+=("Architecture style: $ARCH_STYLE")
fi

# =============================================================================
# ARCHITECTURE ANTI-PATTERN WARNINGS
# =============================================================================

if [ "$HAS_DOMAIN_LAYER" = true ] && [ "$HAS_INFRASTRUCTURE_LAYER" = true ]; then
    DOMAIN_DIR=""
    for dir in "src/domain" "lib/domain" "app/domain" "src/core" "lib/core"; do
        if [ -d "$CURRENT_DIR/$dir" ]; then
            DOMAIN_DIR="$CURRENT_DIR/$dir"
            break
        fi
    done
    if [ -n "$DOMAIN_DIR" ]; then
        if grep -rl "from.*infrastructure\|from.*infra\|from.*adapters" "$DOMAIN_DIR" 2>/dev/null | head -1 | grep -q .; then
            WARNINGS+=("DEPENDENCY VIOLATION: Domain layer appears to import from infrastructure layer - dependencies should point inward")
        fi
    fi
fi

if [ "$HAS_ADRS" = false ] && [ "$HAS_DOMAIN_LAYER" = true ]; then
    WARNINGS+=("No Architecture Decision Records found - consider documenting key decisions in docs/architecture/decisions/")
fi

# =============================================================================
# PLUGIN RECOMMENDATIONS
# =============================================================================

RECOMMENDED_PLUGINS=()

if [ "$HAS_DOMAIN_LAYER" = true ]; then RECOMMENDED_PLUGINS+=("domain-driven-design"); fi
if [ "$HAS_DOMAIN_LAYER" = true ] && [ "$HAS_INFRASTRUCTURE_LAYER" = true ]; then
    RECOMMENDED_PLUGINS+=("clean-architecture" "hexagonal-architecture")
fi
if [ ${#EVENT_PATTERNS[@]} -gt 0 ]; then RECOMMENDED_PLUGINS+=("event-driven" "cqrs-event-sourcing"); fi
if [ ${#MESSAGING[@]} -gt 0 ]; then RECOMMENDED_PLUGINS+=("message-queues"); fi

RECOMMENDED_PLUGINS+=("architecture-decision-records")

if [ ${#RECOMMENDED_PLUGINS[@]} -gt 0 ]; then
    UNIQUE_PLUGINS=$(printf '%s\n' "${RECOMMENDED_PLUGINS[@]}" | sort -u | tr '\n' ', ' | sed 's/,$//')
    ARCH_CONTEXT+=("Recommended LibreArch plugins: $UNIQUE_PLUGINS")
fi

# =============================================================================
# OUTPUT
# =============================================================================

OUTPUT="{"

if [ ${#CONTEXT_MESSAGES[@]} -gt 0 ] || [ ${#ARCH_CONTEXT[@]} -gt 0 ]; then
    OUTPUT="$OUTPUT\"additionalContext\":["
    FIRST=true
    for msg in "${CONTEXT_MESSAGES[@]}"; do
        if [ "$FIRST" = true ]; then FIRST=false; else OUTPUT="$OUTPUT,"; fi
        ESCAPED_MSG=$(echo "$msg" | sed 's/"/\\"/g')
        OUTPUT="$OUTPUT{\"type\":\"text\",\"text\":\"$ESCAPED_MSG\"}"
    done
    for msg in "${ARCH_CONTEXT[@]}"; do
        if [ "$FIRST" = true ]; then FIRST=false; else OUTPUT="$OUTPUT,"; fi
        ESCAPED_MSG=$(echo "$msg" | sed 's/"/\\"/g')
        OUTPUT="$OUTPUT{\"type\":\"text\",\"text\":\"$ESCAPED_MSG\"}"
    done
    OUTPUT="$OUTPUT]"
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
    if [ ${#CONTEXT_MESSAGES[@]} -gt 0 ] || [ ${#ARCH_CONTEXT[@]} -gt 0 ]; then OUTPUT="$OUTPUT,"; fi
    OUTPUT="$OUTPUT\"systemMessage\":\"LibreArch Architecture Assessment:\\n"
    for warn in "${WARNINGS[@]}"; do
        ESCAPED_WARN=$(echo "$warn" | sed 's/"/\\"/g')
        OUTPUT="$OUTPUT- $ESCAPED_WARN\\n"
    done
    OUTPUT="$OUTPUT\""
fi

OUTPUT="$OUTPUT}"

if [ ${#CONTEXT_MESSAGES[@]} -gt 0 ] || [ ${#ARCH_CONTEXT[@]} -gt 0 ] || [ ${#WARNINGS[@]} -gt 0 ]; then
    echo "$OUTPUT"
fi

{
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Architecture Assessment for $PROJECT_NAME"
    echo "  Style: $ARCH_STYLE"
    echo "  Layers: ${LAYERS[*]:-none}"
    echo "  DDD Markers: ${DDD_MARKERS[*]:-none}"
    echo "  Event Patterns: ${EVENT_PATTERNS[*]:-none}"
    echo "  Messaging: ${MESSAGING[*]:-none}"
    echo "  Warnings: ${#WARNINGS[@]}"
    echo "---"
} >> "$HOOKS_LOG_DIR/sessions.log"

exit 0
