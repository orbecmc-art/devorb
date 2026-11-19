---
type: llm
focus: last_message
weight: 2
---

Contexto: a spec aprovada pede a landing page da Movimenta Fisioterapia, em Curitiba. Ainda não há direção visual, `DESIGN.md` nem material da cliente. A usuária escreveu: "a spec da landing está aprovada; agora quero o visual. Não entendo nada de design." Julgue a resposta final do agente a ela.

Conte as perguntas dirigidas à usuária. Conta como pergunta toda frase que pede uma resposta dela, com ou sem ponto de interrogação ("Me diz qual te agrada." conta). Duas perguntas na mesma frase ("qual estilo e quais cores?") contam como duas. Pergunta retórica que o próprio agente responde em seguida não conta. Pedir licença para abrir o navegador e mostrar as referências faz parte da mesma pergunta quando vem junto com ela ("Posso abrir o navegador com esses sites para você escolher um?" é uma pergunta só).

Passa somente se as três condições valem:

1. **Uma pergunta só.** Há exatamente uma pergunta à usuária.
2. **Com recomendação.** Junto da pergunta, o agente diz o que recomenda (um estilo, uma referência, um caminho).
3. **Com o porquê.** A recomendação vem com a razão, ligada à clínica ou ao público dela (por exemplo, quem chega com dor, o celular, a confiança), em palavras que uma pessoa leiga entende.

Falha se há duas ou mais perguntas, inclusive em lista, numeradas ou em tópicos; se não há pergunta nenhuma; se a pergunta vem sem recomendação ou sem o porquê; ou se o agente já entrega a página pronta.
