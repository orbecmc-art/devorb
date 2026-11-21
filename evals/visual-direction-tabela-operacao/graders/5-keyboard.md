---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 1
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Já estavam na spec antes do agente, e não contam como decisão dele: as seções "Contexto", "O que o atendente faz aqui", "Dados" (com a lista dos 85 campos), "Escopo" e "Fora do escopo". Julgue só a direção visual que o agente acrescentou, com qualquer título que ele tenha dado (por exemplo `## Direção visual`). Falha se o agente não acrescentou direção nenhuma.

Passa somente se a direção diz como o atendente trabalha sem o mouse, citando pelo menos uma tecla ou atalho concreto para chegar a um pedido ou agir nele (por exemplo setas para andar pelas linhas, Enter para abrir o pedido, "/" para ir à busca). Falha se o teclado não aparece, ou se aparece só como "acessível por teclado" ou "navegável por teclado" sem tecla nenhuma.

Não julgue gosto, cores nem tipografia.
