# Session log

Rolling log of what happened, so the next session starts informed instead of guessing.
Read at session start, append at session end. Trim entries older than a month.

Use `/start-session` and `/end-session` to keep this current.

---

## Template

```
## YYYY-MM-DD

**Goal:** what I set out to do
**Done:** what actually shipped
**In flight:** what is half-finished and where it stands
**Blocked:** what is stuck and on what
**Next:** the single next action
```

---

## 2026-08-28 (scaffold)

**Goal:** stand up the Claude Code starter for the claims copilot.
**Done:** repo scaffold, control layer, contract stubs, docs, tutorial README.
**In flight:** nothing. Every module is a contract-only stub by design.
**Blocked:** nothing.
**Next:** run `make up && make install && make migrate`, then build `GET /health`
end to end as the first vertical slice. See the first-session walkthrough in the README.
