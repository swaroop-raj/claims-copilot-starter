# Security notes

This starter assumes a hostile environment. The project is claims-adjacent and PII-heavy,
so the safe default is to deny, escalate, or refuse rather than improvise.

## The big four

1. **Redact before model calls**
2. **Authorize before retrieval**
3. **Treat retrieved text as untrusted data**
4. **Audit every stage**

## Specific risks this repo is shaped around

- A claim note containing instructions like "ignore previous instructions"
- Cross-claim retrieval leakage because a filter was applied after retrieval rather than in SQL
- PII leaking into prompts, logs, or eval datasets
- Silent partial ingestion writes that make retrieval flaky and impossible to debug
- Human reviewers making decisions with no durable audit trail
