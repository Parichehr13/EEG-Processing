# Report: Exercise 1 - EEG Preprocessing (Subject 035)

## Objective
Apply the first preprocessing steps to continuous EEG from a trial-based oddball experiment, following the requirements in `Laboratory_Exercise1.pdf`.

## Dataset and Task
- File: `sub-035_ses-01_task-Rest_eeg.mat`
- Channels: 59 EEG electrodes (reference: CPz in acquisition)
- Sampling rate: 500 Hz
- Stimuli: `standard`, `target`, `distractor`
- Goal: produce cleaned, epoch-concatenated EEG and identify/remove bad channels for subsequent exercises.

## Point-by-Point Method (Exercise 1)
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

## Preprocessing Rationale (from Section 2 Notes)
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

### Point 4 - Detrended EEG (time domain)
![Point 4 - Detrended EEG](figures/exercise1_p04_fig_001.png)

### Point 5 - PSD before filtering
![Point 5 - PSD channels 1-30](figures/exercise1_p05_fig_001.png)
![Point 5 - PSD channels 31-59](figures/exercise1_p05_fig_002.png)
![Point 5 - PSD focus F3](figures/exercise1_p05_fig_003.png)
![Point 5 - PSD focus F1](figures/exercise1_p05_fig_004.png)
![Point 5 - PSD focus PO3](figures/exercise1_p05_fig_005.png)

### Point 6 - IIR filter responses
![Point 6 - Low-pass response](figures/exercise1_p06_fig_001.png)
![Point 6 - High-pass response](figures/exercise1_p06_fig_002.png)
![Point 6 - Notch response](figures/exercise1_p06_fig_003.png)

### Point 7 - Filtered EEG (time domain)
![Point 7 - Filtered EEG](figures/exercise1_p07_fig_001.png)

### Point 8 - PSD comparison (before vs after filtering)
![Point 8 - PSD compare channels 1-30](figures/exercise1_p08_fig_001.png)
![Point 8 - PSD compare channels 31-59](figures/exercise1_p08_fig_002.png)
![Point 8 - PSD compare F3](figures/exercise1_p08_fig_003.png)
![Point 8 - PSD compare F1](figures/exercise1_p08_fig_004.png)
![Point 8 - PSD compare PO3](figures/exercise1_p08_fig_005.png)

### Point 9 - Stimulus markers over filtered EEG
![Point 9 - Filtered EEG with markers](figures/exercise1_p09_fig_001.png)

### Point 11 - Epoch-concatenated EEG
![Point 11 - Epoch concatenation](figures/exercise1_p11_fig_001.png)

### Point 12 - Bad-channel identification
![Point 12 - Bad channel highlighted](figures/exercise1_p12_fig_001.png)

Observed bad channel in this run:
- `index_bad = 11`
- channel label: `F1`

## Interpretation of Main Outcomes
- The PSD comparison confirms expected attenuation outside the target analysis band and reduction of narrow-band line-noise contamination.
- Time-domain plots after filtering preserve the main EEG morphology while removing part of the low-frequency drift and high-frequency contamination.
- Marker overlay validates temporal alignment between cleaned continuous EEG and stimulus events, supporting reliable epoch extraction.
- Correlation-based screening identified one outlier channel (`F1`), consistent with the objective of removing channels with atypical behavior before downstream ICA/ERP analyses.

## Conclusion
The required Exercise 1 pipeline was completed end-to-end. The sequence of detrending, elliptic low/high-pass filtering, and 60 Hz notch filtering improved spectral quality while preserving physiologically meaningful structure. Epoching and concatenation were successfully completed, and one bad channel (`F1`) was identified and excluded before saving `sub-035_PreprocessStep1.mat` for downstream ICA/ERP/time-frequency analyses.

