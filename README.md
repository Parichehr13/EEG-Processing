# EEG Processing Project

This repository is organized as one end-to-end EEG research pipeline.
Each stage contains code, figures, and a report.

## About

End-to-end EEG processing portfolio covering preprocessing, ICA-based artifact removal, ERP analysis, time-frequency analysis, and motor-imagery decoding.

## Project Pipeline

1. `01_preprocessing`
   - Signal preparation: detrending, filtering, epoching, bad-channel detection.

2. `02_artifact_removal_ica`
   - ICA-based artifact rejection workflows and preprocessing completion to `PreprocessStep2`.
   - Includes multiple ICA case studies (open eyes, closed eyes, 13-channel setup, REST/TASK/REST analysis).

3. `03_erp_analysis`
   - Event-related potential analysis (single-subject and group-level).

4. `04_time_frequency_analysis`
   - Time-frequency analysis with CWT and alpha-band spatiotemporal evolution.

5. `05_decoding_classification`
   - Motor imagery classification using EEGNet (Python).

6. `06_appendix_method_development`
   - Method-development appendix (PCA/ICA source separation concepts on synthetic mixtures).

## Stage Dependency

`01_preprocessing` -> `02_artifact_removal_ica` -> `03_erp_analysis` / `04_time_frequency_analysis`

`05_decoding_classification` is a parallel decoding track with its own dataset pipeline.

## Reproducibility

- [scripts/README.md](scripts/README.md): runner-layer usage.
