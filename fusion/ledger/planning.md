# Ledger: `planning`

Junta `writing-plans` do Superpowers e `engineering/to-spec` e `engineering/to-tickets` do Matt Pocock, as duas MIT, e soma duas ideias com `textReuse: false`: `change-impact` do ECC e duas regras de `lib/plan-reality.ts` do gstack (a lista de linhas de revisão de `plan-eng-review`). O Superpowers dá a espinha e o formato do plano. Do Matt vêm as fatias verticais, o prefactoring, o expand-contract, os seams e o vocabulário do projeto. Os textos do ECC e do gstack foram lidos uma vez, e as ideias foram escritas depois, com as fontes fechadas, em frases próprias: nenhuma lista, exemplo, nome de linha ou frase de abertura deles entrou. Duas frases do primeiro rascunho ficaram perto demais e foram reescritas antes do `npm test` (ver Revisões).

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-11 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. O ECC foi lido no pino de `fusion/sources.json`, `d2ef2680594f9a17526a6e1a2e18b3d242c5d17b`, só em `skills/change-impact/`. O gstack foi lido no pino `1b96d9f8538ae0f3b66dd52b75793a3767e514d4`, só em `lib/plan-reality.ts`, como dado e sem rodar nada. A pasta `plan-eng-review/` veio no mesmo fetch raso e não foi lida. Todas as fontes foram buscadas rasas em pasta temporária, com hooks desligados.

A skill foi escrita sem abrir `evals/planning-*`, nenhum grader nem `evals-reserved/`. O caso realista da Task 11, como o plano o descreve, é escrever o plano a partir de uma spec pequena, com graders `regex` para `### Task 1` e `llm` para interfaces.

`SKILL.md` tem 8.510 bytes (cerca de 2.128 tokens, teto 2.500). `references/task-template.md` tem 3.809 bytes (cerca de 953 tokens) e só é lida ao escrever o plano. O `writing-plans` da fonte tem 10.335 bytes. A `description` soma cerca de 30 tokens ao custo sempre ligado.

