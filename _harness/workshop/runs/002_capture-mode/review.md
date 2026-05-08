# Review — 002_capture-mode

## Headline
Depth differentiation reads beautifully from every angle, but the trim layer
sits ~1300 units behind the letters and reads as a phantom second logo
floating off to one side.

## Per-axis

- **Depth feel**: Strong. From angle_01 / angle_03 / angle_05 the r / c / d
  layers visibly stagger and the iso-cube sits behind everything, which is
  exactly the *"there's stuff back there"* effect the brief asks for. The
  silhouette spread across the orbit is the single best thing about this
  baseline.

- **Premium-ness**: Mid. The colours are honest and the orthographic
  projection gives it a confident isometric feel. But the materials read
  flat — there's no rim catch from the warm/cool lights at any angle, the
  edges look CSS-extruded rather than lacquered, and the iso-cube faces
  appear unlit (the dark-orange right face especially). It's reading as
  *flat colour blocks in 3D space* rather than *3D objects with surface*.

- **Brand coherence**: The palette is intact. The composition coherence
  is broken by the trim phantom (see headline) — from any side view the
  eye sees two distinct shapes and asks which one is the logo. From
  angle_01 the trim band on the far right looks like a *fourth* letter.

- **Silhouette across angles**: Holds shape, but the front view (angle_00)
  reads as a clean nested-letterform logo while the orbit views read as
  exploded-axonometric *diagrams*. That's not a fault — it's the brief —
  but it means the front view is doing 100% of the "logo" work and the
  orbit is doing 100% of the "discovery" work, with no middle ground.
  Adding any continuous element that connects them (e.g. a faint
  contact-shadow on a ground plane) might bridge the gap.

## Invariants check

- [x] depth contrast readable from side-view
- [x] no perspective fisheye
- [~] cube reads as 3D corner from any angle — the front face looks like
      a flat parallelogram from angle_00, only really resolves as a
      corner from angle_01 / angle_05. Lighting may be the issue more
      than geometry.
- [x] front-on view still feels like a logo (not a diorama)

## Concrete next move

Pull the trim layer forward so it sits *with* the letters instead of
1000+ units behind them. In `index.html` `planes`:

```
trimblue:       { back: 500, front: 600 },   // join cyan c-band
trimorange:     { back: 800, front: 900 },   // join orange r-band
trimorangedark: { back: 800, front: 900 },   // join orange r-band
```

Reason: the trim was authored as a flat backplate (`{back:-1000, front:-1000}`,
zero thickness) which makes it read as a duplicate logo on every side view.
Co-locating it with its colour-matched letter turns it from a phantom into
an extension of the same form. The front-on view is preserved because the
trim already rendered behind the letters at z=-1000 didn't contribute to
the silhouette anyway — it was occluded — and now it'll just sit behind
the letter at the same z-band, hidden from the front and revealed from the
side as part of the logo, not as a separate object.

## Tooling notes (out-of-band)

- `?nobrand=1` is intermittently respected — appears in angle_01 and
  angle_04, hidden in angles 00/02/03/05. Cause: my hook adds the
  `is-hidden` class but the `animate()` loop calls `setBrandVisible(true)`
  every frame and the early-return guard means it sometimes removes the
  class. Fix: in capture mode, skip `setBrandVisible` entirely.
