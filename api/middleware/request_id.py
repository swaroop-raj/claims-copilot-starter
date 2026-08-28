from __future__ import annotations

"""Request id middleware contract.

Generate one request id per inbound request and attach it to request state, response
headers, and every audit event downstream.
"""
