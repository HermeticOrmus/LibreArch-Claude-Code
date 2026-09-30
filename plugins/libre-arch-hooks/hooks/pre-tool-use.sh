#!/usr/bin/env bash
# libre-arch-hooks: PreToolUse
#
# Claude Code sends the tool call as JSON on stdin. When a Read, Edit, Write,
# or MultiEdit targets a file that usually holds secrets (.env files, .pem or
# .key files, credentials or secrets files), ask the user before it runs.
# Every other call passes through silently.
set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input="$(cat)"

tool="$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null)"
case "$tool" in Read|Edit|Write|MultiEdit) ;; *) exit 0 ;; esac

path="$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null)"
[[ -n "$path" ]] || exit 0

cwd="$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)"
rel="$path"
[[ -n "$cwd" ]] && rel="${path#"$cwd"/}"
base="$(basename "$path")"
lower="$(tr '[:upper:]' '[:lower:]' <<<"$rel")"
lbase="$(tr '[:upper:]' '[:lower:]' <<<"$base")"

sensitive=""
case "$lbase" in
  .env.example|.env.sample|.env.template|.env.dist) ;;
  .env|.env.*) sensitive="an environment file" ;;
  *.pem|*.key) sensitive="a private key or certificate file" ;;
esac
if [[ -z "$sensitive" ]]; then
  case "$lbase" in
    *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.py|*.go|*.java|*.kt|*.rs|*.rb|*.cs|*.md) ;;
    *) grep -qE '(^|/)[^/]*(credential|secret)[^/]*(/|$)' <<<"$lower" && sensitive="a credentials or secrets file" ;;
  esac
fi
[[ -n "$sensitive" ]] || exit 0

jq -n --arg reason "LibreArch: $base looks like $sensitive. Confirm before Claude reads or changes it." \
  '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $reason}}'
exit 0
