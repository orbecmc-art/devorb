# Ledger: `implementing`

Junta `subagent-driven-development` (com `implementer-prompt.md`, `task-reviewer-prompt.md`, `re-review-prompt.md`, `references/` e `scripts/`), `executing-plans` (com `scripts/`), `dispatching-parallel-agents` e `using-git-worktrees` do Superpowers, e `engineering/implement` e `engineering/implement-spec` do Matt Pocock, as duas MIT, e soma a ideia de mudança cirúrgica de `karpathy-guidelines`, com `textReuse: false`. O Superpowers dá a espinha: subagente novo por task, revisão por task, laço de correção, revisão final, ledger e scripts. Do Matt vêm o grafo de tasks com fronteira, a branch de integração e o worktree por task, que só valem no modo paralelo. O texto do Karpathy foi lido uma vez, e a regra foi escrita depois, com a fonte fechada, em frases próprias. Um primeiro rascunho ficou perto demais em três frases e foi reescrito antes do `npm test` (ver Revisões).

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-11 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. O Karpathy foi lido no pino de `fusion/sources.json`, `2c606141936f1eeef17fa3043a72095b4765b9c2`, só em `skills/karpathy-guidelines/`. Todas as fontes foram buscadas rasas em pasta temporária, com hooks desligados, e nenhum script foi executado.

O caso realista da Task 13 é um plano de duas tasks em repositório pequeno, com código vizinho bagunçado, e o reservado é um plano que contradiz a spec, em que o certo é parar. A skill foi escrita a partir do texto da Task 13 no plano, sem abrir `evals/implementing-*`, `evals-reserved/` nem nenhum grader.

