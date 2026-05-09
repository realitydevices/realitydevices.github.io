# Review (Alex — peer) — 003_pass2

## Headline
Decoupling `worldPos` from `anchorDir` and adding the scale-with-reveal mechanic
land cleanly at the anchor view, but the at-anchor frame now shows the card
sitting *on top of* the logo rather than beside it — the move from
`(28,6,18) → (22,5,30)` traded the right-third bleed for a centre-overlap.

## Per axis
- brand: 3 — defer-leaning. The card's chrome (1px low-alpha border, 35% bg)
  reads as restrained, not LinkedIn-ish. But at the anchor framing the card
  literally bisects the logo, which is a brand cost. The move "next to the
  brand mark" that the comment at L637–639 promises isn't what the screenshot
  shows.
- exploration: 3 — fading-on-orbit still works (front view shows the card
  ghosted at top-right, far view shows it gone). The added scale gives a
  small "approaching" cue. But the cue is undermined by the floor: the card
  is opacity-0 long before reveal_scale gets near 0.6, so the scale animation
  is mostly happening invisibly. The floor is doing nothing the eye can see.
- weight: 3 — the reveal curve and scale composition are considered. What's
  not considered is the angle between "card overlapping the logo" and the
  manifesto's slow/intentional posture — overlapping the brand mark at the
  primary view is a twitchy outcome of a tunable, not a chosen composition.
- audience: defer — the placeholder div has no real content, so the Brisbane
  professional question doesn't bind yet.
- cohesion: 2 — at the anchor frame the card is *inside* the logo's bounding
  box. The two layers fight rather than coexist. This is the slice's core
  job (placement of one item) and it isn't there yet. Cohesion should
  improve materially with a placement tweak; flagging it here so the next
  pass treats it as the load-bearing edit.

## Implementation notes
- `worldPos: (22, 5, 30)` overshot. At anchor (`yaw=0.4, pitch=0.1`) the
  camera sits at roughly `(sin0.4·cos0.1·R, sin0.1·R, cos0.4·cos0.1·R)`,
  which for the default radius pushes the projection of `(22,5,30)`
  noticeably toward the centre — directly into the logo. The Pass 1 value
  `(28, 6, 18)` was outboard but right-third-bleeding; this pass swung past
  the goal. A point closer to `(26, 6, 22)` is probably what "beside the
  logo" actually wants. This is the obvious thing the next pass should
  bisect to.
- `_camDir` is computed as `camera.getWorldPosition(...).normalize()`, i.e.
  the *position* direction, not the forward vector. For this scene
  (camera always lookAt origin), position-direction and negated forward
  point the same way and the dot with `anchorDir` gives the right reveal.
  Fine for now — but the variable name half-lies, and the moment any item
  moves off the scene-origin sphere or any camera pans, this will silently
  drift. Worth a one-line rename + comment in a future fix-pass; not a
  pass-2 blocker.
- `reveal_scale = 0.6 + 0.4 * reveal` paired with a 0.0 opacity floor: the
  changelog already calls this out. The implementer is right — the floor
  is cosmetically a no-op because the thing is invisible by the time it's
  collapsed. Either drop the scale floor (let it scale to 0 and stop
  pretending) or pair it with an opacity floor (~0.05) so the size cue
  actually reads. Picking one is a tunable for next.md.
- `transform: translate(px,py) translate(-50%,-50%) scale(s)` with
  `transform-origin: center center` does what the changelog claims —
  scale pivots on the card's centre, no drift across the reveal sweep.
  Confirmed by visual diff between angle_00 (small, top-right) and
  angle_01 (full size, centred on logo): the card's centre stayed on the
  projected point. The math is right; the chosen point is wrong.
- Probe is a stub. There is no resize evidence, no console check, no perf
  eyeball. The changelog explicitly flags resize-pixel-size constancy as
  a known Pass-1/slice-1 gap, which is honest, but the peer-review default
  has to be `UNKNOWN` for resize-related invariants. The harness should
  treat a stub probe as a process miss for the next pass.

## Invariants (PASS / FAIL / UNKNOWN per row)
- nav_chrome: PASS — no chrome added; only a positioned card.
- placement_authored: PASS — `worldPos: new THREE.Vector3(22, 5, 30)` and
  `anchorDirection(0.4, 0.1)` are literal numbers in the items array.
- content_local: PASS — the card content is an inline `<h2>Writing</h2>`,
  no fetch.
- scene_unchanged: PASS — diff against changelog confirms no edits to
  camera lerp, breathing, lighting, or palette. Logo group's
  `rotation.z = Math.sin(t*0.3) * 0.03` is untouched.
- no_build_runtime: PASS — no new tooling on the runtime path.
- no_third_party_overlay: PASS — the card is first-party DOM.

## Failure-phrase check
"the obvious thing wasn't done" — the slice's headline goal was a card
that sits *next to* the logo at the anchor view; angle_01 shows it
overlapping the logo. The placement number was tuned but not validated
against the screenshot before declaring done. That's the obvious thing.

## One concrete observation
The at-anchor framing (angle_01) is the load-bearing screenshot for this
slice and it shows the card overlapping the logo's bounding box. The next
pass's single edit should be `worldPos.x` (and probably `worldPos.z`)
chosen to put the card's *projected centre* clearly to the right of the
logo at `yaw=0.4, pitch=0.1` — bisect between the Pass-1 `(28,6,18)`
which over-rightward-bled and this pass's `(22,5,30)` which centre-overlaps.
Everything else this pass did (scale-with-reveal, transform-origin,
transform-only positioning) is correct and should be kept as-is.
