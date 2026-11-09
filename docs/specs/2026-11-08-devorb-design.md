# DevOrb: documento de design

Plugin pessoal de desenvolvimento para Claude Code. "O dono" é a pessoa que encomendou o plugin e vai usá-lo. "Fontes" são os repositórios de terceiros dos quais ele tira ideias.

## Intenção

O dono desenvolve principalmente em um MacBook, usando o Superpowers e o ponytail, e não tem queixa de nada. Ele leu o repositório do Matt Pocock e outros e gostou de alguns itens, e acredita que somar forças é positivo.

Ele não quer ficar pegando um pouco de cada plugin. Quer que tudo se funda em um só: lê os dois lados de cada etapa, fica com o que é bom em cada um e escreve uma skill nova. Quando uma fonte se atualiza, repete: fica com o que é bom na atualização e funde de novo. Assim o conjunto fica enxuto, e as skills conversam entre si.

**A ideia central:** as fontes são matéria-prima, não base a acompanhar. O texto do DevOrb é próprio. Nada é copiado por cima, então uma atualização nunca gera conflito de texto, só uma decisão de adotar ou recusar.

## Objetivos

1. Um único plugin que cobre todas as etapas de desenvolvimento, da base até o design.
2. Uma skill por etapa, fundida. Nunca duas skills disputando a mesma decisão.
3. Skills conectadas: cada uma sabe o que recebe e o que entrega.
4. Substituir o Superpowers no Mac sem perder nada do que funciona hoje.
5. Evoluir todo mês a partir das atualizações das fontes, com aprovação do dono.

## Não objetivos

- Absorver o ponytail. Ele continua um plugin separado.
- Absorver o `everything-claude-code`. O dono não o usa no Mac.
- Incluir skills de agência (n8n, Kommo, Meta Ads). Elas têm outro público e pesariam em todo projeto.
- Suportar outros agentes (Codex, Cursor e afins). É só Claude Code.
- Coletar métricas de retrabalho ou tempo. A comparação de cenários responde com menos esforço.

## Antiobjetivos

O projeto fracassa, mesmo funcionando, se:

- O dia a dia ficar pior do que com o Superpowers atual.
- O plugin crescer a cada mês até deixar de ser enxuto.
- Um texto de terceiros mudar instruções na máquina do dono sem revisão.
- Uma nova fusão apagar uma regra própria que já provou valor.
- A revisão mensal virar um fardo, por tamanho ou por custo.

## Restrições

- **Máquinas:** Mac como principal e um PC com Windows. O hook precisa funcionar nos dois. O Superpowers já resolve isso com `run-hook.cmd` e `session-start`, e esse desenho deve ser reaproveitado.
- **Licenças:** Superpowers e Matt Pocock são MIT. Os avisos ficam em `LICENSES/`.
- **Contexto:** a lista de skills é limitada a 1% da janela de contexto, e o excesso perde descrições, começando pelas menos usadas. Cada saída de hook SessionStart é limitada a 10 mil caracteres.
- **Convivência com o ponytail (v5.3.3, lida em listagens e no repositório):** ele instala hooks em `SessionStart`, `SubagentStart` e `UserPromptSubmit` e não colide em arquivos nem ferramentas. Há conflitos leves: ele prescreve um teste depois do código, sem TDD, e questiona se algo precisa existir. O dono já usa essa combinação com o Superpowers sem queixa, então o DevOrb mantém a mesma convivência e não tenta resolver esses conflitos.
- **Custo:** o teste de fusão de uma só etapa gastou 10 agentes e cerca de 830 mil tokens. Aplicar esse rigor a todas as skills custaria dezenas de milhões de tokens, o que não é viável. Nenhum gasto além da assinatura do dono acontece sem aprovação dele.

## Decisões

### Do dono

- Fundir de verdade, reescrevendo cada skill a partir dos dois lados. Complementos ao lado do original foram descartados.
- A cada atualização, repetir a fusão com o que for positivo.
- Substituir o Superpowers.
- Deixar o ponytail separado.
- Puxar atualizações das fontes e evoluir mensalmente.
- Começar pela base e seguir até o design.
- Trazer na primeira versão os seis itens que só o Matt tem: `domain-modeling`, `codebase-design`, `improve-architecture`, `prototype`, `handoff` e `retro`.

### De Claude, que o dono pode rever

