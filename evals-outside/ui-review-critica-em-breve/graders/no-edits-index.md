---
type: regex
target:
  source: file
  path: index.html
pattern: '^(?=[\s\S]*<h1>Agenda do Prumo</h1>)(?=[\s\S]*<p>Menos telefone\.</p>\s*<p>Menos faltas\.</p>\s*<p>Lista do dia pronta\.</p>)(?=[\s\S]*<section class="simples" id="quando">)'
match: contains
---

A revisão relata e não corrige. Passa se `index.html` ainda tem, como o scaffold deixou, o título `<h1>Agenda do Prumo</h1>`, as três linhas curtas da coluna esquerda ("Menos telefone.", "Menos faltas.", "Lista do dia pronta.") e a seção `simples` de "Quando chega".
