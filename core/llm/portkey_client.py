from __future__ import annotations

"""Portkey client contract.

This is the only module allowed to configure the provider gateway. It owns retries,
timeouts, headers, provider routing, and model defaults. No other module imports a
provider SDK directly.
"""
