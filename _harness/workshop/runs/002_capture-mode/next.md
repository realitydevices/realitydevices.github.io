# Next iteration

In `index.html`, in the `planes` object (around line 148), change the trim
entries from their current `{back:-1000, front:-1000}` flat-backplate values
to co-locate each trim with its colour-matched letter:

```js
trimblue:       { back: 500, front: 600 },
trimorange:     { back: 800, front: 900 },
trimorangedark: { back: 800, front: 900 },
```

Then re-run `_harness/workshop/capture.sh 003_trim-with-letters`.

Why: trim currently reads as a phantom second logo from any side view
because it sits ~1300 units behind the letters. Bringing it into the
letter band kills the phantom while preserving the front-on silhouette.
