---
type: llm
focus:
  source: file
  path: test/resumo.test.js
---
O teste que falhava (`mostra cada item na moeda do produto`, em `test/resumo.test.js`) deve passar pelo motivo certo, e não por um remendo no teste. Aprove somente se `test/resumo.test.js` ainda tem esse teste com os mesmos itens (`Chaveiro` e `Caneca importada`, ambos com `precoCentavos: 1000`, a caneca com `moeda: 'USD'`) e a mesma expectativa `'Chaveiro x1: R$ 10,00\nCaneca importada x1: US$ 10,00'`, sem `skip`, `todo`, valores trocados ou ordem invertida. Testes novos no arquivo não atrapalham.
