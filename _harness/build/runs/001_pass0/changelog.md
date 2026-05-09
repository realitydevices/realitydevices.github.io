# Pass 0 — changelog

## What changed

- **`index.html` CSS:** added `.item` (320×240, fixed, very faint background
  + 1px border for visibility, opacity 0 by default, `pointer-events: none`)
  and `.item h2` (single-line caps heading in Lexend Peta, brand light).
- **`index.html` HTML:** added one `<div class="item" id="item-writing">`
  containing a single `<h2>Writing</h2>`.
- **`index.html` JS:** new helpers (`smoothstep`, `anchorDirection`),
  one-element `items` array carrying anchor/depth/fade, and `updateItems()`
  that runs every frame after `camera.lookAt(0,0,0)` /
  `camera.updateMatrixWorld()`. `updateItems` projects `anchorDir * depth`
  to screen coords for `left`/`top` and computes opacity from the angular
  distance between `camera.position.normalize()` and `anchorDir`.

## What was *not* changed

- Camera lerp, idle breathing, lighting, palette, monoliths, particles,
  fog. Verified by reading the diff: the only addition inside the animate
  loop is `camera.updateMatrixWorld(); updateItems();` — no scene math
  was edited.
- The SVG loader, backplate, cube faces.

## Decisions made inside the ticket

- **Item depth = 30** (along anchor direction, with cameraRadius = 70).
  Rationale: ticket said "the world-space position is `anchorDir * 30`".
  This puts the item on the camera's side of origin at the anchor view.
  *Findings flag:* at the at-anchor camera angle this places the item
  in the line between camera and origin → it occludes the logo. See
  probe.md.
- **CSS:** added the faintest visible background (`rgba(7,9,12,0.35)` +
  1px border at 10% alpha) so the projection is observable in the
  screenshots. Ticket allowed "the faintest possible background so the
  projection is visible to the reviewer."
- **Resize handler:** none added beyond what already exists. The
  existing `window.resize` listener doesn't recompute item position
  directly, but `updateItems` reads `window.innerWidth`/`innerHeight`
  every frame, so item position should follow resize automatically.
  Not exercised by capture (see probe.md).

## Open questions raised by the implementation

1. **Occlusion.** Item depth=30 with camera radius=70 places the item
   between camera and origin at the anchor view, so the item visually
   sits on top of the logo. Three options for Pass 1: negative depth
   (item on the far side of origin, behind logo from camera view),
   anchor-relative offset (item placed at the anchor view's view-plane
   right/up offset from origin so it sits beside the logo), or
   accept-and-style-the-overlap (item is intentionally "in front of
   the logo when looked at"). Picking is for the synthesizer.

2. **Done-criterion #1 conflict.** Ticket says opacity ≤ 0.05 at
   yaw=0,pitch=0 but specifies `smoothstep(0, 0.6, ang)`. With the
   anchor at yaw=0.4,pitch=0.1, the angular distance from front is
   ~0.41 rad → reveal ≈ 0.24. The ticket's done criterion and its
   formula are mutually inconsistent. Implemented the formula
   verbatim; the criterion will fail.

3. **Z-clipping when looking past the anchor.** When the camera is
   well past the anchor (e.g. yaw=-1.0, pitch=0), the item's
   world-position projects to NDC z > 1 (clipped). Opacity is already
   0 by then so visually fine, but `Vector3.project` keeps reporting
   x/y values which would land at wild screen coords if opacity ever
   went to a positive value past z>1. Not a Pass 0 issue but worth
   logging.
