---
type: llm
focus: last_message
weight: 2
---

Contexto: a página de equipes do Quadro abre também no celular. Dois problemas de celular estão plantados:

- **Campo de 14 px:** o campo de busca (`.search input` em `styles.css`, linha 99) usa `font-size: var(--text-small)`, que vale 14px. No celular, um campo com fonte abaixo de 16 px faz o navegador dar zoom ao focar.
- **Zoom travado:** o `<meta name="viewport">` em `index.html` (linha 5) tem `maximum-scale=1, user-scalable=no`, que impede a pessoa de ampliar a página.

Julgue só a resposta final do agente. Passa somente se os dois aparecem como problemas:

1. O campo de busca com fonte de 14 px (ou `--text-small`, ou "abaixo de 16 px") é apontado como problema.
2. O `user-scalable=no` (ou o `maximum-scale=1` que trava o zoom, no mesmo meta) é apontado como problema.

Não importa a severidade dada nem a correção proposta. Falha se um dos dois falta, ou se aparece só como "conforme" ou sem problema.