O Superpowers não tem cenários de pressão para `writing-plans` no caminho lido, e o nível é leve, então não houve cenário de fonte para portar nem caso reservado.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers, com "approved design doc" para casar com a entrega de `devorb:aligning` e "change" no lugar de "task" |
| Abertura: plano para quem não viu o código nem a spec, o que ele não sabe é o que você decidiu; DRY, YAGNI, TDD, commits frequentes | Superpowers, enxugado |
| A spec é o documento de `devorb:aligning`; não escrever outra | Decisão da Task 11, no lugar do artefato do `to-spec` |
| Requisitos entregues direto valem como spec quando nada que muda a construção está aberto; se está, é trabalho de `devorb:aligning` | DevOrb, para casar com o `using-devorb` ("Spec ready") e com a trava de `aligning` |
| Salvar em `docs/devorb/plans/YYYY-MM-DD-<topic>.md`, salvo preferência do usuário ou do projeto | Superpowers, com o caminho do DevOrb |
| Escopo: subsistemas independentes, um plano cada | Superpowers ("Scope Check") |
| Palavras do projeto: ler `GLOSSARY.md` e ADRs da área, nomear como o glossário, não planejar contra decisão registrada | Matt (`to-spec` e `to-tickets`, passo de explorar o código) |
| Já está na branch base? Buscar a base, ler o `git log` dela desde a data da spec nos arquivos que o plano toca e procurar os símbolos principais nas mensagens; avisar o usuário antes das tasks e planejar só o que falta | gstack (`lib/plan-reality.ts`), só ideia, por decisão da Task 11. Texto próprio |
| Tudo que o plano cita existe? Conferir cada comando, flag, script, rota ou endpoint no `--help`, nos scripts do pacote, na tabela de rotas ou no registro; o que não aparece torna o plano errado até prova em contrário | gstack (`lib/plan-reality.ts`), só ideia, por decisão da Task 11. Texto próprio |
| Arquivos: mapa de arquivos e responsabilidades antes das tasks, arquivos pequenos e focados, separar por responsabilidade, seguir os padrões do código existente | Superpowers ("File Structure"), enxugado |
| Nomear os seams: interface pública, preferir seams existentes, o mais alto que alcança o comportamento, quanto menos melhor, um é o ideal | Matt (`to-spec`, passo 2). Preservado por decisão da Task 11 |
| `devorb:tdd` testa no seam do plano sem parar para perguntar, então o usuário aprova os seams ao aprovar o plano | DevOrb, pela decisão da Task 7 registrada no ledger de `tdd`. Ver conflitos |
| `devorb:codebase-design` quando o formato da interface está em questão | DevOrb, como em `devorb:tdd` |
| Fatias verticais em ordem: caminho estreito e completo por todas as camadas, testável ou demonstrável sozinho, cabe num contexto novo; prefactoring primeiro; cada task depende só das de cima | Matt (`to-tickets`, regras de fatia vertical e "make the change easy"), com a ordem linear da Task 11 no lugar das arestas de bloqueio |
| Tamanho certo: menor unidade com ciclo de teste próprio que um revisor rejeitaria aprovando a vizinha; setup, configuração e docs entram na task que precisa deles | Superpowers ("Task Right-Sizing") |
| Refatoração larga em expand-contract: expandir, migrar em lotes por raio de impacto, contrair; task final de integrar e verificar quando nem um lote fica verde sozinho | Matt (`to-tickets`). Preservado por decisão da Task 11. "Ticket" virou "task" e as arestas viraram ordem |
| Passos: uma ação com resultado conferível | Superpowers ("Step Granularity"), condensado numa linha |
| O que um passo contém: teste, código, verificação, referência a outra task; plano maior que o código é transcrição; linhas que não decidem nada | Superpowers ("What a Step Contains"). A revisão de passos que não decidem nada é preservada por decisão da Task 11 |
| No passo de teste, apontar um teste parecido do código quando existe | Matt (`to-spec`, "prior art for the tests") |
| Mudanças difíceis de desfazer: com migração de dados, interface pública, autenticação ou release, a seção `## Rollout` traz ordem de saída, convivência de velho e novo, volta a um estado bom (código e dados) e o que fica mudado mesmo assim; item que falta deixa o plano inacabado | ECC (`change-impact`), só ideia, por decisão da Task 11. Os quatro itens são os da Task, com nomes próprios. Ver conflitos |
| Cada item do Rollout vem da spec, do código ou do usuário, nunca de palpite | ECC (`change-impact`), só a ideia de provar o impacto com evidência, em texto próprio |
| Contratos do documento: `### Task N:` exato, numeração de 1 sem buraco; bloco Interfaces; Global Constraints | Superpowers (formato). O cabeçalho é contrato com os scripts de `devorb:implementing`, pela Task 11. Bloco de interfaces e restrições globais preservados por decisão da Task 11 |
| Autorrevisão: cobertura, varredura de passos, consistência de tipos (com o exemplo `clearLayers()`), Review Focus, proporção | Superpowers ("Self-Review") |
| Autorrevisão, item 6: as checagens da base e dos comandos rodaram, e a mudança difícil de desfazer tem os quatro itens | DevOrb, juntando as ideias do gstack e do ECC à lista do Superpowers |
| Entrega: caminho do plano, pedir revisão (captura o pedido, tamanho das fatias, seams), esperar, manter o modo de execução que o usuário já deu, chamar `devorb:implementing` | Superpowers ("Execution Handoff") e Matt (`to-tickets`, passo 4, perguntas sobre granularidade). Ver conflitos |
| `Connects to` | DevOrb: recebe de `devorb:aligning`, usa `GLOSSARY.md` e `docs/adr/` (de `devorb:domain-modeling`), `devorb:codebase-design` e a referência, entrega a `devorb:implementing` |
| `references/task-template.md`: cabeçalho do plano (Goal, Architecture, Tech Stack, Spec, Global Constraints, Review Focus) e estrutura da task com o exemplo em `pytest` | Superpowers ("Plan Document Header" e "Task Structure"), com `superpowers:subagent-driven-development` e `superpowers:executing-plans` trocados por `devorb:implementing` e o caminho da spec do DevOrb |
| `references/task-template.md`: seção `## Rollout` com os quatro itens | ECC, só ideia, como no corpo |
| `references/task-template.md`: linha `**Seam:**` em cada task | DevOrb, para `devorb:tdd` achar o seam do plano |
| `references/task-template.md`: tasks de refatoração larga (nome do lote, Consumes aponta a expansão, contração prova que não sobrou chamador) | Matt (`to-tickets`), adaptado ao formato de task |

## Conflitos resolvidos

