PYTHON ?= python3
VENV ?= .venv
PIP := $(VENV)/bin/pip
PY := $(VENV)/bin/python
UVICORN := $(VENV)/bin/uvicorn
STREAMLIT := $(VENV)/bin/streamlit
PYTEST := $(VENV)/bin/pytest
RUFF := $(VENV)/bin/ruff
MYPY := $(VENV)/bin/mypy
ALEMBIC := $(VENV)/bin/alembic

.PHONY: install up migrate ingest api ui test eval lint format clean

install:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

up:
	docker compose up -d

migrate:
	psql postgresql://app:app@localhost:5432/claims_copilot -f db/schema.sql
	$(ALEMBIC) upgrade head

ingest:
	$(PY) -m pipelines.offline.run --input data/samples/claims_sample.json

api:
	$(UVICORN) api.main:app --reload --port 8000

ui:
	$(STREAMLIT) run app/main.py

test:
	$(PYTEST) -q

eval:
	$(PY) -m evals.deepeval.run

lint:
	$(RUFF) format .
	$(RUFF) check .
	$(MYPY) api app core pipelines tests

clean:
	rm -rf $(VENV) .pytest_cache .mypy_cache .ruff_cache htmlcov coverage.xml
