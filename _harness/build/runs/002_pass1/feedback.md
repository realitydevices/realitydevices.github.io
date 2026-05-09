# Feedback for pass 1 (run 002_pass1)

<!--
Free-form. The synthesizer reads this AFTER the persona reviews and addresses
it explicitly in review.md (separate "Maintainer feedback" section).

The synthesizer cannot retroactively rewrite axis_means in score.json — that
would corrupt the trajectory record. If you want a score reweight, edit this
file and re-run synthesize.

Personas do NOT see this file. They stay naive.
-->

## Direction for the next ticket

The card should sit **closer to the camera (higher world-z)** so that:

- At the front view it's *less obvious* — partially out of view, or
  scaled down enough that it doesn't compete with the logo.
- At the anchor view it reads *larger* — coming forward into focus,
  not just a fixed-size rectangle that lights up.

This means the reveal animation should drive **scale** as well as
opacity. Today the card is a constant 320×240 with opacity tied to
angular distance. The right shape is opacity *and* scale both following
reveal — small/dim at low reveal, large/bright at high reveal.

This supersedes Pass 2's planned fade-tighten move. The fade window
can still be tightened *as part of* this change if the synthesizer
judges it the same atomic move, but the primary direction is the
closer-and-grows behaviour.

## Where the personas may have it wrong

Nothing to override on the persona judgements themselves.

## Anything else

Real blog post content is coming — that should clear the audience=2
floor in slices 3–6. For now, treat audience as expected to stay low
until content ships; do not let it trigger the stall detector by
itself.
