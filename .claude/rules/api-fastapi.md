---
description: FastAPI conventions for routers, middleware, and schemas.
paths:
  - "api/**"
---

# FastAPI conventions

## Layout

- `api/main.py` wires the app: middleware, routers, lifespan. No business logic.
- `api/routers/` is thin. Parse, call `core/`, shape the response. No orchestration logic
  living secretly in a router.
- `api/schemas/` holds Pydantic v2 models. Request and response models are separate
  types even when they look identical today.
- `api/middleware/` holds cross-cutting concerns only: request id, audit, authz context.

## Rules

- Async endpoints. Blocking calls go through `run_in_threadpool`.
- Every route declares an explicit `response_model`. No bare dict returns.
- Errors use typed exceptions from `core/` mapped to HTTP status by one handler in
  `api/main.py`. Routers do not raise `HTTPException` with ad hoc messages.
- Error responses never echo user input back. Reference the `request_id` instead.
- Every request gets a `request_id` from middleware and it flows into every audit event.
- Dependency injection for the database session, Portkey client, and policy source, so
  tests can substitute fakes.

## Endpoint map

| Route | Purpose |
| --- | --- |
| `POST /chat` | Ask a claim question, get a cited answer or an escalation |
| `GET /health` | Liveness plus database and Portkey reachability |
| `GET /hitl/queue` | Pending human reviews |
| `POST /hitl/{review_id}/decide` | Submit a reviewer decision |
| `GET /admin/audit/{request_id}` | Full audit trail for one request |

## Never

- Never bypass middleware for a "quick" internal route.
- Never return raw retrieved chunk text to the client without going through the
  citation layer.
