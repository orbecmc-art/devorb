---
type: regex
target:
  source: file
  path: painel/pedidos.html
pattern: '^(?=[\s\S]*<html\b[^>]*\blang=["'']pt-BR["''])(?=[\s\S]*<meta\b[^>]*\bcharset=["'']?utf-8\b)'
flags: i
match: contains
---

Português declarado: passa se `painel/pedidos.html` declara `<html lang="pt-BR">` e `<meta charset="utf-8">` (aspas simples ou duplas, maiúsculas ou minúsculas). Falta de `lang`, outro idioma ou falta da declaração de UTF-8 falha.
