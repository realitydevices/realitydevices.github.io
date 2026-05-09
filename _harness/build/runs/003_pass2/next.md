# Pass 3 ticket — bisect placement so the card sits beside the logo, not on it

Decision class: **refine current slice (slice 0).**

Pass 2's scale-on-reveal mechanic landed correctly and should be kept.
The single thing that broke is `worldPos`: the move from `(28, 6, 18)` to
`(22, 5, 30)` swung past the goal — at the anchor view (`yaw=0.4,
pitch=0.1`) the card's projected centre is now *inside* the logo's
bounding box. Pass 1 over-shot right (right-third bleed); Pass 2
over-shot centre. Bisect.

## Single move

In `index.html`'s `items` array, change

```js
worldPos: new THREE.Vector3(22, 5, 30)
```

to

```js
worldPos: new THREE.Vector3(26, 6, 22)
```

Reasoning (from Alex's peer review): the camera at the anchor view sits
roughly at `(sin0.4·cos0.1·R, sin0.1·R, cos0.4·cos0.1·R)`; `(22,5,30)`
projects toward centre, `(28,6,18)` projects toward the right edge.
`(26, 6, 22)` is the bisect — projected centre clearly to the right of
the logo at the anchor view, but not bleeding into the right edge at
the front view. The y-axis returns to 6 (Pass 1's value) since 5 was a
secondary tweak and Pass 1's vertical placement read fine.

Do not change anything else this pass:
- Keep `reveal_scale = 0.6 + 0.4 * reveal`.
- Keep `transform: translate(...) translate(-50%, -50%) scale(...)` with
  `transform-origin: center center`.
- Keep `fade: 0.6` and `anchorDirection(0.4, 0.1)`.
- Do not rename `anchorDirection` or `_camDir` (Alex's flagged
  half-truths are deferred to a future fix-pass).
- Do not change the opacity floor or the scale floor (Alex's note that
  the scale animation is happening invisibly while opacity is 0 is
  recorded; pairing those is a future tunable, not this pass).

## Why this is the right next move

- Cohesion landed at 2.0 this pass against a target of ≥4.0. Alex's
  firm call was unambiguous: at the anchor frame the card is inside
  the logo's bounding box. The slice's headline goal is "card beside
  the logo at the anchor view"; that is what this single number-edit
  exists to achieve.
- Weight regressed from 4.0 to 3.0 specifically because the
  composition reads as a tunable that wasn't validated against the
  screenshot. A correct placement should restore weight by removing
  the "twitchy outcome" reading.
- Brand held at 3.0 but Sam and Alex both flagged the off-axis
  collision as the thing keeping it from 4.0. Same edit fixes both.
- One atomic change, one reviewable signal: at the anchor view, does
  the card sit *beside* the logo with both layers fully readable?

## Done for this pass

- At anchor view (`yaw=0.4, pitch=0.1`): card's projected centre is
  visibly to the right of the logo's bounding box. The logo and the
  card are both fully readable; no overlap.
- At front view (`yaw=0, pitch=0`): card is small (0.6× scale) and
  low-opacity. Does not bleed into the right edge of the screen; does
  not read as a "placeholder box that hasn't loaded."
- Partial-reveal frame (`yaw=0.2, pitch=0.05`): card is mid-scale,
  mid-opacity, sitting between the front and anchor positions.
- Far view (`yaw=-1.0, pitch=0`): card invisible (≤0.05 opacity).
- `score.json` for Pass 3 shows `cohesion` axis mean ≥ 4.0 (Alex's
  call), `brand` ≥ 3.0, `weight` ≥ 4.0.

## Capture

`_harness/build/capture.sh 003_pass3` (same four angles as before:
front, at-anchor, partial, far).

**Probe must be real this pass.** Pass 2's probe was a stub for the
second time in a row; the ticket required (and the synthesizer
reaffirms) explicit observations:

- Console output during page load: any errors / warnings.
- Card's screen-space size and centre coordinate at each of the four
  capture frames (`getBoundingClientRect()` is fine; one line per
  frame).
- One sentence on whether the card now sits *beside* the logo at the
  anchor view, or still overlaps it.

If the probe is a stub a third time, the next synthesizer pass will
record it as a process invariant break.

## Out of scope (do not touch)

- Item content beyond `<h2>Writing</h2>`. Real content ships in
  slice 3+.
- A second item.
- The opacity-floor / scale-floor pairing (Alex's invisibility-of-the-
  scale-cue note) — a future tunable.
- `anchorDirection` / `_camDir` renames (future fix-pass).
- Resize hook in `capture.sh` (slice 1).
- Camera lerp, lighting, palette, monoliths, fog, particles, half-space
  invariant.

## What review will look at

- The anchor-view screenshot. This is the one frame that matters this
  pass. If the card sits beside the logo with both fully readable,
  cohesion lifts and the slice can converge next pass. If it still
  overlaps (either centre or right-bleed), the bisect needs another
  pass.
- Whether weight recovers. Alex's call.
- Whether the front view still reads as restrained rather than empty.
  Sam and Jess.

## Notes for the synthesizer that produced this ticket

- `identity_drift: true` fired for the **second consecutive
  content-pass**. Both flaggings are comprehension-cluster phrases
  ("I can't tell what he does" / "I don't know what this is") that
  the `audience_floor` steering note already names as expected during
  slices 0–2. The synthesizer recorded the signal faithfully (Pass 1
  review.md, Pass 2 next.md, Pass 2 review.md). One more such pass
  fires the kill criterion on a signal that is structurally guaranteed
  to recur until slice 3 ships content. **Maintainer action requested
  before Pass 3 review:** either tighten the rubric to require phrases
  from the *same* identity-failure cluster (sales-site / feed /
  portfolio), or add a comprehension-cluster exemption while real
  content is missing. This is now load-bearing on the loop's
  continuation.
- The probe stubbing is on its way to becoming a process invariant.
  Recording it as steering, not yet a failure.
