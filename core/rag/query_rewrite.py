from __future__ import annotations

"""Query rewrite contract.

This is intentionally unimplemented.

Input:
- redacted question
- conversation history
- resolved claim scope

Output:
- one or more rewritten search queries
- a structured hard filter that retrieval must apply

Non-negotiables:
- deterministic in tests
- model client is injected
- all rewrites are auditable
"""
