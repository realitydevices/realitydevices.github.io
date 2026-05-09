# Abandon — Pass 3, slice 0

The loop halts at Pass 3. Kill criterion: three consecutive
content-passes with `identity_drift: true` (Pass 1, Pass 2, Pass 3).

## What was being attempted

Slice 0 of `_ideas/02_EDGE_PANELS_SPEC.md`: a single hard-coded item
(a placeholder DOM card with an `<h2>Writing</h2>`) anchored to a
3D point at `yaw=0.4, pitch=0.1`, opacity and scale following angular
distance from the camera direction. Done condition: the card fades in
toward the anchor and out away from it, and at the anchor view sits
*beside* the logo, not on it.

## What failed

Two failures, one of them load-bearing:

1. **Rubric / structural failure (load-bearing for the halt).** The
   identity-drift detector fired for three consecutive content-passes
   on the comprehension cluster ("I can't tell what he does" / "I don't
   know what this is"). This was structurally guaranteed to recur until
   slice 3 ships real content into the Writing card — the
   `maintainer_notes.md` audience-floor section already names the
   recurrence as expected for slices 0–2. The rubric's identity-drift
   detector does not have a comprehension-cluster exemption. The
   synthesizer flagged this ambiguity to the maintainer in Pass 1's
   review, carried the warning into Pass 2's ticket, and the Pass 3
   ticket explicitly requested maintainer action before this review
   ran. No `feedback.md` or rubric edit arrived in time. The
   synthesizer applied the rubric as written.

2. **Slice content failure.** The card is still not placed beside the
   logo at the anchor view. Pass 1 over-shot right (`worldPos = (28,6,18)`
   right-third bleed). Pass 2 over-shot centre (`(22,5,30)` centre
   overlap). Pass 3's bisect (`(26,6,22)`) landed at a perp-magnitude of
   ≈15.6 world units against a midpoint of ≈13.95, leaving the card's
   left edge cutting into the logo's right third. The slice's headline
   goal — "card beside the logo at the anchor view" — was not met
   across three content-passes. Cohesion held at 2.0 firmly (Alex's
   call), against a target of ≥4.0.

## Which assumption broke

The assumption that the kill criterion as written and the
maintainer-notes audience-floor steering would not collide on slice 0.

Specifically: the rubric authors and the maintainer-notes author both
named "audience" as the axis where comprehension lives, but the
identity-drift detector keys off *phrases* (failure-phrase clusters)
rather than off the axis. The phrases the personas naturally reach for
to explain a low audience score ("I can't tell what he does") are
indistinguishable in form from the phrases that *would* signal real
identity drift if they recurred without an empty-content excuse.
Without a cluster-level distinction in the rubric, every pass during
slices 0–2 is a coin-flip away from firing identity_drift, and three
in a row was always the likely outcome.

A second-order assumption that broke: that the implementer's
component-wise bisect on `worldPos` would converge to a correct
projected lateral offset. It will not in general — the projected
lateral offset is a function of the perp-magnitude of `worldPos`
relative to the camera direction, not of the raw `(x,y,z)` triple, so
component-wise bisects bias unpredictably. This was not the cause of
the halt, but it was the cause of slice 0 not converging in three
content-passes.

## What was reusable

The Pass 0 → Pass 1 → Pass 2 → Pass 3 progression produced real
artefacts that survive the halt:

- The DOM-anchor projection helper in `index.html` (working under the
  orthographic camera and 0.05/frame lerp).
- The reveal curve `reveal_scale = 0.6 + 0.4 * reveal` and the
  transform-only positioning with `transform-origin: center center`
  (Pass 2; reading correctly across all three subsequent reviewer
  passes).
- The fade behaviour at `fade: 0.6` and `anchorDirection(0.4, 0.1)`
  (front, partial, far frames all read correctly).
- The four-angle capture script and angle definitions (front,
  at-anchor, partial, far) — these are the right four frames for
  reviewing a single-item slice and should survive into any restart.

## What was not reusable

- The component-wise `worldPos` bisect parameterisation. Future restarts
  should use `origin + anchorRight * offset` (a single scalar) so the
  reviewable quantity matches the authored quantity.
- The probe phase as currently shaped. Three consecutive auto-stub
  probes against an explicit ticket requirement is a harness-level
  failure, not a per-pass implementer miss; the loop's probe contract
  needs to be enforced at capture time, not requested in the ticket.

## Recommended path if the maintainer chooses to restart

1. Resolve the identity-drift / comprehension-cluster ambiguity in
   the rubric *before* relaunching. Either tighten cluster
   definitions or add a slices-0..2 exemption to `maintainer_notes.md`.
2. Reparameterise placement to `origin + anchorRight * offset` in the
   first restart pass. This is option (b) from Alex's Pass 3 review
   and is the slower, weightier choice; it removes a class of bug
   rather than fixing one instance of it.
3. Enforce the probe contract at the harness level — block the
   capture-to-review handoff if `probe.md` is the auto-stub. Or
   accept stub probes for slice 0 explicitly and stop asking for them
   in tickets.
4. Once cohesion lifts to ≥4.0 across two consecutive content-passes
   and identity_drift stays false under the refined rubric, the slice
   converges and the loop can advance to slice 1 (DOM-anchor
   projection correctness under resize).

## Trajectory

| Pass | overall | brand | exploration | weight | audience | cohesion | identity_drift | kind |
|---|---|---|---|---|---|---|---|---|
| 0 | 2.0 | 2.0 | 2.0 | 2.0 | 2.0 | 2.0 | false | content |
| 1 | 3.0 | 3.0 | 3.0 | 4.0 | 2.0 | 3.0 | true | content |
| 2 | 2.9 | 3.0 | 4.0 | 3.0 | 2.5 | 2.0 | true | content |
| 3 | 2.6 | 3.0 | 3.0 | 3.0 | 2.0 | 2.0 | true | content |

Three content-passes after the bootstrap. Brand and weight stable in
the 3s. Cohesion oscillated then collapsed when the placement bisect
missed twice. Audience held at the structurally-expected floor.
Exploration's Pass 2 spike to 4.0 (Jess's "huh" moment) did not hold
under Pass 3's clutter reading at the anchor view. Overall trended
down from Pass 1, not up.

The loop's value is the trajectory, not the (unfinished) end state.
The DOM-anchor mechanic itself is sound and shipped; the slice's
load-bearing composition (one card beside one logo) is unsolved; the
rubric's identity-drift detector needs a comprehension-cluster
exemption to be useful for slices 0–2 of a content-thin spec.
