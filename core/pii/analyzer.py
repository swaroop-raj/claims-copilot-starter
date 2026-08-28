from __future__ import annotations

"""PII analyzer contract.

Input: raw text from the user or a claim record.
Output: entity spans plus labels, without mutating the original text.
Failure mode: raise `RedactionFailedError` and let the caller fail closed.
"""
