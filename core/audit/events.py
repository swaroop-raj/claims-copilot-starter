from __future__ import annotations

"""Audit event enums and payload contract."""

from enum import StrEnum


class AuditEventType(StrEnum):
    RECEIVED = "received"
    REDACTED = "redacted"
    AUTHORIZED = "authorized"
    INJECTION_CHECKED = "injection_checked"
    QUERY_REWRITTEN = "query_rewritten"
    RETRIEVED = "retrieved"
    GENERATED = "generated"
    CITATIONS_VERIFIED = "citations_verified"
    RESPONDED = "responded"
    ESCALATED = "escalated"
    ERROR = "error"