`SKILL.md` tem 13.350 bytes, cerca de 3.338 tokens, contra o teto de 5.000. O resto fica em `prompts/` e `references/`, lido quando o caminho chega lá.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers: "executing implementation plans" (`subagent-driven-development`) e "in the current session as the implementer yourself" (`executing-plans`), fundidas em uma linha que cobre subagentes e execução na sessão |
| Abertura: subagente novo por task, revisão por task, revisão final; por que subagentes | Superpowers (`subagent-driven-development`) |
| Os três modos: padrão sequencial, `references/inline.md`, `references/parallel.md` | Decisão da Task 13. "Nunca fingir um dispatch" é do `executing-plans` |
| Narração, seguir sem pausas | Superpowers |
| Decisões em vez de paradas, linha `Ruling:` com custo se errado | Superpowers, preservado por decisão da Task 13. "A spec é a autoridade" ficou restrito a onde o plano é omisso, ambíguo ou incoerente consigo mesmo. Ver conflitos |
| As quatro condições de parada | Superpowers, por decisão da Task 13. A terceira foi reescrita: no Superpowers, "a merge, a push to a shared branch, a publish"; no DevOrb, "a merge into a shared branch, a push, a publish", porque o merge na branch de integração do modo paralelo faz parte da execução e qualquer push pede consentimento. A quarta ganhou o caso do plano que contradiz a spec no que se constrói: regra própria 1 |
| Onde trabalhar: nunca na branch principal sem consentimento, worktree pede consentimento | Superpowers (`subagent-driven-development` e `using-git-worktrees`), por decisão da Task 13 |
| Workspace e ledger: `sdd-workspace`, `progress.md`, primeira linha com o plano, retomada, confiar no ledger e no `git log`, `git clean -fdx` | Superpowers (`subagent-driven-development` e `references/resuming.md`), preservado por decisão da Task 13. A pasta virou `.devorb/sdd` |
| Ler o plano e a spec uma vez, nota de spec ausente | Superpowers. Ler também o Review Focus é do DevOrb, porque o plano de `devorb:planning` tem essa seção |
| Model Selection, em tabela | Superpowers, preservado por decisão da Task 13, porque `skills/using-devorb/references/claude-code-tools.md` cita a seção. Condensado: os papéis e as faixas são os mesmos, com "turn count beats token price" |
| Laço da task: entregar artefatos como arquivo | Superpowers, preservado ("subagente alimentado por arquivo") |
| Trabalho pequeno do mesmo formato num dispatch só | Superpowers (`references/batching.md`), dobrado no corpo |
| Espera em trechos de cinco a dez minutos | Superpowers |
| 1. Dispatch: BASE, `task-brief`, os cinco itens do dispatch, sem histórico colado, identidade do implementador, um por vez | Superpowers. "Inclui Files, Seam e Interfaces" é do DevOrb, porque o `### Task N:` e a linha `**Seam:**` do plano de `devorb:planning` são o contrato que `task-brief` lê |
| 2. Relato: os quatro status | Superpowers (`references/handling-reports.md`), dobrado no corpo |
| 3. Revisão da task: `review-package`, nunca `HEAD~1`, restrições globais copiadas, não pré-julgar, itens "não dá para verificar pelo diff" | Superpowers (corpo e `references/cannot-verify.md`) |
| 4. Laço de correção, lido antes de cada rodada | Superpowers |
| 5. Linhas de conclusão no ledger | Superpowers |
| Revisão final, listas "Rulings I made" e "Deferred minors" | Superpowers (`references/final-review.md` e `executing-plans`), preservado por decisão da Task 13, porque `claude-code-tools.md` cita a lista |
| Terceira lista, "User decides": os itens USER DECIDES de `devorb:reviewing` (teste, portão ou critério de aceite afrouxado), copiados sem mudança, nunca corrigidos nem decididos por `Ruling:`, passados a `devorb:finishing` | DevOrb, pela saída de `devorb:reviewing` (Task 14), na revisão de 2026-11-12. `claude-code-tools.md` manda o orquestrador repassá-la junto com "Rulings I made" |
| Entrega em `devorb:finishing`, sem merge, push nem pull request marcado como pronto | Decisão da Task 13. Ver conflitos (Matt) |
| Tabela de racionalizações | Superpowers (`subagent-driven-development`), condensada, mais duas linhas do DevOrb: arrumar o vizinho (Karpathy) e plano contra spec (regra própria 1) |
| `Connects to` | DevOrb: recebe o plano de `devorb:planning`, usa `devorb:tdd`, `devorb:debugging`, `devorb:verifying` e `devorb:reviewing`, entrega para `devorb:finishing`, como manda a Task 13 |
| `prompts/implementer.md` | Superpowers (`implementer-prompt.md`), adaptado: `devorb:tdd` no seam da brief sem parar para perguntar (decisão da Task 7), `devorb:debugging` quando algo surpreende, typechecker durante a iteração (Matt, `implement`), "improve code you're touching" trocado pela regra do Karpathy |
| `prompts/implementer.md`: "Your diff answers to the brief" | Karpathy, só ideia, com a definição de mínimo de `devorb:debugging` (a menor mudança que corrige a regra quebrada, não a menor em linhas), por decisão da Task 13. Texto próprio |
| `prompts/task-reviewer.md` | Superpowers (`task-reviewer-prompt.md`), condensado. "Extra" passou a incluir edição em código vizinho que a task não pedia: regra própria 3. Testes "pelo seam que a brief nomeia" é do DevOrb |
| `prompts/re-reviewer.md` | Superpowers (`re-review-prompt.md`), condensado, com "mudanças que os achados não pediam" entre as quebras novas |
| `references/preflight.md` | Superpowers (`references/preflight.md` e a varredura do `executing-plans`), mais a linha do plano contra a spec (regra própria 1) e a de comandos inexistentes, que repete a checagem de `devorb:planning` |
| `references/fix-loop.md` | Superpowers, com o caso do plano contra a spec mandando para a quarta parada |
| `references/final-review.md` | Superpowers (`references/final-review.md` e `executing-plans`): pacote, um revisor no modelo mais capaz, uma onda de correção com um implementador só, re-revisão com escopo, sem segunda onda, reclassificar pelo efeito, apagar o workspace. O revisor é `devorb:reviewing`, no lugar do `code-reviewer.md` do Superpowers. A suíte inteira fresca por `devorb:verifying` antes da revisão (comando e contagens vão para `devorb:reviewing`) e de novo depois da onda de correção é do DevOrb, pela interface da Task 13 |
| `references/inline.md` | Superpowers (`executing-plans`): por que inline, quando sugerir subagentes, `task-start`, passos com `Expected:`, contrato de conclusão, `task-done`, revisão final com e sem subagente, um passe de correção com TDD, racionalizações condensadas. Os nomes viraram `devorb:tdd`, `devorb:debugging`, `devorb:verifying` e `devorb:reviewing`. A regra do Karpathy vale também para quem executa inline: DevOrb |
| `references/parallel.md`: quando, consentimento, branch de integração | Decisão da Task 13 sobre o Matt (`implement-spec`). "Marcado pelo plano em palavras, e não pela leitura do controlador" e "conferir a marca no pre-flight" são regra própria 2 |
| `references/parallel.md`: fronteira, dispatch no mesmo turno, worktree por task cortado da ponta da integração, conferir a base e resetar | Matt (`implement-spec`: fronteira, worktree e branch por ticket, confirmar a base e resetar) e Superpowers (`dispatching-parallel-agents`: vários dispatches na mesma mensagem rodam juntos) |
| `references/parallel.md`: um workspace e um ledger, scripts com `-C` | DevOrb, sobre o `-C DIR` que os scripts do Superpowers já aceitam |
| `references/parallel.md`: merge pelo controlador, suíte depois de cada merge, conflito resolvido pelo implementador da task com re-revisão sobre `<ponta da integração>..<cabeça da task>` | DevOrb (regra própria 2). O Matt usa um subagente de merge, e o `dispatching-parallel-agents` manda checar conflitos e rodar a suíte inteira depois de integrar. Ver conflitos |
| `references/parallel.md`: remover o worktree da task depois do merge | Matt (passo 9 do `implement-spec`), com "só limpo, nunca `--force`" do DevOrb |
| `references/worktree.md` | Superpowers (`using-git-worktrees`): detectar o isolamento, guarda de submódulo, consentimento, ferramenta nativa primeiro, fallback com `.worktrees/` e `git check-ignore`, sandbox, instalar dependências, linha de base. Os comandos de setup por linguagem viraram uma linha. A seção "Cleaning up" é do DevOrb |
| `scripts/` (seis) | Superpowers, cópias com caminhos e nomes trocados. Ver "Scripts para revisão humana" |

