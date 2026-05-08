# Audience-Shaped Reviewer Personas in the Harness

## Concept

Today `_harness/workshop/reviewer.md` defines a single aesthetic reviewer.
Extend it to three personas drawn from the ranked audience in PURPOSE.md:
a **Brisbane recruiter** (priority #1), a **Principal-Engineer peer**
(priority #1, technical register), and a **curious passer-by** (priority
#2). Each grades the same screenshots against PURPOSE-aligned questions —
"would I take this person seriously after five seconds?", "is the voice
legible without reading?", "does this look like a sales site or a thinking
surface?" — rather than against generic aesthetic rubrics.

## Why this is high-leverage

The harness is the loop that shapes every visual change. If the reviewer
drifts toward "looks cool", the site drifts with it. Forcing the loop to
re-encounter PURPOSE on every pass is the cheapest available defence
against that drift, and it makes the audience priorities operational
rather than aspirational.

## Open before any code

- Persona files: one `reviewer_*.md` per persona, or one file with three
  sections?
- Synthesis step: do the three reviews get merged into a single `next.md`,
  or does each persona produce its own and the maintainer reconciles?
- Does the existing aesthetic reviewer survive as a fourth voice, or get
  retired in favour of the three?
