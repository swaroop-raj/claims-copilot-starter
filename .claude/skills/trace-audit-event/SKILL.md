---
name: trace-audit-event
description: Add or trace an audit event across the request pipeline. Use when instrumenting a new stage, debugging a request by request_id, or verifying the audit trail is complete end to end.
---

# Trace an audit event

The audit trail is the compliance story and the debugging story at once. If a stage
is not audited, it did not happen as far as anyone downstream can prove.

## Adding a new event

### 1. Define it before emitting it

Add the event type to the enum in `core/audit/events.py`. Every event carries:

| Field | Note |
| --- | --- |
| `request_id` | From middleware. Never generated locally. |
| `event_type` | Closed enum, never a free string |
| `stage` | Which pipeline stage emitted it |
| `actor` | Who initiated the request |
| `claim_id` | Scope, when known |
| `decision` | allow, deny, escalate, complete, error |
| `reason_code` | Closed enum |
| `content_hash` | Hash, never content |
| `duration_ms` | For latency work |
| `prompt_version` | On model-adjacent events only |

### 2. Content rules, non-negotiable

Ids, hashes, enums, and durations. Never raw prompts, claim text, redaction token
maps, or the payload that tripped a detector. If you are unsure, hash it.

### 3. Emit at the boundary

One event per stage transition, written through `core/audit/writer.py`. Never write
to `audit_events` directly from a router or a core module.

### 4. Append-only

No updates. No deletes. A correction is a new compensating event that references the
original event id.

## Tracing an existing request

1. Get the `request_id` from the UI or the client error response.
2. `GET /admin/audit/{request_id}` for the ordered trail.
3. Read the trail as a timeline. The gap between two events is where the time or the
   truth went missing.
4. Expected stage order: `received` -> `redacted` -> `authorized` -> `injection_checked`
   -> `query_rewritten` -> `retrieved` -> `generated` -> `citations_verified` ->
   `responded` or `escalated`.
5. A missing stage is either an unimplemented emitter or a code path that skipped a
   guardrail. Both matter. Determine which before moving on.

## Done means

Event defined in the enum, emitted at exactly one boundary, contains no content, has
a test asserting it fires, and the full trail for one `request_id` reconstructs the
request without gaps.
