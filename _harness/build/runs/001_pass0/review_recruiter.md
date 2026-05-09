# Review (Sam — recruiter) — 001_pass0

*Inputs: angle_00_front.png and angle_01_at-anchor.png. Told this is
realitydevices.au and the maintainer is a Brisbane Platform Lead /
Principal Engineer.*

## Five-second take

First image: there's a logo and the words "Reality Construction Devices",
which I can read. Then there's a faint box with the word "Writing" floating
off to the right with no obvious connection. Looks like a stray UI
fragment. Second image: that same box is now sitting on top of the logo,
half-obscuring it. That reads as broken, not designed. I'd assume this
person's site is half-built.

## Per axis

- **brand: 2** — The mark itself is good and the brand stack reads.
  But on the second image the box overlaps the logo and undermines it;
  the brand surface feels less considered than the logo on its own
  would have been.
- **exploration: defer** — I have two stills, can't say.
- **weight: defer** — Stills don't tell me about pacing.
- **audience: 2** — I would not put this in front of a hiring manager
  who's only going to spend ten seconds. The floating "Writing" looks
  like an unfinished build. If this is the surface someone's
  professional reputation rides on, this image would cost him a
  benefit-of-the-doubt that a static logo wouldn't.
- **cohesion: defer** — Implementation question.

## Invariants

- nav_chrome: PASS
- placement_authored: UNKNOWN
- content_local: UNKNOWN
- scene_unchanged: UNKNOWN
- no_build_runtime: UNKNOWN
- no_third_party_overlay: PASS

## Failure-phrase check

No failure phrases triggered. (The site doesn't read as a sales surface,
a portfolio template, or a LinkedIn profile. It reads as
*incomplete*, which is a different problem.)

## One concrete observation

The item must not be visible — at all — when the camera is centred on
the logo. The brand mark needs to be the only thing on screen at rest.
Whatever the next pass does with depth or fade, the front view (yaw=0,
pitch=0) is the one a five-second visitor sees first; "Writing" floating
in the corner there is the worst possible first frame.
