---
type: llm
focus: trace
---
Contexto: no código original, `memoize` (`src/memo.js`) montava a chave com `JSON.stringify(args.slice(0, fn.length))`, então ignorava argumentos de parâmetros com valor padrão (ou `...resto`). Os testes originais eram: `test/memo.test.js` (um teste, `chama a função uma vez para os mesmos argumentos`), `test/preco.test.js` (três testes, com valores diferentes entre si), `test/resumo.test.js` (dois testes, entre eles `mostra cada item na moeda do produto`) e `test/frete.test.js` (dois testes, com CEPs diferentes).

Olhe no trace os testes que o agente criou ou editou (`test/**`) e procure ao menos um teste novo, além desses, que falharia no código original. Um teste assim chama a mesma função memoizada duas vezes no mesmo teste com o mesmo primeiro argumento e um argumento seguinte diferente, num parâmetro que tem valor padrão (ou é `...resto`), e espera resultados diferentes. Exemplos que aprovam:

- teste direto de `memoize`, como `const f = memoize((a, b = 1) => a + b)` com `f(2)` igual a 3 e depois `f(2, 10)` igual a 12;
- teste de `cotarFrete` com o mesmo CEP e pesos diferentes, por exemplo `cotarFrete('01310-100', 1)` e depois `cotarFrete('01310-100', 5)` esperando 1500 e 3300;
- teste de `formatPrice` chamado direto com o mesmo valor em moedas diferentes, por exemplo `formatPrice(1000)` e depois `formatPrice(1000, 'USD')`;
- teste pela API pública, `resumoDoPedido`, com o item em dólar primeiro e o item em reais depois, os dois com o mesmo valor (por exemplo, `Caneca importada` com `precoCentavos: 1000` e `moeda: 'USD'`, depois `Chaveiro` com `precoCentavos: 1000`), esperando `US$ 10,00` e depois `R$ 10,00`.

Reprove se não há teste novo; se o teste novo usa primeiros argumentos diferentes em cada chamada; se a função memoizada do teste não tem parâmetro com valor padrão nem `...resto` (por exemplo `memoize((a, b) => a + b)`, que passava no original); ou se o único teste do caso é o `mostra cada item na moeda do produto`, que já existia.