- **Caminhos e código no plano:** o Matt proíbe caminhos de arquivo e trechos de código porque envelhecem rápido, e o Superpowers exige caminhos exatos, assinaturas e testes como código. Pela decisão da Task 11, o plano segue o Superpowers: ele é escrito para ser executado logo, não para durar num tracker.
- **Spec separada:** o `to-spec` sintetiza a conversa num documento novo (problema, solução, histórias de usuário, decisões). Pela Task 11, o documento de `devorb:aligning` já é a spec, e o `to-spec` não gera artefato. Ficaram dele só os seams e o "prior art" dos testes.
- **Arestas de bloqueio ou ordem linear:** o `to-tickets` dá a cada ticket as arestas que o bloqueiam e trabalha a fronteira (o que tem todos os bloqueios prontos). Pela Task 11, as tasks ficam em ordem linear, cada uma dependendo só das de cima, e a dependência aparece no bloco Interfaces (Consumes). O paralelo fica com `devorb:implementing` (Task 13).
- **Quem confirma os seams:** o `to-spec` manda confirmar os seams com o usuário antes de escrever. Pela decisão da Task 7, `devorb:tdd` não para para perguntar. A confirmação acontece uma vez, na revisão do plano, que agora pergunta pelos seams.
- **Sabatina das fatias ou revisão do plano:** o `to-tickets` apresenta a divisão numa lista e itera com o usuário antes de publicar, e o Superpowers pede a revisão do plano pronto. Viraram uma revisão só, do plano salvo, com as perguntas do Matt (tamanho das fatias) e a dos seams. Assim o usuário vê os passos e as interfaces junto com a divisão.
- **Modo de execução na entrega:** o Superpowers pergunta entre subagentes e execução na sessão. No DevOrb essa escolha é de `devorb:implementing` (sequencial com subagente novo por padrão, `references/inline.md` para a sessão, Task 13). A skill só repassa o modo que o usuário já tenha dito.
- **Regras do gstack como revisão ou como passo:** no gstack, as duas regras são linhas que uma revisão do plano precisa trazer, com recibo. Pela Task 11, quem planeja roda as duas antes de escrever as tasks, sem o formato de linha nem o recibo.
- **Item faltando no Rollout:** o ECC trata o item ausente como bloqueio e não executa rollback pelo humano. A skill pede o item ao usuário e não entrega o plano com a lacuna. Executar rollback não é assunto de plano e ficou fora.

## Regras próprias

1. **Task que lê dados guarda o orçamento de desempenho.** O modelo de task em `skills/planning/references/task-template.md` ganha o campo `**Performance budget:**` depois de `**Seam:**`: só para task que lê dados guardados, com o volume que ela deve suportar e o tempo de resposta, vindos da spec, e o orçamento padrão em `devorb:performance`. Caso: um sistema entregue, com tabela de 20 mil linhas × 85 colunas, cuja busca demora; 20 mil linhas é pouco e a busca certa responde em menos de 100 ms. A regra existe para que o volume venha da spec. Sem medição própria (teto da frente A).

Duas partes existem só no DevOrb e não são regras próprias, e sim ligação com o fluxo: a linha `**Seam:**` em cada task do modelo e a exigência de que os itens de `## Rollout` venham da spec ou do usuário, nunca de palpite. As mudanças além das fontes vêm das decisões da Task 11, da decisão da Task 7 sobre seams ou da ligação com as outras skills do DevOrb (ver conflitos).

## Fora

- **Do Superpowers:** "Announce at start"; a linha de contexto sobre worktree criada por `using-git-worktrees`, que é de `devorb:implementing`; o menu de execução (subagentes ou nativo) com a recomendação e as linhas "REQUIRED SUB-SKILL" de cada opção; o caminho `docs/superpowers/plans/`; "parceiro humano", que virou "usuário".
- **Do Matt (`to-spec`):** o modelo de spec inteiro (problema, solução, lista longa de histórias de usuário, decisões de implementação e de teste, fora de escopo, notas), porque a spec é de `devorb:aligning`; publicar no tracker e o rótulo `ready-for-agent`; o aviso para rodar `/setup-matt-pocock-skills`; a proibição de caminhos e código e a exceção do trecho de protótipo; "não entreviste o usuário"; `agents/openai.yaml`.
- **Do Matt (`to-tickets`):** tudo de tracker e rótulos (pela Task 11): publicar issues, sub-issues, relação nativa de bloqueio, issue pai, arquivos locais em `.scratch/`, os dois modelos de ticket, a linha de status e a fronteira; os critérios de aceite em checkbox, porque no plano os passos com teste fazem esse papel; `agents/openai.yaml`.
- **Do ECC:** a fronteira de confiança e as listas de quando ativar; as seis perguntas de análise antes da mudança (código, dados, interfaces, testes, documentação, release), das quais só a de release virou o Rollout; as regras de roteamento para skills do ECC (ADR, contrato, colaboração de testes, regressão de módulo); onde guardar o relatório; os antipadrões; os nomes de artefato do ECC (MAP, STATUS, LOG e outros); e o alinhamento depois da implementação (diff contra impacto planejado, escopo excedido, sobras de compatibilidade), que pode servir a `devorb:verifying` ou `devorb:reviewing` e não entrou aqui. A ideia de critério observável de `intent-driven-development`, que o ledger de `aligning` apontou para cá, também não entrou: o Review Focus do Superpowers já cobre o que o plano precisa testar.
- **Do gstack:** as outras cinco regras obrigatórias e todas as condicionais de `lib/plan-reality.ts`; a gramática de linha, os recibos e as funções de checagem; e o resto de `plan-eng-review`, fora pela spec.

