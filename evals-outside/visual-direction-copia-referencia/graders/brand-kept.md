---
type: regex
target:
  source: file
  path: styles.css
pattern: '^(?![\s\S]*#(?:6d4aff|ff7a59|17123a)\b)(?=[\s\S]*#136a7a\b)(?=[\s\S]*#faf6ee\b)(?=[\s\S]*\bGeist\b)'
flags: i
match: contains
---

A marca é a do Prumo, não a da referência. Passa se `styles.css` usa a cor primária `#136A7A` e o fundo `#FAF6EE` do `DESIGN.md`, cita a fonte Geist, e não traz as cores do Quadrante (`#6D4AFF`, `#FF7A59`, `#17123A`). Maiúsculas e minúsculas tanto faz.
