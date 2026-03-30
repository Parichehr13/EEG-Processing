# Artifact Removal ICA

This stage contains ICA artifact-removal workflows and preprocessing-completion scripts.

## Main Scripts

- `01_ica_cleaning_open_eyes/ica_open_eyes_pipeline.m`
- `02_ica_cleaning_closed_eyes/ica_closed_eyes_pipeline.m`
- `03_ica_cleaning_13ch_comparison/ica_13ch_pipeline.m`
- `04_rest_task_rest_analysis/rest_task_rest_ica_pipeline.m`
- `05_pipeline_completion/sub035_pipeline_completion/pipeline_completion_sub035.m`
- `05_pipeline_completion/sub003_pipeline_completion/pipeline_completion_sub003.m`

EEGLAB is required for `plot_IC` and `topoplot` sections.
