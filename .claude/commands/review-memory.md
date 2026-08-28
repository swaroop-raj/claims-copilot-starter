---
description: Mine the prompt journal for rules, skills, and hooks worth creating
---

Review how I have actually been prompting on this project and tell me what to systematize.
Do not write code.

1. Read `.claude/memory/prompt-journal.md`. If it does not exist, say so and stop, the
   capture hook has not run yet.
2. Read `.claude/memory/session-index.md` for session count and cadence.
3. Read `CLAUDE.md` and every file in `.claude/rules/` so you know what is already codified.
4. Analyze the journal and report:
   - **Repeated context.** Anything I explained more than twice that is already in a rule
     file. That means the rule exists but is not landing, so name the likely reason:
     buried, ambiguous, or contradicted elsewhere.
   - **Missing rules.** Constraints I keep restating that appear nowhere. Draft the exact
     line and name the file it belongs in.
   - **Missing skills.** Multi-step processes I walked through more than once. Name the
     steps.
   - **Missing hooks.** Corrections I made repeatedly that could be enforced
     mechanically instead of remembered.
   - **Prompt quality.** Where my prompts were too vague to act on cleanly, with a
     rewritten version of the worst offender.
5. Rank every recommendation by how much friction it removes, and be honest when the
   answer is "nothing yet, not enough signal".

Then stop. I will decide what to implement.
