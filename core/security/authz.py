from __future__ import annotations

"""Authorization contract.

Signature: `(actor, claim_id, intent) -> Decision`.
- Pure function over injected policy data.
- Deny by default on missing or unknown data.
- Must run before retrieval on every request path.
"""