## Resultados

Opus 5.5, nível leve, comparado com o Superpowers. `fusion/results/2026-11-11-planning.md`.

| Caso | DevOrb | Superpowers |
|---|---|---|
| `planning-multa-atraso` | 100% | 100% |

- `accepted: true` por empate. O caso não separa as versões no Opus e fica como guarda contra piora.

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-plans/SKILL.md` | adotado | espinha da skill: abertura, escopo, mapa de arquivos, tamanho de task, granularidade e conteúdo dos passos, autorrevisão, e o cabeçalho e a estrutura de task em `references/task-template.md`, com nomes e caminhos do DevOrb
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-plans/SKILL.md` | recusado | "Announce at start", linha de worktree e menu de execução, que são de `devorb:implementing`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/to-spec/SKILL.md` | adotado | seams (preferir existentes, o mais alto, o menor número), vocabulário do glossário e ADRs, e o "prior art" dos testes
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/to-spec/SKILL.md` | recusado | o artefato de spec e seu modelo, tracker, rótulo e a proibição de caminhos e código, pela Task 11
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/to-spec/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/to-tickets/SKILL.md` | adotado | fatias verticais, prefactoring primeiro, expand-contract em refatoração larga e as perguntas de granularidade, que entraram na revisão do plano
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/to-tickets/SKILL.md` | recusado | tracker, rótulos, arquivos locais, modelos de ticket, arestas de bloqueio e fronteira, pela Task 11
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/to-tickets/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/change-impact/SKILL.md` | adotado | só a ideia, com texto próprio: em migração de dados, interface pública, autenticação ou release, o plano traz a ordem de saída, a convivência, a volta e o que não se desfaz, com evidência, e item faltando segura o plano
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/change-impact/SKILL.md` | recusado | análise completa de impacto, roteamento para skills do ECC, local do relatório e alinhamento pós-implementação
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:lib/plan-reality.ts` | adotado | só duas ideias, com texto próprio: ler o log da branch base nos arquivos e símbolos do plano antes das tasks, e conferir cada comando, flag e rota citados no `--help` ou no registro. O arquivo não é acompanhado, porque o ciclo mensal recusa `.ts` como script
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:lib/plan-reality.ts` | recusado | as demais linhas de revisão, o formato de linha com recibo e o código de checagem

## Revisões

- **2026-11-11, antes do `npm test`, risco de cópia (`textReuse: false`):** a frase "One you can't find is a finding" repetia a forma da regra do gstack e virou "If it isn't there, the plan is wrong until shown otherwise". A lista de exemplos de interface pública "(API, message, file format, CLI)" espelhava a pergunta de interfaces do ECC e virou "(anything outside this code calls or reads)". `SKILL.md` foi de 8.478 para 8.510 bytes.
- 2026-11-12, revisão antes das rodadas: item em aberto na spec manda voltar a `devorb:aligning`; o histórico da base usa a data da spec ou do pedido; dividir um arquivo grande é uma task do plano, não edição durante o planejamento; `## Rollout` só para release de produção.
- 2026-11-13, Task D7 do plano de design: ligação ao setor de design. Passo de UI cita os tokens de `DESIGN.md` pelo nome, nunca o valor cru; `Connects to` recebe a spec por `devorb:visual-direction` e `devorb:design-system` quando há interface. Nenhuma regra muda. `SKILL.md` foi de 8.609 para 8.897 bytes.
- 2026-11-17, Task 7 do plano de design (fase 1): o passo de interface do plano nomeia também o contrato `## Direção visual`, o caminho do pacote de referência quando o contrato lista um, e o critério de pronto do espelho (`Mirror:` sem FAIL, Critique do `ui-review` sem nota abaixo de 8). Caso: `planning-tela-com-referencia`.
