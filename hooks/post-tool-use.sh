#!/bin/bash
# =============================================================================
# LibreArch Post Tool Use Hook
# =============================================================================
# Runs AFTER Edit/Write/MultiEdit operations.
# Scans modified code for architecture violations using pattern matching.
# Checks dependency direction, coupling, and structural fitness.
#
# What this hook does:
# 1. Checks for dependency direction violations (domain importing infra)
# 2. Detects framework coupling in domain layer
# 3. Flags anemic domain model patterns
# 4. Identifies god class indicators
# 5. Checks for cross-context direct imports
# 6. Detects missing abstraction patterns
# 7. Warns about business logic in wrong layers
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

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

HOOKS_LOG_DIR="${LIBREARCH_HOOKS_DIR:-$(dirname "$0")}/logs"
mkdir -p "$HOOKS_LOG_DIR"

FILE_EXT="${FILE_PATH##*.}"
FILE_NAME=$(basename "$FILE_PATH")
FILE_PATH_LOWER=$(echo "$FILE_PATH" | tr '[:upper:]' '[:lower:]')

# Skip non-code files
case "$FILE_EXT" in
    ts|js|tsx|jsx|mjs|cjs|py|go|java|kt|rs|rb|cs) ;;
    *) exit 0 ;;
esac

CRITICAL=()
HIGH=()
MEDIUM=()
LOW=()

FILE_SIZE=$(stat -c%s "$FILE_PATH" 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -gt 102400 ]; then
    FILE_CONTENT=$(head -c 102400 "$FILE_PATH")
else
    FILE_CONTENT=$(cat "$FILE_PATH")
fi

CURRENT_LAYER="unknown"
if echo "$FILE_PATH_LOWER" | grep -qE "/(domain|core|model|entities)/"; then CURRENT_LAYER="domain"; fi
if echo "$FILE_PATH_LOWER" | grep -qE "/(application|use-?cases|usecases)/"; then CURRENT_LAYER="application"; fi
if echo "$FILE_PATH_LOWER" | grep -qE "/(infrastructure|infra|adapters|persistence)/"; then CURRENT_LAYER="infrastructure"; fi
if echo "$FILE_PATH_LOWER" | grep -qE "/(interfaces|api|controllers|presentation|web)/"; then CURRENT_LAYER="interfaces"; fi

# =============================================================================
# DEPENDENCY DIRECTION VIOLATIONS
# =============================================================================

if [ "$CURRENT_LAYER" = "domain" ]; then
    if echo "$FILE_CONTENT" | grep -E "from\s+['\"].*/(infrastructure|infra|adapters|persistence)" 2>/dev/null | grep -qvE "^\s*//|^\s*/\*|^\s*#" 2>/dev/null; then
        CRITICAL+=("DEPENDENCY VIOLATION: Domain layer imports from infrastructure. Dependencies must point inward.")
    fi

    if echo "$FILE_CONTENT" | grep -E "from\s+['\"].*/(interfaces|api|controllers|presentation)" 2>/dev/null | grep -qvE "^\s*//|^\s*/\*|^\s*#" 2>/dev/null; then
        CRITICAL+=("DEPENDENCY VIOLATION: Domain layer imports from interfaces layer.")
    fi

    if echo "$FILE_CONTENT" | grep -qE "from\s+['\"]express|from\s+['\"]@nestjs|from\s+['\"]fastify|from\s+['\"]django|from\s+['\"]flask" 2>/dev/null; then
        HIGH+=("FRAMEWORK COUPLING: Domain layer imports a web framework. Domain must be framework-independent.")
    fi

    if echo "$FILE_CONTENT" | grep -qE "from\s+['\"]typeorm|from\s+['\"]@prisma|from\s+['\"]sequelize|from\s+['\"]mongoose|from\s+['\"]drizzle" 2>/dev/null; then
        HIGH+=("ORM COUPLING: Domain layer imports an ORM. Database concerns belong in infrastructure.")
    fi
fi

if [ "$CURRENT_LAYER" = "application" ]; then
    if echo "$FILE_CONTENT" | grep -E "from\s+['\"].*/(infrastructure|infra|adapters|persistence)" 2>/dev/null | grep -qvE "^\s*//|^\s*/\*|^\s*#" 2>/dev/null; then
        HIGH+=("DEPENDENCY VIOLATION: Application layer imports from infrastructure. Use dependency inversion.")
    fi
fi

# =============================================================================
# STRUCTURAL METRICS
# =============================================================================

LINE_COUNT=$(echo "$FILE_CONTENT" | wc -l)

if [ "$LINE_COUNT" -gt 500 ]; then
    MEDIUM+=("LARGE FILE: $LINE_COUNT lines. Consider splitting into smaller, cohesive units.")
fi

METHOD_COUNT=$(echo "$FILE_CONTENT" | grep -cE "^\s+(public|private|protected|async|static)?\s*[a-z][a-zA-Z]*\s*\(" 2>/dev/null || echo "0")
if [ "$METHOD_COUNT" -gt 15 ]; then
    MEDIUM+=("MANY METHODS: $METHOD_COUNT methods. Consider extracting cohesive groups into separate classes.")
fi

