# Data model

## Raw claim record, starter shape

The sample claim JSON is intentionally tiny but it encodes the important ideas:

- One top-level `claim_id`
- Parties, policy metadata, events, notes, and documents
- Nested free-text fields that need redaction and chunking

## Internal document shape

Each normalized document should carry:

| Field | Meaning |
| --- | --- |
| `document_id` | Stable id derived from source data |
| `claim_id` | Hard retrieval scope |
| `source_type` | note, document, event, summary |
| `source_path` | JSON path or file origin |
| `redacted_text` | redacted content for retrieval |
| `metadata` | structured provenance |

## Chunk shape

| Field | Meaning |
| --- | --- |
| `chunk_id` | deterministic hash |
| `document_id` | parent document |
| `claim_id` | retrieval scope |
| `chunk_index` | order within parent |
| `text` | chunk body |
| `embedding` | pgvector |
| `embedding_model` | exact embedding model used |
| `source_path` | provenance pointer |

## Audit event shape

Keep ids and hashes, not content. The trail should prove what happened without storing
what should not have been stored.
