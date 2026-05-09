# Pass 1 — changelog

## What changed
- `index.html`: replaced the item's `depth: 30` scalar with an
  explicit `worldPos: new THREE.Vector3(28, 6, 18)` — the value
  specified verbatim in the ticket.
- Removed the post-array `items.forEach(...) { it.anchorPos = ... }`
  derivation step. World position is now authored, not computed.
- `updateItems()` now projects `it.worldPos` directly instead of the
  derived `it.anchorPos`. Reveal computation (angular distance between
  `camera.position.normalize()` and `anchorDir` → `1 - smoothstep(0,
  fade, ang)`) is unchanged: `anchorDir` still drives opacity only.
- Updated the explanatory comment block above the `items` array to
  describe the new model: `anchorDir` for reveal, `worldPos` for
  projection, with a note on *why* the two were decoupled (Pass 0
  finding: occlusion at the anchor view).

## What was *not* changed
- `fade: 0.6` left as-is. The Pass-0 front-view bleed
  (`reveal ≈ 0.24`) is acknowledged in the ticket and explicitly
  deferred to Pass 2 — fixing two things at once would muddy the
  signal on whether the placement-model change alone resolves the
  cohesion + brand findings.
- No scene math touched (camera lerp, lighting, palette, monoliths,
  brand fade — all untouched).
- No new items added. Single placeholder item only.
- No content changes inside the `<h2>Writing</h2>` card.
- `anchorDirection()` helper signature and behaviour preserved, even
  though the `pitch` value `0.1` is now used only for reveal — the
  helper is still a useful primitive for the next placement.
- No changes to `capture.sh` or to `angles.txt` — the ticket says
  "same four angles as Pass 0," so I omitted `RUN_DIR/angles.txt`
  and capture will use its defaults.

## Open questions raised by the implementation
- The ticket's `worldPos = (28, 6, 18)` places the card to the right
  and slightly above the logo *in screen space at the anchor view*,
  but its world-space relationship to `anchorDir = (sin0.4·cos0.1,
  sin0.1, cos0.4·cos0.1) ≈ (0.387, 0.0998, 0.916)` is now arbitrary.
  That is the explicit point of this pass — but the next pass should
  consider whether some looser invariant (e.g. "worldPos must lie in
  the half-space `dot(worldPos, anchorDir) > 0`") is worth encoding,
  or whether free-form authoring is the right end state.
- With the current camera frustum and the orthographic-ish framing,
  `(28, 6, 18)` lands at a specific screen offset. Under window
  resize the *world* point is fixed but the *screen* offset relative
  to the logo changes. Pass 1 of slice 1 (per the spec's slice plan)
  is explicitly the resize/projection-correctness pass, so this is
  expected — flagging it so the reviewer doesn't surface it as new.
- The reveal curve is still driven by angular distance from
  `anchorDir`, but the item is no longer sitting on that ray. At
  views where the camera is close to `anchorDir` but `worldPos`
  happens to be off-screen (or behind the camera), the item could
  read as "fully revealed but invisible." Not an issue for the
  current single placement, but it will matter once we have three
  items at varied placements; worth thinking about before Pass 5.
- The ticket's done-condition asks for `cohesion ≥ 4.0` and
  `brand ≥ 3.0`. The front-view bleed is deferred, so `brand` is
  the axis at risk; if Pass 1 lands brand below 3.0, that is the
  signal that placement alone wasn't enough and Pass 2's fade-window
  tighten cannot wait.
