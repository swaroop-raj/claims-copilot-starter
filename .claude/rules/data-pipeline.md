---
description: Offline ingestion pipeline conventions.
paths:
  - "pipelines/**"
  - "db/**"
---

# Offline data pipeline

Five stages, each a pure function, composed by `pipelines/offline/run.py`. Each stage
is independently testable and independently rerunnable.

1. **extract** - read claims JSON, validate against the schema, reject malformed records loudly.
2. **normalize** - flatten nested claim structures into documents with stable ids.
3. **chunk** - split into retrievable units that respect claim record boundaries.
4. **embed** - batch through Portkey, retry with backoff, never partially write a batch.
5. **load** - upsert into `documents` and `chunks`, transactional per claim.

## Rules

- Idempotent. Running twice produces the same database state, no duplicate chunks.
- Deterministic ids. `chunk_id` is a hash of `claim_id` plus source path plus chunk index.
  Re-ingesting an unchanged claim must not churn ids.
- Chunks never span two claims. Cross-claim leakage starts here, not in retrieval.
- Records the embedding model and prompt version on every chunk. When you change the
  model, you re-embed, and you need to know what is stale.
- PII redaction runs during ingestion too, not just at query time.
- Structured run summary on every execution: counts in, counts out, rejects, duration.
- Rejected records go to a dead letter file with a reason. Never silently skipped.

## Schema notes

- `documents` is the source of record for provenance. `chunks` is the retrieval surface.
- `audit_events` is append-only. No updates, no deletes, ever.
- Every migration is reversible and checked in. No manual `psql` schema edits.
