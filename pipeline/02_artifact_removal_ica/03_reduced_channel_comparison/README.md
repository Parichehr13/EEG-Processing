# Reduced-Channel ICA Comparison

Artifact rejection workflow on a 13-channel recording. This case study is useful for showing how ICA-based cleaning behaves under a lower-density montage.

## Inputs

- `EEG_13chans.mat`
- `EYES_OPEN.mat`
- `EYES_CLOSED.mat`
- `Standard-10-20-Cap13.locs`
- `Standard-10-20-Cap19.locs`

## Main Script

- `ica_13ch_pipeline.m`

## Workflow

1. Inspect the reduced-channel recording in time and frequency.
2. Estimate ICA and reconstruct IC activity.
3. Inspect candidate artifact components using time traces, PSD, and topography.
4. Remove the selected IC set and compare pre/post-cleaning behavior.

## Removed Components

- `IC1`, `IC3`, `IC6`, `IC7`, `IC8`

## Representative Figures

![Raw reduced-channel EEG](figures/stage02c_p01_fig_001.png)
![IC inspection panel](figures/stage02c_p07_fig_002.png)
![PSD comparison after cleaning](figures/stage02c_p08_fig_003.png)

## Notes

The reduced montage makes this module a good example of practical tradeoffs in artifact handling when spatial resolution is limited.
