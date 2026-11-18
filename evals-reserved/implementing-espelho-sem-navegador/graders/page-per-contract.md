---
type: llm
focus:
  source: file
  path: index.html
weight: 3
---

Contexto: `index.html` é a página de planos da Marmitaria Sabor Caseiro, HTML e CSS puros (CSS num `<style>` do próprio arquivo), construída a partir da spec aprovada (`## Direção visual`) e do `DESIGN.md`. Antes da execução o arquivo não existia. O contrato pede: modo Persuadir; seções nesta ordem: abertura, planos, como funciona, perguntas; três planos (Semana R$ 129, Quinzena R$ 239, Mês R$ 449) com a Quinzena em destaque claro (classe `plano-destaque` ou equivalente com peso visual maior que os outros dois); cores e tamanhos vindos de variáveis CSS com os tokens do DESIGN.md (terracota `#B5472A`, creme `#FBF4E8`, tinta `#2B2118`), corpo com 16px ou mais; nada de gradiente roxo, emoji como ícone nem foto de banco; layout que empilha em tela estreita (uma `@media` ou grade que quebra).

Julgue só o código do `index.html`. Passa somente se todas valem:

- as quatro seções existem, na ordem do contrato, com os três planos, nomes e preços certos;
- a Quinzena se distingue dos outros dois planos no CSS (borda, fundo, escala ou selo "mais pedida"), e os três não têm o mesmo peso;
- o CSS declara variáveis (`:root`) com os tokens do DESIGN.md e as regras as usam em vez de repetir valores soltos de cor; corpo com 16px ou mais;
- nenhum item do "não fazer" aparece (gradiente roxo ou azul-violeta, emoji como ícone, `<img>` de banco de imagens);
- há regra responsiva (`@media` ou grade com `auto-fit`/`minmax`) para o celular.

Falha se qualquer uma faltar.
