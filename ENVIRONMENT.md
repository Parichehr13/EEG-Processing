# Environment Specification

This document records the software environment expected for reproducible execution.

## Operating System

- Windows (project paths currently use Windows separators and drive paths).

## MATLAB Stack

- MATLAB: recommended R2022b or newer.
- Required toolboxes:
  - Signal Processing Toolbox
  - Statistics and Machine Learning Toolbox
- External dependency:
  - EEGLAB (required for `plot_IC`, `topoplot`, and interpolation-related GUI workflow in Stage 02 comments)
  - Known path convention in this project: `D:\Eeg signal\programing\eeglab2024.1`

## Python Stack (Stage 05)

- Python: 3.11.x (local venv metadata indicates 3.11.9)
- Required packages:
  - `numpy`
  - `scipy`
  - `matplotlib`
  - `scikit-learn`
  - `tensorflow`

Install from:

```powershell
pip install -r 05_decoding_classification/python/requirements-stage05.txt
```

## Repository Conventions

- Run commands from repository root unless explicitly noted.
- MATLAB runners live in `scripts/`.
- Stage-specific outputs are stored inside each stage directory under `figures/`.
- GitHub automation: `.github/workflows/repo_quality.yml` runs doc-presence and Python syntax checks.
