# Maintainer notes — persistent steering for the synthesizer

<!--
This file is read by the synthesizer on every pass. Anything here applies
until removed. Use for things like:
- framing for the active slice ("we're early; tolerate 'looks unfinished'")
- locked tunables ("fade=0.3 is the floor; don't experiment below")
- persona reweighting ("treat Sam's brand=2 as 3 this slice")
- failure-phrase exemptions ("'looks like every other site' isn't drift here")

Personas do NOT read this. Implementer does NOT read this. Synthesizer only.
-->

## Audience floor while content is missing

Slices 0–2 build *placement and motion* for items, not their *content*.
Real blog posts and the curated link list don't ship until slices 3–6.
Until then:

- Expect `audience` axis means to sit around 2.0 — Sam and Jess both
  read an empty card with the heading "Writing" as unfinished, which
  is honest but unfixable inside the current slice.
- Do not let a flat `audience` axis alone trigger the stall detector
  ("no overall improvement ≥ 0.5 for three content passes"). If
  every other axis is moving and only `audience` is flat, that is
  expected, not a stall.
- Once real content lands and `audience` is still ≤ 2, *that* is a
  meaningful signal and should be treated normally.
