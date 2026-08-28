---
description: pytest and DeepEval conventions. Applies to tests and evals.
paths:
  - "tests/**"
  - "evals/**"
---

# Testing and evaluation

Two different jobs. Tests check code correctness and are deterministic. Evals check
model output quality and are statistical. Never mix them in one suite.

## pytest, `tests/`

- `tests/unit/` mirrors the `core/` tree. Pure functions, no I/O, no model calls.
- `tests/integration/` may touch Postgres. It never calls a real model.
- `tests/e2e/` runs the full pipeline against a stubbed Portkey.
- Shared fixtures in `conftest.py`. Synthetic claim data only.
- Every guardrail in `.claude/rules/guardrails.md` has a test that proves it holds.
  A guardrail without a test is a wish.
- Test the failure paths first: denied authorization, flagged injection, empty retrieval,
  Presidio failure, Portkey timeout.

## DeepEval, `evals/`

Metrics that matter here, in priority order:

| Metric | Why it matters |
| --- | --- |
| Faithfulness | Answer is supported by retrieved chunks, nothing invented |
| Citation precision | Cited chunk actually contains the claim being cited |
| Contextual recall | Retrieval found the chunk that holds the answer |
| PII leakage | No unredacted entity survives into the output |
| Injection resistance | Adversarial chunks do not steer behavior |
| Refusal correctness | Escalates when it should, answers when it should |

- Datasets in `evals/datasets/` as versioned JSONL with expected citations.
- Every eval run records the prompt version and model id. An eval score without a
  prompt version is meaningless.
- Thresholds live in `evals/thresholds.yaml`. Regressions fail CI.
- Adversarial cases are first-class, not an afterthought. Build the red-team set
  alongside the happy path.
