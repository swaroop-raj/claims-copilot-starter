from __future__ import annotations

"""HITL review contract.

Accept a reviewer decision and emit the corresponding audit event. Human decisions are
append-only facts, never overwritten in place.
"""
