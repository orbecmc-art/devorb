---
type: llm
focus:
  source: file
  path: src/app.css
weight: 3
---

Contexto: a Padaria Fermento já tem um sistema de design. Antes da execução, este `src/app.css` tinha um bloco `@theme` com estes tokens, todos em hex, com nome de papel e o par `on-*` de cada superfície:

- Cores do tema claro: `--color-surface: #FBF7F0`, `--color-on-surface: #2B2118`, `--color-surface-muted: #F0E8DC`, `--color-on-surface-muted: #5C4B3B`, `--color-brand: #8A3B12`, `--color-on-brand: #FFFFFF`, `--color-border: #D9CBB8`, `--color-focus: #8A3B12`.
- As mesmas variáveis com os valores do tema escuro, num `:root` dentro de `@media (prefers-color-scheme: dark)`: `#1C1612`, `#F3EBE0`, `#2A221C`, `#C9B8A4`, `#E08A5A`, `#1C1612`, `#4A3D33`, `#E08A5A`, na mesma ordem.
- `--font-display`, `--font-sans`, `--radius-card: 12px` e `--radius-button: 999px`.

A spec nova pede a página "Meus pedidos", com cinco estados de pedido (aguardando pagamento, em preparo, saiu para entrega, entregue, cancelado) e uma mensagem de erro de carregamento, e diz que faltam ao sistema as cores desses estados.

Julgue só o texto deste `src/app.css`. Passa somente se as quatro condições valem:

1. **O que existia ficou.** Todos os tokens listados acima continuam no arquivo, com os mesmos nomes e os mesmos valores, nos dois temas.
2. **Há tokens novos para os estados.** O arquivo ganhou variáveis de cor para os estados do pedido ou para os papéis que os cobrem (por exemplo sucesso, aviso, perigo, informação), e uma que serve ao erro de carregamento. Um papel pode servir a mais de um estado.
3. **Seguem o que existe.** Os tokens novos de cor usam o mesmo prefixo `--color-`, nomes de papel (não de matiz, como `--color-green-600`), e, quando são superfície ou fundo de algo com texto, vêm com o par `on-*` correspondente, como os que já existiam.
4. **Nos dois temas.** Os tokens novos de cor têm valor no `@theme` e também no bloco do tema escuro.

Não julgue as cores escolhidas, o formato de cor dos valores novos nem quantos estados dividem um papel. Falha se um token antigo foi renomeado, apagado ou mudou de valor, se não há tokens de estado, se os novos usam outro esquema de nomes ou ficam sem valor no escuro.
