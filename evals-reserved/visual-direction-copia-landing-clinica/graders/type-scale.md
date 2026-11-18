---
type: llm
focus:
  source: file
  path: styles.css
weight: 2
---

Contexto: na referência, o título do hero tem mais de 3 vezes o tamanho do texto de corpo (72 px contra 16 px), e uma parte do título tem outra cor que o resto (título de duas cores). O usuário pediu cópia fiel da forma.

Julgue o `styles.css` entregue. Passa somente se:

1. O título principal do hero tem tamanho pelo menos 3 vezes o do texto de corpo. Vale `clamp()`, `rem` ou `px`, desde que o valor máximo (ou o valor em tela larga) cumpra a razão.
2. Há uma regra para uma parte do título com cor diferente do resto (por exemplo um `span` ou `em` colorido dentro do `h1`).

Não julgue as cores escolhidas nem o gosto.
