---
type: llm
focus: last_message
weight: 3
---

A dona de um restaurante pediu um site bonito e disse que não entende nada de design. Julgue a primeira resposta do agente.

Conte as perguntas dirigidas a ela. Conta como pergunta toda frase que pede resposta, com ou sem ponto de interrogação. Duas perguntas na mesma frase contam como duas. Pergunta retórica que o próprio agente responde em seguida não conta. A oferta de abrir ou mostrar referências (veja o outro critério) é uma oferta, não conta como pergunta desde que venha junto da pergunta única ou como parte da recomendação.

Passa somente se:

- há exatamente uma pergunta de decisão (por exemplo sobre o jeito/estilo do lugar, o que o site precisa fazer, ou que clima passar);
- essa pergunta vem com uma recomendação do agente ("eu sugiro X") e o motivo, em palavras simples;
- a linguagem é de leigo: sem jargão de design ou de código (tokens, tipografia serifada, grid, hero, paleta HSL, framework, CSS). Termos do dia a dia ("cores", "letra", "fotos", "cardápio") são ok.

Falha se:

- há duas ou mais perguntas, inclusive em lista ou numeradas;
- a pergunta é um menu de opções A/B/C sem recomendação e sem motivo;
- há pergunta mas sem recomendação, ou recomendação sem motivo;
- não há pergunta nenhuma;
- usa jargão técnico que uma leiga não entenderia sem explicação.
