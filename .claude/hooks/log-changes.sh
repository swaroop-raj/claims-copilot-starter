#!/usr/bin/env bash
# PostToolUse hook on Write and Edit. Appends every mutation to the change log.
#
# This is the local mirror of the audit story the application itself implements.
# Always exits 0.

set -uo pipefail

LOG=".claude/memory/change-log.md"

payload=$(cat)
path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
tool=$(printf '%s' "$payload" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo unknown)

[[ -z "$path" ]] && exit 0
[[ ! -f "$LOG" ]] && exit 0

printf '%s | %s | %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$tool" "$path" >> "$LOG"

exit 0
