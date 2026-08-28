# Runbook

## First boot

1. Copy `.env.example` to `.env` and fill in your Portkey values.
2. `make up`
3. `make install`
4. `make migrate`
5. `make api` in one terminal
6. `make ui` in another terminal

## First real feature to build

Do not start with the main chat route. That's how starter repos turn into mud.

Recommended order:

1. Implement `GET /health` with database and Portkey checks
2. Implement audit start/end events
3. Implement raw JSON extract + normalize for the sample claim
4. Implement chunking and deterministic ids
5. Implement retrieval with a hard claim filter
6. Implement chat generation only after citations can be verified

## When something smells wrong

- Missing citation? Check `core/rag/citations.py` and the retrieved chunks first.
- Cross-claim data? Your SQL filter is wrong or missing.
- PII in output? Redaction path failed or was bypassed.
- Flaky retrieval? Check the ingest run summary and embedding model consistency.
