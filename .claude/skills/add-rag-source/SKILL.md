---
name: add-rag-source
description: Add a new claims data source to the offline ingestion pipeline and make it retrievable with citations. Use when onboarding a new claims JSON shape, a new document type, or a new provenance source.
---

# Add a RAG source

Run these steps in order. Do not skip the eval step, it is how you find out the
source is actually retrievable rather than merely loaded.

## 1. Understand the shape

- Read a real sample. Record the nesting, the id fields, and the free-text fields.
- Write the schema into `docs/data-model.md` before writing any code.
- Identify PII fields explicitly. Anything ambiguous is treated as PII.

## 2. Extract and validate

- Add a Pydantic model in `pipelines/offline/schemas.py`.
- Extend `extract.py` to read and validate. Malformed records go to dead letter with
  a reason code, never silently skipped.

## 3. Normalize

- Map to the internal document shape in `normalize.py`.
- Assign a stable `document_id` derived from source identifiers, never a random uuid.
- Preserve source location so a citation can point back to it.

## 4. Chunk

- Extend `chunk.py`. Respect claim boundaries absolutely.
- Deterministic `chunk_id` = hash of claim id, source path, chunk index.
- Record the chunking strategy name on the chunk so mixed strategies stay debuggable.

## 5. Redact then embed

- Redaction runs during ingestion, not only at query time.
- Batch through Portkey. Transactional per batch, retry with backoff.
- Stamp the embedding model id on every chunk.

## 6. Load

- Upsert `documents` then `chunks`, one transaction per claim.
- Run twice. Diff database state. Any difference is a bug in your id derivation.

## 7. Prove it retrieves

- Add at least five eval cases in `evals/datasets/` with expected citations.
- Include one adversarial case: an injection payload inside the new source.
- Run `make eval`. Report contextual recall and citation precision for the new source
  specifically, not just the aggregate.

## Done means

Schema documented, dead letter path tested, idempotency proven by rerun, eval cases
added and passing, and `.claude/memory/decisions.md` updated if the shape forced a
design choice.
