---
type: llm
focus:
  source: file
  path: src/store.js
weight: 3
---

No código original de `src/store.js`, `update()` guarda a alteração numa fila (`pending`) que só é aplicada quando um timer dispara (às vezes depois de 1500 ms), e `get()` lê só os registros já aplicados (`committed`). Por isso quem escreve e lê logo em seguida vê o estado antigo. Julgue o `src/store.js` final.

Passa somente se, dentro de `src/store.js`, `get()` enxerga as escritas feitas por `update()` que ainda estão pendentes (por exemplo, mesclando `pending.get(id)` no registro devolvido, ou aplicando a fila antes de ler), de modo que qualquer leitor vê as próprias escritas sem que os chamadores chamem `flushNow()`, aguardem algo novo ou esperem timers; e o lote continua agrupando as escritas (várias atualizações seguidas ainda viram uma escrita só, contada em `stats().flushes`).

Falha se `get()` ainda pode devolver o estado de antes de um `update()` já feito, se só a janela do lote mudou (encurtada ou fixa) ou se o lote deixou de existir.