IMPORT_COUNT=$(echo "$FILE_CONTENT" | grep -cE "^import\s|^from\s" 2>/dev/null || echo "0")
if [ "$IMPORT_COUNT" -gt 20 ]; then
    LOW+=("MANY IMPORTS: $IMPORT_COUNT imports. High import count suggests high coupling.")
fi

# =============================================================================
# CROSS-CONTEXT COUPLING
# =============================================================================

CURRENT_CTX=""
if echo "$FILE_PATH_LOWER" | grep -qE "/(modules|contexts)/([^/]+)/"; then
    CURRENT_CTX=$(echo "$FILE_PATH_LOWER" | sed -n 's|.*/\(modules\|contexts\)/\([^/]*\)/.*|\2|p')
fi

if [ -n "$CURRENT_CTX" ]; then
    if echo "$FILE_CONTENT" | grep -E "from\s+['\"].*/(modules|contexts)/[^/]+/(domain|application|infrastructure)/" 2>/dev/null | grep -qvE "/$CURRENT_CTX/" 2>/dev/null; then
        HIGH+=("CROSS-CONTEXT COUPLING: Importing internal modules from another bounded context. Use published interfaces or events.")
    fi
fi

# =============================================================================
# BUSINESS LOGIC PLACEMENT
# =============================================================================

if [ "$CURRENT_LAYER" = "interfaces" ]; then
    COND_COUNT=$(echo "$FILE_CONTENT" | grep -cE "if\s*\(|switch\s*\(" 2>/dev/null || echo "0")
    if [ "$COND_COUNT" -gt 5 ]; then
        MEDIUM+=("LOGIC PLACEMENT: Multiple conditionals ($COND_COUNT) in interfaces layer. Business logic should live in domain or application layer.")
    fi
fi

# =============================================================================
# OUTPUT
# =============================================================================

TOTAL_FINDINGS=$(( ${#CRITICAL[@]} + ${#HIGH[@]} + ${#MEDIUM[@]} + ${#LOW[@]} ))

if [ "$TOTAL_FINDINGS" -gt 0 ]; then
    {
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Architecture scan of $FILE_PATH (layer: $CURRENT_LAYER)"
        echo "  Findings: $TOTAL_FINDINGS (C:${#CRITICAL[@]} H:${#HIGH[@]} M:${#MEDIUM[@]} L:${#LOW[@]})"
        for f in "${CRITICAL[@]}"; do echo "  [CRITICAL] $f"; done
        for f in "${HIGH[@]}"; do echo "  [HIGH] $f"; done
        for f in "${MEDIUM[@]}"; do echo "  [MEDIUM] $f"; done
        for f in "${LOW[@]}"; do echo "  [LOW] $f"; done
        echo "---"
    } >> "$HOOKS_LOG_DIR/architecture-issues.log"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Scanned: $FILE_PATH (layer: $CURRENT_LAYER, findings: $TOTAL_FINDINGS)" >> "$HOOKS_LOG_DIR/scan-activity.log"

if [ "$TOTAL_FINDINGS" -gt 0 ]; then
    OUTPUT="{"

    if [ ${#CRITICAL[@]} -gt 0 ] || [ ${#HIGH[@]} -gt 0 ] || [ ${#MEDIUM[@]} -gt 0 ]; then
        OUTPUT="$OUTPUT\"systemMessage\":\"LibreArch Architecture Scan ($TOTAL_FINDINGS findings):\\n"
        if [ ${#CRITICAL[@]} -gt 0 ]; then
            OUTPUT="$OUTPUT\\n[CRITICAL]\\n"
            for f in "${CRITICAL[@]}"; do
                E=$(echo "$f" | sed 's/"/\\"/g')
                OUTPUT="$OUTPUT- $E\\n"
            done
        fi
        if [ ${#HIGH[@]} -gt 0 ]; then
            OUTPUT="$OUTPUT\\n[HIGH]\\n"
            for f in "${HIGH[@]}"; do
                E=$(echo "$f" | sed 's/"/\\"/g')
                OUTPUT="$OUTPUT- $E\\n"
            done
        fi
        if [ ${#MEDIUM[@]} -gt 0 ]; then
            OUTPUT="$OUTPUT\\n[MEDIUM]\\n"
            for f in "${MEDIUM[@]}"; do
                E=$(echo "$f" | sed 's/"/\\"/g')
                OUTPUT="$OUTPUT- $E\\n"
            done
        fi
        OUTPUT="$OUTPUT\""
    fi

    if [ ${#LOW[@]} -gt 0 ]; then
        if [ ${#CRITICAL[@]} -gt 0 ] || [ ${#HIGH[@]} -gt 0 ] || [ ${#MEDIUM[@]} -gt 0 ]; then
            OUTPUT="$OUTPUT,"
        fi
        OUTPUT="$OUTPUT\"additionalContext\":["
        FIRST=true
        for f in "${LOW[@]}"; do
            if [ "$FIRST" = true ]; then FIRST=false; else OUTPUT="$OUTPUT,"; fi
            E=$(echo "$f" | sed 's/"/\\"/g')
            OUTPUT="$OUTPUT{\"type\":\"text\",\"text\":\"[LOW] $E\"}"
        done
        OUTPUT="$OUTPUT]"
    fi

    OUTPUT="$OUTPUT}"
    echo "$OUTPUT"
fi

exit 0
