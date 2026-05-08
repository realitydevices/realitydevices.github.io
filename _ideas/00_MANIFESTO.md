# Reality Devices — Design Principles

> **Read `_meta/PURPOSE.md` first.** That doc explains *why* this site exists,
> who it's for, and what the brand stands for. This doc only covers *how* the
> site is designed and built. If the two ever conflict, `PURPOSE.md` wins.

This document is for engineers (human and agentic) working on this site. It is
not marketing copy. It exists so that when you are deciding between two valid
implementations, or proposing a new idea, you can resolve the call against a
shared compass instead of guessing what the maintainer wants.

If a proposal contradicts something here, that is a signal to either reject the
proposal or update this document deliberately — not to quietly diverge.

## What this site is

`realitydevices.au` is a personal site, blog, and link manager presented as a
**single explorable 3D scene**. There is no nav bar, no header, no menu. The
RCD logo is the anchor of the scene; everything else — writing, links, future
content — lives at points around it in space and is found by *looking*.

The user is rewarded for exploring. The reward is finding something they didn't
know was there.

## The vision in one sentence

**A site you navigate with your eyes, not your cursor — where every surface
feels intentional, weighted, and worth orbiting around.**

## Operating principles

These are ordered. When two principles conflict, the earlier one wins.

### 1. Exploration over navigation

The default mode of moving around the site is *looking around*, not clicking
links. Items live in 3D space and reveal themselves when the user's gaze
approaches them. A traditional nav bar would short-circuit this and is
disallowed except as a deliberate, scoped fallback (e.g. a reduced-motion
alternate view).

When you propose a feature, ask: *does this make the scene more worth
exploring, or does it bypass exploration?* Bypassing is sometimes correct
(e.g. accessibility), but it should be conscious.

### 2. Weight and intentionality over responsiveness

Camera lag (the 0.05/frame lerp) is not a bug to be tuned out. Idle breathing
motion is not noise. Slow reveals are not jank. The site is allowed to feel
*considered* — almost slightly heavy — because that is what makes it feel
premium rather than twitchy.

Default to the slower, weightier choice when in doubt. If a reviewer says
"this feels sluggish," check whether they mean *unresponsive to input* (a real
problem) or *not instant* (often the intended feel).

### 3. The brand drives the scene; the scene amplifies the brand

The orange/cyan/light palette is read from the SVG. Light colors are picked to
make orange faces catch the warm rim and cyan faces catch the cool rim. The
3D form, lighting, and motion all exist to make the RCD mark feel inhabited,
not decorated.

If you are adding visual flourish that doesn't either (a) carry the brand
forward or (b) reward exploration, it probably shouldn't ship.

### 4. Curated, deterministic, hand-placed

Items on the sphere are positioned by the maintainer, not auto-distributed.
Content is small in volume and high in care. The scene is not a feed; it is
not infinite; it is not generative-slop-as-content. Generative elements are
allowed *only* in service of atmosphere (e.g. background skyboxes), never as
the substance the user is exploring.

A new feature that scales to "thousands of auto-generated items" is almost
certainly the wrong shape for this site.

### 5. One scene, beautifully rendered, before two scenes

Resist scope creep into rooms, sub-scenes, or page-to-page transitions until
the single scene is genuinely solid. "Click a monolith → enter a new room" is
explicitly a v3 problem. We don't ship the second thing until the first thing
is right.

### 6. Stable spatial geography

Once an item is placed on the sphere, its position is part of the user's
mental map of the site. Don't shuffle item positions between sessions, don't
randomize layouts, don't reflow on resize beyond what's necessary. A returning
visitor should be able to look toward where the writing was and find it
again.

### 7. Web-native, low-ceremony stack

Vanilla JS, ES modules, importmap, three.js from CDN. No build step in the
prototype phase. Move to react-three-fiber + Vite *only* when the scene
graph's complexity actually demands it — not pre-emptively. The site should
remain readable and forkable by a single person on a weekend.

### 8. Accessibility and mobile are not afterthoughts, but they are not v1

`prefers-reduced-motion` and a touch/mobile fallback are required before any
public-facing launch, but they are *fallbacks* — alternative paths into the
same content, not the design driver. Don't compromise the orbital experience
on desktop to make mobile easier.

## Anti-patterns (will be rejected)

- Adding a top nav, hamburger menu, or sidebar to the main scene.
- "Just for now" placeholder copy that breaks the brand voice.
- Per-frame model inference, generated content as substance, infinite-scroll
  feeds, social-media surface patterns.
- Removing the camera lag, the idle breathing, or the lighting two-tone in the
  name of "cleaner" code or "snappier" feel.
- Auto-distributed item layouts (e.g. fibonacci sphere) presented as the
  primary placement strategy.
- Cookie banners, chat widgets, popups, or any third-party overlay that
  competes with the scene for attention.
- Silent rebrands of palette / typography without updating this doc and the
  hardcoded light colors together.

## How to use this doc when proposing or building

1. Read this file before reading any individual `NN_*.md` idea.
2. When proposing a new idea, name which principle(s) it advances and which
   (if any) it tensions against.
3. When implementing, if you find yourself about to violate an anti-pattern
   "just temporarily," stop and ask.
4. If a principle here is wrong or outdated, propose a change to *this* file
   in the same PR as the work that motivated the change. Don't drift.

## What this doc deliberately does not say

- Specific colors, fonts, sizes, or component APIs (those live in the code
  and individual idea docs).
- Roadmap dates or priorities (those are ephemeral; ideas are numbered, work
  is sequenced in conversation).
- Anything about the maintainer's personal taste beyond what is needed to
  make implementation decisions.

If you need one of those, ask — don't infer it from this file.
