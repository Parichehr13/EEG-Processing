# Report: Stage 02C - ICA Cleaning on 13-Channel EEG

## Objective
Apply ICA-based artifact rejection to a 13-channel EEG recording with evident ocular contamination, then evaluate signal quality improvements in both time and frequency domains.

## Dataset and Inputs
- EEG file: `EEG_13chans.mat`
- Channels: 13
- Sampling rate: 128 Hz
- Channel locations for topography: `Standard-10-20-Cap13.locs`
- EEGLAB outputs used by script:
  - demixing matrix: `matrixW_13ch.txt`
  - IC topomap file: `mapICs_13ch.fig`

## Procedure 
1. Loaded 13-channel EEG and plotted full recording (45 s).
2. Computed/visualized PSD of all channels (`pwelch`).
3. Prepared `.mat` data export for EEGLAB.
4. In EEGLAB: estimated ICA and exported demixing matrix.
5. Reconstructed IC time courses from `Y = W*X`.
6. Computed PSD of ICs.
7. Inspected selected ICs (time/PSD/topography) to identify artifact components.
8. Removed selected artifact ICs and reconstructed cleaned EEG; compared PSD before and after correction.

## Identified Artifact Components
Based on the script inspection and comments, removed ICs:
- `IC1`: prominent lateral ocular movement artifact
- `IC3`: blink-related component
- `IC6`, `IC7`: mixed EMG/ECG-like contamination
- `IC8`: additional spurious/non-neural contribution

Removed set in reconstruction: `IC1, IC3, IC6, IC7, IC8`.

## Results and Figures
### Step 1 - Raw 13-channel EEG (before correction)
![Step 1 - Raw EEG](figures/stage02c_p01_fig_001.png)

### Step 2 - PSD of raw EEG
![Step 2 - Raw EEG PSD](figures/stage02c_p02_fig_001.png)

### Step 5 - Estimated ICs (time domain)
![Step 5 - IC time courses](figures/stage02c_p05_fig_001.png)

### Step 6 - PSD of ICs
![Step 6 - IC PSD](figures/stage02c_p06_fig_001.png)

### Step 7 - Detailed IC inspection panels
![Step 7 - IC inspection 1](figures/stage02c_p07_fig_001.png)
![Step 7 - IC inspection 2](figures/stage02c_p07_fig_002.png)
![Step 7 - IC inspection 3](figures/stage02c_p07_fig_003.png)
![Step 7 - IC inspection 4](figures/stage02c_p07_fig_004.png)
![Step 7 - IC inspection 5](figures/stage02c_p07_fig_005.png)

### Step 8 - Cleaned EEG and pre/post PSD comparison
![Step 8 - Cleaned EEG (time)](figures/stage02c_p08_fig_001.png)
![Step 8 - PSD after correction](figures/stage02c_p08_fig_002.png)
![Step 8 - PSD before vs after](figures/stage02c_p08_fig_003.png)

## Interpretation
- ICA isolates non-neural sources that overlap with EEG in frequency and are difficult to remove via simple filtering alone.
- After IC rejection, the time-domain traces show reduced large-amplitude ocular/motion contamination.
- PSD overlays indicate cleaner channel spectra while preserving physiologically meaningful EEG content.
- The workflow is consistent with Stages 02A and 02B, adapted here to the 13-channel montage and the stronger lateral eye-movement artifact.

## Conclusion
Stage 02C successfully improves signal quality through ICA-based artifact rejection on a low-density montage. Removing IC1/3/6/7/8 yields cleaner EEG suitable for downstream analyses while preserving relevant neural dynamics.




