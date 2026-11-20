---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 2
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Já estavam na spec antes do agente, e não contam como decisão dele: as seções "Contexto", "O que o atendente faz aqui", "Dados" (com a lista dos 85 campos), "Escopo" e "Fora do escopo". Julgue só a direção visual que o agente acrescentou, com qualquer título que ele tenha dado (por exemplo `## Direção visual`). Falha se o agente não acrescentou direção nenhuma.

Passa somente se a direção decide como os cerca de 20 mil pedidos chegam à tela, com um mecanismo que limita o que é carregado ou desenhado de cada vez: paginação (por página ou por cursor), "carregar mais", ou lista virtualizada (só as linhas visíveis são desenhadas). Falha se a direção não fala do volume, se só repete que são 20 mil pedidos sem dizer como aparecem, ou se dá a entender que a tabela carrega e desenha todos os pedidos de uma vez.

Não julgue gosto, cores nem tipografia.
