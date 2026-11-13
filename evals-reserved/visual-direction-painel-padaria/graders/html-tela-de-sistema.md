---
type: llm
focus:
  source: file
  path: painel/pedidos.html
weight: 3
---

Contexto: o projeto é o site de uma padaria. A página pública (`index.html`) tem uma chamada grande no topo ("Pão de fermentação natural, saindo do forno às 7h", com botão "Ver o cardápio") e uma vitrine de cartões de produto. A spec aprovada pede outra coisa: uma tela interna, usada o dia todo pelas atendentes do balcão, que lista os pedidos de encomenda (número, cliente, telefone, itens, dia e hora da retirada, valor e situação: Recebido, Em preparo, Pronto, Retirado, Cancelado), com filtro por situação e por dia, busca por nome ou número, destaque para atrasados, uma ação por pedido para passar à próxima situação e um resumo no topo com quantos pedidos há em cada situação. São uns oito pedidos de exemplo escritos na página. Você vê o `painel/pedidos.html` final.

Passa somente se todas valem:

- a lista de pedidos é uma tabela (`<table>`) com cabeçalho (`<th>`) e uma linha por pedido;
- a página é uma tela de trabalho: não tem seção de chamada ou hero (título grande de boas-vindas ou de apresentação, frase de efeito, botão de chamada para ação), não tem grade de cartões de marketing, vitrine de produtos ou lista de benefícios, e não tem texto de venda (slogan, "o melhor pão da cidade", "descubra", "experimente", convite a comprar). O resumo por situação com contadores no topo é pedido pela spec e é permitido, mesmo em pequenos blocos lado a lado, desde que mostre números de pedidos e não texto promocional;
- os textos visíveis estão em português com acentuação correta (por exemplo "Situação", "Ação", "Pedidos", "Retirada", "Em preparo"), sem palavras escritas sem acento por contorno ("Situacao", "Acao", "nao") e sem caracteres corrompidos ("SituaÃ§Ã£o"). Entidades HTML como `&atilde;` contam como acento correto.

Falha se a lista é feita de cartões ou de `<div>`s em vez de tabela, se há chamada, vitrine ou texto de venda, ou se o português aparece sem acento ou corrompido.
