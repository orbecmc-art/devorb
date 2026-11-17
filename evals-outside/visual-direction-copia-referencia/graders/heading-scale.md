---
type: llm
focus:
  source: file
  path: styles.css
weight: 2
---

Contexto: a página de referência tem um título principal (h1) de 56px sobre um corpo de 17px, ou seja, o título é mais de 3 vezes maior que o texto corrido. A cópia, em `styles.css`, deve manter essa escala no computador.

Julgue só este `styles.css`. Passa se, na largura de computador (regras sem media query, ou a media query de telas largas), o tamanho do h1 do hero é pelo menos 3 vezes o tamanho do texto do corpo. Converta as unidades: `rem` e `em` valem 16px vezes o número, salvo se o arquivo muda o tamanho base do `html`; para `clamp(min, ideal, max)` use o máximo; uma variável CSS vale o que o arquivo declara para ela. Exemplos: h1 de 56px com corpo de 17px passa (3,3); h1 de `3.5rem` com corpo de `1.0625rem` passa; h1 de 40px com corpo de 16px falha (2,5).

Falha se o arquivo não define o tamanho do h1 ou do corpo de um jeito que permita a conta, ou se está vazio.
