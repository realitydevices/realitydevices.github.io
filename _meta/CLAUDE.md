# _meta — brand & purpose layer

This directory holds the brand-level docs, assets, and changelog. It's the
"why" layer of the project, separate from `_ideas/` (what to build) and
`index.html` (what's running). Jekyll ignores `_`-prefixed dirs, so nothing
in here is published.

## Purpose summary

Reality Devices is the brand the Kirk uses to
deliberately construct his professional reality. The thesis: *defining,
naming, and making things happen is what makes things happen.* The brand
binds his devices — consulting, writing, reputation-building, a planned plant
nursery, and this site itself — under a single posture of agency through
construction.

This site is the brand's primary public surface and a professional surface
for the maintainer. The priority audience is the Brisbane professional field
(recruiters, employers, colleagues, potential partners). Success looks like
voice + occasional engagement + occasional inbound — **not** traffic,
virality, or SEO. The nursery and any other ventures live on their own
surfaces; this site holds brand vision, professional voice, and consulting
optionality.

**Full doc** (audience ranking, in/out-of-scope content, anti-patterns, how
the docs relate): `_meta/PURPOSE.md`.

## Project facts not in the root `CLAUDE.md`

- **Domain:** realitydevices.au — auto-deploys from `main` via GitHub Pages,
  no CI workflow.
- **Brand mark:** `rcd.svg` at repo root is the source of truth; the 3D scene
  derives its colours from it. `_meta/rcd_logo.png` is a raster export for
  contexts that can't render SVG.

## When editing things in `_meta/`

This is the foundation layer — changes here ripple into how the site
presents itself everywhere else. If you change `PURPOSE.md`, check whether
any in-flight idea docs still align and update
them in the same change rather than letting them drift.
