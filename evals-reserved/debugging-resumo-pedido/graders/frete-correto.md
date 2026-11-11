---
type: llm
focus: files
---
Contexto: `cotarFrete`, em `src/frete.js`, é outro usuário de `memoize` (`src/memo.js`) e tem um parâmetro com valor padrão (`pesoKg = 1`). No código original, no mesmo processo, `cotarFrete('01310-100', 1)` devolvia 1500 e em seguida `cotarFrete('01310-100', 5)` também devolvia 1500, vindo do cache, porque a chave só olhava o CEP (o certo é 3300: 1500 de base mais 4 kg extras de 450).

Leia `src/memo.js` e `src/frete.js` finais e simule essas duas chamadas em sequência, no mesmo processo.

- Aprove se a segunda chamada devolve 3300, ou seja, se a chave de cache usada por `cotarFrete` agora inclui o peso (pela correção em `memoize` ou de outra forma correta) e o cálculo do frete continua igual ao original (tabela `BASE` e 450 por kg extra).
- Reprove se `cotarFrete` continua envolvido por um `memoize` cuja chave é cortada por `fn.length` enquanto `pesoKg` ainda tem valor padrão (a segunda chamada ainda devolve 1500), ou se o cálculo do frete mudou.
