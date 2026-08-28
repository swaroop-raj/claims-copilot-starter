#!/usr/bin/env bash
# SessionEnd hook. Records one line per session plus a pointer to the full transcript.
#
# This is the index that makes the raw JSONL transcripts under ~/.claude/projects/
# actually findable later. Pair it with the /end-session command: this hook captures the
# mechanical facts, /end-session captures the narrative in session-log.md.
#
# Always exits 0.

set -uo pipefail

INDEX=".claude/memory/session-index.md"
JOURNAL=".claude/memory/prompt-journal.md"

payload=$(cat)
session=$(printf '%s' "$payload" | jq -r '.session_id // "unknown"' 2>/dev/null || echo unknown)
transcript=$(printf '%s' "$payload" | jq -r '.transcript_path // "unknown"' 2>/dev/null || echo unknown)
reason=$(printf '%s' "$payload" | jq -r '.reason // "unknown"' 2>/dev/null || echo unknown)

mkdir -p "$(dirname "$INDEX")" 2>/dev/null || exit 0

if [[ ! -f "$INDEX" ]]; then
  {
    echo "# Session index (local only, never committed)"
    echo
    echo "Written by .claude/hooks/session-summary.sh. One row per session, with a pointer"
    echo "to the full JSONL transcript Claude Code already keeps on this machine."
    echo
    echo "| Ended (UTC) | Session | Prompts | Files touched | Branch | Reason | Transcript |"
    echo "| --- | --- | --- | --- | --- | --- | --- |"
  } > "$INDEX"
fi

prompt_count=0
if [[ -f "$JOURNAL" ]]; then
  prompt_count=$(grep -c "session ${session:0:8})" "$JOURNAL" 2>/dev/null || echo 0
fi

files_touched=0
if [[ -f ".claude/memory/change-log.md" ]]; then
  files_touched=$(grep -c "^2" ".claude/memory/change-log.md" 2>/dev/null || echo 0)
fi

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

printf '| %s | %s | %s | %s | %s | %s | `%s` |\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  "${session:0:8}" \
  "$prompt_count" \
  "$files_touched" \
  "$branch" \
  "$reason" \
  "$transcript" >> "$INDEX"

exit 0
