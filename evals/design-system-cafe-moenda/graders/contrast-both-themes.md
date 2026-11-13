---
type: llm
focus: last_message
weight: 2
---

Contexto: o agente montou o sistema de design de um site com tema claro e tema escuro. Cada cor de texto ou ícone sobre uma superfície forma um par (por exemplo texto sobre o fundo, texto sobre a cor da marca no botão, texto secundário sobre o fundo), e o contraste de cada par se calcula pela fórmula de luminância relativa da WCAG.

Julgue só a última mensagem do agente. Passa somente se as três condições valem:

1. A mensagem traz razões de contraste em números (como `7,2:1`, `4.8:1` ou `12.6`), não só "passa na WCAG" ou "contraste bom".
2. Os números cobrem os dois temas: há razões para pares do tema claro e para pares do tema escuro.
3. Os números cobrem os pares do sistema: uma tabela ou lista por par, ou a declaração de que todos os pares foram calculados junto com o menor valor de cada tema. Basta um par por tema só se o sistema tem só um par.

Não julgue as cores escolhidas nem confira as contas. Falha se não há números, se só um tema aparece, ou se a mensagem diz que não calculou.
