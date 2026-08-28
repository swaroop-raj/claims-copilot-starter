from __future__ import annotations

"""Starter test proving the guardrails docs exist where CLAUDE.md says they do."""

from pathlib import Path


RULE_FILES = [
    ".claude/rules/guardrails.md",
    ".claude/rules/security-pii.md",
    ".claude/rules/rag-retrieval.md",
    ".claude/rules/api-fastapi.md",
    ".claude/rules/ui-streamlit.md",
    ".claude/rules/python-style.md",
    ".claude/rules/testing-evals.md",
    ".claude/rules/data-pipeline.md",
]


def test_rule_files_exist() -> None:
    for path in RULE_FILES:
        assert Path(path).exists(), f"Missing rule file: {path}"
