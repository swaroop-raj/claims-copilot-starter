from __future__ import annotations

"""Prompt injection detection contract.

Input: redacted user input plus retrieved chunks.
Output: a structured decision with score, rule hits, and allow/block/escalate action.
Failure mode: conservative block or escalate, never silent pass-through.
"""
