#!/bin/bash
# =============================================================================
# LibreArch Pre Tool Use Hook
# =============================================================================
# Runs BEFORE Edit/Write/MultiEdit operations.
# Detects if the file being modified is architecture-sensitive and provides
# guidance on dependency direction, coupling, and structural integrity.
#
# What this hook does:
# 1. Detects the architectural layer of the file being modified
# 2. Warns about dependency direction violations
# 3. Flags coupling concerns (imports from unrelated bounded contexts)
# 4. Checks for aggregate boundary violations
# 5. Warns about infrastructure leaking into domain
# 6. Suggests architecture fitness considerations
# =============================================================================

set -euo pipefail

HOOK_INPUT=$(cat)

TOOL_NAME=$(echo "$HOOK_INPUT" | grep -oP '"tool_name"\s*:\s*"\K[^"]+' 2>/dev/null || echo "")
FILE_PATH=$(echo "$HOOK_INPUT" | grep -oP '"file_path"\s*:\s*"\K[^"]+' 2>/dev/null || echo "")

if [ -z "$TOOL_NAME" ]; then
    TOOL_NAME=$(echo "$HOOK_INPUT" | grep -o '"tool_name":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "")
fi
if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$HOOK_INPUT" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "")
fi

if [ "$TOOL_NAME" != "Edit" ] && [ "$TOOL_NAME" != "Write" ] && [ "$TOOL_NAME" != "MultiEdit" ]; then
    exit 0
fi

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

CONTEXT_MESSAGES=()
WARNINGS=()

FILE_NAME=$(basename "$FILE_PATH")
FILE_NAME_LOWER=$(echo "$FILE_NAME" | tr '[:upper:]' '[:lower:]')
FILE_PATH_LOWER=$(echo "$FILE_PATH" | tr '[:upper:]' '[:lower:]')

# =============================================================================
# ARCHITECTURAL LAYER DETECTION
# =============================================================================

CURRENT_LAYER="unknown"

if echo "$FILE_PATH_LOWER" | grep -qE "/(domain|core|model|entities)/"; then
    CURRENT_LAYER="domain"
fi

if echo "$FILE_PATH_LOWER" | grep -qE "/(application|use-?cases|usecases)/"; then
    CURRENT_LAYER="application"
fi

if echo "$FILE_PATH_LOWER" | grep -qE "/(infrastructure|infra|adapters|persistence|repositories)/"; then
    CURRENT_LAYER="infrastructure"
fi

if echo "$FILE_PATH_LOWER" | grep -qE "/(interfaces|api|controllers|presentation|web|routes|handlers)/"; then
    CURRENT_LAYER="interfaces"
fi

# =============================================================================
# DEPENDENCY DIRECTION WARNINGS
# =============================================================================

if [ "$CURRENT_LAYER" = "domain" ]; then
    CONTEXT_MESSAGES+=("DOMAIN LAYER: This file is in the innermost layer. It must not import from application, infrastructure, or interfaces layers.")
    CONTEXT_MESSAGES+=("Domain layer checklist: no framework imports, no database imports, no HTTP imports. Only pure domain logic.")

    if echo "$FILE_NAME_LOWER" | grep -qE "(aggregate|entity|value-?object|domain-?event|domain-?service)"; then
        CONTEXT_MESSAGES+=("Domain model file: ensure business invariants are enforced here, not in services or controllers.")
    fi

    if echo "$FILE_NAME_LOWER" | grep -qE "(repository|repo)"; then
        CONTEXT_MESSAGES+=("Repository interface (port): define the contract here. Implementation (adapter) belongs in infrastructure layer.")
    fi
fi

if [ "$CURRENT_LAYER" = "application" ]; then
    CONTEXT_MESSAGES+=("APPLICATION LAYER: This file may import from domain but NOT from infrastructure or interfaces. Use dependency inversion for infrastructure needs.")
fi

if [ "$CURRENT_LAYER" = "infrastructure" ]; then
    CONTEXT_MESSAGES+=("INFRASTRUCTURE LAYER: This file implements interfaces defined in domain/application. Inner layers must not import from here.")
fi

if [ "$CURRENT_LAYER" = "interfaces" ]; then
    CONTEXT_MESSAGES+=("INTERFACES LAYER: Entry point (controller/handler). Should delegate to application layer use cases. No business logic here.")
fi

# =============================================================================
# BOUNDED CONTEXT BOUNDARY DETECTION
# =============================================================================

CONTEXT_NAME=""
if echo "$FILE_PATH_LOWER" | grep -qE "/(modules|contexts|bounded-contexts)/([^/]+)/"; then
    CONTEXT_NAME=$(echo "$FILE_PATH_LOWER" | sed -n 's|.*/\(modules\|contexts\|bounded-contexts\)/\([^/]*\)/.*|\2|p')
fi

if [ -n "$CONTEXT_NAME" ]; then
    CONTEXT_MESSAGES+=("Bounded context: $CONTEXT_NAME - ensure imports from other contexts go through published interfaces, not internal modules.")
fi

# =============================================================================
# AGGREGATE AND EVENT CHECKS
# =============================================================================

if echo "$FILE_NAME_LOWER" | grep -qE "(aggregate)"; then
    WARNINGS+=("AGGREGATE ROOT: All modifications to entities within this aggregate must go through this root.")
    CONTEXT_MESSAGES+=("Aggregate checklist: enforce invariants, keep small, reference other aggregates by ID, emit domain events for state changes.")
fi

if echo "$FILE_NAME_LOWER" | grep -qE "(event|message|command)"; then
    if echo "$FILE_PATH_LOWER" | grep -qE "/(domain|core)/"; then
        CONTEXT_MESSAGES+=("Domain event: events should be immutable value objects. Include all data consumers need.")
    fi
    if echo "$FILE_NAME_LOWER" | grep -qE "(handler|listener|subscriber|consumer)"; then
        CONTEXT_MESSAGES+=("Event handler: ensure idempotent processing. The same event delivered twice must produce the same result.")
    fi
fi

# =============================================================================
# MIGRATION AND API CHANGES
# =============================================================================

if echo "$FILE_NAME_LOWER" | grep -qE "(migration|schema)"; then
    if echo "$FILE_PATH_LOWER" | grep -qE "/(database|persistence|db|migrations)/"; then
        WARNINGS+=("DATABASE SCHEMA: Schema changes may affect aggregate boundaries. Consider backward compatibility and zero-downtime migration.")
    fi
fi

if echo "$FILE_PATH_LOWER" | grep -qE "/(api|routes|controllers|handlers|endpoints)/"; then
    CONTEXT_MESSAGES+=("API boundary: changes here affect the public contract. Consider versioning and backward compatibility.")
fi

# =============================================================================
# OUTPUT
# =============================================================================

if [ ${#CONTEXT_MESSAGES[@]} -gt 0 ] || [ ${#WARNINGS[@]} -gt 0 ]; then
    OUTPUT="{"
    FIRST_SECTION=true

    if [ ${#CONTEXT_MESSAGES[@]} -gt 0 ]; then
        OUTPUT="$OUTPUT\"additionalContext\":["
        FIRST=true
        for msg in "${CONTEXT_MESSAGES[@]}"; do
            if [ "$FIRST" = true ]; then FIRST=false; else OUTPUT="$OUTPUT,"; fi
            ESCAPED_MSG=$(echo "$msg" | sed 's/"/\\"/g')
            OUTPUT="$OUTPUT{\"type\":\"text\",\"text\":\"$ESCAPED_MSG\"}"
        done
        OUTPUT="$OUTPUT]"
        FIRST_SECTION=false
    fi

    if [ ${#WARNINGS[@]} -gt 0 ]; then
        if [ "$FIRST_SECTION" = false ]; then OUTPUT="$OUTPUT,"; fi
        OUTPUT="$OUTPUT\"systemMessage\":\"LibreArch Pre-Edit Architecture Check:\\n"
        for warn in "${WARNINGS[@]}"; do
            ESCAPED_WARN=$(echo "$warn" | sed 's/"/\\"/g')
            OUTPUT="$OUTPUT- $ESCAPED_WARN\\n"
        done
        OUTPUT="$OUTPUT\""
    fi

    OUTPUT="$OUTPUT}"
    echo "$OUTPUT"
fi

exit 0
