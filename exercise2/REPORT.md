# Report: Exercise 2

## Objective
Evaluate PCA and ICA on synthetic mixtures of independent source signals.

## Method Summary
- Generated three independent sources (sinusoidal, triangular, square-like).
- Built linear mixtures with:
  - 3 observed channels,
  - 5 observed channels.
- Computed principal components through covariance eigendecomposition.
- Applied ICA demixing matrices exported from EEGLAB:
  - directly on mixed signals,
  - on reduced PCA subspace (first three PCs),
  - and with PCA reduction inside ICA.

## Results
The outputs show the expected behavior:
- PCA decorrelates mixtures but does not recover fully independent source waveforms.
- ICA recovers components with morphology closer to original generating signals.
- PCA-before-ICA works as dimensionality reduction for overdetermined mixtures.

![Exercise 2 - Sources and Initial Mixtures](figures/exercise2_fig_001.png)
![Exercise 2 - PCA Components](figures/exercise2_fig_002.png)
![Exercise 2 - ICA Recovery](figures/exercise2_fig_003.png)
![Exercise 2 - Five-Channel Mixtures](figures/exercise2_fig_004.png)
![Exercise 2 - Five-Channel PCA](figures/exercise2_fig_005.png)
![Exercise 2 - ICA on PCA-Reduced Data](figures/exercise2_fig_006.png)
![Exercise 2 - ICA with Internal PCA](figures/exercise2_fig_007.png)
![Exercise 2 - Additional Separation Output](figures/exercise2_fig_008.png)

## Conclusion
This exercise confirms the standard workflow for source separation: PCA for compact representation and ICA for approximate recovery of statistically independent latent generators.