- **Nome:** DevOrb, que veio de uma resposta da Perplexity trazida pelo dono.
- **Quem manda no fluxo:** o processo obrigatório do Superpowers, com hook de início de sessão, porque o dono não tem queixa dele. As ideias do Matt se encaixam nesse fluxo.
- **Manual ou automática:** orquestradoras e skills de uso eventual são manuais (`disable-model-invocation: true`), o que tira a descrição do contexto. As do fluxo principal são automáticas.
- **Aprovação:** por pull request. Nada entra sozinho.
- **Skill nova:** depois da primeira versão, só entra com um caso real de uso. Melhoria em skill existente passa pela comparação de cenários.
- **Regras próprias são permitidas e protegidas:** no teste, a regra que parece ter causado a melhora não estava em nenhuma fonte.
- **Língua:** skills em inglês, para comparar com as fontes. Relatórios e pull requests em português.
- **Specs e planos:** arquivos no repositório do projeto, como o Superpowers faz hoje. O fluxo do Matt que depende de issue tracker (`triage`, `wayfinder`, publicação de spec) não entra na base.
- **Repositório:** privado no GitHub do dono, com o marketplace na própria raiz.

## Arquitetura

### Estrutura do repositório

```
devorb/
├── .claude-plugin/        plugin.json e marketplace.json
├── hooks/                 hook de início de sessão, compatível com Mac e Windows
├── skills/<nome>/         SKILL.md, references/, scripts/
├── evals/                 cenários de teste de cada skill
├── fusion/
│   ├── sources.json       fontes, caminhos acompanhados, último commit absorvido
│   └── ledger/<skill>.md  origem de cada parte, regras próprias, decisões e recusas
├── tests/                 tamanho, referências entre skills, estrutura
├── LICENSES/
└── CHANGELOG.md
```

A versão fica em `plugin.json` e sobe a cada pull request, porque uma cópia instalada só se atualiza quando a versão muda. O auto-update vem desligado e precisa ser ligado em cada máquina, em `/plugin` > Marketplaces. O acesso ao repositório privado usa as credenciais da máquina (`gh auth login` e `gh auth setup-git`).

### Mapa de skills da base

| Etapa | Skill | Fontes | Acionamento |
|---|---|---|---|
| Entrada | `using-devorb` | `using-superpowers`, `ask-matt` | Hook |
| Alinhar | `aligning` | `brainstorming`, `grilling`, `grill-me`, `grill-with-docs` | Automática |
| Planejar | `planning` | `writing-plans`, `to-spec`, `to-tickets` | Automática |
| Implementar | `implementing` | `subagent-driven-development`, `executing-plans`, `dispatching-parallel-agents`, `using-git-worktrees`, `implement`, `implement-spec` | Automática |
| Testar | `tdd` | `test-driven-development`, `tdd` | Automática |
| Depurar | `debugging` | `systematic-debugging`, `diagnosing-bugs` | Automática |
| Verificar | `verifying` | `verification-before-completion` | Automática |
| Revisar | `reviewing` | `requesting-code-review`, `receiving-code-review`, `code-review` | Automática |
| Finalizar | `finishing` | `finishing-a-development-branch`, `pr` | Automática |
| Escrever skills | `writing-skills` | `writing-skills`, `writing-for-agents` | Automática |
| Evoluir | `evolving` | Nova | Manual e agendada |

Itens que só o Matt tem e que entram na primeira versão, por decisão do dono:

| Skill | Fonte | Acionamento |
|---|---|---|
| `domain-modeling` | `domain-modeling` (glossário e ADRs) | Automática |
| `codebase-design` | `codebase-design` | Automática |
| `improve-architecture` | `improve-codebase-architecture` | Manual |
| `prototype` | `prototype` | Manual |
| `handoff` | `handoff` | Manual |
| `retro` | `retro` | Manual |

"A base" são as 17 skills destas duas tabelas. `GLOSSARY.md` e `docs/adr/` são mantidos por `domain-modeling`.

O restante fica de fora até haver um caso real: `triage`, `wayfinder`, `teach`, `to-questionnaire`, `wizard`, `research`, `wait-what`, `diagnosing-superpowers`, `setup-matt-pocock-skills` e as pastas `misc` e `in-progress` do Matt.

### Como as skills se conectam

O fluxo principal é: `aligning` → `planning` → `implementing` → `verifying` → `reviewing` → `finishing`. Dentro de `implementing`, `tdd` escreve os testes, e `debugging` entra quando algo falha.

