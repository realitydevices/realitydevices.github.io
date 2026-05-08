# Harness

Iterative refinement loop for the 3D logo (and future visual targets).

## Layout
- `tree/` — goal nodes as markdown. `11_3d-logo.md` is the current leaf.
- `workshop/` — the refinement loop.
  - `capture.sh` — Chrome-headless screenshots from N orbital angles.
  - `reviewer.md` — persona + rubric for the aesthetic reviewer.
  - `runs/` — one folder per iteration: `angle_*.png`, `review.md`, `next.md`.
- `telescope/` — (v2) generalize / specifize prompts that walk the tree.

## Run a workshop pass
```sh
_harness/workshop/capture.sh 001_baseline
```
Screenshots land in `_harness/workshop/runs/001_baseline/`. Hand the PNGs +
`reviewer.md` + `tree/11_3d-logo.md` to a reviewer (currently: just paste
into a Claude conversation) and write the result back as `review.md` and
`next.md` in the same run dir.

## Toolchain
- Python 3 (stdlib `http.server`)
- Chrome (system install)
- Bash

No npm, no node modules.
