---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 2
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos, listados na própria spec. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Julgue só o que o agente acrescentou como direção visual (a seção `## Direção visual` e o que vier depois dela). A lista dos 85 campos que já estava na spec não conta como decisão do agente. Falha se o arquivo não tem direção visual nenhuma.

Passa somente se a direção cobre os três estados da tabela de pedidos, dizendo em cada um o que o atendente vê:

1. **Carregando.** O que aparece enquanto os pedidos carregam (por exemplo linhas de esqueleto no formato da tabela, ou a tabela anterior esmaecida). Falha se só diz "mostra carregando" sem dizer o que se vê, ou se não fala disso.
2. **Vazio.** O que aparece quando uma busca ou um filtro não acha nenhum pedido, com a saída para o atendente (por exemplo limpar a busca ou o filtro). Falha se o único vazio descrito é o de um sistema sem nenhum pedido cadastrado, ou se não há saída.
3. **Erro.** O que aparece quando os pedidos não carregam, com o que o atendente pode fazer (por exemplo tentar de novo). Falha se não fala disso.

Não julgue gosto, cores nem tipografia.
