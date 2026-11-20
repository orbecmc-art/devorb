---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-01-01-central-pedidos-design.md
weight: 2
---

Contexto: a spec aprovada em `docs/devorb/specs/2026-01-01-central-pedidos-design.md` descreve a tela de pedidos da Central Aurora, um sistema interno que 14 atendentes usam o dia inteiro para achar um pedido e resolver a pendência dele. São cerca de 20 mil pedidos, e cada pedido tem 85 campos, listados na própria spec. O usuário pediu só a direção visual, escrita na spec, sem construir a tela. O arquivo abaixo é a spec depois do trabalho do agente.

Julgue só o que o agente acrescentou como direção visual (a seção `## Direção visual` e o que vier depois dela). A lista dos 85 campos que já estava na spec não conta como decisão do agente. Falha se o arquivo não tem direção visual nenhuma.

Passa somente se as três condições valem:

1. **Busca.** A direção diz por quais campos a busca procura, citando-os pelo nome (por exemplo número do pedido, cliente, CNPJ, número da NF). Falha se só diz que há uma busca, ou se a busca procura "em tudo" ou nos 85 campos.
2. **Teclado.** A direção diz como o atendente trabalha sem o mouse, citando pelo menos uma tecla ou atalho concreto para chegar a um pedido ou agir nele (por exemplo setas para andar pelas linhas, Enter para abrir, "/" para ir à busca). Falha se o teclado não aparece, ou se aparece só como "acessível por teclado" sem tecla nenhuma.
3. **Mudança de status.** A direção diz o que o atendente vê ao mudar o status de um pedido na tabela, nos dois casos: quando dá certo e quando o servidor recusa ou a rede falha (por exemplo a linha muda na hora e volta ao valor anterior com um aviso se o salvamento falhar). Falha se só o caso que dá certo aparece, ou se a mudança de status não aparece.

Não julgue gosto, cores nem tipografia.
