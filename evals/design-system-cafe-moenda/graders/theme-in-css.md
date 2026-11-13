---
type: regex
target:
  source: file
  path: src/app.css
pattern: '@theme\b'
match: contains
---

Os tokens seguem o Tailwind instalado. O projeto usa Tailwind 4, então os tokens entram num bloco `@theme` em `src/app.css` (`@theme` ou `@theme inline`). Antes da execução, o arquivo só tem `@import "tailwindcss";`.
