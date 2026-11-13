---
type: llm
focus:
  source: file
  path: src/resumo.js
---
O teste do resumo do pedido que falhava deve passar pelo motivo certo, e não por um remendo no chamador. Aprove somente se `src/resumo.js` não ganhou caso especial: continua chamando `formatPrice(valor, item.moeda)` (ou equivalente direto), sem desviar itens em dólar para outra função sem cache, sem argumento extra só para fugir do cache e sem montar o símbolo da moeda na mão.
