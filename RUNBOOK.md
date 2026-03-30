# EEG Processing Runbook

This file describes the recommended execution order for reproducible runs.

## Scope

- Core stages: `01_preprocessing` -> `02_artifact_removal_ica` -> `03_erp_analysis` -> `04_time_frequency_analysis`
- Parallel stage: `05_decoding_classification` (separate Python pipeline)
- Supporting appendix: `06_appendix_method_development`

## MATLAB Stages (01-04)

Run from repository root with MATLAB:

```matlab
addpath('scripts');
run_all_matlab_stages(true);
```

Notes:

- Argument `true` includes both subjects in Stage 02E pipeline completion (`sub-035` and `sub-003`).
- Many scripts create figures interactively; close figures between runs if memory becomes constrained.

### Manual checkpoint (EEGLAB)

Some Stage 02 workflows include comments/instructions for EEGLAB-dependent inspection/interpolation steps (`plot_IC`, topoplots, interpolation path).  
Ensure EEGLAB is installed and available on the MATLAB path before those sections.

## Python Stage (05)

Preferred:

```powershell
python scripts/run_stage05.py
```

If `python` is not on PATH, use the local virtual environment:

```powershell
.\05_decoding_classification\python\.venv\Scripts\python.exe scripts\run_stage05.py
```

Alternative (direct):

```powershell
cd 05_decoding_classification/python
python run_decoding_export.py
```

Expected outputs:

- `05_decoding_classification/figures/stage05_decoding_fig_001.png`
- `05_decoding_classification/figures/stage05_decoding_fig_002.png`
- `05_decoding_classification/figures/stage05_decoding_fig_003.png`
- `05_decoding_classification/figures/stage05_decoding_fig_004.png`
- `05_decoding_classification/figures/stage05_decoding_manifest.json`

## Output Validation

After running stages, use:

```matlab
addpath('scripts');
validate_outputs();
```

This checks for the key stage artifacts and reports missing files.
