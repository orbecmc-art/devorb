# Ledger: `using-devorb`

Skill de entrada, injetada pelo hook de início de sessão. Foi escrita na Task 3, sem passar pelo processo de fusão, fundindo `using-superpowers` (Superpowers) com `ask-matt` (Matt Pocock), e este ledger a registra na Task 6. Pinos lidos: Superpowers em `22f0b463e7a5e579904dd6211a520321035526f7`, igual à `main` dele em 2026-11-11, e Matt em `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`.

`SKILL.md` tem 3.498 bytes (eram 3.499 antes da regra própria 5), contra o limite de 3.500 do teste de bootstrap (teto de 875 tokens). Qualquer acréscimo precisa tirar algo. São 307 bytes acima da fonte, cerca de 77 tokens a mais por sessão, e a Task 6 mede se isso se paga.

Os casos da skill são `evals/using-devorb-triggers-feature` ("adiciona exportação em CSV" dispara `devorb:aligning`), `evals/using-devorb-triggers-bug` ("esse teste está falhando" dispara `devorb:debugging`) e `evals/using-devorb-legacy-names` ("usa o superpowers:brainstorming para isso" dispara `devorb:aligning`).

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers, encurtada para "Use when starting any conversation" no commit `742a020` |
| `SUBAGENT-STOP` | Superpowers |
| Bloco `EXTREMELY-IMPORTANT` e a regra do 1% | Superpowers, condensado |
| A regra: invocar antes de qualquer resposta, anunciar e criar um item por passo da lista | Superpowers |
| Antes do plan mode, `devorb:aligning` | Superpowers (era o `brainstorming`) |
| Precedência em três níveis | Superpowers ("User Instructions") e decisão da Task 3 |
| Pular um passo só quando o nível 1 manda explicitamente | Superpowers |
| Skills de domínio depois da skill de processo | Superpowers ("Skill Priority") |
| Trabalho novo entra por `devorb:aligning`, bug por `devorb:debugging` | Superpowers ("Let's build X" e "Fix this bug") e decisão da Task 3 |
| Fluxo `aligning` até `finishing` e tabela de etapas | Matt (`ask-matt`, fluxo principal) e spec |
| Ler a skill antes de descrevê-la ou de pulá-la | Matt (`ask-matt`) |
| Invocar pelo nome mesmo fora da lista de skills | Regra própria 2 |
| Linha `devorb:browser-testing` | Plano, Task 23 (commits `742a020` e `7af9f5e`) |
| Skills manuais: sugerir, nunca começar | Spec e decisão da Task 3 |
| Sinais de alerta | Superpowers (12 linhas viraram 8) |
| Sinal de alerta "It's urgent" ou "tests later", com `devorb:tdd` primeiro em mudança de código | Regra própria 5 |
| Pegar o caminho das referências invocando a skill | Regra própria 3 |
| `references/legacy-names.md` | Regra própria 1 |
| `references/phase-boundaries.md` | Matt (`ask-matt/PHASE-BOUNDARIES.md`), com os nomes do DevOrb e sem o link externo, mais a regra própria 4 |
| `references/claude-code-tools.md` | Superpowers (`using-superpowers/references/claude-code-tools.md`), com os nomes do DevOrb |
| `hooks/hooks.json` e `hooks/run-hook.cmd` | Superpowers, cópias sem alteração |
| `hooks/session-start` | Superpowers, só o ramo de saída do Claude Code, com os nomes do DevOrb |

## Conflitos resolvidos

