---
description: Verify work is actually done before calling it done
---

Run the full done-check on the current work. Report results, fix nothing silently.

1. `make lint` - report every failure, do not auto-fix without telling me what changed.
2. `make test` - full pass required. A skipped test is a failure until justified.
3. `make eval` if anything model-adjacent changed. Report scores against
   `evals/thresholds.yaml`.
4. Use the **adversarial-reviewer** subagent on the diff. Paste its verdict in full,
   including the NOT CHECKED section.
5. If the diff touches `core/security/`, `core/pii/`, `core/audit/`, `api/middleware/`,
   `.claude/settings.json`, or `.claude/hooks/`, also use the **security-reviewer**
   subagent. Paste its findings in full.
6. Confirm each guardrail in `.claude/rules/guardrails.md` that this diff could affect
   still holds, and name the test that proves it.
7. Check for orphans: files added and never imported, config added and never read.
8. Propose the commit message in Conventional Commits format with the `agent:brain`
   scope, one logical change per commit. Split the diff if it is doing two things.

End with a single verdict: **ship** or **not yet**, and if not yet, the shortest path to yes.
