# Decisions

Short, dated entries. One line of context, one line of choice, one line of consequence.
Anything with real architectural weight gets a full ADR in `docs/decisions/` instead.

---

**2026-08-28 - Portkey as the only gateway.**
We need observability, retries, fallbacks, and cost control across providers without
rewriting call sites. Consequence: `import openai` outside `core/llm/portkey_client.py`
is a bug, and provider swaps are a config change.

**2026-08-28 - Presidio for PII, wrapped.**
Mature recognizer set and custom recognizer support beat rolling our own regex library.
Consequence: Presidio is a dependency of `core/pii/` only, so it stays swappable.

**2026-08-28 - pgvector, not a dedicated vector store.**
Retrieval, audit events, and HITL queue in one Postgres means one transaction boundary
and one backup story. Consequence: we accept lower ceiling scale for far lower ops cost.

**2026-08-28 - Redaction before authorization.**
Authorization logic should never see raw PII. Consequence: one extra pass over input,
and a redaction failure becomes a hard request rejection.

**2026-08-28 - Streamlit as a pure HTTP client.**
Keeps the UI disposable and the API the real product surface. Consequence: no shared
in-process state, and the UI cannot shortcut a guardrail.
