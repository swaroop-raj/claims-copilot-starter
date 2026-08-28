---
description: Plan a feature before writing any code
---

Plan the feature described in $ARGUMENTS. Write no code in this response.

Use subagents for investigation so this context stays clean.

1. **Read the contracts.** Find the stub modules involved and quote their docstring
   contracts. Those are the interface you must honor.
2. **Read the rules.** Load every `.claude/rules/` file matching the paths you will
   touch. Name the constraints that bind this feature.
3. **Investigate.** Delegate to a subagent: how is this wired today, what already
   exists, what will break. Report the summary, not the file dump.
4. **Present the plan:**
   - Files created, files modified, one line each on why
   - The vertical slice order, so something works end to end early
   - Guardrails this touches and how each stays intact
   - Tests that will prove it works, including the failure paths
   - Eval cases needed, if this is model-adjacent
   - What could go wrong, ranked by likelihood
5. **Flag the decisions you need from me** before you can start. Give a recommendation
   with each one.

If this touches `core/security/`, `core/pii/`, or `db/`, say explicitly that plan mode
approval is required.

Then stop and wait for approval.
