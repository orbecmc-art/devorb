---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 2
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Já estavam na spec antes do agente, e não contam como decisão dele: as seções "Contexto", "O que o atendente faz aqui", "Dados" (com a lista dos 85 campos), "Escopo" e "Fora do escopo". Julgue só a direção visual que o agente acrescentou, com qualquer título que ele tenha dado (por exemplo `## Direção visual`). Falha se o agente não acrescentou direção nenhuma.

Passa somente se a direção cobre os três estados da tabela de pedidos:

1. **Carregando.** Diz o que aparece enquanto os pedidos carregam (por exemplo linhas de esqueleto no formato da tabela, ou a lista anterior esmaecida). Falha se só diz "mostra carregando" sem dizer o que se vê, ou se não fala disso.
2. **Vazio de busca ou filtro.** Diz o que aparece quando uma busca ou um filtro não acha nenhum pedido, e dá uma saída ao atendente (por exemplo limpar a busca ou o filtro). Falha se o único vazio descrito é o de um sistema sem nenhum pedido cadastrado, ou se não há saída.
3. **Erro.** Diz o que aparece quando os pedidos não carregam, e dá uma saída ao atendente (por exemplo tentar de novo). Falha se não fala disso, ou se cita o erro sem saída nenhuma.

Não julgue gosto, cores nem tipografia.
