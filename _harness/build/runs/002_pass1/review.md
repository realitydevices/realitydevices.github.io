# Review — 002_pass1

## Headline

The decoupling change landed cleanly and removed the at-anchor occlusion,
but the card still reads as a flat, fixed-size DOM rectangle bolted onto
a volumetric scene — the next move is to drive *scale* off reveal, not
just opacity, so the card grows forward as you orbit toward it.

## Where personas agreed

- The placement-model change worked at the anchor view: Sam, Alex, and
  Jess all describe a coherent composition where the card sits beside
  the logo without fighting it (Alex's call most explicit; Sam and Jess
  read it as "deliberate" / "identity").
- The reveal mechanic is the right primitive — Alex confirmed the
  gradient via `angle_02_partial` and the disappearance at
  `angle_03_far`; Jess called the cube's behaviour the small "huh" she
  was looking for.
- Front-view bleed is still legible. Sam read the front frame as too
  sparse; Jess called the visible-but-empty card "placeholder boxes
  that haven't been filled in." Alex's inline note ("a rectangle, which
  is the ceiling on this score until the fade window closes") names the
  same thing in code terms. The Pass 1 ticket explicitly deferred this
  to Pass 2, so it's expected, but it is the binding ceiling on
  brand/cohesion this pass.

## Where personas diverged

- **brand axis.** Only Sam scored firm (3); Alex's 3 and Jess's defer
  agree in spirit. Sam's 3 weights into axis_means. The Pass 1 done
  criterion ("brand ≥ 3.0") is met. The card no longer hurts the mark;
  it just doesn't yet help it.
- **exploration axis.** Only Jess scored firm (3). Alex's non-firm 3
  agrees. The mechanic is present; the *reward* is not yet — explicitly
  by spec, since slice 0 ships one item.
- **weight axis.** Alex firm=4 (the surgical change with documented
  rationale is craft, not pose). Sam's non-firm 3 reads the front view
  as sparse; Jess's non-firm 4 reads it as restrained. Alex weights;
  axis mean = 4.0. The synthesizer agrees with Alex: the implementer
  named what was deferred and why, and the diff is contained.
- **cohesion axis.** Only Alex scored firm (3): the geometric placement
  is now correct, but the card is "a hard-edged rectangle with a 1px
  border on a scene that is otherwise volumetric extruded geometry plus
  soft fog — the *material language* of the card is still bolted-on
  DOM." That's the next ceiling. The Pass 1 done criterion asked for
  cohesion ≥ 4.0; not met. Alex flagged it as honestly unreachable
  inside this slice while the card stays a flat CSS rectangle.
- **audience axis.** Sam firm=2, Jess firm=2; both name the same
  thing — the page does not say what Kirk does. Per
  `maintainer_notes.md`, this floor is expected until real content ships
  in slices 3–6 and does not on its own count toward stall.

## Invariants

- failed: [ ]
- unknown: Sam and Jess returned UNKNOWN on `content_local`,
  `scene_unchanged`, `no_build_runtime` (cannot judge from PNGs). Alex's
  diff read confirmed PASS on all three (changelog: "diff is confined to
  the items block"; "three.js still from CDN importmap, no build step
  introduced"). Synthesizer overrides Sam and Jess's UNKNOWNs to PASS on
  Alex's authority — flagging here for maintainer audit per the
  override rule.

## Identity drift

Two personas used flagged phrases this pass:

- Sam: "I can't tell what he does" (recruiter cluster — brand/audience
  comprehension failure).
- Jess: "I don't know what this is" (passer-by cluster — comprehension
  failure).

Per the rubric ("two of three personas use a flagged phrase in the same
pass → `identity_drift: true` regardless of axis scores"), this fires.
`identity_drift: true`.

Important caveat for the maintainer: both phrases are
*comprehension-cluster* phrases — they both name "the page does not
communicate what Kirk does." The `audience_floor` note in
`maintainer_notes.md` already explains *why* this is expected during
slices 0–2 (no real content yet). The drift signal is technically
correct but is naming the same thing the audience floor already
acknowledges; it is *not* sales-site / portfolio-template / feed-shape
drift, which is the failure mode the detector was tuned for.

This is the second pass in a row where the rubric's drift definition
has been ambiguous (Pass 0's review.md flagged the same gap). The
synthesizer is recording `identity_drift: true` faithfully; the
maintainer should consider tightening the rubric to "≥2 personas using
phrases from the *same identity-failure cluster* (sales-site / feed /
portfolio / etc.)" or adding a comprehension-cluster exemption while
content is missing. Three consecutive content-passes with
`identity_drift: true` is a kill criterion, so this is load-bearing.

## Maintainer feedback

`feedback.md` is present and is treated as authority above the
personas:

- **Direction overrides Pass 2's planned move.** The feedback supersedes
  the previously-deferred fade-window tighten. The next pass's ticket is
  to drive **scale and opacity together off reveal** (small/dim at low
  reveal → large/bright at high reveal) with the card placed *closer to
  the camera* (higher world-z). The fade-window tighten may be folded
  in if it's the same atomic move, but is not the primary direction.
  This directly addresses Alex's cohesion ceiling ("the card still
  reads as a CSS rectangle floating in front of a 3D scene") — a card
  that grows forward into focus is no longer a fixed-size overlay; it
  acquires depth behaviour.
- **Audience floor reaffirmed.** Feedback explicitly says audience=2 is
  expected until real content ships and should not on its own trigger
  stall detection. This matches `maintainer_notes.md`. No score
  override needed; just noted.
- **No persona overrides.** Feedback says the personas have it right on
  the judgements themselves.

No score reweighting applied to `score.json` — the feedback redirects
the *next* pass, it does not contradict any persona's judgement of
*this* pass.

## Decision

- **kind:** content
- **advance_to_next_slice:** false
- **rationale:** Pass 1's done conditions are partially met (brand ≥ 3.0
  yes; cohesion ≥ 4.0 no — Alex was honest that he could not score it
  there with the card still a flat rectangle). Slice 0's done condition
  ("the item fades in/out as you orbit toward/away from it") is met in
  the mechanic but the *reading* is still chrome-like. Maintainer
  feedback names the concrete next move: scale-on-reveal with the card
  closer to camera. That refines slice 0 and is one atomic change.
