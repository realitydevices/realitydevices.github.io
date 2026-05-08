---
id: 11_3d-logo
parents: [10_reputation, 20_skill-demo]
status: in-progress
target: index.html
---

# 3D extruded RCD logo with orbital camera

## Why
A landing page where the RCD mark is the centerpiece of an explorable 3D
scene. Mouse position drives an orbital camera; depth and rear faces are
revealed as the user moves. Aim is *premium / studio / discoverable* — the
opposite of a static PNG hero. See `_ideas/01_REDESIGN_3D.md` for the
fuller brief.

## Invariants
- Depth contrast readable from side-view (no flat-plate silhouette).
- No perspective fisheye — orthographic camera.
- The iso-cube reads as a real 3D corner from any angle in the orbit.
- Front-on view still feels like a logo, not a diorama.
- Color palette stays read straight from the SVG fills (orange / cyan /
  light). Light tints can be tuned; logo colors cannot.

## Tunables (the surface the workshop edits)
The most expressive parameters live at the top of `index.html`:
- `cameraRadius`, `frustumSize` — zoom / framing
- `yawRange`, `pitchRange`, `cameraLag` — orbit feel
- `planes[*]` — per-layer extrusion `{back, front}` z-spans
- `cubeBaseZ`, `cubeApexZ` — iso-cube depth
- light intensities, fog density

## Evidence
(Workshop runs append summaries here, newest last.)

- **002_capture-mode** (2026-05-08) — First successful 6-angle capture.
  Depth differentiation working strongly across orbit; trim layer at
  z=-1000 reads as a phantom second logo from side angles; iso-cube
  doesn't quite read as a 3D corner because materials are flat-shaded.
  Lead next move: pull trim into the letter band.
