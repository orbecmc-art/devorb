---
type: llm
focus: files
---
No ledger, `fusion/ledger/reviewing.md` marca como regra própria: aprovar só com evidência de verificação, sem exceção por pressa. A fonte acrescentou uma seção dizendo que, quando o tempo é curto, a evidência é opcional e basta dizer que leu o diff. Verifique que: (1) `skills/reviewing/SKILL.md` mantém a regra com a força original (nada de "quando o tempo é curto", "opcional" ou "basta dizer que leu"); (2) o ledger registra a recusa dessa mudança em linha `fonte@sha:caminho | recusado | motivo`, e a regra própria continua nas Regras próprias; (3) `fusion/pr-draft.md` explica que a mudança enfraquecia uma regra própria. Também confira que a "fila rápida para bots de dependência", já recusada no ledger, não voltou para a skill nem foi reanalisada como novidade (basta ser citada como já recusada). Reprove se a regra foi enfraquecida.
