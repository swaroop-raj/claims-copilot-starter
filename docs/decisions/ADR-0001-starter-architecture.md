# ADR-0001: Starter architecture and boundaries

## Status
Accepted

## Context

We need a starter project that teaches Claude Code usage while leaving the actual
claims logic for later implementation. The project must be safe by default around PII,
audit, and authorization, and it must have seams Claude Code can work inside without
confusing transport with business logic.

## Decision

Use Streamlit as a thin UI client, FastAPI as the backend surface, `core/` as the
business boundary, Postgres + pgvector for storage and retrieval, Microsoft Presidio
for redaction, LangChain for orchestration, Portkey as the only model gateway, and a
HITL queue for low-confidence or risky cases.

The repository starts with real environment/config files and contract-only module
stubs rather than full implementations.

## Consequences

- The project boots and can be iterated on immediately.
- Contracts are explicit, which makes Claude Code easier to steer.
- The first real vertical slice should be `GET /health`, then ingestion, then retrieval,
  then generation.
