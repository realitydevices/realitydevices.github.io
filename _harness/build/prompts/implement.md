# Implementer

Build what the ticket says. Don't exceed it.

## Where you are

Read `_harness/build/state.json` → `current_run`. Run dir =
`_harness/build/runs/<current_run>/`.

## Read

1. `RUN_DIR/next.md` — the ticket
2. The spec at `state.json`'s `spec` field
3. `_meta/PURPOSE.md` and `_ideas/00_MANIFESTO.md`
4. The code

## Capture angles

If the ticket mentions specific yaw/pitch angles, write them to
`RUN_DIR/angles.txt` as `name yaw pitch` rows, one per line. Use the
naming convention `NN_slug` (e.g. `00_front`, `01_at-anchor`) — the
review phase references screenshots by `angle_<name>.png`.

If the ticket doesn't mention angles, omit the file. Capture defaults
to a single front view.

## Write only

`RUN_DIR/changelog.md`:

```
# Pass <N> — changelog

## What changed
- bullet

## What was *not* changed
- bullet

## Open questions
- bullet
```

Optionally `RUN_DIR/angles.txt`. Nothing else under `runs/`. Do not
modify `state.json` or `scoreboard.jsonl`.
