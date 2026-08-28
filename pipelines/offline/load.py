from __future__ import annotations

"""Load stage contract.

Upsert documents and chunks transactionally. A failed chunk batch must roll back the
whole claim ingest.
"""
