---
type: llm
focus: files
weight: 3
---

No código original, `update()` de `src/store.js` guarda a alteração numa fila (`pending`) que só é aplicada quando um timer dispara (às vezes depois de 1500 ms), e `get()` lê só os registros já aplicados (`committed`). Por isso quem escreve e lê logo em seguida vê o estado antigo.

Passa somente se a correção está em `src/store.js` e, com ela, qualquer leitor vê as próprias escritas logo depois de `update()`, sem esperar o timer: por exemplo, `get()` passa a considerar a fila pendente. O lote precisa continuar existindo (várias atualizações seguidas ainda viram uma escrita só, como `test/store.test.js` verifica).

Falha se o conserto é chamar `flushNow()` nos chamadores (`src/payments.js`, `src/refunds.js` ou nos testes), aumentar ou trocar esperas, encurtar ou fixar a janela do lote sem fazer o leitor ver a fila, ou se `src/store.js` continua com `get()` lendo só os registros aplicados.
