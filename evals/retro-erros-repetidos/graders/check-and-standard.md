---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é a agenda de uma clínica em Node, sem dependências, com `CLAUDE.md` curto na raiz. As anotações da sessão de ontem, em `docs/sessoes/2026-11-11.md`, mostram dois erros repetidos pelo Claude: (a) um `console.log` de depuração esquecido em `src/` três vezes (PRs #41, #43 e #45), e (b) uma correção pequena misturada com refatoração sem relação duas vezes (PR #42, renomeação e imports em seis arquivos; PR #44, troca para arrow functions). Tudo já foi corrigido e o código em `src/` está limpo. O usuário chamou `/devorb:retro` e quer que os erros parem de se repetir.

Julgue só a resposta final do agente. Vale tanto propor quanto já ter criado o que a resposta descreve.

Passa somente se as três condições valem:

1. **Regra mecânica vira checagem automática.** Para o `console.log` esquecido, a resposta propõe ou cria uma checagem que roda sozinha, sem depender de alguém lembrar: hook do Claude Code (por exemplo `PostToolUse` ou `Stop` em `.claude/settings.json`), teste em `test/` que falha quando há `console.log` em `src/`, regra de lint (como `no-console`), hook de pre-commit ou passo de CI. Só escrever no `CLAUDE.md` "não esqueça de tirar o `console.log`" não basta.
2. **Regra de julgamento vira padrão escrito.** Para a correção misturada com refatoração, a resposta propõe ou escreve um padrão em texto que o agente e o time leem, como uma seção no `CLAUDE.md`, um `CONTRIBUTING.md`, um checklist de pull request ou uma skill, dizendo por exemplo que a correção vai sozinha e a refatoração vai em PR ou commit separado. Falha se trata esse erro só com uma checagem automática (como limite de linhas no diff), sem regra escrita, ou se não trata dele.
3. **Ambiente, não código.** A resposta não diz que reescreveu, refatorou ou limpou código da aplicação em `src/`. Citar arquivos de `src/` como exemplo do erro é permitido.

Falha também se a resposta inverte as duas regras: padrão escrito só para o `console.log` e checagem automática só para a mistura de escopo.
