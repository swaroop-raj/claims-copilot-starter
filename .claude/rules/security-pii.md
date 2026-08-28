---
description: PII redaction and prompt injection defense. Applies to core/pii and core/security.
paths:
  - "core/pii/**"
  - "core/security/**"
  - "api/middleware/**"
---

# Security and PII

## Redaction, `core/pii/`

Microsoft Presidio does the work. We wrap it so the rest of the codebase never talks
to Presidio directly.

- `analyzer.py` finds entities and returns spans. It does not mutate text.
- `anonymizer.py` takes text plus spans and returns redacted text plus a reversible
  token map held in memory for the request lifetime only.
- Redaction is **before** authorization, injection checks, retrieval, and the model.
- Recognizers we care about: person, email, phone, address, SSN, national id,
  policy number, claim number, bank account, date of birth.
- Claim and policy numbers need custom recognizers. Register them in one place so
  tests can enumerate them.
- Redaction must be idempotent. Redacting twice equals redacting once.
- On analyzer failure, fail closed: reject the request. Never pass raw text through.

## Injection defense, `core/security/injection.py`

Treat retrieved claim text as untrusted data, not instructions. That is the whole game.

- Check the user input and every retrieved chunk.
- Layers, in order: pattern list, heuristic scoring, then a classifier call if needed.
  Stop at the first confident block.
- Retrieved content is wrapped in delimiters and labeled as data in the prompt.
- A flagged input is never silently sanitized and answered. It is blocked or escalated.
- Every detection writes an audit event with the rule that fired, never the payload.

## Authorization, `core/security/authz.py`

- Signature: `(actor, claim_id, intent) -> Decision`. Nothing else.
- `Decision` carries allow, deny, or partial, plus a reason code and the policy version.
- Deny by default. Missing data is a denial.
- Pure function over an injected policy source. No database calls inside the decision.
- Reason codes are a closed enum so the UI and audit trail can rely on them.

## Never

- Never write a bypass flag, debug override, or `if DEBUG: allow`.
- Never log the text that triggered a detector.
- Never let an exception path skip redaction.
