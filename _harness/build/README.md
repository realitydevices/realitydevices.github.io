# Build loop

Feature → implement → capture → review → next ticket. One reviewer, no
rubric. You feed in feedback when you want to.

## Phases

| Phase | Kind | Output (in `runs/<id>/`) |
|---|---|---|
| `implement` | agent | `changelog.md`, optionally `angles.txt` |
| `capture` | shell | `angle_*.png`, `manifest.txt`, `probe.md` |
| `review` | agent | `review.md` (verdict + summary) and `next.md` (next ticket) |
| `advance` | shell | new run dir seeded with `next.md` |

## Commands

```sh
./run.sh status              # state + trajectory
./run.sh next                # next pending phase
./run.sh prompt implement    # print the implement prompt
./run.sh prompt review       # print the review prompt
./run.sh phase capture       # run capture
./run.sh phase advance       # create next run dir
./run.sh complete <phase>    # mark phase done (review appends trajectory)
./run.sh redo review         # drop review outputs + trajectory line; re-run
./run.sh feedback            # open per-pass feedback.md
./run.sh notes               # open persistent maintainer_notes.md
./run.sh stop                # halt
./run.sh resume              # clear halt
```

## Stepping a pass

1. `./run.sh next` — confirm pending phase.
2. Agent phase (`implement` / `review`): get the prompt with
   `./run.sh prompt <phase>`, dispatch as a fresh isolated subagent,
   then `./run.sh complete <phase>`.
3. Shell phase (`capture` / `advance`): just `./run.sh phase <name>`.

## Maintainer injection

| File | Read by | Purpose |
|---|---|---|
| `runs/<id>/feedback.md` | reviewer (this pass only) | Per-pass override of the review's judgement |
| `maintainer_notes.md` | reviewer (every pass) | Persistent steering |
| `runs/<id>/next.md` (direct edit) | implementer (next pass) | Override the next ticket directly |
| `STOP` | driver | Halt the loop |

## Trajectory log

`scoreboard.jsonl` — one line per completed review:

```json
{"pass":1,"run_dir":"runs/002_pass1","ts":"...","on_track":"yes","summary":"..."}
```

`on_track` is `yes` / `no` / `partial`, taken from the review's first
section. The summary is the rest of that line. That's all the
trajectory needs — anything richer lives in `review.md`.

## State

`state.json` carries: `current_run`, `current_pass`, `spec` (path to
the active spec), and `last_completed_phase` (cosmetic — phase
detection actually goes off file presence).

To start a new build target: edit `spec` in `state.json`, seed a
`runs/000_seed/next.md` with the first feature ticket, reset
`current_run` and `current_pass`, truncate `scoreboard.jsonl`.
