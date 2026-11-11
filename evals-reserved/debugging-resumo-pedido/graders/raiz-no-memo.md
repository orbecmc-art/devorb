---
type: llm
focus:
  source: file
  path: src/memo.js
weight: 3
---
Contexto: `src/memo.js` exporta `memoize`, usado por `formatPrice` (`src/preco.js`) e por `cotarFrete` (`src/frete.js`). No código original a chave do cache era `JSON.stringify(args.slice(0, fn.length))`. Como `fn.length` não conta parâmetros com valor padrão (`currency = 'BRL'`, `pesoKg = 1`), chamadas que só diferem nesses argumentos caíam na mesma entrada do cache. Essa é a causa raiz.

Julgue o `src/memo.js` final:

- Aprove se, no comportamento padrão de `memoize` (sem nenhuma opção extra), chamadas que diferem num argumento de parâmetro com valor padrão (ou de `...resto`) ganham chaves diferentes. Exemplos que aprovam: chave `JSON.stringify(args)`, chave com todos os `args`, Maps aninhados por argumento, `args.slice(0, Math.max(fn.length, args.length))`, ou uma contagem de parâmetros que inclui os que têm valor padrão (nenhum chamador atual usa `...resto`).
- Reprove se a chave ainda é cortada por `fn.length` e assim ignora argumentos de parâmetros com valor padrão; se `memoize` só ganhou uma opção (aridade, função de chave) que os chamadores precisam passar, mantendo o padrão errado; se `memoize` foi apagado; ou se a chave continua igual à original (a correção ficou só em `src/preco.js`, `src/resumo.js`, `src/frete.js` ou nos testes).
