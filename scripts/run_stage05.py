#!/usr/bin/env python
"""Run Stage 05 decoding export from repository root."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


def main() -> None:
    repo_root = Path(__file__).resolve().parents[1]
    stage05_dir = repo_root / "05_decoding_classification" / "python"
    runner = stage05_dir / "run_decoding_export.py"

    if not runner.is_file():
        raise FileNotFoundError(f"Stage 05 runner not found: {runner}")

    print(f"[RUN] Stage 05 -> {runner.name}")
    subprocess.run([sys.executable, str(runner)], cwd=str(stage05_dir), check=True)


if __name__ == "__main__":
    main()
