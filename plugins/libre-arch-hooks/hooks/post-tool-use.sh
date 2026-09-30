#!/usr/bin/env bash
# libre-arch-hooks: PostToolUse
#
# After Claude edits or writes a source file, scan it for architecture
# problems and hand any findings back to Claude as context:
#   - dependency direction (domain or application importing infrastructure)
#   - web framework or ORM imports inside the domain layer
#   - imports from another bounded context's internals
#   - many conditionals in the interfaces layer (logic in the wrong place)
#   - large files, many methods, many imports (low-severity hints, added
#     only when one of the checks above already found something)
# Silent when nothing is found. Writes no files.
set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input="$(cat)"

tool="$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null)"
case "$tool" in Edit|Write|MultiEdit) ;; *) exit 0 ;; esac

file="$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null)"
[[ -n "$file" && -f "$file" ]] || exit 0

case "${file##*.}" in
  ts|js|tsx|jsx|mjs|cjs|py|go|java|kt|rs|rb|cs) ;;
  *) exit 0 ;;
esac

content="$(head -c 102400 "$file")"
cwd="$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)"
rel="$file"
[[ -n "$cwd" ]] && rel="${file#"$cwd"/}"
lower="/$(tr '[:upper:]' '[:lower:]' <<<"$rel")"

# The layer is the innermost directory on the path (relative to the project)
# that names one.
layer="unknown"
IFS='/' read -r -a parts <<<"$(dirname "$lower")"
for part in "${parts[@]}"; do
  case "$part" in
    domain|core|model|entities) layer="domain" ;;
    application|use-cases|usecases|usecase) layer="application" ;;
    infrastructure|infra|adapters|persistence) layer="infrastructure" ;;
    interfaces|api|controllers|presentation|web) layer="interfaces" ;;
  esac
done

findings=()
hints=()
code="$(grep -vE '^\s*(//|/\*|\*|#)' <<<"$content")"

if [[ "$layer" == "domain" ]]; then
  grep -qE "from\s+['\"].*/(infrastructure|infra|adapters|persistence)" <<<"$code" \
    && findings+=("[critical] Dependency violation: the domain layer imports from infrastructure. Dependencies must point inward.")
  grep -qE "from\s+['\"].*/(interfaces|api|controllers|presentation)" <<<"$code" \
    && findings+=("[critical] Dependency violation: the domain layer imports from the interfaces layer.")
  grep -qE "from\s+['\"](express|@nestjs|fastify|django|flask)" <<<"$content" \
    && findings+=("[high] Framework coupling: the domain layer imports a web framework. Keep the domain framework-independent.")
  grep -qE "from\s+['\"](typeorm|@prisma|sequelize|mongoose|drizzle)" <<<"$content" \
    && findings+=("[high] ORM coupling: the domain layer imports an ORM. Database concerns belong in infrastructure.")
fi

if [[ "$layer" == "application" ]]; then
  grep -qE "from\s+['\"].*/(infrastructure|infra|adapters|persistence)" <<<"$code" \
    && findings+=("[high] Dependency violation: the application layer imports from infrastructure. Depend on a port and inject the adapter.")
fi

ctx="$(sed -nE 's#.*/(modules|contexts)/([^/]+)/.*#\2#p' <<<"$lower")"
if [[ -n "$ctx" ]]; then
  cross="$(grep -E "from\s+['\"].*/(modules|contexts)/[^/]+/(domain|application|infrastructure)/" <<<"$code" | grep -v "/$ctx/")"
  [[ -n "$cross" ]] && findings+=("[high] Cross-context coupling: this file imports another bounded context's internals. Use its published interface or events.")
fi

if [[ "$layer" == "interfaces" ]]; then
  conds="$(grep -cE 'if\s*\(|switch\s*\(' <<<"$content")"
  (( conds > 5 )) && findings+=("[medium] Logic placement: $conds conditionals in the interfaces layer. Business rules belong in the domain or application layer.")
fi

(( ${#findings[@]} > 0 )) || exit 0

lines="$(wc -l <<<"$content")"
(( lines > 500 )) && hints+=("[low] Large file: $lines lines. Consider splitting it into smaller, cohesive units.")
methods="$(grep -cE '^\s+(public|private|protected|async|static)?\s*[a-z][a-zA-Z]*\s*\(' <<<"$content")"
(( methods > 15 )) && hints+=("[low] Many methods: $methods. Consider extracting cohesive groups into separate classes.")

imports="$(grep -cE '^(import|from)\s' <<<"$content")"
(( imports > 20 )) && hints+=("[low] Many imports: $imports, a sign of high coupling.")

msg="LibreArch scan of $(basename "$file") (layer: $layer):"
for f in "${findings[@]}" "${hints[@]}"; do msg+=$'\n'"- $f"; done

jq -n --arg ctx "$msg" '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $ctx}}'
exit 0
