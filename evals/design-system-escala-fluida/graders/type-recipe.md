---
type: llm
focus:
  source: file
  path: DESIGN.md
weight: 3
---

Contexto: o agente montou o sistema de design da landing de uma ferramenta de devtools, em modo Persuade, com Geist e Geist Mono. Antes da execução não havia `DESIGN.md`.

Julgue só o texto deste `DESIGN.md`. Passa somente se as três condições valem:

1. **Título:** o título principal (h1 ou display) chega a um tamanho entre 56 e 96px na tela larga (ou o equivalente em rem, com 1rem = 16px, ou um `clamp()` cujo máximo cai nessa faixa), com peso entre 400 e 500 e tracking (letter-spacing) negativo.
2. **Corpo:** o texto corrido tem entre 14 e 16px.
3. **Lead:** o parágrafo de abertura (lead, intro ou subtítulo do hero) tem entre 18 e 22px.

Basta que cada valor esteja escrito no arquivo, em px, rem ou dentro de um `clamp()`. Não julgue nomes de token, a fonte nem as cores. Falha se algum dos três falta, se o título passa de 500 de peso ou fica com tracking zero ou positivo, ou se algum tamanho cai fora da faixa.
