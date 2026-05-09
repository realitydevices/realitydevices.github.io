# Pass 0 ticket — placeholder item anchored to scene direction

This is the bootstrap ticket for the build loop targeting
`_ideas/02_EDGE_PANELS_SPEC.md`. Pass 0 is also the loop's first run, so
the work is intentionally minimal: any review noise should be
attributable to the loop, not the change.

## Single move

Add one DOM-overlay element to `index.html` that:

- has class `.item` and contains a single `<h2>Writing</h2>`.
- is positioned every frame from a 3D anchor at `yaw = 0.4 rad`,
  `pitch = 0.1 rad`. The anchor direction is the unit vector
  `(sin(yaw)*cos(pitch), sin(pitch), cos(yaw)*cos(pitch))`. The world-space
  position is `anchorDir * 30` (placing it inside the camera's reachable
  shell at radius 70).
- has its screen position computed each frame by projecting the world
  position through the existing orthographic camera; CSS `left`/`top`
  follow the projection (item centred on the projected point).
- has opacity = `1 - smoothstep(0, 0.6, angularDistance(camDir, anchorDir))`
  where `camDir = camera.position.clone().normalize()` and
  `angularDistance = acos(clamp(camDir.dot(anchorDir), -1, 1))`.
- is sized 320×240 px, contains no chrome other than the heading, and
  has `pointer-events: none` for this pass.

## Why this is the right first move

Two questions need answers before any content slice can land:

1. Does the DOM-anchor projection track correctly under the existing
   orthographic camera + 0.05/frame lerp, including under window resize?
2. Does an angular-distance fade read as *discovery* or as a UI element
   switching on?

Everything else in the spec is downstream of those two.

## Done for this pass

- Item is invisible (opacity ≤ 0.05) when the camera is centred on the
  logo (`yaw=0, pitch=0`).
- Item fades in smoothly as the camera orbits toward (yaw=0.4, pitch=0.1).
- Item fades out symmetrically when the camera orbits past the anchor.
- Screen position tracks the projected anchor across one window resize
  during capture.
- No new console errors. Existing scene's perceived FPS is unchanged
  (eyeball; no measurement required this pass).

## Capture

Run `_harness/build/capture.sh 001_pass0` from the repo root. That script
captures four item-relevant angles into
`_harness/build/runs/001_pass0/`:

- `angle_00_front.png` — yaw=0, pitch=0. Item should be near-invisible.
- `angle_01_at-anchor.png` — yaw=0.4, pitch=0.1. Item should be fully revealed.
- `angle_02_partial.png` — yaw=0.2, pitch=0.05. Item should be partially revealed.
- `angle_03_far.png` — yaw=-1.0, pitch=0.0. Item should be fully faded.

Then write `probe.md` containing:

- Console output (errors / warnings / info during page load).
- What happened on a window resize during the capture run (the harness
  forces one resize between the second and third frame; check that
  `index.html`'s resize handler is hit and the item's screen position
  recomputes).
- One subjective sentence on the fade curve: does it read as discovery,
  or as a UI element switching on?

## Out of scope (do not touch in this pass)

- Wheel events, scroll capture.
- `posts/`, `links.json`, `scripts/generate-posts.mjs`.
- `prefers-reduced-motion` fallback.
- Any styling beyond the bare div + heading + faintest possible
  background so the projection is visible to the reviewer.
- A second item.
- Camera, lighting, idle breathing, palette, monoliths, particles, fog,
  or anything in the existing scene other than (a) exposing the projection
  helper if needed and (b) adding the per-frame item update inside the
  existing animate loop.

## What review will look at

- PNGs: does the fade read as discovery, or as a UI element switching on?
  Does the item's screen position make sense relative to the logo?
- Changelog: was the projection helper added cleanly, or did it duplicate
  scene math that already exists in the animate loop?
- Probe: did resize behave; were there console errors; subjective fade
  read.

## What review will *not* look at

- Typography polish, copy quality, item content. There is no content yet.
- Mobile / reduced-motion behaviour. That's slice 7.
- Performance under load. Eyeball-only this pass.
