# CLAUDE.md

Project handbook. Claude Code loads this at the start of every session.
Keep it under 200 lines. If it grows, move detail into `.claude/rules/`.

## WHY

Claims handling is slow because answers live in dense claim JSON that humans must
read end to end. This project answers claim questions in plain language with a
citation for every factual sentence, and escalates to a human when confidence or
authorization is insufficient.

## WHAT

A grounded claims copilot. Request flow, in order:

1. **Streamlit UI** (`app/`) collects the question and session identity.
2. **FastAPI** (`api/`) validates the request and assigns a request id.
3. **PII redaction** (`core/pii/`) via Microsoft Presidio before anything leaves the process.
4. **Authorization + injection checks** (`core/security/`) decide if this caller may ask this.
5. **RAG** (`core/rag/`) rewrites the query, retrieves from pgvector, attaches citations.
6. **LangChain + Portkey** (`core/llm/`) calls the model (Portkey gateway, OpenAI GPT underneath).
7. **HITL** (`core/hitl/`) queues for human review when a gate trips.
8. **Cited response** returns to the UI. Every stage emits an audit event (`core/audit/`).

Offline, `pipelines/offline/` loads claims JSON into Postgres + pgvector for retrieval.

## HOW

### Commands

- `make up` - start Postgres + pgvector via Docker
- `make install` - create venv and install dependencies
- `make migrate` - apply `db/schema.sql` and Alembic migrations
- `make ingest` - run the offline pipeline over `data/samples/claims_sample.json`
- `make api` - run FastAPI on :8000
- `make ui` - run Streamlit on :8501
- `make test` - pytest unit + integration
- `make eval` - DeepEval suite in `evals/`
- `make lint` - ruff format + ruff check + mypy

Run `make lint && make test` before you consider any task done.

### Non-negotiables

- **Never** send unredacted text to any model or external service. Redaction happens
  in `core/pii/` before the LLM layer, with no exceptions.
- **Never** commit real claim data. `data/samples/` holds synthetic records only.
- **Never** log raw prompts, raw claim bodies, or secrets. Audit events store ids and
  hashes, not content.
- Every factual sentence in a model response carries a citation to a retrieved chunk.
  No citation means the sentence gets dropped, not guessed.
- Portkey is the only model entry point. Do not import `openai` directly anywhere.

### Architecture rules

- One-way dependency: `app/` -> `api/` -> `core/`. `core/` imports nothing from `api/` or `app/`.
- `core/` modules are pure and testable: no FastAPI objects, no Streamlit calls.
- Config comes from `core/config.py` only. No `os.environ` reads scattered in modules.
- Async in `api/` and `core/`. Streamlit stays sync and calls the API over HTTP.

### Working agreement

- Use **plan mode** for anything touching `core/security/`, `core/pii/`, or `db/`.
- Delegate research to subagents so the main context stays clean:
  `use a subagent to investigate how retrieval is wired`
- Before calling a task done, run the adversarial reviewer:
  `use the adversarial-reviewer subagent to review this diff`
- Update `.claude/memory/decisions.md` after any architectural choice.

### Unimplemented by design

Most modules are contract-only stubs. Read the module docstring for the input and
output contract, then implement against it. Do not delete a contract to make a test
pass. If a contract is wrong, say so and propose a change first.

## Additional context

@.claude/rules/guardrails.md
@.claude/rules/security-pii.md
@.claude/rules/rag-retrieval.md
@.claude/rules/api-fastapi.md
@.claude/rules/ui-streamlit.md
@.claude/rules/python-style.md
@.claude/rules/testing-evals.md
@.claude/rules/data-pipeline.md

- Architecture: `docs/architecture.md`
- Request flow diagram: `docs/flow.md`
- Data model: `docs/data-model.md`
- Decisions log: `docs/decisions/`
- Session continuity: `.claude/memory/session-log.md`
