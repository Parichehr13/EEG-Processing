# ICA Artifact Removal

This module groups the repository's ICA-centered workflows. It combines compact case studies on artifact rejection with the main preprocessing-completion branch that produces the cleaned `PreprocessStep2` datasets used by ERP and time-frequency analysis.

## Submodules

- `01_open_eyes_resting_state`
  ICA artifact cleaning on a 19-channel eyes-open recording.
- `02_closed_eyes_resting_state`
  ICA artifact cleaning on a 19-channel eyes-closed recording.
- `03_reduced_channel_comparison`
  Artifact cleaning and interpretation on a reduced 13-channel montage.
- `04_rest_task_rest_spectral_dynamics`
  ICA cleaning followed by phase-wise spectral and alpha-power comparisons across a REST/TASK/REST recording.
- `05_pipeline_completion`
  Completion of the main oddball preprocessing branch, including IC rejection, interpolation when needed, average re-referencing, and conversion back to epoched tensors.

## Main Scripts

- `01_open_eyes_resting_state/ica_open_eyes_pipeline.m`
- `02_closed_eyes_resting_state/ica_closed_eyes_pipeline.m`
- `03_reduced_channel_comparison/ica_13ch_pipeline.m`
- `04_rest_task_rest_spectral_dynamics/rest_task_rest_ica_pipeline.m`
- `05_pipeline_completion/subject_035/pipeline_completion_sub035.m`
- `05_pipeline_completion/subject_003/pipeline_completion_sub003.m`

## Dependency Notes

- EEGLAB is required for `plot_IC`, `topoplot`, and interpolation-assisted steps.
- The main pipeline-completion branch depends on the outputs generated in `pipeline/01_preprocessing`.

## Why This Module Matters

- It demonstrates artifact handling across multiple recording setups rather than a single curated example.
- It preserves the connection between qualitative IC inspection and downstream quantitative analysis.
- It shows how preprocessing decisions propagate into analysis-ready datasets.
