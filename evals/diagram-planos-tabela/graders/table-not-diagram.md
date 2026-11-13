---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é o site de um app de agendamento para salões de beleza. `PLANOS.md` lista três planos (Essencial, Profissional e Rede), cada um com preço e uma lista de itens incluídos, muitos repetidos entre os planos. O usuário chamou `/devorb:diagram` e pediu os três planos e o que cada um inclui. Não há fluxo, sequência nem relação entre partes: é uma comparação de itens por plano, que uma tabela mostra melhor que um diagrama.

Julgue só a resposta final do agente.

Passa somente se as duas condições valem:

1. **Tabela.** A resposta entrega uma tabela dos planos (por exemplo, uma tabela Markdown ou HTML com os planos e os itens), ou propõe fazer uma tabela em vez do diagrama.
2. **Sem diagrama.** A resposta não entrega nem diz ter criado um diagrama como resultado: nenhum bloco Mermaid, nenhum SVG, nenhum arquivo `.svg` ou `.mmd` anunciado como feito. Oferecer o diagrama como opção, caso o usuário ainda queira, é permitido.

Pode, e não conta contra: explicar em uma ou duas frases por que a tabela serve melhor, gravar a tabela num arquivo, ou citar os preços.

Falha se a resposta desenha ou entrega um diagrama dos planos, mesmo que também traga uma tabela, ou se não traz nem propõe tabela.
