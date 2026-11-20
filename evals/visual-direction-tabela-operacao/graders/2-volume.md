---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 2
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos, listados na própria spec. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Julgue só o que o agente acrescentou como direção visual (a seção `## Direção visual` e o que vier depois dela). A lista dos 85 campos que já estava na spec não conta como decisão do agente. Falha se o arquivo não tem direção visual nenhuma.

Passa somente se a direção diz como os cerca de 20 mil pedidos chegam à tela, como uma decisão: paginação (páginas, com ou sem tamanho de página) ou lista virtualizada (só as linhas visíveis são desenhadas; rolagem infinita com janela também vale). Falha se a direção não fala do volume, se só repete que são 20 mil pedidos sem dizer como aparecem, ou se dá a entender que a tabela carrega e desenha todos os pedidos de uma vez.

Não julgue gosto, cores nem tipografia.
