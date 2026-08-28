from __future__ import annotations

"""Domain exceptions.

Use typed exceptions so FastAPI can map them to stable API errors without leaking
raw stack traces or prompt content.
"""


class ClaimsCopilotError(Exception):
    """Base exception for domain failures."""


class AuthorizationDeniedError(ClaimsCopilotError):
    """Raised when the actor is not authorized for the claim scope."""


class InjectionDetectedError(ClaimsCopilotError):
    """Raised when prompt injection risk exceeds the allowed threshold."""


class RedactionFailedError(ClaimsCopilotError):
    """Raised when PII redaction cannot complete safely."""
