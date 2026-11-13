---
type: regex
target:
  source: file
  path: index.html
pattern: 'href=["'']#["'']'
match: not_contains
---

Nenhum link morto. Passa se `index.html` não tem `href="#"` (nem `href='#'`). Âncoras para seções da página, como `href="#agendar"`, valem.
