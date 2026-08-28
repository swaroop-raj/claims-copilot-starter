from __future__ import annotations

"""Retriever contract.

Input: rewritten queries plus a claim-scope filter.
Output: ranked chunks with `chunk_id`, `document_id`, `claim_id`, `text`, `score`, and provenance.
Rule: claim scope is filtered in SQL, never post-filtered in Python.
"""
