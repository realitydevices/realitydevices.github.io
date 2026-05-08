# Reality Devices — agent guide

This file is for agents (and humans) working on this repo. It is excluded from
the Jekyll build via `_config.yml` and is not published.

## Read these first, in order

1. **`_meta/PURPOSE.md`** — why this site exists, who it's for, what the brand
   stands for. The spine.
2. **`_ideas/00_MANIFESTO.md`** — design principles and anti-patterns. How
   `PURPOSE.md` is expressed in implementation choices.
3. **`_ideas/NN_*.md`** — individual ideas / proposals. Read the one(s) you're
   working on.

If `PURPOSE.md` and the manifesto conflict, `PURPOSE.md` wins. If a manifesto
principle and an idea doc conflict, the manifesto wins. Don't let the docs
drift — update the higher-priority doc in the same change.

## Where things live

- `index.html` — the site. Single page, vanilla JS + ES modules + three.js
  from CDN, no build step.
- `_meta/` — purpose, changelog, brand assets. Jekyll ignores `_`-prefixed
  dirs, so this isn't published.
- `_ideas/` — manifesto + numbered idea docs.
- `_harness/` — iterative refinement loop for the 3D scene (screenshots →
  reviewer → next pass). See `_harness/README.md` for how to run a pass.

## Defaults when proposing or building

- Name which manifesto principle(s) the change advances, and which (if any) it
  tensions against.
- Prefer the slower, weightier choice when in doubt (manifesto §2).
- No build step, no framework migration, no auto-distributed layouts unless
  the manifesto is updated to allow it.
