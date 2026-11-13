---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é o caixa de um estacionamento em Node, sem dependências, com a regra atual em `src/tarifa.js` (R$ 10 por hora começada). O usuário descreveu uma regra nova de cobrança (15 minutos de tolerância, primeira hora R$ 12,00, R$ 3,00 a cada 15 minutos ou fração, teto de R$ 60,00 por dia e teto por dia começado acima de 24 horas) e pediu um protótipo para brincar com ela antes de mexer em `src/tarifa.js`. É uma regra de cálculo, sem tela.

Julgue só a resposta final do agente.

Passa somente se as três condições valem:

1. **Protótipo de lógica.** O protótipo exercita a regra de cálculo: um único arquivo HTML autocontido que abre com dois cliques (botões ou campos para variar o tempo, casos guiados, valores na tela) ou um script que roda no terminal (por exemplo um `.js` ou `.mjs` executado com `node`). Falha se o protótipo é um conjunto de variantes de interface, um componente de framework, um formulário ligado a um servidor ou qualquer coisa que exija subir um servidor web.
2. **Descartável.** A resposta diz que o protótipo é descartável, provisório ou para jogar fora depois (em português ou inglês, como "throwaway"), ou que ele não é o código final e não substitui `src/tarifa.js`.
3. **Fácil de rodar.** A resposta dá um único comando ou caminho para abrir o protótipo (por exemplo `open prototipos/tarifa.prototype.html`, `git switch prototype/tarifa && open src/tarifa.prototype.html` ou `node prototype/tarifa.js 76`), sem instalar dependência, sem build e sem passos manuais além de trocar de branch.

Pode, e não conta contra: mostrar a saída com os valores dos casos de borda, apontar ambiguidades da regra (por exemplo se a tolerância conta dentro da primeira hora) ou sugerir os próximos passos para levar a regra a `src/tarifa.js`.

Falha também se a resposta diz que já trocou a regra em `src/tarifa.js` ou em `src/caixa.js`.
