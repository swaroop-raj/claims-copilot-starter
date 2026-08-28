from __future__ import annotations

"""Audit middleware contract.

Emit request start and request completion events around the API boundary.
Never store raw request bodies.
"""