## Conflitos resolvidos

- **Melhorar o código que se toca:** o `implementer-prompt.md` do Superpowers manda melhorar o código tocado "como um bom desenvolvedor faria". O Karpathy proíbe melhorar código vizinho. Pela decisão da Task 13, vale o Karpathy: a frase do Superpowers saiu e a regra própria do prompt entrou no lugar.
- **Paralelo ou sequencial:** o Superpowers proíbe implementadores em paralelo, e o `implement-spec` do Matt roda tudo em paralelo, na fronteira, para máxima concorrência. Pela decisão da Task 13, o padrão é sequencial, e o paralelo só vale para tasks que o plano marca como independentes, em `references/parallel.md`.
- **Pull request:** o Matt abre um pull request de rascunho depois do primeiro merge e o marca como pronto no fim. Pela decisão da Task 13, a entrega termina no menu de `devorb:finishing`, e `implementing` não abre, não marca como pronto, não faz merge na branch base nem push.
- **Quem faz o merge na integração:** o Matt usa um subagente de merge, e o implementador de cada ticket faz merge da ponta da integração no próprio ramo antes de dizer que terminou. No DevOrb, o merge limpo é do controlador, porque é uma operação de git sem decisão, e o implementador só traz a ponta da integração quando há conflito. Assim o diff revisado de cada task contém só a task, e a resolução do conflito, que é mudança de código, passa por re-revisão.
- **A spec como autoridade:** o Superpowers decide todo conflito do plano contra a spec com uma linha `Ruling:` e segue. A Task 13 reserva um caso em que o plano contradiz a spec e o certo é parar. Resolvido pela regra própria 1: o plano que contradiz a spec no que se constrói cai na quarta condição de parada. Onde o plano é omisso, ambíguo ou incoerente consigo mesmo, a spec continua decidindo por `Ruling:`. As quatro condições continuam quatro.
- **Pré-requisito "tasks quase independentes":** o diagrama de uso do Superpowers manda planos de tasks muito acopladas para execução manual. O `devorb:planning` escreve fatias verticais em ordem linear, em que cada task depende só das de cima, e a execução sequencial as cobre. O pré-requisito saiu.
- **Revisor final:** o Superpowers usa o `code-reviewer.md` de `requesting-code-review`, e o Matt chama `code-review`. No DevOrb, os dois viram `devorb:reviewing`, que a Task 14 define como quem recebe de `implementing` e devolve achados com severidade.
- **Base da linha de testes falhando:** o `using-git-worktrees` manda perguntar se a linha de base falha, e o "decisões em vez de paradas" proíbe perguntas no meio da execução. A pergunta fica, porque acontece antes de a execução começar.
- **Ferramenta nativa de worktree:** o Superpowers prefere a ferramenta do harness para o worktree da sessão. No modo paralelo, a mesma preferência vale para a opção de dispatch que dá um worktree a cada subagente, e o implementador confere a base porque essa opção pode cortar o worktree de outro commit.
- **Quantas referências:** o Superpowers tem sete arquivos em `references/`. `batching.md`, `cannot-verify.md`, `handling-reports.md` e `resuming.md` tinham de 500 a 1.100 bytes e viraram parágrafos do corpo, que ainda fica em 3.338 tokens. `preflight.md`, `fix-loop.md` e `final-review.md` continuam arquivos, porque só alguns caminhos os usam.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As regras abaixo foram escritas antes da linha de base da Task 13, e o resultado da comparação ainda está por vir.

