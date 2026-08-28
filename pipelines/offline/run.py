from __future__ import annotations

"""Offline pipeline orchestrator.

Contract:
- Compose extract -> normalize -> chunk -> embed -> load.
- Accept a sample JSON file path from the CLI.
- Emit a structured summary and exit non-zero on rejects above threshold.
"""

import argparse


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, help="Path to a claims JSON file")
    args = parser.parse_args()
    print({"status": "not_implemented", "input": args.input})


if __name__ == "__main__":
    main()
