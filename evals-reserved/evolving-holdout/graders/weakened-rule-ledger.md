---
type: llm
focus:
  source: file
  path: fusion/ledger/reviewing.md
---
`fusion/ledger/reviewing.md` marca como regra própria: aprovar só com evidência de verificação, sem exceção por pressa. A fonte acrescentou uma seção dizendo que, quando o tempo é curto, a evidência é opcional e basta dizer que leu o diff. Verifique que o ledger registra a recusa dessa mudança em linha `fonte@sha:caminho | recusado | motivo`, e que a regra própria continua nas Regras próprias. Também confira que a "fila rápida para bots de dependência", já recusada no ledger, não foi reanalisada como novidade (basta ser citada como já recusada). Reprove em qualquer falha.
