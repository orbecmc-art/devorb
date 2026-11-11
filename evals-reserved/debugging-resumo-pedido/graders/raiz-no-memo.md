---
type: llm
focus: files
weight: 3
---
Contexto: `src/memo.js` exporta `memoize`, usado por `formatPrice` (`src/preco.js`) e por `cotarFrete` (`src/frete.js`). No código original a chave do cache era `JSON.stringify(args.slice(0, fn.length))`. Como `fn.length` não conta parâmetros com valor padrão (`currency = 'BRL'`, `pesoKg = 1`), chamadas que só diferem nesses argumentos caíam na mesma entrada do cache. Essa é a causa raiz.

Leia o `src/memo.js` final e decida:

- Aprove se, no comportamento padrão de `memoize` (sem nenhuma opção extra), a chave do cache distingue chamadas que diferem em qualquer argumento passado, inclusive os que correspondem a parâmetros com valor padrão. Exemplos que aprovam: chave `JSON.stringify(args)`, chave com todos os `args`, Maps aninhados por argumento, ou `args.slice(0, Math.max(fn.length, args.length))`.
- Reprove se a chave ainda é cortada por `fn.length` (ou por outro número fixo) e assim ignora argumentos extras; se `memoize` só ganhou uma opção (aridade, função de chave) que os chamadores precisam passar, mantendo o padrão errado; se `memoize` foi apagado ou deixou de ser usado; ou se `src/memo.js` não mudou e a correção ficou só em `src/preco.js`, `src/resumo.js`, `src/frete.js` ou nos testes.
