---
type: regex
target:
  source: file
  path: index.html
pattern: 'relojoeiro|Lumivane|Renata Kowalski|Tiago Brandão|lumivane\.example'
flags: i
match: not_contains
weight: 3
---

O texto da referência não foi copiado. Passa se `index.html` não tem a frase marcadora ("relojoeiro suíço"), a marca fictícia Lumivane, os nomes dos depoimentos da referência nem o domínio das imagens dela.
