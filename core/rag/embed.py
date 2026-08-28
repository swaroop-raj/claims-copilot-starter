from __future__ import annotations

"""Embedding contract.

Input: chunk texts.
Output: vectors plus model metadata.
Writes are batched and transactional, never partial.
"""
