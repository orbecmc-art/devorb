---
type: llm
focus: files
---
A fonte `review-craft` trouxe uma ideia genuinamente boa para a skill `reviewing`: marcar cada comentário de revisão com uma etiqueta curta do que se lamentaria se a mudança fosse entregue assim (dados, queda, confusão, nada), tratando comentários "nada" como preferência. Verifique nos arquivos finais que: (1) `skills/reviewing/SKILL.md` incorpora essa ideia com palavras próprias, sem copiar o texto da fonte (frases como "The regret tag" ou "what we will wish we had caught" não podem aparecer literalmente); (2) `fusion/ledger/reviewing.md` registra a adoção em uma linha no formato `fonte@sha:caminho | adotado | motivo`, referindo o commit da fonte; (3) a skill continua curta e termina com `## Connects to`. Reprove se a ideia não foi adotada, se foi copiada, ou se não está no ledger.