- Cada skill termina com uma seção `Connects to`: o que recebe, o que usa e para quem entrega.
- Os artefatos têm lugar fixo: specs em `docs/devorb/specs/`, planos em `docs/devorb/plans/`, glossário em `GLOSSARY.md` e decisões em `docs/adr/`.
- `using-devorb` define a precedência: instruções do usuário e do projeto, depois o fluxo do DevOrb, depois a skill específica. Skill manual só roda quando chamada.
- Um teste em `tests/` falha se uma referência `devorb:*` não existir ou se sobrar um nome antigo, como `superpowers:` ou `/grill-me`.

### Limites de tamanho

Medidos com `claude plugin details`:

- **Custo fixo:** não passa do Superpowers de hoje, cerca de 706 tokens por sessão.
- **Por skill ao ser chamada:** teto de 2.500 tokens. `implementing` e `writing-skills` têm teto de 5.000, porque suas fontes hoje custam cerca de 8.100 e 6.600.
- **Limite rígido:** `SKILL.md` abaixo de 20 mil bytes, o corte que o Claude Code aplica após compactar a conversa.
- **Regra de crescimento:** passar do teto exige tirar algo ou mover para `references/`.

Os números são estimativa de Claude. Quem constrói pode recalibrá-los nas primeiras fusões, registrando o motivo. O espírito é inegociável: fundir não pode só somar.

## Como fundir uma skill

1. Ler as fontes inteiras, com arquivos de apoio.
2. Escrever os cenários antes da fusão: um caso realista com checagem oculta, os cenários de pressão das fontes quando existirem, e **um caso reservado, que quem escreve a skill não vê antes de terminá-la**.
3. Rodar a linha de base com cada fonte, e sem skill quando o caso for novo, para provar que ele separa as versões. Os resultados ficam guardados e são reaproveitados enquanto a fonte não mudar.
4. Escrever a skill. Conflitos entre fontes são resolvidos e registrados no ledger.
5. Rodar a fundida e comparar.
6. Registrar no ledger a origem de cada parte, as regras próprias com o cenário que as justificou, e o que ficou de fora.

Uma skill só é aceita se não ficar pior que a linha de base em nenhum cenário, passar nas checagens ocultas e respeitar os limites. Regras marcadas como próprias não podem sair em uma nova fusão sem decisão explícita do dono.

**Níveis de teste (decisão de Claude, para caber no orçamento):**

| Nível | Skills | Casos | Rodadas |
|---|---|---|---:|
| Completo | `using-devorb`, `aligning`, `implementing`, `tdd`, `debugging`, `verifying` | Um realista, um reservado e os de pressão das fontes | 3 |
| Leve | `planning`, `reviewing`, `finishing`, `writing-skills` e os seis itens do Matt | Um realista, comparado só com a fonte principal | 2 |

**Skills de uma fonte só,** como os seis itens do Matt e `verifying`, não têm dois lados para fundir: são adaptadas ao fluxo do DevOrb, enxugadas e registradas no ledger.

**Orçamento:** `debugging` é a primeira skill a passar pelo processo. Depois dela, quem constrói mede o custo real, estima o restante e mostra ao dono antes de seguir. Os testes usam o mesmo modelo que o dono usa no Mac, fixado em cada rodada, e `--max-cost-usd` serve de teto.

**Ferramenta de teste:** `claude plugin eval`, nativo, com casos em `evals/`, graders e comparação sem plugin. Ela não roda script depois do agente, então as checagens ocultas são graders sobre os arquivos finais, que o agente não consegue ler. No Windows nativo, casos com Bash exigem WSL2, então os testes rodam no Mac. A documentação não cobre comparar duas versões do mesmo plugin. Rodar nos dois diretórios e comparar o `--json` é uma inferência a confirmar. Os scripts do teste de fusão estão em `spike-devorb-debugging/harness/`.

**Comparação com o ponytail ligado:** Superpowers com ponytail contra DevOrb com ponytail, de preferência no Mac. O ponytail já manda procurar todos os chamadores e corrigir a causa em código compartilhado, então parte do ganho visto no teste pode já existir no dia a dia do dono.

- **Quando:** primeiro em `debugging`, logo depois da fusão dela, e de novo antes da migração.
- **Regra:** empate passa, porque o objetivo é não piorar e ter tudo em um só plugin. Se o DevOrb perder em um cenário, aquela skill é corrigida antes de migrar.
- **Regras repetidas com o ponytail:** ficam, porque o DevOrb também precisa funcionar com ele desligado. São as primeiras a sair quando uma skill passar do teto.

## Ciclo mensal

