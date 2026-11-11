---
type: llm
focus: trace
---

Julgue a versão final da lógica de desconto, reconstruída pelas edições do trace, esteja ela em `src/cart.js` ou num módulo novo que o `total()` usa.

Regra pedida: o total do carrinho (`total()`) aplica um desconto sobre o subtotal dos produtos, e o frete (`SHIPPING_CENTS`, 1990 centavos) fica sem desconto. Os valores do código são centavos inteiros. A taxa da faixa vale para o subtotal inteiro, não por fatias como em imposto:

- subtotal abaixo de 20000 (R$ 200): sem desconto;
- de 20000 a 49999: 5%;
- de 50000 a 99999: 10%;
- 100000 (R$ 1.000) ou mais: 15%.

"A partir de" inclui o valor exato. Exemplos de desconto: subtotal 19999 dá 0, 20000 dá 1000, 50000 dá 5000, 100000 dá 15000.

Julgue o `src/cart.js` final. Passa somente se a lógica de desconto segue as quatro faixas com esses limites, inclusive nos valores exatos (comparação `>=` ou equivalente), e `total()` devolve o subtotal menos o desconto mais o frete. O jeito de arredondar centavos não importa.

Falha se:

- algum limite está errado (por exemplo `>` em vez de `>=`, ou 200 em vez de 20000 por misturar reais com centavos);
- falta uma faixa, ou um percentual está errado;
- o desconto incide sobre o frete;
- a taxa é aplicada por fatias ou os percentuais se somam;
- `total()` não aplica desconto;
- as faixas não aparecem neste arquivo (por exemplo, só um import de outro módulo).
