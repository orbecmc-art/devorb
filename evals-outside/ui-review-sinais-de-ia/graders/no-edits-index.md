---
type: regex
target:
  source: file
  path: index.html
pattern: '^(?=[\s\S]*<h1>Deploys sem mistério</h1>)(?=[\s\S]*<h3 class="t-roxo">Feature 1</h3>[\s\S]*<h3 class="t-rosa">Feature 2</h3>[\s\S]*<h3 class="t-verde">Feature 3</h3>)(?=[\s\S]*<strong class="n-roxo">10x</strong>\s*<span>mais rápido</span>)(?=[\s\S]*<div class="icone-hero" aria-hidden="true">)'
match: contains
---

A revisão relata e não corrige. Passa se `index.html` ainda tem, como o scaffold deixou, o título `<h1>Deploys sem mistério</h1>`, os três cartões "Feature 1", "Feature 2" e "Feature 3" nessa ordem, o número "10x mais rápido" e o ícone grande do hero.