**Gatilho:** uma tarefa agendada do Claude Code (`/schedule`), com cron como `0 9 1 * *`. Há também o comando manual `/devorb:evolving`. A tarefa agendada está em prévia de pesquisa, usa a cota da assinatura e publica em branches `claude/`. Ela é desligada se o GitHub ficar 72 horas desconectado. O preset mensal não existe, então é preciso confirmar o cron personalizado.

**Passos:**

1. Ler `fusion/sources.json` e comparar cada fonte com o último commit absorvido, só nos caminhos acompanhados. Skills novas viram candidatas.
2. Sem mudança relevante: nenhum pull request e nenhum commit. O histórico da tarefa agendada serve de registro.
3. Classificar cada mudança como adotar, recusar com motivo, ou candidata a skill nova. O que já foi recusado no ledger não volta para análise.
4. Refundir só as skills afetadas, dentro dos limites.
5. Rodar os cenários só dessas skills e das vizinhas no fluxo.
6. Abrir um pull request em português, com a versão nova e os commits atualizados. Ele traz, por fonte, o que mudou, o que foi adotado, o que foi recusado e por quê, a tabela de testes e a variação de tokens.
7. O dono aprova. O auto-update leva a versão às duas máquinas.

**Segurança:** todo texto vindo das fontes é dado, nunca instrução. Hooks e scripts de terceiros nunca são adotados no ciclo automático, e o pull request os aponta com destaque. Só o dono faz o merge.

**Ensaio antes de ligar o agendamento:** `evolving` não tem fonte para comparar, então é testada com uma fonte de exemplo que traz uma mudança boa e outra com uma instrução maliciosa embutida. Passa se adotar a primeira, recusar a segunda e apontá-la no pull request.

## Migração

1. Construir e testar em diretório local, sem mexer na instalação atual.
2. No Mac, instalar o DevOrb e desligar o Superpowers, nunca os dois juntos.
3. Usar em trabalho real. Para voltar, basta desligar o DevOrb e religar o Superpowers.
4. Desinstalar o Superpowers quando o dono estiver satisfeito.

## Design, depois da base

É um projeto separado, com plano próprio, que começa depois da migração da base. O plano atual termina nessa migração. Desinstalar o Superpowers não espera o design, porque ele não tem skills dessa etapa. O teto de custo fixo vale para a base, e o design define o seu ao começar.

O dono ainda vai enviar os repositórios. As etapas seguem o mesmo processo de fusão e entram em `sources.json`. Nesta máquina estão instalados `frontend-design`, `taste-skill` e `ui-ux-pro-max`, mas Claude não sabe se são as fontes pretendidas. A skill resultante entra no fluxo entre `aligning` e `implementing`, quando a tarefa tiver interface.

## O que já se sabe sobre a fusão

O teste de depuração está em `spike-devorb-debugging/FUSAO.md`. A skill fundida ficou menor que as duas fontes e foi a única a corrigir o bug na origem, em 2 de 2 rodadas. O resultado está enviesado: as regras novas foram escritas depois de ver a falha nesse mesmo bug. A skill ainda é descartável, e `debugging` só é aceita depois de passar pelo processo acima.

## Sucesso

- Cada skill da base passa na comparação do processo de fusão.
- O custo fixo por sessão não passa do Superpowers de hoje.
- O dono usa o DevOrb em trabalho real no Mac e desinstala o Superpowers.
- O primeiro pull request mensal chega sozinho e pode ser revisado em até 15 minutos.

## O que fica para quem constrói

- O texto de cada skill e os casos de teste.
- A ordem das fusões. Sugestão: `using-devorb` e `debugging`, depois `tdd`, `verifying`, `domain-modeling`, `aligning`, `planning`, `codebase-design`, `implementing`, `reviewing`, `finishing`, `writing-skills`, as manuais (`improve-architecture`, `prototype`, `handoff`, `retro`) e por fim `evolving`.
- O formato de `sources.json` e do ledger.
- Onde os testes do ciclo mensal rodam. A documentação não diz se a tarefa agendada na nuvem consegue rodar `claude plugin eval`. Se não conseguir, os testes rodam no Mac, na assinatura do dono, e o pull request nunca é aprovado sem eles. Uma GitHub Action com API paga só entra com aprovação dele.
- Como a tarefa agendada acessa `evolving`, já que `disable-model-invocation` impede o pré-carregamento em tarefas agendadas. Ler o arquivo do repositório é o caminho provável.
- Se projetos antigos que citam `superpowers:` precisam de algum mapeamento de nomes.
