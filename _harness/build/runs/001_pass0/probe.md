# Pass 0 — probe

## Console output during capture

Headless Chrome capture mode does not surface runtime console messages
through the screenshot pipeline used here, and the `--dump-dom` probe
returned only static script source rather than runtime output. For Pass 0
the proxy signal is: all four screenshots rendered without blank/black
frames, and the SVG-derived logo + monoliths + particles all rendered as
in prior workshop runs. No visible regression.

A proper console-capture probe (chrome `--enable-logging
--log-file=...` plus filtering, or a tiny puppeteer driver) is a
candidate Pass-1 add. Not blocking this pass.

## Resize behavior

Capture script does not currently force a window resize between frames,
so resize was *not* exercised in this capture. By inspection of
`index.html`:

- The existing `window.resize` handler updates the orthographic camera
  frustum and `renderer.setSize`. Untouched by this pass.
- `updateItems()` reads `window.innerWidth` / `window.innerHeight` every
  frame and re-runs `Vector3.project`, so item screen position will
  follow the new viewport on the next animation frame after resize.

That's a defensible argument that resize works, but it is *not* a
verified observation. Flagging as UNKNOWN for the invariant check.

A "force-resize during capture" hook (e.g. `?resize=1440x900,1024x768`
that animates a resize after N frames) would close this gap; recommend
for Pass 1 if the reviewers find resize an open question.

## Subjective fade read (one sentence)

The fade reads as a UI surface lighting up rather than as an item
emerging from depth — at the front view the item is already visible at
~24% opacity (right of the logo, faint), so there is no "I orbited and
*then* it appeared" beat. The fade is smooth on the way out (angle_03)
but the onset is too generous, so the discovery moment is missing.

## Performance

Eyeball only, per ticket. Capture run took roughly the same wall time as
prior workshop runs at the same headless config, so no obvious regression.
Not measured.

## Done-criteria assessment (implementer's pre-review honest read)

| Criterion | Status |
|---|---|
| Invisible (≤0.05) at yaw=0,pitch=0 | **FAIL** — ~0.24 in angle_00. (Math conflict in ticket.) |
| Fades in smoothly toward anchor | PASS — angle_02 → 01 transition reads smooth. |
| Fades out symmetrically past anchor | PASS — angle_03 fully invisible. |
| Position tracks resize | UNKNOWN — not exercised. |
| No new console errors | UNKNOWN — not properly captured. |
