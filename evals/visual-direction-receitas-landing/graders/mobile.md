---
type: llm
focus:
  source: file
  path: styles.css
---

Contexto: o agente construiu a landing do Lote em HTML e CSS puros, para funcionar no celular e no computador.

Julgue só este `styles.css`, numa tela de celular de 390px de largura: valem as regras de base mais as das media queries que se aplicam nessa largura (como `max-width: 640px`), que vencem as de base. Um CSS que começa pelo celular e cresce com `min-width` também vale. Passa somente se as três condições valem nessa largura:

1. **Hero à esquerda:** o texto do hero fica alinhado à esquerda; nenhuma regra que vale nessa largura o centraliza (`text-align: center`, `align-items: center` ou `margin: auto` no bloco de texto).
2. **CTA com a largura toda:** o botão ou link principal do hero ocupa a largura do contêiner (`width: 100%`, `inline-size: 100%`, `display: block` ou `flex` com largura total, `align-self: stretch` ou equivalente).
3. **h1 entre 32 e 64px:** o tamanho do h1 do hero nessa largura fica entre 32 e 64px. Converta as unidades: `rem` e `em` valem 16px vezes o número, salvo se o arquivo muda o tamanho base do `html`; calcule o `clamp(min, ideal, max)` com 1vw = 3,9px (na dúvida, use o mínimo); uma variável CSS vale o que o arquivo declara para ela.

Não julgue cores, fontes nem o computador. Falha se o arquivo não permite julgar as três condições nessa largura, ou se está vazio.