1. **Plano contra spec no que se constrói é parada.** Uma task que constrói o que a spec proíbe, um valor diferente ou um requisito da spec que nenhuma task cobre cai na quarta condição de parada: o usuário aprovou os dois, e qual deles vale é decisão dele. O pre-flight procura isso antes do Task 1, e o laço de correção e o modo inline mandam para a mesma parada quando aparece depois. Caso: o reservado da Task 13, descrito no plano ("um plano que contradiz a spec, em que o certo é parar"), sem abrir os arquivos dele. Sem a regra, a frase "a spec é a autoridade" do Superpowers leva o controlador a decidir sozinho e seguir.
2. **Paralelo só com a marca do plano, e com merge verificado.** A marca de independência vem do plano, em palavras; a leitura do controlador não basta, e o pre-flight confere a marca (duas tasks "independentes" que tocam o mesmo arquivo rodam em sequência). Depois de cada merge na integração, roda a suíte; vermelho é uma rodada de correção. Conflito volta ao implementador da task, com re-revisão sobre `<ponta da integração>..<cabeça da task>`. Nenhuma fonte diz como revisar uma task que precisou de merge, e duas tasks verdes sozinhas podem quebrar juntas.
3. **O revisor da task também cobra a regra do Karpathy.** A Task 13 põe a regra no prompt de quem implementa. O `task-reviewer.md` passou a contar como "Extra" a edição de código vizinho que a task não pedia (renomear, reformatar, reescrever comentário, apagar código morto que já existia), e o `re-reviewer.md` conta como quebra nova a mudança que os achados não pediam. Caso: o realista da Task 13, com código vizinho bagunçado. Sem a regra, a revisão por task só confere o que falta e o que sobra de funcionalidade, e a edição no vizinho passa.
4. **Espelho do construtor em task de interface.** Uma task que constrói ou muda uma página, tela ou componente roda o espelho antes do commit: serve a página, roda `shoot.mjs` de `devorb:ui-review` no modo do contrato, compara com `compareStructure` quando o pacote tem `1440/metrics.json`, olha os prints contra o pacote ou o `floor.md`, corrige e repete, no máximo 3 rodadas. O relatório traz `Mirror: rounds <n>/3 · shots <dir> · checks FAIL <n> WARN <n> · vs reference: <grossFail yes/no>`. Sem navegador e sem o sim explícito do usuário para instalar, `Mirror: not run (<why>)` e DONE_WITH_CONCERNS, sem afirmar print nem medida. O despacho nomeia o contrato, o `DESIGN.md`, o pacote, o `floor.md` e a ordem do espelho. Caso: `evals-outside/implementing-espelho-em-breve` (Task 6 do plano de qualidade de design), em que a linha de base fez a página certa, mas nunca se olhou nem levou o pacote e o `floor.md` ao despacho. Task sem interface não muda: `implementing-resgate-extrato` segue igual.
5. **Regra do dono: o implementador lê as fontes antes da UI.** O despacho de uma task de interface leva o caminho de `ui-sources.json` e a linha `Sources:`; o implementador lê as fontes antes do primeiro arquivo de UI e relata `Sources:` no relatório. Tocou `SKILL.md` e `prompts/implementer.md`. Cenário: `evals/implementing-fontes-ui`, grader `sources-before-ui`. RED em `devorb@91ce711`: falha 2/2 no devorb e 2/2 no `none`, US$ 7,66. GREEN em `devorb@4a966e3`: 100% (1,00), `none` 0,00, US$ 4,25. Resultados: `fusion/results/2026-11-19-implementing-fontes-red.md` e `fusion/results/2026-11-19-implementing-fontes.md`.
6. **O revisor da task bloqueia leitura sem limite.** O `skills/implementing/prompts/task-reviewer.md` ganha, na Parte 2, o item **Data:** com os quatro sinais (consulta sem limite, consulta por linha dentro de laço, filtro ou ordenação sem índice, lista sem paginação nem virtualização), cada um Important, escritos no próprio prompt porque o subagente revisor não recebe mais nada. A isenção é a do revisor da branch: leitura por chave fora de laço, escrita e lista que o código ou o esquema mantém pequena. Caso: um sistema entregue, com tabela de 20 mil linhas × 85 colunas, cuja busca era lenta e passou na revisão por task. Sem medição própria (teto da frente A).

## Fora

- **Do Superpowers (`subagent-driven-development`):** os dois diagramas `dot`; a comparação "vs. Executing Plans", que virou a lista dos três modos; o cabeçalho "Part of superpowers:..." das referências; duas linhas das racionalizações ("o revisor vai achar algo novo de qualquer jeito" e "revisões atrasam o laço"), cobertas pelo laço com escopo; e o nome "parceiro humano", que virou "usuário".
- **Do Superpowers (`executing-plans`):** o diagrama `dot`; o ponteiro para `../using-superpowers/references/`; e cinco linhas das racionalizações ("checar antes da próxima task", "deve passar, a mudança foi trivial", "pular a revisão final também", "o revisor disse Minor", "a correção é óbvia"), cobertas pelo corpo de `inline.md` e por `devorb:verifying`.
- **Do Superpowers (`dispatching-parallel-agents`):** o exemplo de três arquivos de teste falhando, o prompt de exemplo, "erros comuns" e a sessão real. Ficaram a ideia de um agente por domínio independente, os dispatches na mesma mensagem e a checagem de conflitos e da suíte depois de integrar. O uso da fonte para investigar falhas independentes fora de um plano não tem casa em `implementing` (ver dúvidas no relatório da Task).
- **Do Superpowers (`using-git-worktrees`):** "anuncie no início", a tabela de referência rápida, o formato do relatório e a tabela de racionalizações; os comandos de setup por linguagem viraram uma linha.
- **Do Matt (`implement`):** buscar ticket no issue tracker; a descrição e `disable-model-invocation`, porque a skill do DevOrb é automática; `agents/openai.yaml`.
- **Do Matt (`implement-spec`):** issue tracker, tickets e `/setup-...` (o `devorb:planning` tirou tracker e labels na Task 11); o pull request de rascunho e marcá-lo como pronto; fechar tickets; o subagente de exploração que salva notas fora do repositório; o subagente de merge; `agents/openai.yaml`.
- **Do Karpathy:** "pense antes de codar", "simplicidade primeiro" e "execução guiada por objetivo", que `devorb:aligning`, `devorb:tdd` e `devorb:verifying` já cobrem. Só a mudança cirúrgica entrou, como ideia.

