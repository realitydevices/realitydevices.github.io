---
id: 12_edge-panels
parents: [11_3d-logo]
status: not-started
target: index.html, items.js, posts/, links.json, scripts/generate-posts.mjs
loop: _harness/build/README.md
spec: _ideas/02_EDGE_PANELS_SPEC.md
---

# Spatial items on the sphere — writing, links, inbound

## Why
The 3D scene is currently atmosphere with no content. This node turns the
prototype into the actual site by placing three hand-positioned items on
the same fixed sphere: a writing list, a curated links list, and an inbound
surface. See `_ideas/02_EDGE_PANELS.md` for the concept and
`_ideas/02_EDGE_PANELS_SPEC.md` for the resolved implementation spec.

## Invariants
- No top nav, hamburger, or sidebar. Items are found by orbiting.
- Item positions are literal numbers in `items.js`. No fibonacci sphere,
  no auto-distribution.
- All content ships in the repo. No runtime fetch from a remote service.
- Camera lerp, idle breathing, two-tone lighting, SVG-derived palette are
  not modified by this work.
- No build step in the runtime path. The Node script is offline-only.
- `prefers-reduced-motion` users get a usable static fallback before this
  node is considered done.

## Tunables (the surface the build loop edits)
- Per-item `{ yaw, pitch, depth }` and item dimensions.
- Reveal curve: angular-distance → opacity/scale mapping.
- Active-item threshold for wheel capture.
- Item typography / spacing.
- Markdown render styling.
- Frontmatter contract (`title`, `date`, `summary`).

## Evidence
(Build runs append summaries here, newest last.)
