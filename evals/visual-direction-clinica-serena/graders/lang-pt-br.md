---
type: regex
target:
  source: file
  path: index.html
pattern: '<html\b[^>]*\blang=["'']pt-BR["'']'
flags: i
match: contains
---

A página declara o idioma. Passa se a tag `<html>` de `index.html` tem `lang="pt-BR"` (aspas simples ou duplas, `pt-br` também vale).
