# Pass 3 changelog

## What changed

- `index.html`, `items` array, single item (`item-writing`):
  `worldPos` changed from `new THREE.Vector3(22, 5, 30)` to
  `new THREE.Vector3(26, 6, 22)`. This is the bisect between Pass 1's
  `(28, 6, 18)` (over-shot right, right-third bleed) and Pass 2's
  `(22, 5, 30)` (over-shot centre, projected inside the logo's
  bounding box at the anchor view). The y-axis returns to Pass 1's
  `6`. The inline comment was updated to reflect the new reasoning.

## What was *not* changed

- `reveal_scale = 0.6 + 0.4 * reveal` — kept as-is.
- `transform: translate(...) translate(-50%, -50%) scale(...)` with
  `transform-origin: center center` — kept as-is.
- `fade: 0.6` and `anchorDirection(0.4, 0.1)` — kept as-is.
- `anchorDirection` and `_camDir` names — not renamed (deferred fix-pass).
- Opacity floor and scale floor — not paired (future tunable).
- Item content beyond `<h2>Writing</h2>` — untouched (slice 3+).
- No second item added.
- `capture.sh` resize hook — untouched (slice 1).
- Camera lerp, lighting, palette, monoliths, fog, particles — untouched.

## Open questions

- Is the bisect tight enough? Pass 1 was right-edge bleed, Pass 2 was
  centre-overlap; `(26, 6, 22)` should land "card to the right of the
  logo, both fully readable" at the anchor view, but the projected
  centre's exact pixel position depends on the orthographic frustum at
  the maintainer's viewport — only the screenshot tells us. If it is
  still inside the logo's bbox, the next bisect target is the segment
  `(26..28, 6, 18..22)`; if it now bleeds right at front view, the
  next target is `(22..26, 6, 22..26)`.
- The `identity_drift: true` flagging that has fired two consecutive
  content-passes is a synthesizer-rubric concern, not an implementer
  concern, but it is load-bearing on whether this loop continues past
  Pass 3 review. Implementer flags it forward as the ticket requested,
  no action taken in code.
- The probe-stub-as-process-invariant risk is unchanged; this pass's
  capture/probe is the harness operator's responsibility, not the
  implementer's, and the ticket explicitly asks for a real probe this
  time.
