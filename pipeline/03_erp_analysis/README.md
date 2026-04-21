# ERP Analysis

This module estimates within-subject and group-level ERPs from the cleaned `PreprocessStep2` outputs. It focuses on condition-wise waveform comparison and scalp-topography summaries in a compact oddball-style setting.

## Inputs

- `sub-035_PreprocessStep2.mat`
- `sub-003_PreprocessStep2.mat`
- `WSA_allsubjects.mat`
- `Standard-10-20-Cap60.locs`

## Main Scripts

- `erp_within_subject_analysis.m`
- `erp_group_grand_average.m`

## Processing Summary

1. Baseline-correct cleaned epochs.
2. Split trials by `standard`, `target`, and `distractor`.
3. Compute within-subject averages at representative channels and over the full scalp.
4. Aggregate subject-level averages into group-level grand averages.
5. Summarize results through waveform plots and topographic maps.

## Representative Figures

![Within-subject ERP maps](figures/stage03a_p06_fig_001.png)
![Grand-average ERP maps](figures/stage03b_p04_fig_001.png)

## Notes

The module keeps the scope honest: it is a small-sample ERP workflow meant to demonstrate signal-processing rigor and interpretation, not to claim a large-scale population study.
