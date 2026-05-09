# Review — 004_pass3

## Headline

The bisect missed: `(26, 6, 22)` did not place the card "beside" the logo at the
anchor view — Alex reads the card's left edge as cutting into the logo's right
third — and the comprehension cluster fires for the third consecutive
content-pass, tripping the rubric's kill criterion against a maintainer-flagged
structural recurrence.

## Where personas agreed

- The three other angles (front, partial, far) read correctly. Pass 2's
  scale-on-reveal mechanic, transform-origin, and fade behaviour are
  preserved and reading honestly across the orbit. Sam, Alex and Jess all
  treat these as intact (Alex confirms via the changelog; Sam/Jess via the
  PNGs).
- The brand mark itself is still doing its job: a distinctive,
  intentional cube-in-hexagon with an off-axis reveal of an inner cube
  that genuinely rewards looking. Sam ("distinctive, not a template"),
  Alex (unchanged scene), Jess ("the hidden inner cube revealed by the
  angle change is the actual reward").
- The page does not say what Kirk does, and the lone "Writing" label is
  the only content cue and is barely visible. Sam ("nearly invisible"),
  Jess ("one tiny word 'Writing' floating in space"). Per
  `maintainer_notes.md`, this is the expected slice-0..2 audience floor.
- The probe is an auto-stub for the third consecutive pass. Pass 2's
  ticket explicitly named this as a process invariant on its way to
  becoming a failure; the Pass 3 ticket reaffirmed the requirement; it
  is again unfulfilled. Recording as a process miss, not a rubric
  invariant.

## Where personas diverged

- **brand axis.** Sam firm=3 (recruiter authority): the off-axis card-on-
  logo collision costs a point but the mark itself is intact. Alex
  non-firm 3 names the same collision as a brand cost. Jess defer. Sam
  weights → mean = 3.0. No movement from Pass 2; same pattern, same
  cost.
- **exploration axis.** Jess firm=3 (passer-by authority) — the off-axis
  reveal of the inner cube is the reward, but the floating diamonds /
  wireframes don't earn their place yet, so she pulls back from Pass 2's
  4 to 3. Alex non-firm 3 ("nothing makes the scene more worth orbiting,
  nothing regresses the mechanic"). Mean = 3.0. **This is a regression
  from 4.0**, driven by Jess re-reading the second angle as cluttered
  rather than composed — which is the same observation Alex makes about
  the placement collision, in different words.
- **weight axis.** Alex firm=3 (peer authority) — the result on the
  anchor screenshot is the same collision pattern; the slice still reads
  as a tunable being tuned. Sam non-firm 3, Jess non-firm 4. Alex
  weights → mean = 3.0. Held flat from Pass 2.
- **audience axis.** Sam firm=2, Jess firm=2 (both their authority).
  Alex defers. Mean = 2.0. **Regression from Pass 2's 2.5**, driven by
  Jess pulling from 3 to 2 ("I'd be confused. ... it doesn't make a case
  for itself"). This is the structurally-expected audience floor per
  the maintainer note; recording but not weighting as a stall signal.
- **cohesion axis.** Alex firm=2 (peer authority): the bisect missed,
  the card's left edge intersects the logo's right third at the anchor
  view, the slice's done condition is not met. Sam non-firm 4 ("the panel
  and mark sharing the same scene"). Jess defer ("a bit of a mess for
  me"). Alex weights firm → mean = 2.0. **Held flat from Pass 2** — the
  exact regression the pass was supposed to fix.

Sam's non-firm cohesion=4 and Alex's firm cohesion=2 are reading the
same scene and disagreeing. Sam is reading from the front and partial
frames where the card sits restrained; Alex is reading the anchor frame
where the bisect was meant to land. The slice's headline goal lives at
the anchor frame, so Alex's call is what the synthesizer weights.

## Invariants

- failed: [ ]
- unknown: Sam returned UNKNOWN on `content_local`, `scene_unchanged`,
  `no_build_runtime`. Jess returned UNKNOWN on `placement_authored`,
  `content_local`, `scene_unchanged`, `no_build_runtime`. Alex's diff
  read confirmed PASS on all six; the Pass 3 changelog confirms only
  `worldPos` changed (from `(22,5,30)` to `(26,6,22)`) plus an inline
  comment, no scene math touched, content remains inline `<h2>Writing</h2>`,
  no build-step additions.
  **Synthesizer override** of Sam's and Jess's UNKNOWNs to PASS on Alex's
  authority and the changelog text. Flagged for maintainer audit per the
  override rule.
- The probe is again an auto-stub. Alex correctly notes this is the
  third consecutive miss against an explicit ticket requirement. Not a
  rubric invariant; recording as steering.

## Identity drift

Three personas, three flagged phrases this pass:

- Sam (recruiter cluster): "I can't tell what he does."
- Jess (passer-by cluster): "I don't know what this is" (mild, qualified —
  Jess says she's intrigued, just doesn't know what Kirk *does*).
- Alex (peer cluster): "the math is fighting itself"; "I can see where
  the seams are hidden" (mild).

Per the rubric (≥2 personas using flagged phrases), `identity_drift:
true` for the **third consecutive content-pass**. This trips the kill
criterion as written: "Three consecutive content-passes with
`identity_drift: true` triggers the kill criterion."

**Conflict with maintainer steering.** `maintainer_notes.md` explicitly
names the audience floor (slices 0–2) as expected and says a flat
`audience` axis "alone" should not trigger the stall detector. It does
not explicitly exempt the comprehension-cluster from the
identity-drift detector. The Pass 1 review flagged this rubric
ambiguity; the Pass 2 review carried the warning forward; the Pass 3
ticket asked the maintainer to either tighten the cluster definition or
add a comprehension-cluster exemption before this review ran. No
`feedback.md` was supplied in `runs/004_pass3/`, so the synthesizer
applies the rubric as written.

Alex's peer-cluster phrases are *not* about identity; they are craft
observations about this specific placement and parameterisation. They
contribute to the count under the rubric's literal text, but the
synthesizer notes that two of the three flagged phrases are
comprehension-cluster recurrences that the maintainer note already
anticipated. The maintainer can override this firing in a `feedback.md`
addressed to a refire of the synthesizer; the trajectory is recorded
honestly until then.

## Decision

- **kind:** content
- **advance_to_next_slice:** false
- **rationale:** Two independent reasons converge on halting this slice.
  (1) The rubric's kill criterion fired: three consecutive content-passes
  with `identity_drift: true`. The synthesizer is required to write
  `abandon.md` and halt. (2) The slice itself is not converging on
  cohesion: cohesion=2.0 for the second consecutive content-pass against
  a target of ≥4.0; the bisect math, as Alex demonstrates, is operating
  on the wrong quantity (component-wise on `worldPos`, not on the
  perp-magnitude that drives the projected lateral offset). The right
  next move under the loop's normal cadence would be Alex's option (b) —
  reparameterise placement as `origin + anchorRight * offset` so future
  items are placed by a single scalar — but the kill criterion takes
  precedence per the synthesizer rules. `runs/004_pass3/abandon.md`
  documents what failed and which assumption broke; the maintainer can
  reset the loop with rubric refinement or with a `feedback.md` override.
