# Contributing Guide

This repository is structured as a research pipeline. Keep changes reproducible, traceable, and stage-scoped.

## Branch Strategy

- Create focused branches from `main` (example: `docs/runbook-update`, `stage03/erp-fix`).
- Keep each pull request to one clear objective.
- Delete feature branches after merge.

## Commit Style

- Use short, action-oriented messages.
- Recommended format:
  - `docs: clarify stage02 runner instructions`
  - `stage04: fix CWT frequency axis labeling`
  - `scripts: add output validation check`

## Reproducibility Requirements

- If you change execution behavior, update:
  - `RUNBOOK.md`
  - `ENVIRONMENT.md` (if dependencies change)
  - `scripts/README.md` (if runner commands change)
- Keep stage outputs inside each stage's `figures/` directory.

## Reports and Code

- Keep report narratives consistent with script names and figure names.
- Prefer explicit, stage-specific file names over generic names.
- Avoid renaming large folders unless there is a clear structural benefit.

## Pull Request Checklist

- [ ] Change is limited to a clear scope.
- [ ] Related docs were updated.
- [ ] Stage scripts still run (or limitation documented).
- [ ] New files follow the stage naming convention.
