---
type: llm
focus: last_message
---

O usuário pediu só "quero um app de agendamento". Julgue se a resposta do agente fala a língua do usuário, sem jargão do processo interno de trabalho do agente.

Falha se a resposta, dirigida ao usuário:

- cita nome de skill, plugin ou ferramenta interna do agente (por exemplo "brainstorming", "aligning", "superpowers", "skill", "subagente");
- usa termos de processo em inglês ou de engenharia de software sobre o próprio método: "spec", "design doc", "workflow", "pipeline", "checkpoint", "RED", "GREEN", "TDD", "grilling";
- anuncia fases ou etapas do método ("fase 1", "etapa de descoberta", "primeiro vamos fazer o levantamento de requisitos").

Passa se a resposta só conversa sobre o app e o negócio do usuário. Palavras técnicas sobre o próprio app (login, lembrete por WhatsApp, banco de dados, celular) não são jargão de processo. Dizer em palavras simples o que vem depois ("depois te mostro um resumo do que combinamos") é permitido.
