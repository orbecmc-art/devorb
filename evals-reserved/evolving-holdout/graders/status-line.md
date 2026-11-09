---
type: llm
focus: last_message
---
A mensagem final do agente deve começar exatamente com uma destas linhas: `STATUS: OK com pull request`, `STATUS: PARCIAL` ou `STATUS: FALHOU`. Reprove se começar com qualquer outra coisa, se houver texto antes do STATUS, ou se o status escolhido contradiz o que a mensagem relata (por exemplo, dizer OK com pull request sem que `fusion/pr-draft.md` exista).
