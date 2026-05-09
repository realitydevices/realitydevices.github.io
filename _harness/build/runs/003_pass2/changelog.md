# Pass 2 — changelog

## What changed
- `index.html` items array: moved the writing card's `worldPos` from
  `(28, 6, 18)` to `(22, 5, 30)`. Higher z brings the card nearer the
  camera at the anchor view (`yaw=0.4, pitch=0.1`); reduced x makes the
  front view (`yaw=0, pitch=0`) less right-third anchored. `anchorDir`
  and `fade: 0.6` are unchanged.
- `index.html` `updateItems()`: reveal now drives a multiplicative scale
  in addition to opacity. `reveal_scale = 0.6 + 0.4 * reveal`, so the
  card runs from 60% size at low reveal to 100% size at full reveal.
- `index.html` `updateItems()`: replaced `style.left` / `style.top`
  positioning with a single `style.transform` of the form
  `translate(<px>,<py>) translate(-50%,-50%) scale(<reveal_scale>)`.
  This composes correctly with `transform-origin: center center` so
  the card scales around its own centre rather than the projection
  origin or the top-left corner.
- `.item` CSS: pinned `left: 0; top: 0` (since position is now
  transform-driven), added `transform-origin: center center`, and
  updated `will-change` from `opacity, left, top` to
  `opacity, transform`.
- Wrote `_harness/build/runs/003_pass2/angles.txt` with the four
  Pass-1 angles (front, at-anchor, partial, far) so capture.sh
  reproduces the same review framings.

Fade window left at `0.6` per the ticket's instruction to only
tighten if move-forward + scale don't already resolve the front-view
bleed; capture review will show whether that holds. Recording the
choice here so the reviewer doesn't have to infer it.

## What was *not* changed
- `anchorDirection()` helper — Alex's flag that its name half-lies is
  noted by the ticket as out of scope for this pass.
- `fade: 0.6` — left at the prior value; will be tightened to 0.45 in
  a follow-up if the front-view bleed persists. Not split across two
  passes, just deferred-conditionally per the ticket.
- `.item` width/height (still 320×240) and content (still just
  `<h2>Writing</h2>`) — slice 3+ territory.
- Camera lerp, two-tone lighting, palette, monoliths, fog, particles,
  brand fade behaviour, half-space invariant — all manifesto- or
  ticket-protected.
- No second item added.
- `capture.sh` resize hook — slice 1 territory.

## Open questions raised by the implementation
- The composition-order comment in `updateItems()` notes that CSS
  applies transforms left-to-right in *coordinate-system* terms (each
  transform composes onto the result of the prior), which is what the
  ticket's prescribed order assumes. With `transform-origin: center
  center` the scale's pivot is the card's own centre regardless of
  preceding translates, which is the behaviour the ticket wants.
  Worth verifying in the probe — if the card visually drifts as it
  scales, the order is wrong.
- The 0.6 floor on `reveal_scale` is paired with a 0.0 floor on
  `opacity`. At very low reveal the card is small but fully
  transparent, so the floor doesn't actually keep it visible — it
  only keeps it from collapsing to a point in the moment before it
  fades in. Whether this matches the intent ("still feel like a thing
  in space") depends on whether the reviewer reads "thing in space"
  as a size cue, an opacity cue, or both. Flagging for the reviewer.
- The item still uses absolute pixel projection from
  `worldPos.project(camera)`. Under window resize the card's
  pixel-space size (320×240 × reveal_scale) is constant while the
  projection point moves with the orthographic frustum. This is the
  Pass 1 / slice 1 issue and is not in scope for this pass; noting
  here in case the resize-frame capture surfaces it visibly.
