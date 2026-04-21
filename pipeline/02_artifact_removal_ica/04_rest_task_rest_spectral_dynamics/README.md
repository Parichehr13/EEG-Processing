# REST-TASK-REST Spectral Dynamics

ICA cleaning followed by phase-wise spectral analysis on a 13-channel REST/TASK/REST recording.

## Inputs

- `REST_TASK_REST.mat`
- `Standard-10-20-Cap13.locs`
- EEGLAB-derived `matrixW_rest_task_rest.txt` and `mapICs_rest_task_rest.fig`

## Main Script

- `rest_task_rest_ica_pipeline.m`

## Workflow

1. Clean the recording with ICA-assisted artifact rejection.
2. Split the session into Relax 1, Task, and Relax 2 segments.
3. Compute PSDs for each phase.
4. Aggregate spectral behavior by scalp region.
5. Quantify alpha-band power changes across phases.

## Removed Components

- `IC1`, `IC2`, `IC3`, `IC4`, `IC8`

## Representative Figures

![Regional PSD comparison](figures/stage02d_p10_fig_001.png)
![Alpha-band trends](figures/stage02d_p11_fig_001.png)

## Notes

This is the most analysis-heavy ICA case study in the repository because it links artifact cleaning directly to interpretable regional spectral summaries.
