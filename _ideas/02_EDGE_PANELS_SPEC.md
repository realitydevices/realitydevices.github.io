# Spatial Items — Implementation Spec

> Companion to `_ideas/02_EDGE_PANELS.md`. That doc is the *concept* (with five
> open questions). This doc is the *spec* — the resolved version a single
> "implementer" agent can act on inside the build loop at
> `_harness/build/README.md`.
>
> Read in order: `_meta/PURPOSE.md` → `_ideas/00_MANIFESTO.md` →
> `_ideas/02_EDGE_PANELS.md` → this file.

## Resolution of the five open questions

These are the working defaults. Any of them may be overridden by the
maintainer in a `next.md` ticket; the implementer agent does not relitigate
them on its own.

1. **What counts as an item.** One item per *surface*, not per record. The
   blog *list* is one item (showing the N most recent posts inside it). The
   curated links *list* is one item. A long-form post being read is rendered
   in-place inside the blog item, not as a new item on the sphere. The
   inbound surface (idea 04) is one item. Starting count: **3 items.**
2. **Placement.** Hand-authored angular positions (yaw, pitch, depth) per
   item, in a single `items.js` array with comments. No fibonacci sphere, no
   auto-distribution. (Manifesto §4, §6.)
3. **Orbit range.** Stays bounded for v1 (`yawRange ±0.6π`, `pitchRange
   ±0.25π`). Items live within that bounded region. Full-sphere orbit is a
   later question once we know how density actually feels.
4. **Hints between items.** None in v1. Empty space is part of the reward
   for exploration — finding something is supposed to require looking.
   Revisit only if the reviewer panel reports the user genuinely cannot
   find items.
5. **Close interaction.** Orbit away. The item fades on angular distance;
   no explicit close button. The exception is the in-place markdown render
   for a blog post — it gets a clear dismiss (`Esc` and a small × in the
   item's own corner) because it has captured both keyboard and scroll.

## What the agent is building

A persistent DOM-overlay layer, anchored to 3D positions on the same fixed
sphere as the existing scene, carrying three items:

- **Writing** — list of recent posts from `posts/index.json`, click to
  render the markdown in-place.
- **Links** — curated list from `links.json`.
- **Inbound** — single item carrying email + one-line filter (idea 04).

No new framework. No build step beyond a tiny Node script that emits
`posts/index.json` from markdown frontmatter (that script is allowed to be
run by hand — no watcher, no CI). All runtime code stays vanilla JS / ES
modules / CDN three.js.

## Slice plan — smallest viable increment first

The implementer agent ships **one slice per pass.** Each slice is a single
PR-shaped change that runs end-to-end. The reviewer panel scores after each.

| Pass | Slice | Done means |
|---|---|---|
| 0 | Single hard-coded item (a placeholder div with a title) anchored at one yaw/pitch, opacity follows angular distance from camera direction. | The item fades in/out as you orbit toward/away from it. No content yet, just the mechanic. |
| 1 | DOM ↔ 3D anchor projection is correct under camera lerp + orthographic frustum at all viewport sizes. Item sized to ≥1/4 viewport when looked at. | Item lives in the right place under window resize and across the orbit range. |
| 2 | Wheel events route to the active item's internal scroll; `preventDefault`-ed when an item is active; no-op otherwise. | You can wheel-scroll a list inside an item; orbit still works between items. |
| 3 | `posts/` directory + `scripts/generate-posts.mjs` + `posts/index.json`. Writing item reads the JSON and renders the list. | Adding a markdown file under `posts/` and re-running the script makes the post appear in the list. |
| 4 | Click a post → markdown renders in-place via `marked` from CDN. `Esc` and × dismiss. | A post can be read inside the item without leaving the scene. |
| 5 | Links item: reads `links.json`, renders the curated list. External links open in new tab. | Three items now live on the sphere; the second is real. |
| 6 | Inbound item per `_ideas/04_INBOUND_ITEM.md`. Rendered text email (not `mailto:`). | Three items, all real. |
| 7 | `prefers-reduced-motion`: items go static-positioned and stacked; orbit disabled; no breathing. | Reduced-motion users get a usable, content-complete page. |

Slices may be split or merged in `next.md` if a reviewer pass finds the
slice was too coarse; but the agent does not unilaterally skip ahead.

## Hard invariants (any violation halts the loop)

These are anti-patterns at the manifesto level. A reviewer flagging any of
these stops the loop until the implementer fixes it; a fix-pass is not a
content-pass and does not count toward convergence.

- No top nav, hamburger menu, sidebar, or any global navigation chrome.
- No auto-distribution of item positions. Every item position is a literal
  in `items.js`.
- No item fetched from a remote service at runtime. All content ships in
  the repo.
- The camera lerp, idle breathing, two-tone lighting, and SVG-derived
  palette are not modified by this work.
- No build step in the runtime path. The Node script is offline-only.
- No third-party overlay (chat, analytics modal, cookie banner, etc.).

## Tunables surface (what `next.md` is allowed to address)

The implementer agent treats these as the editable surface for the cycle:

- Per-item `{ yaw, pitch, depth }` and item dimensions.
- Reveal curve: angular-distance → opacity/scale mapping.
- Active-item threshold for wheel capture.
- Item typography / spacing within the DOM card.
- Markdown render styling.
- The Node script's frontmatter contract (`title`, `date`, `summary`).

Anything outside this list is out of scope for a normal pass.

## Done — termination criterion

The idea is "implemented" when **all** of:

- Passes 0–7 have shipped.
- For two consecutive content-passes, every reviewer persona scores ≥ 4.0
  on every rubric axis (see `_harness/build/README.md`).
- No hard invariant has fired in the most recent three passes.
- `prefers-reduced-motion` fallback is wired and itself reviewer-confirmed.

## Abandon — kill criteria

The idea is "no longer good" and the loop ends with a writeup if any of:

- After three full cycles on the same slice, reviewer scores do not
  improve (loop is stuck).
- Reviewer panel reaches consensus that the items make the scene feel like
  a feed, a sales site, or a LinkedIn surface — and a single concrete
  edit cannot resolve it.
- The DOM-overlay approach turns out to fight the orbit math at acceptable
  performance (sustained <50fps on the maintainer's machine after Pass 2).
- The maintainer marks the idea abandoned in `_meta/CHANGELOG.md`.

In any abandon case, the implementer writes `_harness/build/runs/NNN_abandon.md`
explaining what was tried, what failed, and which assumption broke. That
file is the value extracted from the dead loop.

## What the agent must not do

- Re-litigate the five resolved questions inside a pass. Raise it as a
  blocker in the run's `review.md`, do not change the answer mid-cycle.
- Add features beyond the active slice "just because it's nearby."
- Touch `index.html`'s scene setup, lighting, or camera math except as
  strictly required to expose the DOM-anchor projection helper.
- Generate placeholder copy for the inbound item or the links list. Those
  are voice-carrying surfaces; the implementer flags them as needing
  copy from the maintainer rather than inventing it.
- Skip the capture pass at the end of a slice. No screenshots = no review
  = the slice did not happen.
