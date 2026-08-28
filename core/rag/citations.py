from __future__ import annotations

"""Citation verification contract.

Input: answer candidate plus retrieved chunks.
Output: supported sentences only, each mapped to chunk ids.
Unsupported sentences are dropped, not softened.
"""
