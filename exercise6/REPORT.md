# Report: Exercise 6 - REST/TASK/REST Spectral Dynamics After ICA Cleaning

## Objective
Analyze how EEG spectral content changes across three phases (Relax 1, Task, Relax 2) after ICA-based artifact correction, with focus on regional PSD and alpha-band power (8-14 Hz).

## Dataset and Inputs
- EEG file: `REST_TASK_REST.mat`
- Channels: 13
- Sampling rate: 128 Hz
- Recording structure:
  - Relax 1 (R1): first 5 minutes
  - Task (T): middle 5 minutes
  - Relax 2 (R2): last 5 minutes
- Channel locations: `Standard-10-20-Cap13.locs`
- EEGLAB outputs used by script:
  - demixing matrix: `matrixW_Exercise6.txt`
  - IC topomap file: `mapICs_Exercise6.fig`

## Procedure (Aligned with Exercise Points)
1. Loaded 13-channel EEG and plotted full-duration traces.
2. Computed baseline PSD of raw EEG channels (`pwelch`).
3. Prepared data export for EEGLAB.
4. In EEGLAB: estimated ICA and exported demixing matrix.
5. Reconstructed IC time courses (`Y = W*X`).
6. Computed PSD of ICs.
7. Inspected selected ICs by time/PSD/topography to identify artifacts.
8. Removed selected artifact ICs and reconstructed cleaned EEG.
9. Computed cleaned-EEG PSD separately for R1, T, and R2.
10. Averaged PSD by scalp regions:
   - frontal (`F3`, `F4`)
   - temporo-central (`T7`, `C3`, `Cz`, `C4`, `T8`)
   - parieto-occipital (`PO3`, `PO4`, `PO7`, `PO8`, `O1`, `O2`)
11. Computed alpha power (`trapz`) in each region and phase.

## Artifact Components Removed
From IC inspection and script logic, removed:
- `IC1`, `IC2`, `IC3`, `IC4`, `IC8`

## Results and Figures (All Exported Point-by-Point)
### Point 1 - Raw EEG (before correction)
![Point 1 - Raw EEG](figures/exercise6_p01_fig_001.png)

### Point 2 - PSD of raw EEG
![Point 2 - Raw EEG PSD](figures/exercise6_p02_fig_001.png)

### Point 5 - Estimated ICs (time domain)
![Point 5 - IC time courses](figures/exercise6_p05_fig_001.png)

### Point 6 - PSD of ICs
![Point 6 - IC PSD](figures/exercise6_p06_fig_001.png)

### Point 7 - IC inspection panels (time/PSD/topography)
![Point 7 - IC inspection 1](figures/exercise6_p07_fig_001.png)
![Point 7 - IC inspection 2](figures/exercise6_p07_fig_002.png)
![Point 7 - IC inspection 3](figures/exercise6_p07_fig_003.png)
![Point 7 - IC inspection 4](figures/exercise6_p07_fig_004.png)
![Point 7 - IC inspection 5](figures/exercise6_p07_fig_005.png)
![Point 7 - IC inspection 6](figures/exercise6_p07_fig_006.png)
![Point 7 - IC inspection 7](figures/exercise6_p07_fig_007.png)
![Point 7 - IC inspection 8](figures/exercise6_p07_fig_008.png)

### Point 8 - Cleaned EEG and pre/post PSD comparison
![Point 8 - Cleaned EEG (time)](figures/exercise6_p08_fig_001.png)
![Point 8 - PSD after correction](figures/exercise6_p08_fig_002.png)
![Point 8 - PSD before vs after](figures/exercise6_p08_fig_003.png)

### Point 9 - Phase-specific PSD (R1, T, R2)
![Point 9 - PSD Relax R1](figures/exercise6_p09_fig_001.png)
![Point 9 - PSD Task T](figures/exercise6_p09_fig_002.png)
![Point 9 - PSD Relax R2](figures/exercise6_p09_fig_003.png)

### Point 10 - Regional PSD by phase
![Point 10 - Regional PSD comparison](figures/exercise6_p10_fig_001.png)

### Point 11 - Alpha power by phase and region
![Point 11 - Alpha power trends](figures/exercise6_p11_fig_001.png)

## Interpretation
- ICA removal suppresses major non-neural contamination while preserving relevant EEG rhythms.
- Phase-wise PSDs reveal condition-dependent modulation across R1, T, and R2.
- Regional averaging highlights that modulation is not spatially uniform across scalp regions.
- Alpha-power curves provide a compact quantitative summary of phase-related changes and recovery trends from task back to relax.

## Conclusion
Exercise 6 successfully combines ICA cleaning with phase-specific spectral analysis and regional alpha-power quantification. The pipeline provides both qualitative and quantitative evidence of state-dependent EEG modulation in a REST-TASK-REST paradigm.

