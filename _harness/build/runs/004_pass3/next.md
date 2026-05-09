# Pass 4 ticket — HALT (kill criterion fired)

Decision class: **halt.**

The rubric's kill criterion fired at Pass 3: three consecutive
content-passes (Pass 1, Pass 2, Pass 3) with `identity_drift: true`.

See `runs/004_pass3/abandon.md` for the writeup of what failed and
which assumption broke.

## What is *not* the right next move

The implementer agent does **not** run a Pass 4. Specifically:

- Do not attempt another `worldPos` bisect, even though Alex's analysis
  identifies a correct one.
- Do not reparameterise placement as `origin + anchorRight * offset`,
  even though that is the slower, weightier, manifesto-preferred move.
- Do not add content to the Writing card, even though that would
  structurally clear the comprehension-cluster signal.

All of those are valid moves under the loop's normal cadence. The kill
criterion forecloses them until the maintainer acts.

## What the maintainer can do

One of the following, in any order:

1. **Refine the rubric.** Either tighten the failure-phrase clusters so
   that comprehension-cluster phrases ("I can't tell what he does", "I
   don't know what this is") only count toward identity-drift when paired
   with sales-site / feed / portfolio cluster phrases — i.e. drift =
   "looks like the wrong kind of site," not "doesn't yet say what he
   does." Rubric change resets the slice per the rubric's own rule
   ("If this rubric changes mid-slice, the slice resets — no carrying
   scores across rubric revisions"). Pass 3 review and scoreboard entry
   stay intact as historical record.
2. **Add a comprehension-cluster exemption to `maintainer_notes.md`** for
   slices 0–2. The Pass 1, 2, and 3 reviews each flagged this as the
   needed structural fix; the synthesizer applies maintainer notes
   silently from there. With this in place, identity_drift on the
   comprehension cluster does not fire while real content is missing,
   and the loop continues from Pass 4 with cohesion still firmly at 2.0
   to address.
3. **Override Pass 3 via `runs/004_pass3/feedback.md`** then re-run the
   synthesizer. The synthesizer rules allow per-pass maintainer overrides
   in `feedback.md`; that file does not exist. If the maintainer writes
   one stating "do not fire kill criterion, comprehension-cluster
   recurrence is expected per the audience-floor steering note", the
   synthesizer can re-emit Pass 3's artefacts with `identity_drift:
   false` and write a Pass 4 ticket against the cohesion failure.
4. **Accept the halt.** Mark the spatial-items idea abandoned in
   `_meta/CHANGELOG.md`, treat `runs/004_pass3/abandon.md` as the value
   extracted from the dead loop, and move on.

## What was within reach if the loop had continued

For the maintainer's reference (so that decision is informed):

- **Cohesion at the anchor view.** Alex's analysis names a correct fix.
  The bisect should be on the perp-magnitude of `worldPos` relative to
  the camera direction, not component-wise on the `(x, y, z)` triple.
  Pass 1 perp ≈ 19.2 (right-bleed); Pass 2 perp ≈ 8.7 (centre overlap);
  Pass 3 perp ≈ 15.6 (still right of midpoint). True midpoint perp ≈
  13.95; e.g. `worldPos = (24, 6, 24)` gives perp ≈ 12.9, biased toward
  Pass 2 to clear the right third. Cleaner option: reparameterise as
  `origin + anchorRight * offset` where `anchorRight = anchorDir × up`
  and `offset` is a single scalar in world units. Future items become
  trivially placeable.
- **Probe stub recurrence.** Three passes in a row of stub probes is a
  process miss the implementer cannot self-correct from inside a
  ticket. The harness should treat a stub probe as a soft fail in the
  next iteration of the loop's design, separate from the kill criterion.

## Why this is the right next move

It is the *only* move available to the synthesizer under the rubric as
written. The rubric does not give the synthesizer discretion to defer
the kill criterion; it gives the maintainer the authority to refine the
rubric or override per-pass. The honest action is to halt and surface
the choice.