## Resultados

Opus 5.5, 3 rodadas, `--ablation none`. `fusion/results/2026-11-12-implementing*.md`.

| Caso | DevOrb | Superpowers | Matt |
|---|---|---|---|
| `implementing-resgate-extrato` | 100% (1,00) | 67% (0,92) | 0% (0,75) |
| Reservado `implementing-cashback` | 100% (1,00) | 0% (0,25) | 100% (1,00) |

- `accepted: true` nos dois. O DevOrb é o único braço que passa nos dois casos.

Espelho do construtor (Task 6 do plano de qualidade de design), fora do sandbox, Opus 5.5, `fusion/results/2026-11-17-implementing-outside-baseline.md`:

| Caso | Braço | Aprovação | Pontuação |
|---|---|---|---|
| `implementing-espelho-em-breve` (RED, 2 rodadas) | `none` | 0% | 0,56 |

- RED: o braço `none` falha em `brief-carries`, `mirror-ran` e `report-field` e passa em `result` e `result-scale`. A página sai certa, mas ninguém a fotografa antes do commit. O GREEN fica para a comparação com `devorb,superpowers`.

Plano de regras de cor e referências, 2026-11-19, Opus 5.5, 2 rodadas, `--arms devorb,none`:

| Caso | RED | GREEN devorb | GREEN none |
|---|---|---|---|
| `implementing-fontes-ui` | 0/2 em devorb e em none | 100% (1,00) | 0,00 |

