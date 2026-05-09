# Pass 1 ticket — decouple item world position from anchor direction

Decision class: **refine current slice (slice 0).**

## Single move

Change the item model so the **anchor direction** drives only the reveal
opacity, and the **world position** is an independently-authored 3D point.
Concretely, in `index.html`'s `items` array, replace the `depth` scalar
with an explicit `worldPos` `THREE.Vector3`. Compute reveal as before
(angular distance between `camera.position.normalize()` and `anchorDir`),
but project `worldPos` directly — do not derive world position from
`anchorDir`.

For the existing single placeholder item, set:

```js
{
  el: document.getElementById('item-writing'),
  anchorDir: anchorDirection(0.4, 0.1),
  worldPos: new THREE.Vector3(28, 6, 18),   // beside-and-above the logo at anchor view
  fade: 0.6,
}
```

The numbers `(28, 6, 18)` place the item to the right of the logo and
slightly up, in the half-space the camera occupies at yaw=0.4,
pitch=0.1. Logo bbox is roughly ±10 around origin; this puts the item
clear of it.

Leave `fade = 0.6` unchanged this pass. The front-view bleed
(`smoothstep(0, 0.6, 0.41) ≈ 0.76` → reveal ≈ 0.24) is acknowledged but
deferred to Pass 2 — fixing two things at once would muddy the signal
on whether the placement-model change alone resolves the cohesion and
brand findings.

## Why this is the right next move

The Pass-0 review converged on placement geometry as the central
problem. Three personas, three different framings, same root: the item
sits between camera and logo at the anchor view, and bleeds into the
front view. Both symptoms come from coupling world position to anchor
direction. Decoupling them is the smallest model change that fixes the
occlusion finding cleanly; once placement is right, fade-window tuning
is a one-number change in Pass 2.

## Done for this pass

- At anchor view (yaw=0.4, pitch=0.1), the item sits beside the logo,
  not over it. The brand mark is visible at full strength while the
  item is at full reveal.
- At front view (yaw=0, pitch=0), the logo is visually dominant. The
  item is allowed to bleed at ≤0.25 opacity for now (Pass 2 will close
  this) but must not visually compete with the logo.
- At yaw=-1.0, pitch=0, item is invisible (≤0.05 opacity).
- The reveal curve still varies smoothly across the orbit — angular
  distance still drives opacity; this pass changed *only* world position.
- `score.json` for Pass 1 shows `cohesion` axis mean ≥ 4.0 (Alex's
  call) and `brand` axis mean ≥ 3.0 (Sam's call).

## Capture

`_harness/build/capture.sh 002_pass1` (same four angles as Pass 0).
Probe must report the at-anchor and front views explicitly: where is
the item relative to the logo silhouette in each.

## Out of scope (do not touch)

- Fade window edges (deferred to Pass 2).
- Item content beyond the existing `<h2>Writing</h2>` heading.
- Multiple items.
- Resize hook in capture.sh (Pass 1 of slice 1).
- Any scene math.

## What review will look at

- Is the logo the visually dominant element at *all four* capture angles?
- Does decoupling world position from anchor direction read as a
  cleaner model, or as ad-hoc placement?
- Does the fade still feel coherent now that world position is no
  longer on the anchor ray?
