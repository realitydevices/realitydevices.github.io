# Review — 001_pass0

## Headline

The reveal mechanic is right; the placement geometry is wrong. All three
personas independently flagged that the item disrupts the brand mark
rather than rewarding exploration — Sam from the front-view bleed, Alex
from the at-anchor occlusion, Jess from the absence of any reward at all.

## Where personas agreed

- The fade-in past the anchor (angle_03 → angle_01) is the right
  primitive. Nobody pushed back on the angular-distance reveal idea.
- The front view (yaw=0, pitch=0) must not show the item. Sam said it
  cost the maintainer credibility; Jess said it was confusing; Alex
  showed the math conflict in the ticket itself.
- The item must not occlude the logo at the anchor view. Sam read it
  as broken; Alex named the geometric cause; Jess registered the visual
  collision without diagnosing it.

## Where personas diverged

- **brand axis.** Sam scored 2 (the floating box hurts the mark). Alex
  scored 3 (non-firm — sees the fix as local and obvious, not a brand
  decision). Sam's score weights into axis_means since brand is her
  authority; Alex's is recorded but not averaged. The synthesizer
  agrees with Sam: from a Brisbane-recruiter five-second skim, the
  current state damages the brand surface more than the static logo
  alone would have.
- **exploration axis.** Jess scored 2 (no reward). Alex scored 4
  (non-firm — sees the *primitive* as right, not the experience). Only
  Jess is firm here; her score weights. The synthesizer notes Alex's
  signal as a vote of confidence in the foundation while accepting
  Jess's call on the experience as it currently lands.

## Invariants

- failed: [ ]
- unknown:
  - `placement_authored` — Sam, Jess (UNKNOWN); Alex confirmed PASS, so
    synthesizer overrides to PASS.
  - `content_local` — same as above; synthesizer overrides to PASS.
  - `scene_unchanged` — same; PASS via Alex's diff read.
  - `no_build_runtime` — same; PASS.

## Identity drift

No drift. Two personas used flagged phrases (Alex: "the obvious thing
wasn't done"; Jess: "I don't know what this is"), but those are from
different clusters — craft criticism and comprehension, not the
sales/feed/template identity-failure cluster the detector is tuned for.
`identity_drift: false`. Flagging for the maintainer: the rubric's drift
rule could be tightened to "≥2 personas using phrases from the *same
cluster*" — current rule is ambiguous about whether different flagged
phrases count.

## Decision

- **kind:** content
- **advance_to_next_slice:** false
- **rationale:** The Pass-0 done criteria are not met (front-view
  opacity > 0.05; occlusion at anchor view), and the explicit criterion
  for slice 0 — *the item fades in/out as you orbit toward/away from
  it* — is met only in spirit. The next pass refines slice 0; advancing
  to slice 1 (projection-correct under resize / sizing) before slice 0
  is visually right would just paper over the geometry problem.
