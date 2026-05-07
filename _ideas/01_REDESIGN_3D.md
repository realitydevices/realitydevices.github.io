# RCD Orbit — Spec & Handoff

## Concept

A landing page where the RCD logo is the centerpiece of an explorable 3D scene. Mouse position drives an orbital camera around the logo. As the user moves the mouse, the camera arcs around the logo and reveals depth — particles, floating geometric forms, and the back faces of the logo itself. The feel is exploratory and rewarding: you didn't know there was anything *behind* the logo until you moved.

This is a hybrid of two references:
1. **Flipbook** (cafeai.home.blog, viral early May 2026) — the "no HTML, just generated pixels" exploratory vibe. We're not copying the architecture (per-frame model inference is too expensive and has no spatial consistency), just the *feeling* of discovery.
2. A desire to render the RCD logo as a 3D object rather than a flat mark, with real lighting and presence.

**Explicitly out of scope for v1:** clicking on background objects to navigate into new "rooms." That can come later. v1 is one scene, beautifully rendered.

## Stack

- **Three.js 0.160** via ES modules + importmap (CDN, no build step for the prototype)
- **SVGLoader + ExtrudeGeometry** to lift the SVG paths into 3D (no GLB conversion needed)
- Vanilla JS, single HTML file
- Run locally with `python -m http.server 8000` from this directory

If/when productionising, port to **react-three-fiber** + Vite. The scene graph translates 1:1.

## Files

- `index.html` — the prototype (working, runs as-is)
- `rcd.svg` — source logo (orange/cyan isometric cube on a wedged background)

## Architecture decisions

**SVG → 3D extrusion (not GLB).** `SVGLoader.createShapes()` → `ExtrudeGeometry` per path. Lets us tweak depth/bevel/material live and keeps the source-of-truth as the SVG. Bevel is on (`bevelThickness: 0.4`, `bevelSize: 0.4`) — gives the edges that subtle highlight catch that makes 3D feel premium rather than flat-extruded.

**White-path filter.** The SVG has four `#FFFFFF` paths that are background wedges from the original logo composition, not part of the mark itself. They're filtered out (`c.r > 0.99 && c.g > 0.99 && c.b > 0.99`). The near-white `#EAF4F5` *is* part of the logo (inner cube faces) and is kept.

**Y-axis flip.** SVG coordinate system has Y pointing down. After extrusion we flip the group with `scale.y *= -1` so the logo renders right-side-up.

**Lighting story matches the logo's two-tone split.** Warm orange point light from the left, cool cyan point light from the right. Plus a neutral key from upper-right and a low ambient. This means the orange faces of the logo catch the warm rim and the cyan faces catch the cool rim — the lighting *amplifies* the design rather than fighting it.

**Materials: `MeshPhysicalMaterial` with clearcoat.** Metalness 0.3, roughness 0.35, clearcoat 0.6. Reads as "premium plastic / lacquered" rather than chrome or matte. Try metalness 0.7+ if you want a more jewel/metallic look.

**Camera: lerped orbital, not OrbitControls.** Mouse position maps directly to target yaw (±~108°) and pitch (±~45°). Current orientation lerps toward target at 0.05/frame. The lag is the magic — instant tracking feels twitchy and cheap; a 200ms-ish settle gives the camera weight and intentionality. Don't remove this.

**Background = three layers of additive particles + 12 monoliths.**
- Particles on three concentric shells (radius 120 / 250 / 500), with size attenuation and additive blending → free parallax depth as the camera orbits.
- Monoliths are low-poly platonic solids (icos/octa/tetra) at varying depths, biased *behind* the logo (`z - 20`). Half orange, half cyan, all at low opacity (0.18). Some wireframe. They drift and bob slowly. They're the "what's behind there?" reward.

**Idle motion.** The logo has a tiny `sin(t * 0.3) * 0.03` z-rotation breathing so it never feels frozen if the user stops moving the mouse. Subtle — barely perceptible, but the absence of it would be felt.

## Known limitations / decisions deferred

1. **No mobile touch handling.** `pointermove` works for hover but on touch devices there's no hover. Need to either (a) use device orientation API for tilt-based orbit, (b) auto-orbit slowly with touch-drag override, or (c) ship a static hero image on mobile. Pick when you know the audience.
2. **No content beyond the scene.** This is just the hero. Nav, copy, CTAs need to overlay or live in a scroll-revealed section below.
3. **No loading state.** SVG fetch is fast but on a slow connection there's a beat with no logo. Consider a simple fade-in once `loader.load()` completes.
4. **No accessibility story.** A user with reduced-motion preference should get a static render. Wire up `matchMedia('(prefers-reduced-motion: reduce)')` and disable the lerp / monolith animation / breathing.
5. **Colors are read straight from the SVG fills.** If you rebrand the logo, the scene re-tints itself for free. But the *light* colors are hardcoded to match the current orange/cyan palette — those need updating manually if the brand changes.

## Tuning knobs (where to play)

The most expressive parameters, in order of impact:

| Knob | Where | Current | Effect |
|---|---|---|---|
| `cameraRadius` | top of script | 70 | how zoomed in the logo feels |
| `extrudeSettings.depth` | in SVGLoader callback | 8 | logo thickness / chunkiness |
| `target.yaw` multiplier | pointermove handler | `0.6` | how far you can orbit horizontally |
| `current.yaw += ... * 0.05` | animate() | 0.05 | camera lag amount (lower = laggier/weightier) |
| Light intensities | top of script | 1.4 / 2.5 / 2.0 | mood. Try halving everything for a moodier night look |
| Monolith count / radius | monolith loop | 12 / 60-140 | density of the background discovery layer |
| Fog density | scene.fog | 0.018 | atmospheric depth. Higher = more mystery, less visibility |

## Next steps if extending

**Phase 2 candidates, roughly in order of impact-to-effort:**

1. **Reduced-motion + mobile fallbacks.** Non-negotiable before shipping.
2. **Bloom post-processing pass.** `EffectComposer` + `UnrealBloomPass`. The cyan and orange will pop dramatically. Watch the perf budget on mobile.
3. **Logo idle rotation drift.** Slight continuous y-axis rotation when mouse is idle for >3s, returns to mouse-tracking on motion. Adds life.
4. **Click-to-pulse.** Click anywhere → emit a shockwave (expanding ring shader) from the logo, particles get briefly displaced. Pure eye candy but gives the page a heartbeat.
5. **Background scene generation via image model (the Flipbook nod).** Replace the procedural particle/monolith background with a generated equirectangular skybox, regenerated per-session or per-day. *Only* the background — the logo and orbit stay deterministic. This is where the "AI dynamic render" reference actually earns its keep without compromising stability.
6. **Then, and only then, consider rooms.** Click a monolith → smooth camera dolly into it → new scene. But this is a v3 problem; v1 needs to be solid first.

## What to ask the user before doing anything destructive

- Production framework preference (react-three-fiber vs vanilla)? Affects file structure entirely.
- Target devices? Mobile-first changes the perf budget significantly.
- Is the current color palette locked or evolving? Affects whether to hardcode light colors or derive them.
