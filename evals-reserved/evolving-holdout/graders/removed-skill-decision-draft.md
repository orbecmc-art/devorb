---
type: llm
focus:
  source: file
  path: fusion/pr-draft.md
---
Na fonte, a skill `risk-notes` foi apagada e a pasta `wrap-up-branch` foi renomeada (o diff mostra os arquivos dela como removidos e os caminhos acompanhados como ausentes). Verifique que `fusion/pr-draft.md` apresenta isso ao dono como uma decisão a tomar (por exemplo: manter o texto próprio já fundido, acompanhar o novo caminho `branch-closeout`, ou aposentar a skill), e não como algo resolvido sozinho. A skill candidata nova `flaky-test-hunt` deve aparecer como candidata para decisão do dono. Reprove se o rascunho nem menciona a remoção e o renome, se os apresenta como já resolvidos, ou se não apresenta `flaky-test-hunt` como candidata.
