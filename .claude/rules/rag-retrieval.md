---
description: Retrieval, query rewriting, and citation rules. Applies to core/rag and core/llm.
paths:
  - "core/rag/**"
  - "core/llm/**"
---

# RAG and citations

## Query rewriting, `core/rag/query_rewrite.py`

This is the piece you are building. The contract is fixed, the strategy is yours.

- Input: redacted question, conversation history, resolved claim scope.
- Output: a list of one or more search queries plus a structured filter.
- The filter is a hard constraint, not a hint. Retrieval must not cross claim scope.
- Rewriting is deterministic in tests. Inject the model client, never construct it inside.
- Log the rewrite as an audit event so you can debug bad retrieval later.

## Retrieval, `core/rag/retriever.py`

- pgvector, cosine distance, over `chunks.embedding`.
- Always filter by claim scope in SQL, never in Python after the fact.
- Return chunks with `chunk_id`, `document_id`, `claim_id`, `text`, `score`, and
  source location. A chunk with no traceable source is unusable.
- Hybrid retrieval is preferred once dense retrieval works: add `tsvector` keyword
  search and fuse. Do not start there.
- Empty result set is a valid, expected outcome. Handle it explicitly.

## Citations, `core/rag/citations.py`

- Every factual sentence maps to at least one `chunk_id`.
- Verify citations *after* generation. Drop unsupported sentences, do not rewrite them
  into something vaguer.
- Citation markers are structured data attached to the response, not inline text the
  model invented.
- Citation precision is an eval metric, not a vibe. See `evals/metrics/`.

## Model calls, `core/llm/`

- LangChain builds the chains, Portkey is the gateway, OpenAI GPT is the model.
- All chains live in `core/llm/chains/`. All prompts live in `core/llm/prompts/` as
  files, never as inline string literals in logic modules.
- Prompts are versioned. Changing a prompt means bumping its version so evals can
  compare across versions.
- Portkey config, retries, fallbacks, and caching are set in `portkey_client.py` only.
- Structured output over free text wherever a downstream module consumes the result.
