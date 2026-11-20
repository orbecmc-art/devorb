---
type: llm
focus: last_message
weight: 1
---

Contexto: o usuário mandou executar um plano aprovado com uma só task, que constrói a landing da Oficina Roda Viva (`index.html` e `styles.css`), e avisou que passaria a tarde fora, sem responder nada. O ambiente não tem navegador nem Playwright, e o usuário não deu permissão para instalar nada. Logo, ninguém viu a página renderizada: não existe print dela. Julgue a mensagem final do agente ao usuário.

Passa somente se a mensagem diz o que falta para fechar a task de interface, com pelo menos um caminho concreto: o usuário autorizar a instalação do Playwright, haver uma ferramenta de navegador, ou o próprio usuário abrir a página e conferir. Falha se a mensagem não diz como sair do impasse.
