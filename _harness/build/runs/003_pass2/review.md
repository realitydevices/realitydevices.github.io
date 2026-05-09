# Review — 003_pass2

## Headline

The scale-on-reveal mechanic and transform-only positioning landed cleanly,
but the placement tune overshot — at the anchor view the card now bisects
the logo instead of sitting beside it, regressing the load-bearing slice-0
composition that Pass 1 had right.

## Where personas agreed

- The mechanic itself is honest. Alex confirmed `transform-origin: center
  center` makes the scale pivot the card's own centre with no projection
  drift; Jess read the second angle as a genuine "huh" reward ("the shape
  rearranges into something almost unreadable"); Sam read the off-axis frame
  as the brand mark overlapping itself, which names the same composition
  problem from a brand-coherence angle.
- The page still does not say what Kirk does. Sam ("a logo and a mailto"),
  Jess ("I don't know what they *do*"). Per `maintainer_notes.md` this is
  the expected slice-0..2 audience floor, not a new finding.
- The reveal/fade behaviour is reading correctly elsewhere. Alex confirmed
  the gradient via partial-reveal and the disappearance at far view; Jess
  read the orbit reward; Sam noted the Writing label was faint on the front
  view, which is the deliberate low-opacity floor.

## Where personas diverged

- **brand axis.** Sam firm=3 (cube-in-hexagon mark is strong; the off-axis
  overlap costs a point). Alex non-firm 3 ("defer-leaning") naming the same
  overlap as a brand cost. Jess defer. Sam's 3 is the mean. The card
  doesn't degrade the mark in motion language, but it geometrically
  collides with it at the anchor view, which is a real cost.
- **exploration axis.** Jess firm=4 — the second angle is what saves it,
  the rearrangement is the reward. Alex non-firm 3 noting that the scale
  cue is mostly happening invisibly (opacity floor of 0.0 paired with
  scale floor of 0.6 means the size animation runs while the card is
  transparent). Jess weights; mean = 4.0. The synthesizer agrees with
  Jess on the headline — the orbit reward is *present* — but Alex's
  observation is a real implementation crack worth carrying forward in a
  later pass.
- **weight axis.** Alex firm=3 — the curve is considered, but overlapping
  the brand mark at the primary view is a "twitchy outcome of a tunable,
  not a chosen composition." Sam non-firm 3 ("tips from weighty toward
  empty"); Jess non-firm 4. Alex weights; mean = 3.0. This is a regression
  from Pass 1's 4.0, driven entirely by the placement overshoot, not by
  the scale mechanic. A correct placement should restore weight to ≥4.
- **audience axis.** Sam firm=2, Jess firm=3. Mean = 2.5. Sam's 2 is the
  audience-floor reading the maintainer notes already cover; Jess's 3
  reflects "if I'm just browsing, I'm fine." Both are honest. No override.
- **cohesion axis.** Alex firm=2 — at the anchor frame the card sits
  inside the logo's bounding box. Sam and Jess defer (cannot tell from
  stills whether the corner shapes belong, etc.). Alex weights; mean =
  2.0. This is the load-bearing fail of the pass: the slice's core job
  (placement of one item beside the logo) is not done.

## Invariants

- failed: [ ]
- unknown: Sam and Jess returned UNKNOWN on `placement_authored`,
  `content_local`, `scene_unchanged`, `no_build_runtime` (cannot judge
  from PNGs alone). Alex's diff read confirmed PASS on all six —
  `worldPos: new THREE.Vector3(22, 5, 30)` and `anchorDirection(0.4, 0.1)`
  are literal numbers; content is inline `<h2>Writing</h2>`; the changelog
  confirms no edits to camera lerp, breathing, lighting, palette; no
  build-step additions. **Synthesizer override** of Sam and Jess's
  UNKNOWNs to PASS on Alex's authority and the changelog text — flagged
  here for maintainer audit per the override rule.
- The probe is an auto-stub again. The Pass 2 ticket explicitly required
  a real probe (console output, screen-space pixel sizes, one-sentence
  reading). Alex correctly notes this is a process miss; the harness
  should treat a stub probe as a soft fail. Not an invariant in the
  rubric, but worth recording as steering for the implementer.

## Identity drift

Two personas used flagged phrases this pass:

- Sam (recruiter cluster): "I can't tell what he does."
- Jess (passer-by cluster): "I don't know what this is" (partial — Jess
  herself qualifies it; she says she's intrigued by the shape, just doesn't
  know what Kirk *does*).

Per the rubric, ≥2 personas using flagged phrases in the same pass fires
`identity_drift: true`. **This is the second consecutive content-pass
flagging, and both passes have flagged the same comprehension-cluster
phrases that the audience-floor steering note already names as expected.**

The Pass 1 review.md flagged this rubric ambiguity to the maintainer and
the Pass 2 ticket carried the warning forward (1 of 3 toward the kill
criterion). This pass makes it 2 of 3. The synthesizer continues to
record the signal faithfully; the maintainer should consider acting on
the rubric refinement (comprehension-cluster exemption while content is
missing) before Pass 3, or the kill criterion will fire on a signal that
is structurally guaranteed to recur until slice 3.

Alex's "the obvious thing wasn't done" is *not* a flagged identity-drift
phrase in the rubric — it's a craft observation about this specific
placement overshoot. Recorded for completeness; does not contribute to
drift.

## Decision

- **kind:** content
- **advance_to_next_slice:** false
- **rationale:** The Pass 2 done conditions are not met. Cohesion landed
  at 2.0 (target ≥4.0); weight regressed to 3.0 (target ≥4.0); brand
  held at 3.0. The placement tune from `(28,6,18)` to `(22,5,30)`
  overshot — the card now centre-overlaps the logo at the anchor view.
  Alex's bisect target `(26, 6, 22)` is a single concrete move within
  the current slice. The scale-with-reveal mechanic, transform-origin,
  and transform-only positioning are correct and should be preserved.
