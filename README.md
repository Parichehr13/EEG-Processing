# EEG Processing - Exercise Overview

This repository contains 10 EEG analysis projects.  
Each folder includes code, figures, and a report.

1. `01_preprocessing-foundations`: EEG preprocessing basics (resampling, detrending, filtering, epoching, bad-channel check).
2. `02_pca-ica-source-separation`: PCA/ICA on synthetic mixtures (source separation concepts).
3. `03_artifact-removal-ica`: ICA-based artifact removal on EEG (time + PSD comparison before/after cleaning).
4. `04_cleaning-workflow`: ICA cleaning workflow on a second EEG dataset (IC inspection and correction).
5. `05_multicondition-analysis`: ICA cleaning on 13-channel EEG and comparison across conditions.
6. `06_rest-task-spectral-analysis`: Rest-task-rest EEG analysis (artifact correction + condition-level spectral changes).
7. `07_full-preprocessing-pipeline`: Preprocessing pipeline completion (ICA, interpolation, re-reference, final epoched output).
8. `08_erp-analysis`: ERP analysis (single-subject WSA and group-level grand average, waveforms + topomaps).
9. `09_time-frequency-analysis`: Time-frequency analysis with CWT (ERSP-style maps and alpha-band scalp evolution).
10. `10_motor-imagery-classification`: Motor imagery classification with EEGNet (Python pipeline, training curves, confusion matrices, spatial weights).
