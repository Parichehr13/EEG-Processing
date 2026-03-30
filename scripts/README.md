# Runner Scripts

## MATLAB

From repository root:

```matlab
addpath('scripts');
run_stage01();
run_stage02(true);
run_stage03();
run_stage04();
```

Or run the full MATLAB chain:

```matlab
addpath('scripts');
run_all_matlab_stages(true);
```

## Python (Stage 05)

From repository root:

```powershell
python scripts/run_stage05.py
```

If needed, use the local venv interpreter:

```powershell
.\05_decoding_classification\python\.venv\Scripts\python.exe scripts\run_stage05.py
```

## Validation

```matlab
addpath('scripts');
validate_outputs();
```
