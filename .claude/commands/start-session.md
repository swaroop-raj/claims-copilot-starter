---
description: Load context and orient before starting work
---

Start this session by orienting yourself. Do not write code yet.

1. Read `.claude/memory/session-log.md` and report the last entry: what was in flight,
   what was blocked, and what the stated next action was.
2. Read `.claude/memory/lessons.md` and name any lesson relevant to today's likely work.
3. Run `git log --oneline -10` and `git status` and summarize where the tree stands.
4. Run `make up` if Postgres is not already running, then confirm with `docker compose ps`.
5. Run `/context` and confirm which memory files actually loaded. If a rule file is
   missing, say so, that is a real problem worth fixing before anything else.
6. State in one paragraph: where the project stands, and the single highest-value next
   action with a reason.

Then stop and wait for direction.
