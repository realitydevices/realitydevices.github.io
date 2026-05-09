# Pass 2 ticket — reveal drives scale, not just opacity

Decision class: **refine current slice (slice 0).**

This ticket supersedes the previously-deferred Pass-2 fade-window tighten.
Per maintainer feedback in `runs/002_pass1/feedback.md`, the primary
direction is now **closer-and-grows behaviour**: the card sits closer to
the camera (higher world-z), small/dim at low reveal, larger/brighter at
high reveal. The fade window may be tightened *as part of* this move if
it's the same atomic change; it is not the primary axis.

## Single move

In `index.html`'s `items` array and in `updateItems()`:

1. **Move the card forward** (closer to the camera). Replace
   `worldPos: new THREE.Vector3(28, 6, 18)` with
   `worldPos: new THREE.Vector3(22, 5, 30)`. The intent: at the anchor
   view (`yaw=0.4, pitch=0.1`) the camera sits roughly at radius 70 along
   the anchor ray, so a `worldPos` with higher z reads as nearer the
   camera and projects larger; at the front view (`yaw=0, pitch=0`) the
   point is more lateral relative to the camera and naturally moves
   off-centre rather than sitting in the right-third of the screen.

2. **Drive scale off reveal.** Today the card is a constant 320×240 with
   `opacity` tied to angular distance and `transform: translate(...)` on
   the projection. Add a multiplicative `scale(reveal_scale)` to that
   transform, where:

   ```js
   const reveal_scale = 0.6 + 0.4 * reveal;   // 0.6 at reveal=0, 1.0 at reveal=1
   ```

   So at low reveal (front view) the card is at 60% size *and* low
   opacity; at full reveal (anchor view) it's at 100% size and full
   opacity. The `0.6` floor is deliberate — even at low reveal the card
   should still feel like a thing in space, not a vanishing point. The
   transform composition order is: `translate(<projected>) translate(-50%, -50%) scale(<reveal_scale>)`
   so the card scales around its own centre, not the projection origin.

3. **Tighten the fade window**, *only if* the result of (1) and (2) does
   not already resolve the front-view bleed. Suggested floor:
   `fade: 0.45` instead of `0.6`. Make this change inside the same
   commit if needed; do not split it across passes. If the front view
   reads cleanly without it, leave `fade: 0.6` and note in the changelog
   that fade tightening was unnecessary.

Use `transform-origin: center center` on `.item` if it isn't already, so
the scale doesn't drift the projected centre.

## Why this is the right next move

- Alex's cohesion ceiling this pass was explicit: "the card still reads
  as a CSS rectangle floating in front of a 3D scene." Driving scale
  off reveal gives the card a depth behaviour — it grows forward as the
  viewer orbits toward it — which is what makes a DOM element stop
  reading as a fixed overlay.
- Sam's front-view objection ("plainly visible as a rectangle") and
  Jess's front-view objection ("placeholder boxes that haven't been
  filled in") have the same root: at low reveal the card is *visible
  enough to demand a reading* but has no content yet. Shrinking it at
  low reveal lets it sit as background-of-view rather than competing.
- This is one atomic change with a clean reviewable signal: did the
  card stop reading as bolted-on chrome?

## Done for this pass

- At anchor view (yaw=0.4, pitch=0.1), the card reads *larger* than it
  did in Pass 1 — visibly forward in the composition, not a fixed-size
  rectangle that lights up. Logo still visible at full strength
  (placement-correctness from Pass 1 is preserved).
- At front view (yaw=0, pitch=0), the card is *both* low-opacity and
  smaller. It does not read as a "placeholder box that hasn't loaded."
  If you can't see it at all, that's acceptable for this pass.
- At yaw=-1.0, pitch=0.0, item is invisible (≤0.05 opacity, ≤0.65
  scale — i.e. fully off).
- The reveal still varies smoothly — partial-reveal frame
  (`yaw=0.2, pitch=0.05`) shows a card that is *both* dimmer and smaller
  than at anchor view, in the same proportion.
- `score.json` for Pass 2 shows `cohesion` axis mean ≥ 4.0 (Alex's
  call). `brand` should not regress below 3.0; `weight` should hold at
  ≥ 4.0.

## Capture

`_harness/build/capture.sh 003_pass2` (same four angles as Pass 1).

**Probe must report explicitly** (the Pass 1 probe was an auto-stub and
that is not acceptable for this pass):

- Console output during page load: any errors / warnings introduced by
  the scale-on-transform change.
- Card's screen-space size in pixels at each of the four capture
  frames. (Read `getBoundingClientRect()` if needed; even a single
  number per frame is enough.)
- One sentence on whether the card now reads as a thing growing
  forward, or as an overlay being scaled (these are different).

## Out of scope (do not touch)

- Item content beyond the existing `<h2>Writing</h2>` heading. Real
  content ships in slice 3+.
- A second item.
- Resize hook in capture.sh (still slice 1 territory).
- Camera lerp, lighting, palette, monoliths, fog, particles.
- The `anchorDirection` helper — Alex flagged that its name now
  half-lies (it's reveal-only, not placement) but said the helper is
  still a useful primitive; do not rename this pass.
- The half-space invariant Alex suggested (`dot(worldPos, anchorDir) >
  0` as a dev-only `console.warn`). Worth doing before Pass 5 when a
  second item is added; not yet.

## What review will look at

- Does the card now read as a thing in space rather than a flat overlay?
  (Cohesion is the binding axis.)
- Did the front-view bleed get resolved by the move-forward + shrink,
  or did the implementer also need the fade-window tighten? Either
  outcome is fine; the review notes which.
- Did `weight` hold? A scale animation is the kind of move that can
  easily tip into "twitchy / over-helpful" if the curve is wrong.
  Alex's call.

## Notes for the synthesizer that produced this ticket

- `identity_drift: true` fired this pass on Sam's "I can't tell what he
  does" + Jess's "I don't know what this is." Both phrases are
  comprehension-cluster, both already covered by the audience-floor
  steering note. The synthesizer is recording the signal faithfully but
  flagging the rubric ambiguity to the maintainer (see
  `runs/002_pass1/review.md` § Identity drift). Three consecutive
  content-passes with `identity_drift: true` is a kill criterion; this
  is now 1 of 3 if the maintainer does not tighten the rubric or add a
  comprehension-cluster exemption.
