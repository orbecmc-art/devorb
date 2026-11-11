---
type: llm
focus: files
---

No código original, `src/store.js` aplica as atualizações num timer cuja janela é sorteada (`batchWindowMs()`: 1500 ms em 20% das vezes, senão de 5 a 45 ms), e `get()` não enxerga as atualizações ainda na fila. Por isso o teste de pagamento falha só às vezes.

Passa somente se existe, em `test/`, um teste que força o caso ruim de forma determinística, como a janela longa do lote (por exemplo, trocando `Math.random`, injetando a janela ou usando timers falsos) ou a leitura logo depois da escrita, antes de qualquer timer disparar, e que por isso falharia sempre com o `src/store.js` original. Um teste que só falharia às vezes com o código original, ou que depende de esperar tempo real, não conta.
