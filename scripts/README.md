# Runner Scripts

These helpers are thin wrappers for running the main MATLAB workflow from the repository root.

## MATLAB

Run the modules individually:

```matlab
addpath('scripts');
run_preprocessing();
run_ica_workflows(true);
run_erp_analysis();
run_time_frequency_analysis();
```

Run the full workflow:

```matlab
addpath('scripts');
run_full_pipeline(true);
```

## Validation

```matlab
addpath('scripts');
validate_outputs();
```
