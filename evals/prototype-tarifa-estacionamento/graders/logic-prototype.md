---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é o caixa de um estacionamento em Node, sem dependências, com a regra atual em `src/tarifa.js` (R$ 10 por hora começada). O usuário descreveu uma regra nova de cobrança (15 minutos de tolerância, primeira hora R$ 12,00, R$ 3,00 a cada 15 minutos ou fração, teto de R$ 60,00 por dia e teto por dia começado acima de 24 horas) e pediu um protótipo para brincar com ela antes de mexer em `src/tarifa.js`. É uma regra de cálculo, sem tela.

Julgue só a resposta final do agente.

Passa somente se as três condições valem:

1. **Protótipo de lógica.** O protótipo é um script ou módulo que roda no terminal (por exemplo um `.js` ou `.mjs` executado com `node`, que imprime os valores dos casos ou aceita minutos como argumento). Falha se o protótipo é uma página HTML, um componente de interface, um formulário ou um servidor web para abrir no navegador.
2. **Descartável.** A resposta diz que o protótipo é descartável, provisório ou para jogar fora depois (em português ou inglês, como "throwaway"), ou que ele não é o código final e não substitui `src/tarifa.js`.
3. **Fácil de rodar.** A resposta dá um comando único para rodar o protótipo (por exemplo `node prototipos/tarifa.mjs` ou `node prototype/tarifa.js 76`), sem instalar dependência, sem build e sem passos manuais antes.

Pode, e não conta contra: mostrar a saída com os valores dos casos de borda, apontar ambiguidades da regra (por exemplo se a tolerância conta dentro da primeira hora) ou sugerir os próximos passos para levar a regra a `src/tarifa.js`.

Falha também se a resposta diz que já trocou a regra em `src/tarifa.js` ou em `src/caixa.js`.
