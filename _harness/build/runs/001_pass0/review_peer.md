# Review (Alex — peer) — 001_pass0

*Inputs: all four PNGs, `_ideas/02_EDGE_PANELS_SPEC.md`, `changelog.md`,
`probe.md`, plus the diff against the parent commit.*

## Headline

The mechanic is right; the geometry is wrong. Reveal-by-angular-distance
projects fine, but item-at-anchorDir×30 puts the box on the line between
camera and origin, so when the user looks at the item it occludes the
logo. The front-view bleed is the same problem from the other side: the
fade window is wide enough that the item is already at ~24% opacity when
the camera is centred on the logo.

## Per axis

- **brand: 3** — The mechanic doesn't damage the brand by design, but the
  current geometry (occlusion in angle_01, faint bleed in angle_00)
  does in practice. Ranking 3 because the fix is local and obvious;
  this isn't a brand decision being made wrong, it's a placement
  parameter being wrong.
- **exploration: 4** — Reveal-by-angular-distance is the right primitive.
  The angular fade itself, between angle_03 (faded) → angle_02 (partial)
  → angle_01 (full), is the discovery shape we want once the front-view
  bleed is fixed.
- **weight: 2** — The fade does not feel weighted. At yaw=0,pitch=0 the
  item is already there at a quarter opacity; there is no "I had to
  orbit to find this" beat. That is exactly the manifesto §2 failure
  mode — instant rather than considered.
- **audience: defer** — Sam's lane.
- **cohesion: 2** — A bordered box with a small caps heading sitting in
  the same composition as the extruded logo and the wireframe monoliths
  reads as a different design language. The DOM layer is bolted onto
  the WebGL layer in the most literal way. This is a Pass-1 problem,
  not a Pass-0 problem, but it's the cohesion score for *this* pass.

## Implementation notes

- The math is right. `camera.position.clone().normalize()` for camera
  direction, `acos(clamp(dot, -1, 1))` for angular distance, and
  `Vector3.project()` after `camera.updateMatrixWorld()` — that's all
  the right primitives, used cleanly. The implementer didn't duplicate
  the orbit math; they consume the camera's already-computed state.
- The reused vectors (`_camDir`, `_projected`) avoid per-frame
  allocation. Honest.
- The `depth = 30` choice is a placement bug, not a math bug.
  Three workable Pass-1 options: (a) `depth = -30` (item on the
  far side of origin → behind the logo at anchor view, which is its
  own occlusion problem in reverse but at least the logo wins);
  (b) place item at `cameraDir_when_at_anchor + view_plane_offset`
  so it sits beside the logo at anchor view; (c) decouple item
  *world position* from the *anchor direction* entirely — the anchor
  drives reveal, the world position is authored independently to sit
  beside the logo at anchor view.
- Front-view bleed: with anchor at (yaw=0.4, pitch=0.1) the angular
  distance from (0,0,1) is ~0.41 rad. `smoothstep(0, 0.6, 0.41) ≈
  0.76`, so reveal ≈ 0.24. To meet the spec's "≤ 0.05 at front" the
  fade has to clip earlier — `smoothstep(0, 0.35, ang)` would do it,
  or move the anchor further off-axis, or use a steeper curve.
- Resize was not exercised in capture. The probe's argument that
  resize works "by reading window dimensions every frame" is correct
  but unverified. Capture script should grow a resize hook.
- `Vector3.project` past z=1 (item behind camera near plane) is a
  latent footgun once items live further out — the implementer
  flagged it; not blocking now.

## Invariants

- nav_chrome: PASS
- placement_authored: PASS (anchor literals at line ~616 of index.html)
- content_local: PASS
- scene_unchanged: PASS (verified by reading the diff — only addition
  inside animate() is `camera.updateMatrixWorld(); updateItems();`)
- no_build_runtime: PASS
- no_third_party_overlay: PASS

## Failure-phrase check

"the obvious thing wasn't done" — the obvious thing being *don't put
the item directly between camera and logo*. That's the central finding.

## One concrete observation

Pass 1 should change item depth (or, better, decouple item world
position from anchor direction) so the item does not occlude the logo
at the anchor view, *and* tighten the fade window so the item is
genuinely invisible at front view. Both are placement, not math; the
math survives.
