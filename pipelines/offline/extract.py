from __future__ import annotations

"""Extract stage contract.

Read claims JSON and validate each record against the ingestion schema. Malformed
records go to dead letter with a reason, never silently skipped.
"""
