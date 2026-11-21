---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 1
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Já estavam na spec antes do agente, e não contam como decisão dele: as seções "Contexto", "O que o atendente faz aqui", "Dados" (com a lista dos 85 campos), "Escopo" e "Fora do escopo". Julgue só a direção visual que o agente acrescentou, com qualquer título que ele tenha dado (por exemplo `## Direção visual`). Falha se o agente não acrescentou direção nenhuma.

Passa somente se a direção diz por quais campos a busca procura, citando pelo menos dois (por exemplo número do pedido, nome da oficina ou cliente, CNPJ, número da NF, placa). Nomes do dia a dia valem: "oficina" ou "cliente" contam como o nome do cliente. Falha se a direção só diz que há uma busca, se a busca procura "em tudo" ou em todos os 85 campos, ou se a busca não aparece.

Não julgue gosto, cores nem tipografia.
