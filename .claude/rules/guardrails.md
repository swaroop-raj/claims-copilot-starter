---
description: Hard limits that apply to the whole repo. Never relax these without a written decision record.
---

# Guardrails

These are the rules that, if broken, make the system unshippable. Advisory rules go
elsewhere. Anything here that can be enforced mechanically is also a hook or a deny
rule in `.claude/settings.json`, because instructions are advisory and hooks are not.

## Data

- Unredacted text never leaves the process. Redaction is upstream of the LLM layer.
- No real claim data in the repo, in tests, in fixtures, or in eval datasets.
- No PII in logs, audit events, error messages, or exception payloads.
- Audit events store `claim_id`, `request_id`, actor, decision, and content hashes.
  Never the content itself.

## Model

- Portkey is the only gateway. `import openai` outside `core/llm/portkey_client.py`
  is a bug.
- Temperature stays at or below 0.2 for anything user-facing. Grounded answers, not prose.
- No model call without a retrieval step behind it. If retrieval returns nothing,
  the answer is "I could not find this in the claim record", not a guess.
- Token and cost budgets live in `core/config.py`. Exceeding a budget raises, it does
  not silently truncate.

## Authorization

- Every claim query resolves an authorization decision before retrieval, never after.
- Deny by default. An unknown actor or unknown claim is a denial, not an allow.
- Authorization decisions are audited whether they pass or fail.

## Human in the loop

Escalate to HITL, do not answer, when any of these are true:

- Retrieval confidence is below the configured floor.
- The question implies a payout, denial, or coverage determination.
- Authorization is partial rather than clean.
- The injection detector flags the input but the request is otherwise valid.

## Change control

- Changes to `core/security/`, `core/pii/`, or `db/` require plan mode and an
  adversarial review pass before they count as done.
- Loosening a guardrail requires an ADR in `docs/decisions/` explaining the tradeoff.
