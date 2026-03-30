# Report: Stage 02D - REST/TASK/REST Spectral Dynamics After ICA Cleaning

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
  - demixing matrix: `matrixW_rest_task_rest.txt`
  - IC topomap file: `mapICs_rest_task_rest.fig`

## Procedure 
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

## Results and Figures 
### Step 1 - Raw EEG (before correction)
![Step 1 - Raw EEG](figures/stage02d_p01_fig_001.png)

### Step 2 - PSD of raw EEG
![Step 2 - Raw EEG PSD](figures/stage02d_p02_fig_001.png)

### Step 5 - Estimated ICs (time domain)
![Step 5 - IC time courses](figures/stage02d_p05_fig_001.png)

### Step 6 - PSD of ICs
![Step 6 - IC PSD](figures/stage02d_p06_fig_001.png)

### Step 7 - IC inspection panels (time/PSD/topography)
![Step 7 - IC inspection 1](figures/stage02d_p07_fig_001.png)
![Step 7 - IC inspection 2](figures/stage02d_p07_fig_002.png)
![Step 7 - IC inspection 3](figures/stage02d_p07_fig_003.png)
![Step 7 - IC inspection 4](figures/stage02d_p07_fig_004.png)
![Step 7 - IC inspection 5](figures/stage02d_p07_fig_005.png)
![Step 7 - IC inspection 6](figures/stage02d_p07_fig_006.png)
![Step 7 - IC inspection 7](figures/stage02d_p07_fig_007.png)
![Step 7 - IC inspection 8](figures/stage02d_p07_fig_008.png)

### Step 8 - Cleaned EEG and pre/post PSD comparison
![Step 8 - Cleaned EEG (time)](figures/stage02d_p08_fig_001.png)
![Step 8 - PSD after correction](figures/stage02d_p08_fig_002.png)
![Step 8 - PSD before vs after](figures/stage02d_p08_fig_003.png)

### Step 9 - Phase-specific PSD (R1, T, R2)
![Step 9 - PSD Relax R1](figures/stage02d_p09_fig_001.png)
![Step 9 - PSD Task T](figures/stage02d_p09_fig_002.png)
![Step 9 - PSD Relax R2](figures/stage02d_p09_fig_003.png)

### Step 10 - Regional PSD by phase
![Step 10 - Regional PSD comparison](figures/stage02d_p10_fig_001.png)

### Step 11 - Alpha power by phase and region
![Step 11 - Alpha power trends](figures/stage02d_p11_fig_001.png)

## Interpretation
- ICA removal suppresses major non-neural contamination while preserving relevant EEG rhythms.
- Phase-wise PSDs reveal condition-dependent modulation across R1, T, and R2.
- Regional averaging highlights that modulation is not spatially uniform across scalp regions.
- Alpha-power curves provide a compact quantitative summary of phase-related changes and recovery trends from task back to relax.

## Conclusion
Stage 02D successfully combines ICA cleaning with phase-specific spectral analysis and regional alpha-power quantification. The pipeline provides both qualitative and quantitative evidence of state-dependent EEG modulation in a REST-TASK-REST paradigm.




