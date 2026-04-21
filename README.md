# EEG Processing

GitHub repository: [Parichehr13/EEG-Processing](https://github.com/Parichehr13/EEG-Processing)

End-to-end EEG preprocessing and classical analysis workflow built around resting-state and oddball-style recordings. The repository focuses on signal conditioning, ICA-based artifact handling, ERP estimation, and time-frequency analysis, with the emphasis on transparent methodology rather than inflated claims or framework-heavy software design.

This project is organized as a sequential analysis workflow: raw EEG is cleaned, converted into analysis-ready tensors, and then reused for downstream ERP and time-frequency studies. Supporting method-development notes are kept in a separate appendix so the main repository narrative stays focused.

Motor-imagery decoding work that previously lived in this repository has been intentionally spun out into a separate dedicated repository so the scope here stays focused on preprocessing and classical EEG analysis.

## Scope

- EEG preprocessing with detrending, filtering, epoch extraction, and bad-channel screening
- ICA-assisted artifact analysis across several practical case studies
- Preprocessing completion to cleaned, re-referenced `PreprocessStep2` datasets
- Single-subject and group-level ERP analysis
- Single-subject and group-level time-frequency analysis using continuous wavelet transforms
- Method-development appendix for PCA/ICA source-separation concepts

## Why This Repository Is Useful

- It shows a full signal-processing path rather than an isolated notebook or single experiment.
- It keeps intermediate artifacts, figures, and written interpretation close to the analysis code.
- It demonstrates EEG-specific judgment: filtering choices, artifact inspection, re-referencing, condition-wise averaging, and time-frequency interpretation.

## Workflow

1. `pipeline/01_preprocessing`
   Produces the first analysis-ready EEG snapshot from raw recordings by applying detrending, filtering, event alignment, epoch extraction, and bad-channel detection.

2. `pipeline/02_artifact_removal_ica`
   Collects ICA-based artifact-cleaning case studies and completes the main preprocessing branch to `PreprocessStep2` outputs for downstream analysis.

3. `pipeline/03_erp_analysis`
   Builds within-subject and group-level ERPs from cleaned epochs and summarizes condition-dependent temporal and topographic responses.

4. `pipeline/04_time_frequency_analysis`
   Extends the ERP branch into the time-frequency domain using CWT-based power estimation and alpha-band topographic summaries.

5. `appendix/ica_source_separation_concepts`
   Contains a compact method-development note on PCA and ICA behavior in synthetic mixtures. It supports the main workflow but is not presented as the core contribution of the repository.

## Representative Outputs

### Preprocessing and artifact handling
![Preprocessing output](pipeline/01_preprocessing/figures/stage01_p08_fig_001.png)
![Pipeline completion output](pipeline/02_artifact_removal_ica/05_pipeline_completion/figures/stage02e_sub035_fig_006.png)

### ERP and time-frequency analysis
![ERP grand average](pipeline/03_erp_analysis/figures/stage03b_p04_fig_001.png)
![Time-frequency grand average](pipeline/04_time_frequency_analysis/figures/stage04b_p03_fig_001.png)

## Repository Layout

```text
EEG-Processing/
|-- pipeline/
|   |-- 01_preprocessing/
|   |-- 02_artifact_removal_ica/
|   |-- 03_erp_analysis/
|   `-- 04_time_frequency_analysis/
|-- appendix/
|   |-- README.md
|   `-- ica_source_separation_concepts/
|-- docs/
|   `-- cv_summary.md
|-- scripts/
|   |-- run_preprocessing.m
|   |-- run_ica_workflows.m
|   |-- run_erp_analysis.m
|   |-- run_time_frequency_analysis.m
|   |-- run_full_pipeline.m
|   `-- validate_outputs.m
`-- README.md
```

## Requirements

- MATLAB
- Signal Processing Toolbox
- EEGLAB for ICA inspection, scalp maps, and interpolation-dependent steps

The repository is not packaged as a general-purpose Python library. It is intended as a reproducible research workflow with MATLAB scripts, saved intermediate datasets, and curated outputs.

## Usage

From the repository root in MATLAB:

```matlab
addpath('scripts');
run_preprocessing();
run_ica_workflows(true);
run_erp_analysis();
run_time_frequency_analysis();
```

Or run the full workflow:

```matlab
addpath('scripts');
run_full_pipeline(true);
```

Check for expected artifacts:

```matlab
addpath('scripts');
validate_outputs();
```

## Module Notes

- Each workflow directory includes a local `README.md` describing its purpose, inputs, outputs, and representative figures.
- Outputs are stored next to the scripts that generate them so preprocessing decisions and downstream interpretations stay easy to trace.
- The repository favors clarity and reproducibility over excessive abstraction.

## Limitations

- The main oddball analysis branch is small in subject count, so the group-level results should be read as a compact technical study rather than a large-sample neuroscience claim.
- ICA rejection still depends on EEGLAB-assisted inspection and manual judgment, which is realistic for EEG work but not fully automated.
- The repository focuses on classical EEG processing and interpretation rather than benchmark-scale model development.

## Future Improvements

- Add lightweight environment capture for MATLAB and EEGLAB versions used in exported outputs.
- Add a small number of scripted figure-regeneration checks for easier public reproducibility.
- Expand documentation around data provenance and analysis assumptions where raw-source metadata allow it.