- Custo total do plano: US$ 43,09 dos US$ 50 aprovados (RED 3,83 + 2,09 + 7,66 + RED2 1,56 + RED3 1,56; GREEN 6,39 + 7,79 + 2,06 + 4,25 + GREEN2 2,06 + GREEN3 1,95; diagnóstico 1,89).

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/SKILL.md` | adotado | espinha da skill: subagente novo por task, revisão por task, decisões em vez de paradas, quatro paradas, workspace e ledger, Model Selection, laço da task, conclusão, revisão final
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/SKILL.md` | recusado | diagramas `dot`, comparação com `executing-plans`, duas linhas de racionalizações
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/implementer-prompt.md` | adotado | base de `prompts/implementer.md`, com `devorb:tdd`, `devorb:debugging` e a regra do Karpathy no lugar de "melhore o código que toca"
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/task-reviewer-prompt.md` | adotado | base de `prompts/task-reviewer.md`, condensado, com a regra própria 3
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/re-review-prompt.md` | adotado | base de `prompts/re-reviewer.md`, condensado
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/preflight.md` | adotado | base de `references/preflight.md`, com a linha do plano contra a spec
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/fix-loop.md` | adotado | base de `references/fix-loop.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/final-review.md` | adotado | base de `references/final-review.md`, com `devorb:reviewing` e `devorb:verifying`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/batching.md` | adotado | dobrado no corpo
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/cannot-verify.md` | adotado | dobrado no corpo
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/handling-reports.md` | adotado | dobrado no corpo
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/references/resuming.md` | adotado | dobrado no corpo, com `.devorb/sdd/progress.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/scripts/sdd-repo` | adotado | cópia com 2 comentários trocados; código de terceiro, revisão humana nesta Task
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/scripts/sdd-workspace` | adotado | cópia com `.superpowers/sdd` trocado por `.devorb/sdd` em 3 linhas; código de terceiro, revisão humana nesta Task
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/scripts/task-brief` | adotado | cópia com 1 comentário trocado; código de terceiro, revisão humana nesta Task
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/subagent-driven-development/scripts/review-package` | adotado | cópia com 1 comentário trocado; código de terceiro, revisão humana nesta Task
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/executing-plans/SKILL.md` | adotado | base de `references/inline.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/executing-plans/SKILL.md` | recusado | diagrama `dot`, ponteiro para `using-superpowers`, cinco linhas de racionalizações
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/executing-plans/scripts/task-start` | adotado | cópia com o caminho para `task-brief` e um comentário trocados; código de terceiro, revisão humana nesta Task
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/executing-plans/scripts/task-done` | adotado | cópia com o caminho para `sdd-repo` e `sdd-workspace` trocado; código de terceiro, revisão humana nesta Task
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/dispatching-parallel-agents/SKILL.md` | adotado | um agente por domínio independente, dispatches na mesma mensagem, conflitos e suíte depois de integrar, em `references/parallel.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/dispatching-parallel-agents/SKILL.md` | recusado | exemplos de investigação de testes falhando, erros comuns e sessão real
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-git-worktrees/SKILL.md` | adotado | base de `references/worktree.md`: detecção, consentimento, ferramenta nativa, fallback, linha de base
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/using-git-worktrees/SKILL.md` | recusado | anúncio, tabela de referência rápida, formato de relatório, racionalizações
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/implement/SKILL.md` | adotado | typechecker e teste focado durante a iteração, suíte inteira uma vez
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/implement/SKILL.md` | recusado | ticket do issue tracker e invocação só manual
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/implement-spec/SKILL.md` | adotado | fronteira do grafo de tasks, branch de integração, worktree e branch por task, conferir a base, remover worktrees no fim, comunicação por ponteiros
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/implement-spec/SKILL.md` | recusado | issue tracker, pull request de rascunho marcado como pronto, subagente de exploração, subagente de merge
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/implement/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/implement-spec/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `karpathy-skills@2c606141936f1eeef17fa3043a72095b4765b9c2:skills/karpathy-guidelines/SKILL.md` | adotado | só a ideia da mudança cirúrgica, com texto próprio, no prompt de quem implementa
- `karpathy-skills@2c606141936f1eeef17fa3043a72095b4765b9c2:skills/karpathy-guidelines/SKILL.md` | recusado | as outras três diretrizes, já cobertas por outras skills do DevOrb
- `taste-skill@sem-pin:portão de 3 rodadas e prints por largura (commit visto f6b76575f949707b4e3c37cd86cb44b0b98643e8, caminho fora dos rastreados)` | adotado (só ideia) | portão do construtor com no máximo 3 rodadas e prints em várias larguras, no passo Mirror de `prompts/implementer.md`; texto próprio
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/SKILL.md` | adotado (só ideia) | construir e revisar antes de seguir, começando pelo hero, que virou olhar os prints contra o pacote seção por seção antes do commit; texto próprio
- registro em fusion/sources.json: decisão do dono

## Scripts para revisão humana

Os seis scripts vêm do Superpowers no commit `22f0b463e7a5e579904dd6211a520321035526f7` e ficam juntos em `skills/implementing/scripts/`, com modo executável (`100755`), como na fonte. A Task 13 manda que uma pessoa os revise nesta Task, fora do ciclo automático. Nenhum foi executado na fusão. Mudança só em caminho e nome; o resto é igual byte a byte, conferido com `diff` contra a fonte. O blob é o `git rev-parse <commit>:<caminho>` da fonte.

| Script | Caminho na fonte | Blob da fonte | SHA-256 da fonte | SHA-256 no DevOrb |
|---|---|---|---|---|
| `sdd-repo` | `skills/subagent-driven-development/scripts/sdd-repo` | `b1756b975cf7df470bd4f8b8a0ed9e24f3d64c5f` | `6f8256a776968d394bae679572e41ce572fd45c72074b98f9a8eb8b4f160e06f` | `a39d2f1f34cd5b6cdb2bdae8c29efaf55eae67900152002369f07d7cc23b8e0a` |
| `sdd-workspace` | `skills/subagent-driven-development/scripts/sdd-workspace` | `ca3ac3b087fed24e460a249b6686910ea4ef5a95` | `de3af5252fa595fc2000ba05cf69e06187d5c8aae9d283cced4c167ad1813061` | `59f990efbcd0205eb8755ad7177a8df55e3e163480ddc39dc9c75d7eef6ebcf1` |
| `task-brief` | `skills/subagent-driven-development/scripts/task-brief` | `a490211ad85b3236de038df27261395ac107befc` | `0f244a12e146393c552ba62069d3eedcc85cb3f76de67b01f4e11219e5ebbcd8` | `15b18e39ce9ef4eb6e39d5fecf18c3f9685295ad57a2c790079c8da104341754` |
| `review-package` | `skills/subagent-driven-development/scripts/review-package` | `04c2b918c6289b49e716fe1faa0afc98a4e465f9` | `aed7c6e09fc660417d28898ed975e84651cb9f18f4675141cd475edfb7037f3d` | `ab4e8908ffdee871dde84dd8fbaaf92529b0a3955075827190e53c7a2a0fa8ee` |
| `task-start` | `skills/executing-plans/scripts/task-start` | `04f1c6588be8d4fca7e9f83b20d01d0b0a165d97` | `4ae7ce3b6777c3240af786197836a6b4bbf3b0ee831c25f147c149ea8db54a21` | `64a0a000505870e4e2e893fb03e167962b05e310f7ec961c4880f000d61b0380` |
| `task-done` | `skills/executing-plans/scripts/task-done` | `d6400b40f4404586ab7557747ae64be83cd02998` | `ac0b5ebafc7d471507b7e94d88da77a11f187ba277c8d48fefaf8ff3e4fee50e` | `3ffd95639b0744c82ffe45664ad0c6ad683d5e9629ae112983bd58cf7d8abc5a` |

**Mudanças, linha a linha:**

- `sdd-repo`
  - Linha 9 (comentário): `(writing-plans leaves the plan uncommitted there)` virou `(where the plan may not be committed yet)`. A fonte nomeava a skill de planos dela e afirmava que ela não faz commit; `devorb:planning` não diz se faz, então o comentário ficou neutro (revisão de 2026-11-12; a versão anterior dizia `devorb:planning leaves the plan uncommitted there`).
  - Linha 21 (comentário): `the SDD and executing-plans` virou `the SDD and inline-execution`. Nome, porque os dois scripts da execução inline agora moram na mesma pasta.
- `sdd-workspace`
  - Linha 6 (comentário): `(.superpowers/sdd/<plan-basename>/)` virou `(.devorb/sdd/<plan-basename>/)`.
  - Linha 24 (comentário): `.gitignore at .superpowers/sdd/` virou `.gitignore at .devorb/sdd/`.
  - Linha 65 (código): `base="$root/.superpowers/sdd"` virou `base="$root/.devorb/sdd"`. É a única mudança de comportamento: a pasta do workspace.
- `task-brief`
  - Linha 7 (comentário): `.superpowers/sdd/` virou `.devorb/sdd/` no caminho padrão do `OUTFILE`.
- `review-package`
  - Linha 8 (comentário): `.superpowers/sdd/` virou `.devorb/sdd/` no caminho padrão do `OUTFILE`.
- `task-start`
  - Linha 3 (comentário): `(via subagent-driven-development's task-brief, so both skills` virou `(via task-brief in this folder, so subagent and inline runs`.
  - Linha 21 (código): `sdd="$(cd "$(dirname "$0")/../../subagent-driven-development/scripts" && pwd)"` virou `sdd="$(cd "$(dirname "$0")" && pwd)"`. Na fonte, os scripts estavam em duas skills; no DevOrb, na mesma pasta.
- `task-done`
  - Linha 21 (código): a mesma troca de `task-start`, de `../../subagent-driven-development/scripts` para a própria pasta.

**Pontos para quem revisa** (nada disso foi mudado, porque a regra é cópia fiel fora de caminho e nome):

- `task-start` e `task-done` chamam `"$sdd/task-brief"` e `"$sdd/sdd-workspace"` direto, enquanto os outros scripts chamam `"${BASH:-bash}" "$here/..."`, com o comentário de que alguns extratores tiram o bit de execução. Se a instalação do plugin perder o bit, só esses dois quebram.
- `task-done` roda o comando de teste que o chamador passa depois de `--`, grava a saída em `task-N-tests.log` no workspace e só acrescenta a linha ao `progress.md` se o comando sair com 0.
- `task-brief` apaga só o próprio arquivo de saída quando o `awk` falha (`rm -f "$out"`).
- `sdd-workspace` cria `.devorb/sdd/<plano>/`, grava `plan-path` com o caminho do plano e cria `.devorb/sdd/.gitignore` com `*` só se ele não existir. O `.gitignore` da raiz do DevOrb ignora `.superpowers/`, mas não `.devorb/`; o workspace se ignora sozinho.
- `review-package` só lê o git (`log`, `diff`, `rev-list`, `merge-base`) e escreve um arquivo no workspace. Recusa intervalo vazio ou HEAD que não descende de BASE (saída 3).
- Nenhum script acessa a rede nem lê fora do repositório e do arquivo de plano por conta própria. A exceção é o comando de teste que `task-done` executa: ele é do chamador e pode fazer qualquer coisa, inclusive acessar a rede.
- Os comentários citam issues do Superpowers (`#2040`, `#1799`, `#2459`, `#2496`, `#2436`), que ficaram como estavam.

## Revisões

- **2026-11-11, antes do `npm test`.** O primeiro rascunho da regra em `prompts/implementer.md` ficou perto do Karpathy em três frases: o título "every changed line traces to this task", "even when you would write them differently" e a lista "import, variable, function" do que a mudança deixou sem uso. As três foram reescritas sem a fonte aberta ("Your diff answers to the brief", "Your taste is not a reason to edit", "a helper you replaced, an import only the old code used"), e as menções em `SKILL.md`, `references/inline.md` e `prompts/task-reviewer.md` seguiram a nova redação.
- **2026-11-12, depois da revisão do commit `8a8d389`.** `SKILL.md` foi de 12.857 para 13.350 bytes (cerca de 3.215 para 3.338 tokens).
  - **USER DECIDES:** `devorb:reviewing` entrega à parte os itens que só o usuário decide (teste, portão ou critério de aceite afrouxado). Entrou uma terceira lista, "User decides", com os itens copiados sem mudança e nunca corrigidos nem decididos por `Ruling:`: `SKILL.md` (lista final e `Connects to`), `references/final-review.md` (separados antes da triagem, linha `Final: user decides:` no ledger, coletados no fim), `references/inline.md` (o mesmo na revisão final inline) e `skills/using-devorb/references/claude-code-tools.md` (o orquestrador repassa as duas listas).
  - **Ordem da evidência:** `references/final-review.md` e `references/inline.md` rodam a suíte inteira fresca por `devorb:verifying` antes da revisão e entregam comando e contagens a `devorb:reviewing`. A rodada depois da onda de correção continua.
  - **Segurança do trabalho do usuário:** o prompt de quem implementa proíbe `stash`, `reset --hard`, `checkout --`, `clean` e `push` ("commit ou relato"). No modo paralelo, o reset para a ponta da integração é `git reset --hard <T>` e só vale com `git status --porcelain` e `git log <T>..HEAD` vazios; fora isso, NEEDS_CONTEXT. Sem worktree, o setup roda `git status --porcelain` e pergunta se a árvore tem trabalho não commitado.
  - **Consentimento do paralelo:** a pergunta sobre rodar tasks em paralelo, um worktree cada, sai junto com a do worktree no setup, em vez de no meio da execução.
  - **Ajustes menores:** "by default" na abertura; "never merge outside the integration branch" na entrega; no revisor da task, item mandado pelo plano é decidido pelo controlador (como em `fix-loop.md`), não pelo usuário; "— <cost if wrong>" nos formatos de `Ruling:` de `fix-loop.md` e `inline.md`; `inline.md` passa ao revisor as linhas `Ruling:`, `parked` e `minor (deferred)`, como `final-review.md`; o workspace é apagado depois da onda de correção, com as listas coletadas; o refactor de `devorb:tdd` só nas linhas que o ciclo escreveu ou mudou também responde à brief; `inline.md` chama os scripts com `bash`; "dead code that was already there" no revisor.
  - **Script:** o comentário da linha 9 de `sdd-repo` ficou neutro sobre o commit do plano. Tabela e lista de mudanças acima atualizadas, com o novo SHA-256.
  - **Ledger:** registrada a reescrita da terceira parada e qualificada a frase sobre rede (o comando de `task-done` é do chamador).
- 2026-11-13, Task D7 do plano de design e Task M4 do plano mobile: ligação aos setores de design e mobile. O despacho nomeia `devorb:motion` quando algo na tela se move e `devorb:native-app` quando o projeto é app (`expo` no `package.json` ou `AndroidManifest.xml`), e `Connects to` lista as duas. Nenhuma regra muda. `SKILL.md` foi de 13.350 para 13.687 bytes.
- **2026-11-17, Task 6 do plano de qualidade de design: espelho do construtor.**
  - `SKILL.md`: a task de interface nomeia no despacho o contrato (`## Direção visual`), o `DESIGN.md`, o pacote (`design/referencias/<slug>/`) quando o contrato tem um, o caminho absoluto do `references/floor.md` de `devorb:visual-direction`, o sim explícito do usuário para instalar Playwright, se houver, e a ordem de rodar o espelho antes do commit. `Connects to` passou a citar `floor.md`, `shoot.mjs` e `rules.mjs`. Foi de 13.687 para 14.310 bytes (cerca de 3.578 tokens, teto 5.000).
  - `prompts/implementer.md`: novo passo 3, "Mirror", antes do commit (o commit virou 4 e o self-review, 5), e a seção Mirror com os caminhos a preencher, os cinco passos, a regra de instalação de `devorb:browser-testing` e a linha `Mirror:` do relatório. O passo fica antes do commit, e não logo antes do self-review como dizia o plano, porque o self-review vem depois do commit e o espelho tem de olhar a página antes de ela entrar no histórico.
  - `prompts/task-reviewer.md`: numa task de interface, a linha `Mirror:` faltando, ou `not run` sem motivo, conta como Missing.
  - `references/inline.md`: quem executa inline roda o mesmo espelho antes do commit e põe a linha `Mirror:` no ledger.
  - Origem: taste-skill (portão com no máximo 3 rodadas e prints por largura) e Hallmark (construir e revisar o hero antes de seguir), só ideias, com `textReuse: false`. Regra própria 4.
  - Caso novo `evals-outside/implementing-espelho-em-breve`, fora do sandbox porque precisa de navegador. Graders: `mirror-ran`, `report-field`, `brief-carries`, `result` e `result-scale`. Um subagente novo escreveu um caso reservado no sandbox, que não abri.
- **2026-11-18, decisão do dono: grader `report-field` estrito.** Em `evals-outside/implementing-espelho-em-breve/graders/report-field.md` saiu a alternativa `Mirror: not run \(`: só passa uma escrita de `task-<n>-report.md` com `Mirror: rounds <número>/3`, porque o espelho tem de rodar. Conferido nos rastros reais do GREEN (`.arms/devorb@9af742a`): as duas rodadas `devorb` passam e as duas `none` falham. Amostras sintéticas: Write e Bash com `Mirror: rounds <n>/3` (número) passam; Write e Bash com `Mirror: not run (` falham; o modelo `Mirror: rounds <n>/3` sem número falha.
