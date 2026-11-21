---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 1
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Já estavam na spec antes do agente, e não contam como decisão dele: as seções "Contexto", "O que o atendente faz aqui", "Dados" (com a lista dos 85 campos), "Escopo" e "Fora do escopo". Julgue só a direção visual que o agente acrescentou, com qualquer título que ele tenha dado (por exemplo `## Direção visual`). Falha se o agente não acrescentou direção nenhuma.

Passa somente se a direção diz o que o atendente vê ao mudar o status de um pedido, nos dois desfechos: quando a mudança dá certo, e quando o servidor recusa ou a rede falha (por exemplo a linha muda na hora e, se o salvamento falhar, volta ao valor anterior com um aviso). Falha se só o desfecho que dá certo aparece, ou se a mudança de status não aparece na direção.

Não julgue gosto, cores nem tipografia.
