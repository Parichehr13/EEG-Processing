# Project Summary

## Objective

Build an end-to-end EEG processing and analysis workflow spanning preprocessing, ICA artifact mitigation, ERP analysis, time-frequency analysis, and motor-imagery decoding.

## Pipeline

1. `01_preprocessing`
2. `02_artifact_removal_ica`
3. `03_erp_analysis`
4. `04_time_frequency_analysis`
5. `05_decoding_classification` (parallel decoding track)

`06_appendix_method_development` contains supporting methodological experiments.

## Core Deliverables

- Stage-structured MATLAB scripts and reports.
- Python EEGNet decoding workflow with exported training/evaluation figures.
- Standardized figure/manifests per stage.
- Reproducible runner layer in `scripts/`.

## Scientific Focus

- Signal quality improvement via filtering and ICA-based artifact rejection.
- Event-locked response characterization (ERP).
- Oscillatory dynamics via CWT time-frequency analysis.
- Supervised neural decoding of motor imagery classes.

## Reproducibility Assets

- `RUNBOOK.md`: execution order and commands.
- `ENVIRONMENT.md`: software stack and dependencies.
- `scripts/validate_outputs.m`: key artifact checks.
