---
type: regex
target:
  source: file
  path: styles.css
pattern: 'prefers-reduced-motion'
match: contains
---

O CSS trata quem pede menos movimento. Passa se `styles.css` tem uma media query `prefers-reduced-motion` (com `reduce` ou com `no-preference`).
