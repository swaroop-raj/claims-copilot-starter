#!/usr/bin/env bash
# PreToolUse hook on Bash. Blocks destructive commands deterministically.
#
# Contract: reads the hook payload as JSON on stdin. Exit 0 allows the command,
# exit 2 blocks it and returns stderr to Claude as the reason. Any pattern this
# script does not recognize is allowed, so it fails open on parsing and closed on
# a known-bad match.

set -uo pipefail

payload=$(cat)
command=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

[[ -z "$command" ]] && exit 0

block() {
  echo "BLOCKED by guard-bash.sh: $1" >&2
  echo "Command: $command" >&2
  echo "If this is genuinely required, ask the user to run it manually." >&2
  exit 2
}

# Recursive deletes
[[ "$command" =~ rm[[:space:]]+(-[a-zA-Z]*[rR][a-zA-Z]*[[:space:]]+)+ ]] && block "recursive delete"

# Force pushes and history rewrites
[[ "$command" =~ git[[:space:]]+push.*--force ]] && block "force push"
[[ "$command" =~ git[[:space:]]+push.*-f([[:space:]]|$) ]] && block "force push"
[[ "$command" =~ git[[:space:]]+reset[[:space:]]+--hard ]] && block "hard reset"
[[ "$command" =~ git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*[fd] ]] && block "git clean"

# Destructive SQL
upper=$(printf '%s' "$command" | tr '[:lower:]' '[:upper:]')
[[ "$upper" =~ DROP[[:space:]]+(TABLE|DATABASE|SCHEMA) ]] && block "destructive DDL"
[[ "$upper" =~ TRUNCATE[[:space:]] ]] && block "truncate"
[[ "$upper" =~ DELETE[[:space:]]+FROM[[:space:]]+AUDIT_EVENTS ]] && block "audit_events is append-only"

# Volume-destroying docker teardown
[[ "$command" =~ docker[[:space:]]+compose[[:space:]]+down.*-v ]] && block "docker teardown with volume loss"

# Writes against anything that looks like a non-local database
if [[ "$command" =~ psql ]]; then
  if [[ ! "$command" =~ (localhost|127\.0\.0\.1) ]]; then
    block "psql against a non-local host"
  fi
fi

# Privilege escalation
[[ "$command" =~ (^|[[:space:]])sudo([[:space:]]|$) ]] && block "sudo"

# Piping the internet into a shell
[[ "$command" =~ (curl|wget).*\|[[:space:]]*(ba)?sh ]] && block "curl piped to shell"

exit 0
