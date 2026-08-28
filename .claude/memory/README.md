# `.claude/memory/`

Four memory surfaces, two of which are committed and two of which never are.

| File | Written by | Committed | Purpose |
| --- | --- | --- | --- |
| `session-log.md` | you, via `/end-session` | yes | narrative continuity between sessions |
| `decisions.md` | you, via `/end-session` | yes | architectural choices and consequences |
| `lessons.md` | you, when something breaks | yes | mistakes encoded so they stop recurring |
| `change-log.md` | `log-changes.sh` hook | yes | append-only log of file mutations (paths only) |
| `prompt-journal.md` | `capture-prompt.sh` hook | **no** | every prompt you sent, scrubbed |
| `session-index.md` | `session-summary.sh` hook | **no** | one row per session + transcript pointer |

## Why the split

The committed files are *distilled*: decisions, lessons, state. They are safe to share
and they are what a teammate or a future session actually needs.

The uncommitted files are *raw*: your literal prompts and session metadata. In a
PII-heavy claims project, raw prompt text is exactly the kind of thing
`.claude/rules/guardrails.md` says never to put somewhere shareable. `capture-prompt.sh`
scrubs obvious secret and PII shapes, but scrubbing is defense in depth, not permission
to commit the file.

## Native auto memory

Separate from all of the above, Claude Code maintains its own auto memory. This project
pins it explicitly in `.claude/settings.json`:

```json
{
  "autoMemoryEnabled": true,
  "autoMemoryDirectory": "~/.claude/memory/claims-copilot-starter"
}
```

That directory holds learnings Claude accumulates on its own: patterns it noticed, your
preferences, debugging context. Note the path must be absolute or start with `~/`, so it
cannot live inside the repo. That is a feature here, not a limitation, since it keeps
accumulated context off the shared branch.

To inspect or toggle it in a session, run `/memory`.

## The habit that makes this pay off

Once a week, skim `prompt-journal.md` and ask one question: **what did I have to explain
more than twice?**

- Explained the same constraint repeatedly -> it belongs in `CLAUDE.md` or a rule file.
- Walked through the same multi-step process repeatedly -> it belongs in a skill.
- Corrected the same mistake repeatedly -> it belongs in a hook, where it is enforced
  rather than suggested.

That loop is the entire reason to capture prompts. Without it you are just hoarding logs.
