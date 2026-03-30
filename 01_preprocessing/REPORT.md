# Report: Stage 01 - EEG Preprocessing (Subject 035)

## Objective
Apply the first preprocessing steps to continuous EEG from a trial-based oddball experiment.

## Dataset and Task
- File: `sub-035_ses-01_task-Rest_eeg.mat`
- Channels: 59 EEG electrodes (reference: CPz in acquisition)
- Sampling rate: 500 Hz
- Stimuli: `standard`, `target`, `distractor`
- Goal: produce cleaned, epoch-concatenated EEG and identify/remove bad channels for subsequent stages.

## Point-by-Step Method
1. Loaded EEG data and converted `X` from single to double precision.
2. Prepared optional resampling logic (`p=1`, `q=1` in this run, so no resampling applied).
3. Linearly detrended all channels.
4. Plotted full-duration detrended EEG.
5. Estimated pre-filter PSD with Welch method and inspected all channels + focused channels (F3, F1, PO3).
6. Designed and applied sequential zero-phase IIR filters:
   - low-pass elliptic (passband up to 60 Hz, stopband from 80 Hz),
   - high-pass elliptic (passband from 0.5 Hz),
   - 60 Hz notch (`BW = 60/45`).
7. Plotted filtered EEG in time domain.
8. Estimated PSD after filtering and compared with pre-filter PSD (all channels and F3/F1/PO3).
9. Overlaid stimulus markers on filtered EEG using color by stimulus class.
10. Extracted epochs around each stimulus in the interval `[-0.2, 0.8]` s.
11. Concatenated epochs into a 2-D matrix.
12. Detected bad channels via nearby-channel correlation method.
13. Removed bad channels from the concatenated data.
14. Saved preprocessing output to `sub-035_PreprocessStep1.mat`.

## Preprocessing Rationale
- Preprocessing is a signal-to-noise trade-off: reducing artifact/noise while preserving task-relevant EEG content.
- Resampling is kept configurable because acquisition at high sampling rate is flexible, but lower rates can reduce computational load when high frequencies are not needed.
- Linear detrending removes slow baseline drift (electrode/skin interface effects) before spectral analysis.
- Filtering choices are goal-driven:
  - high-pass (0.5 Hz) attenuates very slow drifts and DC components,
  - low-pass attenuates higher-frequency noise not required for this analysis,
  - notch filter removes residual power-line interference.
- Zero-phase filtering (`filtfilt`) is used to avoid phase distortion of EEG waveforms in offline analysis.
- Filtering is applied on continuous EEG before epoching to avoid repeating edge artifacts at each epoch boundary.

## Results and Figures

### Detrended EEG (time domain)
![Detrended EEG](figures/stage01_p04_fig_001.png)

### PSD before filtering
![PSD channels 1-30](figures/stage01_p05_fig_001.png)
![PSD channels 31-59](figures/stage01_p05_fig_002.png)
![PSD focus F3](figures/stage01_p05_fig_003.png)
![PSD focus F1](figures/stage01_p05_fig_004.png)
![PSD focus PO3](figures/stage01_p05_fig_005.png)

### IIR filter responses
![Low-pass response](figures/stage01_p06_fig_001.png)
![High-pass response](figures/stage01_p06_fig_002.png)
![Notch response](figures/stage01_p06_fig_003.png)

### Filtered EEG (time domain)
![Filtered EEG](figures/stage01_p07_fig_001.png)

### PSD comparison (before vs after filtering)
![PSD compare channels 1-30](figures/stage01_p08_fig_001.png)
![PSD compare channels 31-59](figures/stage01_p08_fig_002.png)
![PSD compare F3](figures/stage01_p08_fig_003.png)
![PSD compare F1](figures/stage01_p08_fig_004.png)
![PSD compare PO3](figures/stage01_p08_fig_005.png)

### Stimulus markers over filtered EEG
![Filtered EEG with markers](figures/stage01_p09_fig_001.png)

### Epoch-concatenated EEG
![Epoch concatenation](figures/stage01_p11_fig_001.png)

### Bad-channel identification
![Bad channel highlighted](figures/stage01_p12_fig_001.png)

Observed bad channel in this run:
- `index_bad = 11`
- channel label: `F1`

## Interpretation of Main Outcomes
- The PSD comparison confirms expected attenuation outside the target analysis band and reduction of narrow-band line-noise contamination.
- Time-domain plots after filtering preserve the main EEG morphology while removing part of the low-frequency drift and high-frequency contamination.
- Marker overlay validates temporal alignment between cleaned continuous EEG and stimulus events, supporting reliable epoch extraction.
- Correlation-based screening identified one outlier channel (`F1`), consistent with the objective of removing channels with atypical behavior before downstream ICA/ERP analyses.

## Conclusion
The required Stage 01 pipeline was completed end-to-end. The sequence of detrending, elliptic low/high-pass filtering, and 60 Hz notch filtering improved spectral quality while preserving physiologically meaningful structure. Epoching and concatenation were successfully completed, and one bad channel (`F1`) was identified and excluded before saving `sub-035_PreprocessStep1.mat` for downstream ICA/ERP/time-frequency analyses.





