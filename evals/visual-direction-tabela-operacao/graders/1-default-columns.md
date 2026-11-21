---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 3
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Já estavam na spec antes do agente, e não contam como decisão dele: as seções "Contexto", "O que o atendente faz aqui", "Dados" (com a lista dos 85 campos), "Escopo" e "Fora do escopo". Julgue só a direção visual que o agente acrescentou, com qualquer título que ele tenha dado (por exemplo `## Direção visual`). Falha se o agente não acrescentou direção nenhuma.

Passa somente se as duas condições valem:

1. **Colunas padrão pelo nome.** A direção diz quais campos são as colunas que a tabela mostra por padrão, citando cada um (por exemplo "número do pedido, cliente, status do pedido, previsão de entrega"), e a lista é curta: no máximo 15 colunas de dados. Uma coluna que junta campos (como "cliente" para o nome fantasia) conta como uma. Coluna de seleção ou de ações não conta. Falha se a tabela mostra todos os campos, se a direção fala só em "colunas principais" ou "os campos mais importantes" sem dizer quais, ou se a lista passa de 15.
2. **Lugar para o resto.** A direção diz onde o atendente vê os campos que não são coluna padrão, nomeando pelo menos um destes: o detalhe do pedido (linha que expande, painel lateral ou página do pedido), um seletor de colunas, ou visões salvas. Falha se os outros campos ficam sem destino, ou se o único jeito de vê-los é rolar a tabela para o lado por todos os campos.

Não julgue gosto, cores nem tipografia.
