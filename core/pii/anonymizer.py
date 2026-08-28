from __future__ import annotations

"""PII anonymizer contract.

Input: raw text plus analyzer spans.
Output: redacted text plus a request-scoped token map held in memory only.
Failure mode: raise `RedactionFailedError`. Never pass through raw text on failure.
"""
