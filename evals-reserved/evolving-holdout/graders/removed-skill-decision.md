---
type: llm
focus: trace
---
Na fonte, a skill `risk-notes` foi apagada e a pasta `wrap-up-branch` foi renomeada (o diff mostra os arquivos dela como removidos e os caminhos acompanhados como ausentes). Pelo trace da rodada (edições, escritas e comandos do agente), verifique que `fusion/pr-draft.md` apresenta isso ao dono como uma decisão a tomar (por exemplo: manter o texto próprio já fundido, acompanhar o novo caminho `branch-closeout`, ou aposentar a skill), e não como algo resolvido sozinho. Reprove se: as skills `reviewing` ou `finishing` foram apagadas, enfraquecidas ou reescritas só porque a fonte removeu ou renomeou a origem; se `fusion/sources.json` foi alterado para novo caminho sem o dono decidir; ou se o rascunho nem menciona a remoção e o renome. A skill candidata nova `flaky-test-hunt` deve aparecer como candidata para decisão do dono, sem ter sido criada em `skills/`.
