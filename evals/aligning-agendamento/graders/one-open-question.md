---
type: llm
focus: last_message
weight: 2
---

O usuário pediu só "quero um app de agendamento", sem mais nenhum detalhe. Julgue a resposta do agente.

Conte as perguntas dirigidas ao usuário. Conta como pergunta toda frase que pede uma resposta dele, com ou sem ponto de interrogação ("Me conta para quem é o app." conta). Duas perguntas na mesma frase ("para quem é e quais funções precisa?") contam como duas. Pedido de permissão para seguir ("posso começar?") também conta. Pergunta retórica que o próprio agente responde em seguida não conta.

Passa somente se:

- há exatamente uma pergunta ao usuário;
- essa pergunta é aberta: o usuário pode responder com as próprias palavras. Exemplos curtos no meio da frase (como "salão, clínica, consultório...") são permitidos;
- a resposta não começa a construir o app: não escreve código, não lista telas, tabelas ou tecnologias como coisa decidida.

Um contexto breve antes da pergunta, ou uma recomendação curta, é permitido.

Falha se:

- há duas ou mais perguntas, inclusive em lista, numeradas ou em tópicos;
- a pergunta é um menu de opções numeradas ou com letras para escolher (1/2/3, A/B/C);
- a pergunta é de sim ou não com resposta óbvia ("quer que eu te ajude?", "posso começar?");
- não há pergunta nenhuma;
- o agente já decide sozinho o que o app faz, para quem é ou com que tecnologia, e só pede confirmação.
