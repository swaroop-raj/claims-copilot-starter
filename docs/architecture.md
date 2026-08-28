# Architecture

This starter is intentionally split into layers so Claude Code has obvious seams to
work within:

- `app/`: Streamlit UI only
- `api/`: FastAPI transport only
- `core/`: real behavior and contracts
- `pipelines/offline/`: claims ingestion into Postgres + pgvector
- `db/`: schema and migrations
- `evals/` + `tests/`: quality harness

The target request flow is:

1. Receive question and assign `request_id`
2. Redact PII with Presidio
3. Authorize actor against claim scope
4. Check prompt injection on input and retrieved chunks
5. Rewrite query and retrieve chunks from pgvector
6. Generate through LangChain + Portkey + OpenAI GPT
7. Verify citations sentence by sentence
8. Return answer or escalate to HITL
9. Write append-only audit events all the way through

## Why Streamlit + FastAPI

Streamlit is fast for a working front end. FastAPI is the durable product surface.
Keeping the UI as a client means you can replace it later without touching the core
logic.

## Why pgvector

One Postgres for retrieval, audit, and HITL keeps the operational story sane. For a
starter project that is the right trade.