- **Entrada automática ou roteador manual:** o Superpowers injeta uma skill que obriga a checar skills antes de responder. O `ask-matt` é um roteador que só roda quando chamado. A entrada do DevOrb segue o Superpowers, e o roteador do Matt não vira skill: o mapa dele vira a tabela de etapas, e a árvore de fronteiras de fase vai para `references/phase-boundaries.md`.
- **Precedência:** o Superpowers tem dois degraus, as instruções do usuário acima das skills. O DevOrb põe o fluxo no meio: instruções do usuário e do projeto, depois o fluxo do DevOrb, depois a skill específica. O resto da frase da fonte ficou fora, como diz "Fora".
- **Onde o trabalho novo começa:** o Superpowers manda para o `brainstorming`, e o Matt para o `grill-with-docs`. Os dois viram `devorb:aligning`, inclusive antes do plan mode.
- **Quem pode pular um passo:** a fonte diz "o seu parceiro humano". O DevOrb diz "o nível 1", que inclui as instruções do projeto, como um `CLAUDE.md`.
- **Fronteira de fase:** o Matt descreve as cinco opções sem dizer quem as executa. A referência diz que `/clear`, `/compact` e `devorb:handoff` são do usuário, e o agente recomenda um.
- **Plataformas:** o Superpowers traz notas para vários harnesses. O DevOrb é só para o Claude Code, como diz a spec, e mantém só essa nota.

## Regras próprias

Regras próprias só saem com decisão explícita do dono.

1. **Nomes antigos viram o nome do DevOrb.** `references/legacy-names.md` traduz cada skill do Superpowers e do Matt para a do DevOrb, e diz que as sem equivalente não existem mais. Caso: `evals/using-devorb-legacy-names`. Motivo: o dono tem instruções e hábitos que citam as skills antigas.
2. **Invocar as skills do fluxo pelo nome, mesmo quando a lista de skills não as mostra.** Sem caso que a justifique. Achado da revisão geral: a frase parece valer só para o fluxo e não tem teste (`skills/using-devorb/SKILL.md:30`). Custo observado: enquanto as skills do fluxo estão `planned`, o agente chama skills que ainda não existem e gasta turnos, o que se anota nos resultados da Task 6.
3. **Pegar o caminho das referências invocando `devorb:using-devorb`.** Sem caso que a justifique. Achado da revisão geral: invocar a skill reinjeta o texto inteiro, e o hook poderia imprimir o caminho (`skills/using-devorb/SKILL.md:66`).
4. **Na fronteira de fase, `/clear`, `/compact` e `devorb:handoff` são do usuário: recomendar um e dizer por quê.** Sem caso que a justifique.
5. **Urgência ou "testa depois" não dispensa a checagem de skills.** Uma linha nova nos sinais de alerta diz que é aí que o fluxo mais ajuda e que, em mudança de código, `devorb:tdd` vem primeiro. Caso: `evals/tdd-desconto-progressivo` ("adiciona desconto progressivo, é urgente, escreve o teste depois se der tempo"). Na comparação paga, o DevOrb chamou 0 skills em 3 de 3 rodadas: leu o código, editou `src/cart.js`, depois o teste, e rodou `npm test`. O Superpowers chamou a skill de TDD dele em 1 de 3. Sem urgência, o roteamento funciona (`using-devorb-triggers-feature`, 3 de 3). Enquanto `aligning`, `planning` e `implementing` estão `planned`, só `devorb:tdd` pode impor o teste primeiro, por isso a linha a nomeia. A linha tem 109 bytes, e o texto liberou 110 sem tirar regra: "to execute" virou "for" no `SUBAGENT-STOP`; "what you are doing" virou "your task"; "the codebase" virou "code" e saiu "for the situation" na regra; "Before entering plan mode ... if you haven't aligned yet" virou "Before plan mode ... if not aligned yet"; "describing it or skipping it" virou "describing or skipping it"; ", so suggest" virou "; suggest"; "current version" virou "current one"; e frases mais curtas em References e em Connects to.

## Fora

