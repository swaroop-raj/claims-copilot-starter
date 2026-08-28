---
description: Python style and typing. Applies repo-wide.
paths:
  - "**/*.py"
---

# Python style

Ruff and mypy own formatting and typing. Do not hand-argue style in review, run `make lint`.

- Python 3.12. Full type hints on every public function.
- `from __future__ import annotations` at the top of every module.
- Pydantic v2 for anything crossing a boundary. Dataclasses for internal value objects.
- Absolute imports only.
- Custom exceptions in `core/exceptions.py`. Never raise bare `Exception`.
- Structured logging via `structlog`. Key-value pairs, no f-string log messages.
- No mutable default arguments. No module-level side effects on import.
- Docstrings on every module and public function. For stub modules, the docstring is
  the contract: inputs, outputs, failure modes.
- Functions do one thing. If a function needs a comment explaining its second half,
  it is two functions.
- Prefer explicit over clever. This codebase gets read by people learning it.
