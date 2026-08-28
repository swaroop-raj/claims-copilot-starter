#!/usr/bin/env bash
# PostToolUse hook on Write and Edit. Formats and auto-fixes only the touched file.
#
# Always exits 0. A formatter failure must never block real work, it just prints
# a note that Claude can read and act on.

set -uo pipefail

payload=$(cat)
path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)

[[ -z "$path" ]] && exit 0
[[ ! -f "$path" ]] && exit 0

case "$path" in
  *.py) ;;
  *.json|*.md|*.yaml|*.yml)
    if command -v prettier >/dev/null 2>&1; then
      prettier --write "$path" >/dev/null 2>&1 || echo "prettier could not format $path"
    fi
    exit 0
    ;;
  *) exit 0 ;;
esac

if ! command -v ruff >/dev/null 2>&1; then
  echo "ruff not installed, skipping format. Run 'make install'."
  exit 0
fi

ruff format "$path" >/dev/null 2>&1 || echo "ruff format failed on $path"
ruff check --fix --quiet "$path" 2>&1 | head -20 || true

exit 0
