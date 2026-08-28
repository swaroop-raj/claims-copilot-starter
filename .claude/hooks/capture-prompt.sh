#!/usr/bin/env bash
# UserPromptSubmit hook. Appends every prompt you send to a LOCAL-ONLY journal.
#
# Why this exists: Claude Code keeps full session transcripts as JSONL under
# ~/.claude/projects/, but those are machine-shaped and hard to skim. This gives you a
# readable record of how you actually prompted, which is the raw material for improving
# your CLAUDE.md, your rules, and your skills.
#
# SAFETY: the journal is gitignored and must stay that way. This project is PII-heavy
# and `.claude/rules/guardrails.md` forbids logging raw prompt content into anything
# shareable. This script scrubs obvious secret shapes as a second line of defense, but
# scrubbing is not a substitute for keeping the file untracked.
#
# Always exits 0. Capture is a convenience and must never block your work.

set -uo pipefail

JOURNAL=".claude/memory/prompt-journal.md"
MAX_CHARS="${CLAUDE_PROMPT_JOURNAL_MAX_CHARS:-4000}"

# Opt out for a session with: export CLAUDE_PROMPT_JOURNAL=off
[[ "${CLAUDE_PROMPT_JOURNAL:-on}" == "off" ]] && exit 0

payload=$(cat)
prompt=$(printf '%s' "$payload" | jq -r '.prompt // .user_prompt // empty' 2>/dev/null || true)
session=$(printf '%s' "$payload" | jq -r '.session_id // "unknown"' 2>/dev/null || echo unknown)

[[ -z "$prompt" ]] && exit 0

mkdir -p "$(dirname "$JOURNAL")" 2>/dev/null || exit 0

if [[ ! -f "$JOURNAL" ]]; then
  {
    echo "# Prompt journal (local only, never committed)"
    echo
    echo "Written by .claude/hooks/capture-prompt.sh. Read it when you want to improve how"
    echo "you prompt: repeated instructions here belong in CLAUDE.md, .claude/rules/, or a skill."
    echo
    echo "---"
    echo
  } > "$JOURNAL"
fi

# Scrub secret shapes before anything touches disk.
scrubbed=$(printf '%s' "$prompt" \
  | sed -E 's/sk-[A-Za-z0-9_-]{20,}/[REDACTED_KEY]/g' \
  | sed -E 's/(gh[pousr])_[A-Za-z0-9]{20,}/[REDACTED_TOKEN]/g' \
  | sed -E 's/(pk_live|sk_live)_[A-Za-z0-9]{16,}/[REDACTED_KEY]/g' \
  | sed -E 's#postgres(ql)?://[^:@/]+:[^:@/]+@#postgresql://[REDACTED_CREDS]@#g' \
  | sed -E 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/[REDACTED_EMAIL]/g' \
  | sed -E 's/\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b/[REDACTED_SSN]/g' \
  | sed -E 's/\b\+?[0-9]{1,2}-?[0-9]{3}-?[0-9]{3}-?[0-9]{4}\b/[REDACTED_PHONE]/g')

# Truncate so one pasted document does not swallow the journal.
if (( ${#scrubbed} > MAX_CHARS )); then
  scrubbed="${scrubbed:0:MAX_CHARS}"$'\n\n[... truncated, see the full transcript in ~/.claude/projects/]'
fi

{
  printf '## %s (session %s)\n\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${session:0:8}"
  printf '%s\n\n' "$scrubbed"
  printf -- '---\n\n'
} >> "$JOURNAL"

exit 0
