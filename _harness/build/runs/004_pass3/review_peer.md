# Review (Alex — peer) — 004_pass3

## Headline
The bisect missed: at the anchor view the card still sits *on* the logo
(its left edge cuts into the logo's right half), because bisecting
`worldPos` component-wise is not the same as bisecting the projected
screen offset.

## Per axis
- brand: 3 — Brand mark is now noticeably occluded at the anchor view,
  which was the exact thing Pass 2's regression was supposed to fix.
  Front and partial views read fine — card is visibly subordinate to
  the logo, the type echoes the logo's letterforms, palette respects
  the scene. But the anchor frame is the load-bearing frame this pass,
  and the brand collision is back. Holding at 3 rather than dropping
  because the other three frames carry it.
- exploration: 3 — Behaviour is unchanged from Pass 2: orbit reveals,
  orbit-away hides, scale floor and opacity track together. Nothing
  here makes the scene more worth orbiting (single empty card with
  one word), but nothing here regresses the mechanic either. Defer-
  adjacent; calling it 3.
- weight: 3 — The slice still reads as "a tunable being tuned." The
  changelog correctly names the bisect intent, but the result on the
  anchor screenshot is still a collision — so the same "twitchy
  outcome" critique that pulled weight to 3 last pass holds. Not
  worse, not better. The reasoning in the changelog is honest about
  the open risk, which I respect; but the output is what gets scored.
- audience: defer — Sam's territory. Comprehension is still bottle-
  necked on slice-3 content, not on this pass's edit.
- cohesion: 2 — Anchor-view collision. The card's projected centre
  is not "clearly to the right of the logo"; the card's left edge
  intersects the logo's right third and the card's body sits over
  the logo's negative space and right-side faces. The done-criteria
  in `next.md` ("card's projected centre is visibly to the right of
  the logo's bounding box ... no overlap") is not met. This is the
  axis I score firmly and the synthesizer needs to hear it: the
  bisect failed, do another one.

## Implementation notes
- The bisect math is fighting itself. Camera direction at anchor is
  `≈ (0.388, 0.0998, 0.917)`. The perpendicular-to-camera magnitude
  of `worldPos` (which is what actually drives screen offset under
  the orthographic projection — the dot-with-camDir part is depth and
  doesn't move the projected point laterally) goes:
    - Pass 1 `(28,6,18)` → perp ≈ 19.2 world units (right-bleed).
    - Pass 2 `(22,5,30)` → perp ≈ 8.7 world units (centre overlap).
    - Pass 3 `(26,6,22)` → perp ≈ 15.6 world units.
  A *true* bisect of the screen-offset signal lands near 13.95, not
  15.6. Pass 3 is biased toward Pass 1 by roughly a third of the gap.
  The right next move is either (a) bisect on the perp magnitude, not
  on the raw `(x,y,z)` triple, or (b) reparameterise the placement as
  `anchorRight * offset` where `anchorRight = anchorDir × up` and
  `offset` is a single scalar in world units — then the bisect is one
  number, not three. Option (b) is what I'd do. It also makes future
  items trivially placeable.
- The probe is a stub for the third consecutive pass. The
  `next.md` was explicit ("If the probe is a stub a third time, the
  next synthesizer pass will record it as a process invariant
  break"). The probe stub does not contain the
  `getBoundingClientRect()` numbers the ticket demanded, so I cannot
  confirm screen-space card centres / sizes — I'm reading them off
  the PNGs by eye. That is the seam this review has to point at.
- `worldPos.project(camera)` is doing the right thing under the
  orthographic camera, but the inline comment ("The two are
  intentionally decoupled... we author worldPos beside the logo") is
  now load-bearing and slightly misleading: the worldPos isn't being
  authored beside the logo, it's being authored at a 3D point whose
  projection-under-current-camera is being eyeballed. Either teach
  the comment that the lateral offset is a function of the perp
  component of worldPos relative to camDir, or — see option (b)
  above — change the parameterisation so the comment becomes true.
- The scale-floor / opacity-floor pairing call from Pass 2 is
  correctly deferred per the ticket; not penalising. But for the
  record: in the front-view PNG the card box is faintly visible at
  ~6% opacity in the upper-right and reads, very mildly, as a
  "ghost rectangle." It's not a "placeholder hasn't loaded" failure
  yet, but it's the direction the failure would come from.

## Invariants (PASS / FAIL / UNKNOWN per row)
- nav_chrome: PASS — no top nav, hamburger, sidebar, or global chrome.
- placement_authored: PASS — `worldPos` is a literal Vector3 in
  `items.js`-equivalent inline array; no auto-distribution.
- content_local: PASS — card content is a hard-coded `<h2>Writing</h2>`,
  no runtime fetch. (Slice 3 will wire JSON, that's fine.)
- scene_unchanged: PASS — camera lerp, breathing, lighting and
  palette are untouched per changelog and confirmed by the
  monolith / particle / fog rendering across the four angles.
- no_build_runtime: PASS — vanilla JS, CDN three.js, no bundler.
- no_third_party_overlay: PASS — no chat, no banner, no analytics modal.

## Failure-phrase check
- "the math is fighting itself" — applies. Component-wise bisect of
  worldPos is not bisecting the quantity that actually moves the
  card on screen.
- "I can see where the seams are hidden" — applies, mildly. The
  inline comment claims `worldPos` is "authored beside the logo,"
  but the only thing being authored is a 3D point whose projection
  is being checked after the fact. The seam is between the model
  ("a number you set") and the actual behaviour ("a number that
  goes through a non-trivial projection").

## One concrete observation
The single number that needs to change is the *projected lateral
offset of the card from the logo at the anchor view*, and the
current parameterisation makes that quantity a non-obvious function
of three numbers. A correct Pass 4 either (a) does a true bisect on
the perp-magnitude (target ~13.95 world units → e.g. `worldPos =
(24, 6, 24)` gives perp ≈ 12.9, closer to the midpoint than the
current 15.6, and shifts the card further right at anchor without
right-bleed at front), or (b) reparameterises placement as
`origin + anchorRight * offset` so future items are placed by a
single scalar that means what it says. Option (b) is the slower,
weightier choice and it's the right one — it removes a class of
bug rather than fixing one instance of it, and it makes the
comment true. Either way, the probe must produce real
`getBoundingClientRect()` numbers next pass; reviewing pixel
collisions off the PNGs is not how this loop is supposed to work.
