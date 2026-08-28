#!/usr/bin/env bash
# PreToolUse hook on Write and Edit. Blocks secrets from ever entering the tree.
#
# Exit 0 allows the write, exit 2 blocks it. Checks both the target path and the
# content being written.

set -uo pipefail

payload=$(cat)
path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
content=$(printf '%s' "$payload" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null || true)

block() {
  echo "BLOCKED by block-secrets.sh: $1" >&2
  echo "Target: ${path:-unknown}" >&2
  echo "Put real credentials in your shell profile or .env, never in a tracked file." >&2
  exit 2
}

# Protected paths
case "$path" in
  *"/.env"|*"/.env."*|".env"|".env."*) block ".env files are never written by the agent" ;;
  *.pem|*.key|*.p12|*.keystore)         block "credential file" ;;
  */data/production/*)                  block "production data directory" ;;
  *".claude/memory/change-log.md")      block "hook-generated audit file" ;;
  *".claude/memory/prompt-journal.md")  block "hook-generated prompt journal, local only" ;;
  *".claude/memory/session-index.md")   block "hook-generated session index, local only" ;;
esac

[[ -z "$content" ]] && exit 0

# Live key shapes. Example and placeholder values are allowed on purpose.
if printf '%s' "$content" | grep -Eq 'sk-[A-Za-z0-9_-]{20,}'; then
  printf '%s' "$content" | grep -Eqi '(example|placeholder|your[-_]?key|xxx|redacted|\.\.\.)' || block "OpenAI-style secret key"
fi
if printf '%s' "$content" | grep -Eq '(pk_live|sk_live)_[A-Za-z0-9]{16,}'; then
  block "live publishable or secret key"
fi
if printf '%s' "$content" | grep -Eq 'PORTKEY_API_KEY[[:space:]]*=[[:space:]]*["'\'']?[A-Za-z0-9+/_-]{20,}'; then
  printf '%s' "$content" | grep -Eqi '(example|placeholder|your|xxx)' || block "hardcoded Portkey key"
fi
if printf '%s' "$content" | grep -Eq '(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}'; then
  block "GitHub token"
fi
if printf '%s' "$content" | grep -Eq 'BEGIN [A-Z ]*PRIVATE KEY'; then
  block "private key block"
fi
# Connection strings with an embedded password against a remote host
if printf '%s' "$content" | grep -Eq 'postgres(ql)?://[^:@/]+:[^:@/]+@'; then
  printf '%s' "$content" | grep -Eq 'postgres(ql)?://[^:@/]+:[^:@/]+@(localhost|127\.0\.0\.1|db|postgres)' || block "remote connection string with credentials"
fi

exit 0
