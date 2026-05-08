# Spatial Items — Blog & Links on the Sphere

## Concept (as stated)

The site is a personal site / blog / link manager. The current 3D scene already
lets the user orbit around a center point. Extend that: **distribute "items"
around the same fixed sphere**, at different points in 3D space. As the user
moves their gaze across the sphere, items come into view from foreground or
background depending on where they sit. The user explores the sphere to find
content, rather than being shown a navigation bar.

Per the user:

- Items live on **a fixed sphere in 3D space**, not on left/right edges.
- There can be **a large number** of them, scattered across that sphere.
- An item should be **at least ~1/4 of the screen** when looked at directly
  ("reasonable size"); larger is fine and we may want some quite large.
- Larger items create a **navigation-sensitivity tradeoff** — small head
  movements cover a lot of pixels on the item — but tuning that is deferred.
- Once an item is in view, the **scroll wheel scrolls within that item**
  (e.g. a blog post list).

## What's settled (from earlier exchange)

- **DOM overlay** for the items, not WebGL geometry. Each item is HTML/CSS
  positioned per frame from a 3D anchor.
- **Two content types to start:** a blog post list, and a curated link list.
- Blog posts come from **markdown files in `/posts`**, surfaced via a **tiny
  Node generator script** that emits `posts/index.json`.
- Clicking a post **renders the markdown in place** (modal-style overlay,
  using `marked` from CDN).

## What I'm still inferring (please correct)

The user has not specified these — flagging them rather than deciding:

1. **What counts as an "item"?** Is the blog *list* one item (showing N posts
   inside it), or is each post its own item on the sphere? Same question for
   links: one big "links" panel, or each link as its own item?
2. **How are items placed on the sphere?** Hand-authored angular positions
   (yaw, pitch, depth per item)? An auto-distributed pattern (e.g. fibonacci
   sphere)? Manual seems likely given the curated feel of the site.
3. **Is the orbit range still bounded** (current `yawRange ±0.6π`,
   `pitchRange ±0.25π`), or does this concept want a fuller sphere now that
   things live all around?
4. **What happens between items** — empty space, or a faint "hint" (small
   marker) of the nearest item to guide the user?
5. **What's the close interaction?** (How does a user dismiss an item once
   they've scrolled it / read it? Just orbit away?)

## Mechanics (to build, once the inferred bits are confirmed)

### Item model

Each item carries:

- An **anchor direction** on the sphere (a unit vector, or yaw/pitch).
- A **depth** (how foreground/background it sits).
- Its own **DOM element** with content (a list, a single link, etc.).

### Reveal by angular proximity

Each frame, for each item, compute the **angular distance** between the
current camera direction and the item's anchor direction. That distance maps
to a `reveal` value in `[0, 1]` (close to 0° → 1, beyond some cutoff → 0).
The DOM element's screen position is the anchor's projection; opacity / scale
follow `reveal`.

This generalizes "approaches edge of rotation" to "approaches the item,
wherever on the sphere it is."

### Scroll capture

The item with the **highest reveal** above a threshold is the *active* item.
Wheel events route to its internal scroll (`element.scrollTop += delta`) and
get `preventDefault`-ed. If no item is active, wheel does nothing.

### Sizing

Items are sized so that a directly-looked-at item occupies ≥1/4 of the
viewport. Sizing is independent of reveal — small reveal just means the item
is dimmer/translucent or off-screen, not smaller.

## Settled file layout

```
posts/
  index.json                  # generated manifest
  YYYY-MM-DD-slug.md          # one per post (frontmatter + body)
links.json                    # hand-maintained list
scripts/
  generate-posts.mjs          # node scripts/generate-posts.mjs
```

Markdown frontmatter: `title`, `date`, `summary`. Generator sorts by date
descending and writes `posts/index.json`.

## Open before any code

- Resolve the five "still inferring" points above.
- Decide a starting item count (3? 12? 50?) so we can place a few real
  examples and feel the navigation density.