- **"Which in turn override default behavior":** a fonte diz que as instruções do usuário vêm antes das skills, que por sua vez vencem o comportamento padrão do agente. A lista de três níveis (`skills/using-devorb/SKILL.md:22-24`) deixou de fora a segunda parte, e a Task 3 não registrou isso. Fica registrado agora, sem mudar a skill: "follow it exactly", na regra, cobre parte do efeito, e a skill não tem folga. Volta só se um caso mostrar o agente preferindo o próprio padrão à skill.
- **Notas de outros harnesses:** Codex, Gemini, Pi, Antigravity, Hermes e Muse, o `hooks-cursor.json` e os ramos de Cursor, Copilot e Muse do `session-start`. O DevOrb é só para o Claude Code.
- **Sinais de alerta da fonte:** "posso checar git ou arquivos rápido" foi fundida com "explorar primeiro". "Juntar informação primeiro", "isso não conta como tarefa" e "isso parece produtivo" saíram, para caber no limite.
- **Do `ask-matt`:** as rampas `/triage` e `/wayfinder`, as skills avulsas sem equivalente (`/teach`, `/to-questionnaire`, `/wizard`, `/research`, `/wait-what`), a pré-condição `/setup-matt-pocock-skills` e a higiene de contexto em detalhe. `references/legacy-names.md` diz ao agente que essas skills não existem.

## Resultados (2026-11-11, Task 6)

Opus 5.5, 3 rodadas por caso, `--ablation none`, com o braço `none`. Relatórios em `fusion/results/2026-11-11-using-devorb*.md`.

| Caso | DevOrb | Superpowers | Matt | Sem plugin |
|---|---|---|---|---|
| `using-devorb-triggers-feature` | 100% | 100% | 0% | 0% |
| `using-devorb-triggers-bug` | 100% | 100% | 0% | 0% |
| `using-devorb-legacy-names` | 100% | 0% (de propósito) | 0% | 0% |
| Reservado `using-devorb-fechamento-outubro` | 100% | 100% | 0% (0,50) | 0% (0,50) |

- `accepted: true` na comparação normal. No reservado, 2 rodadas do DevOrb chegaram ao limite de 8 turnos do caso depois de chamar a skill certa, e a versão desta execução do `compare.mjs` contou isso como erro da ferramenta. Com a regra corrigida, também é `accepted: true` (anotado no relatório).
- O caso de nomes legados só aceita o nome traduzido. O Superpowers chama o próprio `brainstorming` e falha de propósito, e o DevOrb traduz em todas as rodadas.
- **Custo da regra própria 2:** enquanto `aligning` está `planned`, o agente chama `devorb:aligning`, recebe "não encontrada" e segue. A chamada conta para o grader, e a Task 10 roda esses casos de novo quando `aligning` existir.
- Depois da regra própria 5 (urgência), a comparação rodou de novo: `accepted: true` nos casos visíveis e no reservado, 100% no DevOrb. Em `using-devorb-triggers-feature` as 3 rodadas chegaram ao limite de 8 turnos depois de chamar a skill certa, o que não bloqueia.
- O Matt não dispara skill nenhuma nesses pedidos: as dele não entram pelo roteamento automático.

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/SKILL.md` | adotado | base da regra de checar skills, do `SUBAGENT-STOP`, da precedência e dos sinais de alerta
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/claude-code-tools.md` | adotado | adaptado com os nomes do DevOrb
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/codex-tools.md` | recusado | o DevOrb é só para o Claude Code
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/gemini-tools.md` | recusado | o DevOrb é só para o Claude Code
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/pi-tools.md` | recusado | o DevOrb é só para o Claude Code
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/antigravity-tools.md` | recusado | o DevOrb é só para o Claude Code
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/hermes-tools.md` | recusado | o DevOrb é só para o Claude Code
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-superpowers/references/muse-tools.md` | recusado | o DevOrb é só para o Claude Code
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:hooks/hooks.json` | adotado | cópia sem alteração, com o matcher `startup|clear|compact`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:hooks/run-hook.cmd` | adotado | cópia sem alteração
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:hooks/session-start` | adotado | só o ramo do Claude Code, lendo `skills/using-devorb/SKILL.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:hooks/hooks-cursor.json` | recusado | o DevOrb é só para o Claude Code
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/ask-matt/SKILL.md` | adotado | o fluxo principal vira a tabela de etapas, e ler a skill antes de descrevê-la vira regra; o roteador manual não vira skill
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/ask-matt/PHASE-BOUNDARIES.md` | adotado | vira `references/phase-boundaries.md`, com os nomes do DevOrb
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/ask-matt/agents/openai.yaml` | recusado | metadado de outra ferramenta
