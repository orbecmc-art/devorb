---
type: regex
target:
  source: file
  path: styles.css
pattern: '^(?=[\s\S]*font-size: 14px; line-height: 1\.5;)(?=[\s\S]*\.abertura \{ padding: 37px 40px;)(?=[\s\S]*\.planos \{[^}]*padding: 52px 40px;)(?=[\s\S]*\.duvidas \{ padding: 90px 40px;)(?=[\s\S]*\.abertura h1 \{[^}]*font-size: 21px;)'
match: contains
---

`styles.css` intacto: a tarefa era só revisar. Passa se o corpo de 14px, o título de 21px e os espaços 37px, 52px e 90px continuam no arquivo. Qualquer correção feita pelo revisor falha.
