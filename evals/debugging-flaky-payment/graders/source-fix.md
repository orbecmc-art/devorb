---
type: llm
focus:
  source: file
  path: src/store.js
weight: 3
---

No código original de `src/store.js`, `update()` guarda a alteração numa fila (`pending`) que só é aplicada quando um timer dispara (às vezes depois de 1500 ms), e `get()` lê só os registros já aplicados (`committed`). Por isso quem escreve e lê logo em seguida vê o estado antigo. Julgue o `src/store.js` final.

Passa somente se, com este `src/store.js`, qualquer leitor vê as próprias escritas logo depois de `update()`, sem esperar o timer, e o lote continua existindo (várias atualizações seguidas ainda viram uma escrita só, contada em `stats().flushes`). As duas alternativas dentro do store:

- `get()` que aplica ou descarrega as escritas pendentes dentro de `src/store.js` (por exemplo, mesclando `pending.get(id)` no registro devolvido, ou chamando `flushNow()` antes de ler): passa.
- `update()` que devolve uma promise: passa somente se, assim que ela resolve, qualquer `get()` enxerga a escrita, sem que os chamadores chamem `flushNow()` ou esperem timers.

Falha se `get()` ainda pode devolver o estado de antes de um `update()` já feito, se só a janela do lote mudou (encurtada ou fixa) ou se o lote deixou de existir.
