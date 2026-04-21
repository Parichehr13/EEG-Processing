# Pipeline Completion

This module completes the main preprocessing branch that begins in `pipeline/01_preprocessing`. It performs ICA-based artifact rejection on the concatenated epoch matrix, interpolates missing channels when required, restores average reference, and saves the final `PreprocessStep2` datasets used in downstream analyses.

## Subject Workflows

- `subject_035/pipeline_completion_sub035.m`
- `subject_003/pipeline_completion_sub003.m`

## Processing Summary

1. Load `PreprocessStep1` data.
2. Estimate ICA in EEGLAB and export the demixing matrix.
3. Inspect and reject artifactual components.
4. Reconstruct cleaned EEG on the retained channels.
5. Reinsert and interpolate bad channels when necessary.
6. Re-reference to the average reference and restore `CPz`.
7. Reshape the cleaned data back to `channels x samples x epochs`.
8. Save `sub-*_PreprocessStep2.mat` outputs.

## Representative Figures

![Subject 035 final cleaned output](figures/stage02e_sub035_fig_006.png)
![Subject 003 final cleaned output](figures/stage02e_sub003_fig_004.png)

## Notes

- Subject 035 includes a bad-channel interpolation path.
- Subject 003 follows the same logic without the interpolation branch.
- These outputs are the direct inputs to the ERP and time-frequency modules.
