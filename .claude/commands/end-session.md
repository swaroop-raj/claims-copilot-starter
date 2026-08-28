---
description: Capture what happened and leave the next session informed
---

Close out this session. Be honest about what is unfinished.

1. Run `git status` and `git diff --stat` to see what actually changed.
2. Append an entry to `.claude/memory/session-log.md` using the template there:
   goal, done, in flight, blocked, next. "In flight" means half-finished with a
   specific file and line, not a vague area.
3. If any architectural choice was made, add a one-line entry to
   `.claude/memory/decisions.md`. If it has real weight, draft an ADR in
   `docs/decisions/` instead.
4. If something went wrong and the fix is generalizable, add it to
   `.claude/memory/lessons.md`. If that lesson has now appeared three times, propose
   promoting it into `.claude/rules/` or a hook.
5. If CLAUDE.md is now stale or over 200 lines, say so and propose the specific cuts.
6. Report anything uncommitted and whether it is safe to leave that way.

Do not commit anything unless asked.
