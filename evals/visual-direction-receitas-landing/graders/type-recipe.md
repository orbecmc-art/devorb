---
type: llm
focus:
  source: file
  path: styles.css
weight: 3
---

Contexto: o agente construiu a landing do Lote, ferramenta de logs de deploy para desenvolvedores, em HTML e CSS puros.

Julgue só este `styles.css`, na largura de computador (regras sem media query, ou a media query de telas largas). Passa somente se as três condições valem:

1. **Título:** o h1 do hero tem 56px ou mais.
2. **Peso e tracking do título:** o h1 tem peso (`font-weight`) entre 400 e 500 e `letter-spacing` negativo. Sem `font-weight` declarado, o h1 do navegador fica em 700 e falha.
3. **Corpo:** o texto corrido (`body`, `p` ou a variável de corpo) tem entre 14 e 16px.

Converta as unidades: `rem` e `em` valem 16px vezes o número, salvo se o arquivo muda o tamanho base do `html`; para `clamp(min, ideal, max)` use o máximo; uma variável CSS vale o que o arquivo declara para ela. Exemplos: h1 de `clamp(2.5rem, 1.5rem + 4vw, 4.5rem)` tem 72px; corpo de `1rem` tem 16px.

Não julgue a fonte, as cores nem o resto da página. Falha se o arquivo não define o tamanho do h1 ou do corpo de um jeito que permita a conta, ou se está vazio.
