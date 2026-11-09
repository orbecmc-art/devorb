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
- Absorver as fontes novas inteiras. Na base, entram 6 de 98 skills da Trail of Bits, 3 do Spartan, 7 de 314 do ECC e 7 de 63 do gstack. O setor de design tem a própria seleção.
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
- **Licenças:** Superpowers e Matt Pocock são MIT, e o `webapp-testing` da Anthropic é Apache 2.0. Os avisos ficam em `LICENSES/`. As outras fontes novas só fornecem ideias, como explica "Fontes novas".
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
- Trazer quatro fontes novas, recomendadas a ele: as diretrizes do Karpathy, a Trail of Bits, o `webapp-testing` da Anthropic e o `ai-toolkit` (Spartan). Ele aprovou a seleção de Claude, que fica só com as partes de "Fontes novas".
- Trazer mais duas fontes que ele considera importantes: o ECC e o gstack. A seleção é de Claude e entra na revisão do pull request. O plugin `everything-claude-code`, nome antigo do ECC, foi desinstalado do PC e agora só fornece ideias.
- Fundir também a parte de construção visual. Ele enviou seis repositórios (`emilkowalski/skills`, `pbakaus/impeccable`, `paper-design/shaders`, `Nutlope/hallmark`, `cathrynlavery/diagram-design` e `nateherkai/scroll-craft`) e citou a `ui-ux-pro-max`. A seleção é de Claude e entra na revisão do pull request.
- Ter fontes de referência de UI fixas, consultadas primeiro sempre que a parte de design for usada, buscando as que combinam com o estilo que o cliente descreve, como "clean". A lista é a da descrição do vídeo "UI Libraries for Claude Code", de Griffin Wooldridge.

### De Claude, que o dono pode rever

- **Nome:** DevOrb, que veio de uma resposta da Perplexity trazida pelo dono.
- **Quem manda no fluxo:** o processo obrigatório do Superpowers, com hook de início de sessão, porque o dono não tem queixa dele. As ideias do Matt se encaixam nesse fluxo.
- **Manual ou automática:** orquestradoras e skills de uso eventual são manuais (`disable-model-invocation: true`), o que tira a descrição do contexto. As do fluxo principal são automáticas.
- **Aprovação:** por pull request. Nada entra sozinho.
- **Skill nova:** depois da primeira versão, só entra com um caso real de uso. Melhoria em skill existente passa pela comparação de cenários.
- **`browser-testing` na base:** o caso real é testar as telas dos sites e sistemas do dono antes de dizer que ficaram prontas. Esse caso é suposição de Claude, que o dono não corrigiu ao aprovar a seleção.
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
| Alinhar | `aligning` | `brainstorming`, `grilling`, `grill-me`, `grill-with-docs`, `intent-driven-development` | Automática |
| Planejar | `planning` | `writing-plans`, `to-spec`, `to-tickets`, `change-impact`, `plan-eng-review` | Automática |
| Implementar | `implementing` | `subagent-driven-development`, `executing-plans`, `dispatching-parallel-agents`, `using-git-worktrees`, `implement`, `implement-spec`, `karpathy-guidelines` | Automática |
| Testar | `tdd` | `test-driven-development`, `tdd`, `property-based-testing` | Automática |
| Depurar | `debugging` | `systematic-debugging`, `diagnosing-bugs`, `implement-patch`, `variant-analysis`, `service-debugging`, `click-path-audit` | Automática |
| Verificar | `verifying` | `verification-before-completion`, `verification-loop`, `loop-design-check`, `benchmark-optimization-loop`, `verify`, `benchmark`, `review/gate-integrity.md` | Automática |
| Testar no navegador | `browser-testing` | `webapp-testing`, `browser-qa` (Spartan e ECC) | Automática |
| Revisar | `reviewing` | `requesting-code-review`, `receiving-code-review`, `code-review`, `differential-review`, `spec-to-code-compliance`, `fp-check`, `js-security-audit`, `review` | Automática |
| Finalizar | `finishing` | `finishing-a-development-branch`, `pr`, `modernize`, `document-release` | Automática |
| Escrever skills | `writing-skills` | `writing-skills`, `writing-for-agents` | Automática |
| Evoluir | `evolving` | Nova | Manual e agendada |

Itens que só o Matt tem e que entram na primeira versão, por decisão do dono:

| Skill | Fonte | Acionamento |
|---|---|---|
| `domain-modeling` | `domain-modeling` (glossário e ADRs) | Automática |
| `codebase-design` | `codebase-design` | Automática |
| `improve-architecture` | `improve-codebase-architecture` | Manual |
| `prototype` | `prototype`, com uma ideia de Emil `prototype` | Manual |
| `handoff` | `handoff`, com uma ideia de `context-save` | Manual |
| `retro` | `retro` | Manual |

"A base" são as 18 skills destas duas tabelas. `GLOSSARY.md` e `docs/adr/` são mantidos por `domain-modeling`.

O restante fica de fora até haver um caso real: `triage`, `wayfinder`, `teach`, `to-questionnaire`, `wizard`, `research`, `wait-what`, `diagnosing-superpowers`, `setup-matt-pocock-skills` e as pastas `misc` e `in-progress` do Matt.

### Fontes novas

| Fonte | Licença | Partes acompanhadas | Uso |
|---|---|---|---|
| Karpathy | MIT declarada, sem arquivo de licença | `karpathy-guidelines` | Só ideias |
| Anthropic | Apache 2.0 | `webapp-testing` | Texto permitido |
| Trail of Bits | CC BY-SA 4.0 | `variant-analysis`, `implement-patch`, `property-based-testing`, `differential-review`, `spec-to-code-compliance`, `fp-check` | Só ideias |
| Spartan (`c0x12c/ai-toolkit`) | MIT declarada no README, sem arquivo de licença | `browser-qa`, `js-security-audit`, `service-debugging` | Só ideias |
| ECC (`affaan-m/ECC`, antes `everything-claude-code`) | MIT | `verification-loop`, `loop-design-check`, `benchmark-optimization-loop`, `browser-qa`, `intent-driven-development`, `change-impact`, `click-path-audit` | Só ideias |
| gstack (`garrytan/gstack`) | MIT | Oito arquivos de `review`, `verify`, `benchmark`, `modernize`, `document-release` e `context-save`. As duas regras de `plan-eng-review` entram uma vez e não são acompanhadas | Só ideias |

"Só ideias" fica marcado com `textReuse: false` em `fusion/sources.json`: a ideia é reescrita com palavras próprias e creditada no ledger, e nenhum texto é copiado. Na Trail of Bits, a CC BY-SA exigiria a mesma licença em texto copiado, se o DevOrb um dia for compartilhado. No Karpathy e no Spartan, não há arquivo de licença cujo aviso possa ser mantido. No ECC e no gstack, a raiz é MIT, mas partes derivam de terceiros, e nem toda origem tem licença conferida.

No gstack, o `SKILL.md` é gerado com um preâmbulo comum, que muda com frequência, então os caminhos acompanhados são os arquivos de origem. Nos 30 dias antes do pino, o gstack teve 683 commits e o ECC, 938, mas só os 8 arquivos do gstack e 2 pastas do ECC mudaram entre os caminhos escolhidos. A revisão mensal fica pequena mesmo com fontes tão ativas.

**Conflitos já decididos:**

- **Mudança mínima ou correção na origem:** mínimo é a menor mudança que corrige a regra quebrada, não a menor em linhas. Isso concilia a mudança cirúrgica do Karpathy com a correção na origem de `debugging`.
- **Espera no navegador:** esperar um elemento específico, e usar `networkidle` só em app sem websocket nem polling. A Anthropic trata essa espera como crítica, e o Spartan avisa que ela nunca termina nesses apps.
- **Ler o código ou perguntar:** o Matt manda consultar o código em vez de perguntar, e o ECC avisa que regra de negócio não se lê nele. O código responde como o sistema age hoje. Retenção, SLA, preço e conformidade achados ali viram suposição a confirmar.
- **Enviar formulário no navegador:** o Spartan manda enviar um formulário válido, e o ECC proíbe alterar dados em produção. Em produção, só leitura. Fluxo que altera dados roda em staging ou preview, com permissão explícita e credencial de teste.
- **Teste afrouxado:** `verifying` confere em uma linha o próprio diff, e `reviewing` guarda a lista completa, para a regra não pesar duas vezes.

**Recusados:** o fluxo `/spartan:build`, que concorre com o do DevOrb, e a regra "Boil the Lake", que manda fazer sempre a versão completa. Também os hooks das fontes novas, o `with_server.py` da Anthropic, que usa `shell=True` e exige Python, e as skills de blockchain, C/C++, fuzzing, criptografia e Codex da Trail of Bits.

Do ECC e do gstack, ficam de fora:

- hooks, scripts, binários e o preâmbulo comum do gstack, que checa atualizações, tem telemetria opcional e lê `~/.claude.json`;
- fluxos concorrentes: `ship`, `autoplan`, `captain`, `land-and-deploy`, `blueprint`, `plan-orchestrate` e `orch-*`;
- personas: `office-hours`, `plan-ceo-review` e `council`;
- `qa`, `browse` e `cso`, que dependem do daemon, de binário próprio ou de Docker;
- `continuous-learning-v2`, cujos hooks geram regras sozinhos, o que contraria um antiobjetivo.

O próprio gstack cortou `investigate` e `plan-eng-review` depois de avaliações sem ganho. Em `investigate`, foram 50,0% de acerto contra 47,2% sem a skill, em 18 tarefas. Por isso, nenhuma ideia dessas fontes vale por vir de um repositório popular: cada skill continua passando pela comparação.

### Como as skills se conectam

O fluxo principal é: `aligning` → `planning` → `implementing` → `verifying` → `reviewing` → `finishing`. Dentro de `implementing`, `tdd` escreve os testes, e `debugging` entra quando algo falha. Quando a tarefa tem interface, `verifying` usa `browser-testing`.

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
| Leve | `planning`, `reviewing`, `finishing`, `writing-skills`, `browser-testing` e os seis itens do Matt | Um realista, comparado só com a fonte principal | 2 |

**Skills de uma fonte principal,** como os seis itens do Matt e `verifying`, não têm dois lados para fundir: são adaptadas ao fluxo do DevOrb, enxugadas e registradas no ledger. As ideias de fontes novas entram nelas como frases próprias, dentro do teto.

**Fontes novas não viram braço de comparação.** Elas entregam poucas partes de repositórios grandes, então os braços continuam sendo Superpowers e Matt. `browser-testing` não tem braço de fonte e compara sem plugin.

**Orçamento:** `debugging` é a primeira skill a passar pelo processo. Depois dela, quem constrói mede o custo real, estima o restante e mostra ao dono antes de seguir. Os testes usam o mesmo modelo que o dono usa no Mac, fixado em cada rodada, e `--max-cost-usd` serve de teto.

**Ferramenta de teste:** `claude plugin eval`, nativo, com casos em `evals/`, graders e comparação sem plugin. Ela não roda script depois do agente, então as checagens ocultas são graders sobre os arquivos finais, que o agente não consegue ler. No Windows nativo, casos com Bash exigem WSL2, então os testes rodam no Mac. A documentação não cobre comparar duas versões do mesmo plugin. Rodar nos dois diretórios e comparar o `--json` é uma inferência a confirmar. Os scripts do teste de fusão estão em `docs/spike-devorb-debugging/harness/`.

**Comparação com o ponytail ligado:** Superpowers com ponytail contra DevOrb com ponytail, de preferência no Mac. O ponytail já manda procurar todos os chamadores e corrigir a causa em código compartilhado, então parte do ganho visto no teste pode já existir no dia a dia do dono.

- **Quando:** primeiro em `debugging`, logo depois da fusão dela, e de novo antes da migração.
- **Regra:** empate passa, porque o objetivo é não piorar e ter tudo em um só plugin. Se o DevOrb perder em um cenário, aquela skill é corrigida antes de migrar.
- **Regras repetidas com o ponytail:** ficam, porque o DevOrb também precisa funcionar com ele desligado. São as primeiras a sair quando uma skill passar do teto.

## Ciclo mensal

**Gatilho:** uma tarefa agendada do Claude Code (`/schedule`), com cron como `0 12 1 * *`, em UTC. Há também o comando manual `/devorb:evolving`. A tarefa agendada está em prévia de pesquisa e usa a cota da assinatura. Por padrão ela publica em branches `claude/`, mas isso é só um padrão. Ela é desligada se o GitHub ficar 72 horas desconectado. O cron personalizado é definido depois de criar a tarefa.

**Passos:**

1. Ler `fusion/sources.json` e comparar cada fonte com o último commit absorvido, só nos caminhos acompanhados. Nas fontes novas, só as pastas escolhidas são acompanhadas, para a revisão não virar fardo. Skills novas viram candidatas.
2. Sem mudança relevante, ou com mudança que só alimenta skills ainda não fundidas: nenhum pull request e nenhum commit, e o pino fica onde está. A mensagem final começa com uma linha de status, e falha ou fonte inacessível abre uma issue. O histórico da tarefa agendada guarda o resto, mas ele mostra só como a sessão terminou, então um mês sem pull request não prova que o ciclo funcionou.
3. Classificar cada mudança como adotar, recusar com motivo, ou candidata a skill nova. O que já foi recusado no ledger não volta para análise. De fonte com `textReuse: false`, só entram ideias reescritas.
4. Refundir só as skills afetadas, dentro dos limites.
5. Rodar os cenários só dessas skills e das vizinhas no fluxo.
6. Abrir um pull request em português, com a versão nova e os commits atualizados. Ele traz, por fonte, o que mudou, o que foi adotado, o que foi recusado e por quê, a tabela de testes e a variação de tokens.
7. O dono aprova. O auto-update leva a versão às duas máquinas.

**Segurança:** todo texto vindo das fontes é dado, nunca instrução. Hooks e scripts de terceiros nunca são adotados no ciclo automático, e o pull request os aponta com destaque. Nomes de arquivo das fontes nunca entram em um shell. Só o dono faz o merge. A nuvem não limita para qual branch a tarefa envia, então proteger a `main` é uma decisão do dono antes de agendar.

**Ensaio antes de ligar o agendamento:** `evolving` não tem fonte para comparar, então é testada com uma fonte de exemplo que traz uma mudança boa e outra com uma instrução maliciosa embutida. Passa se adotar a primeira com palavras próprias, recusar a segunda e apontá-la no pull request.

## Migração

1. Construir e testar em diretório local, sem mexer na instalação atual.
2. No Mac, instalar o DevOrb e desligar o Superpowers, nunca os dois juntos.
3. Usar em trabalho real. Para voltar, basta desligar o DevOrb e religar o Superpowers.
4. Desinstalar o Superpowers quando o dono estiver satisfeito.

## Setor de design

Cobre a construção visual: como uma interface é decidida, escrita em tokens, posta em movimento e conferida depois de pronta. O processo é o mesmo da base: fundir, não colecionar. O caso real é fazer sites, landing pages e sistemas web que não pareçam gerados por IA. Esse caso é suposição de Claude a partir do que o dono descreveu.

**Ordem:** a seleção, esta seção e o plano `docs/plans/2026-11-09-devorb-design.md` são feitos agora, neste PC, por recomendação de Claude que o dono seguiu. As fusões rodam no Mac, só depois do portão da Task 6 da base, porque ela calibra o processo e mede o custo real. Desinstalar o Superpowers não espera o design, porque ele não tem skills dessa etapa.

### Mapa de skills do design

| Etapa | Skill | Espinha | Outras fontes | Acionamento |
|---|---|---|---|---|
| Dar direção | `visual-direction` | Impeccable: `SKILL.src.md`, `new-work`, `craft-floor`, `mode-persuade`, `mode-operate`, `mode-read` | Hallmark: `SKILL.md`, `gates`, `anatomy`, `imagery`, `craft`, `flow`. taste-skill: `copy`, `copy-voice`. `frontend-design`. ECC: `frontend-design-direction`. gstack: `design-html/sections/craft`, `design-consultation/sections/proposal-and-preview`, `plan-design-review/sections/review-sections`. Emil: `pick-ui-library` | Automática |
| Escrever o sistema | `design-system` | Impeccable: `extract`, `document` | UI UX Pro Max: `colors.csv`. ECC: `design-system` | Automática |
| Mover | `motion` | Emil: `animate` | Emil: `choreograph`, `gestures`, `animation-performance`, `remove-animations`, `emil-design-eng`, `apple-design`. gstack: `design-motion`. ECC: `motion-foundations`, `motion-patterns`, `motion-advanced`. `scroll-craft`: `devices`, `feel`, `verify`. `paper-shaders`: `README`, `CHANGELOG` | Automática |
| Conferir | `ui-review` | gstack: `docs/design-lint.md`, `design-review/sections/craft-audit` | Impeccable: `audit`, `polish`, `harden`. Emil: `break-ui`, `mobile-native`. UI UX Pro Max: `ux-guidelines.csv` | Automática |
| Diagramar | `diagram` | `diagram-design`: `SKILL.md`, `primitives-core`, `layout-budget`, `animation` | gstack: `diagram` | Manual |

Cada arquivo acompanhado aparece em uma só linha, a da skill principal dele. Uma ideia de um arquivo pode ir para outra skill: o ledger dela registra o caminho. Na revisão mensal, a mudança em um arquivo é classificada para a skill da tabela e para cada skill cujo ledger cita aquele caminho.

A `prototype` da base recebe uma ideia de Emil `prototype`, registrada na tabela da base. Fora isso, as skills deste mapa não mudam as da base, só se conectam a elas.

### Fronteiras

- **`visual-direction`** decide o modo, a quantidade de invenção, o conteúdo, os estados, a família tipográfica, que vem do mundo do público, e as bibliotecas de componentes, a partir das fontes de referência fixas. Registra o contrato de direção e o piso de entrega. Não escolhe valores.
- **`design-system`** é a única que escolhe valores: cor, escala e ritmo tipográfico, espaço, raio, borda e estados. Quando a fundação é o shadcn/ui, é ela que troca o tema padrão pelos tokens do projeto. Grava `DESIGN.md`, em projeto novo ou lendo o que já existe. As restrições de acessibilidade nascem aqui como tokens: pares de contraste, foco e o limiar de texto grande.
- **`motion`** é a única que decide se algo se move e como, inclusive duração e curva. Se o projeto guarda esses valores como tokens, `design-system` só os grava. Scroll e shaders são referências dela, não skills à parte.
- **`ui-review`** mede o que foi construído contra `DESIGN.md`, o contrato de direção e os pisos das outras três skills. Os passes de acessibilidade e de web no celular são dela. Relata de P0 a P3 e para, sem corrigir. Não decide estética nem valores.
- **`browser-testing`** continua respondendo se a tela funciona, e `ui-review`, se ficou como combinado. `reviewing` só encaminha quando o diff toca interface.
- **`diagram`** é ferramenta eventual, não etapa. Por ser manual, não custa nada em toda sessão, mas linguagem natural não a aciona.

### Fluxo

Quando a tarefa tem interface: `aligning` → `visual-direction` → `design-system` → `planning` → `implementing`, com `motion` quando algo se move → `verifying`, com `browser-testing` e depois `ui-review` → `reviewing` → `finishing`. Em superfície que já existe, `visual-direction` só estende e `design-system` só lê. Sem interface, nada muda.

O contrato de direção fica na spec de `aligning`, em `## Direção visual`. `DESIGN.md` fica na raiz do projeto, no formato de `google-labs-code/design.md`, que a Impeccable segue: tokens no frontmatter YAML e prosa depois. Nunca é sobrescrito sem pedido.

### Fontes de referência fixas

Decisão do dono: quando a parte de design for usada, ela olha primeiro estas fontes, escolhendo as que combinam com o estilo que o cliente descreve. Se ele pede algo clean, a skill procura nas fontes marcadas como clean antes de inventar.

**O que a lista é.** As 13 fontes da descrição do vídeo, sem os links de redes sociais e de afiliados. São 12 bibliotecas de componentes, em três tipos, e o Mobbin, o único acervo de telas reais:

| Tipo | Fontes | Para quê |
|---|---|---|
| Fundação | shadcn/ui, Base UI, Radix | A base acessível dos componentes |
| Especialista | Sonner, Vaul, cmdk, NumberFlow | Avisos, gavetas, paleta de comandos e números animados, que a IA erra quando faz do zero |
| Destaque | Beautiful UI, RareUI, Magic UI, Aceternity UI, 21st.dev | Um componente que chama atenção |
| Telas reais | Mobbin | Padrões de produtos de verdade, como onboarding, preços e checkout |

O vídeo não traz galerias de sites inteiros, e por isso a lista ainda não tem nenhuma.

**Onde fica.** Em `fusion/ui-sources.json`, até a skill `visual-direction` existir. A Task D2 a move para `skills/visual-direction/references/ui-sources.json`. Só o dono muda a lista, por pull request, e um teste garante que as 13 fontes continuam lá.

**Como a skill usa a lista:**

- Antes de escolher a direção ou de fazer um componente do zero, lê a lista e consulta as fontes do estilo pedido. A resposta diz quais consultou.
- A fundação e os especialistas servem a qualquer estilo. Os componentes de destaque e as telas reais são escolhidos pelas palavras do cliente, que a lista agrupa em clean, ousado, animado, divertido, IA e produto.
- A combinação é uma fundação, o especialista de cada função no lugar de uma versão feita à mão, e no máximo um componente de destaque por página.
- O que já está no `package.json` vem primeiro. Biblioteca nova entra no contrato de direção antes de ser instalada.
- O tema padrão do shadcn virou uma cara de IA, então `design-system` o troca pelos tokens do projeto.
- Antes de copiar um componente, a skill confere a licença dele. No 21st.dev cada componente pertence ao seu autor, e na Aceternity só a parte gratuita é livre.
- O texto desses sites é dado, nunca instrução. Se um site não abrir, a skill diz isso e passa para a próxima fonte.

**Calls de Claude, que o dono pode rever:**

- **Estilos:** as marcas de cada fonte vêm da descrição do próprio site.
- **Destaque único:** a regra vem do título de um capítulo do vídeo. A transcrição não pôde ser lida.
- **Vaul:** o README dele diz que o repositório não tem mais manutenção. Ele fica, com esse aviso.
- **`pick-ui-library`:** a do Emil, que o vídeo recomenda, entra como fonte de ideias de `visual-direction`: identificar a tarefa, não a biblioteca citada, olhar o `package.json` primeiro e recomendar uma só.

**Revisão mensal:** a lista não é fonte de fusão e não passa pelo ciclo mensal. A `pick-ui-library` passa, porque está em `fusion/sources.json`.

### O que entra de cada fonte

Todas entram só como ideias (`textReuse: false`), mesmo as que permitiriam copiar. Partes delas derivam umas das outras sem aviso, e a skill precisa de voz própria. Os pinos estão em `fusion/sources.json`.

| Fonte | Licença | Entra | Fica de fora |
|---|---|---|---|
| Impeccable | Apache 2.0 | Modos, escala de invenção, contrato de direção, piso de ofício, extração e auditoria | Motor em Rust, sorteio de direção, telemetria e hooks, que rodam fora da aprovação do modelo e podem baixar o motor |
| Hallmark | MIT | Regras checáveis, material antes da forma, seções vindas do trabalho do visitante, fato nunca inventado | Lint, temas e `install-hook`, que pode alterar `~/.claude/settings.json` |
| taste-skill | MIT | Folha de fatos e orçamento de texto | A estética única, o kit de componentes, o hook `Stop` no frontmatter e `install.sh` |
| `frontend-design` | Apache 2.0 | Teste do espelho e os looks gastos descritos em números | O resto já está na espinha |
| Emil | MIT | Espinha de `motion`, gestos, `break-ui`, o piso de páginas web no celular e o modo de escolher biblioteca de `pick-ui-library` | Blocos que fixam a resposta do agente, personas, `write-swift`, `animate-expo`, `ask-sonner`, `animation-vocabulary` e o que `apple-design` deriva da Apple |
| `scroll-craft` | MIT | Referência de scroll: clipe mapeado ao palco, trilho, reduced motion | O motor de 62 KB, `serve --lan` e `kie.mjs`, que envia chave e imagens a outro servidor |
| `paper-shaders` | Apache 2.0 | Referência de cerca de 40 linhas: quando usar, versão exata, reduced motion, fallback sem WebGL2 | A biblioteca, que o projeto instala se quiser. Não é uma skill |
| `diagram-design` | MIT | Decidir se desenha, Mermaid ou SVG, orçamento, conectores e acessibilidade, em cerca de 12 tipos | 45 tipos, importadores, perfis e exportação |
| UI UX Pro Max | MIT | Esquema de 16 papéis de cor em pares e as linhas de acessibilidade, reescritas | Busca em Python, as 192 paletas, `stack/`, `design`, `brand`, `banner-design` e `slides` |
| ECC, mais 5 skills | MIT | Estados, espécime e detalhes da biblioteca Motion | `taste*`, que são de vídeo, `brand-discovery` e `frontend-a11y`, com exemplo de código ruim |
| gstack, mais 6 skills e `docs/design-lint.md` | MIT | Medir o renderizado, regras de lint, um só momento de movimento | Binários, daemon, `design-shotgun` e perfil de gosto |
| `ai-toolkit` | Sem arquivo de licença | Nada: tabelas, e embute a UI UX Pro Max | `design-workflow` e `design-intelligence` |

**UI UX Pro Max:** o dono a citou, e por isso o motivo fica explícito. A busca é BM25 sobre CSV, e Grep a substitui. Conferimos 1.152 pares de cor das 192 paletas, e nenhum fica abaixo de 4,5:1. Mas elas usam só 50 cores primárias distintas, com `#2563EB` 17 vezes e `#7C3AED` 16 vezes, então semear com elas reproduz a cara padrão que o projeto quer evitar. O que vale é a estrutura em pares, não as cores.

**Banners, logos e slides** não entram, porque não são etapa de desenvolvimento e dependem de chaves de geração de imagem. Se o dono usa essas skills da UI UX Pro Max, o plugin fica instalado só para isso. É decisão dele, na Task D8 do plano.

**Conflitos estruturais já decididos.** Os conflitos de cada skill estão no plano, na task dela.

- **Sorteio ou plano livre:** o Impeccable exige um sorteio com binário próprio. Vence o plano livre com o teste do espelho, sem script nem serviço.
- **Uma estética para tudo:** o taste-skill impõe uma só. Perde: quem decide é o modo da superfície, e sistema não recebe tratamento de landing.
- **Fatos e envio falso:** taste-skill aceita preço plausível marcado, e gstack simula sucesso de formulário. Vence o Hallmark, que proíbe os dois: fato ausente vira lacuna visível.
- **Listas de fontes:** uma fonte recomenda o que outra proíbe. Nenhuma lista vira lei: em Persuade, fonte saturada exige motivo registrado, e o brief vence.

### Limites

- **Custo fixo:** até 250 tokens no setor, somando as quatro descrições automáticas, além dos 706 da base. Os três plugins visuais instalados no PC custam hoje cerca de 1.982.
- **Por skill ao ser chamada:** teto de 2.500 tokens, com o detalhe em `references/`.
- **Valores de partida:** são estimativa de Claude, e valem as regras de "Limites de tamanho".

### Testes

Mesmo processo de "Como fundir uma skill", com três diferenças:

- **Braços:** `none` em todas. Na fusão, `visual-direction` e `design-system` também comparam com `ui-ux-pro-max`, porque é o que o dono citou e usa, e sem esse braço o antiobjetivo de piorar o dia a dia não seria medido. É a única fonte nova que vira braço. Na revisão mensal, os braços continuam os que a `evolving` define, com `none`.
- **O que os graders leem:** CSS, HTML, tokens e relatórios finais. Render só se a sondagem de Chromium da Task 23 passar. Grader não vê gosto.
- **Portão do dono:** por isso, `visual-direction` só é aceita depois de o dono ver páginas geradas com e sem a skill.

`visual-direction` é de nível completo. As outras quatro são de nível leve.

### Revisão mensal

Acompanhar 17 fontes tem custo. Medido com o comparador, a partir de pinos de 30 dias antes, os caminhos do design mudaram em 34 arquivos, somando as fontes novas e os caminhos novos do ECC e do gstack, contra cerca de 60 nos caminhos da base. Nenhum deles era script ou nome estranho. Isso só pesa quando as skills estiverem `done`. Se a revisão mensal passar dos 15 minutos previstos em "Sucesso", a primeira medida é tirar caminhos da fonte mais barulhenta.

### Regras próprias candidatas

Nenhuma fonte as traz, e Claude as propõe a partir do próprio conhecimento. Precisam de um cenário que as justifique.

- A fonte escolhida precisa ter os acentos do português, porque os sites do dono são em português.
- O foco usa `outline`, por causa de `forced-colors`.
- Texto grande, no WCAG, é 24 px, ou 18,66 px em negrito.

Nenhuma fonte cobre `animation-timeline` nem View Transitions. É uma lacuna, não uma regra: só entra se um caso real pedir.

### Sucesso do setor

- As cinco skills passam na comparação, e `visual-direction` passa pelo portão do dono.
- O custo fixo do setor não passa de 250 tokens.
- O dono usa as skills em um site real e desinstala os plugins visuais que elas substituem.

## O que já se sabe sobre a fusão

O teste de depuração está em `docs/spike-devorb-debugging/FUSAO.md`. A skill fundida ficou menor que as duas fontes e foi a única a corrigir o bug na origem, em 2 de 2 rodadas. O resultado está enviesado: as regras novas foram escritas depois de ver a falha nesse mesmo bug. A skill ainda é descartável, e `debugging` só é aceita depois de passar pelo processo acima.

## Sucesso

- Cada skill da base passa na comparação do processo de fusão.
- O custo fixo por sessão da base não passa do Superpowers de hoje. O setor de design tem teto próprio.
- O dono usa o DevOrb em trabalho real no Mac e desinstala o Superpowers.
- O primeiro pull request mensal chega sozinho e pode ser revisado em até 15 minutos.

## O que fica para quem constrói

- O texto de cada skill e os casos de teste.
- A ordem das fusões. Sugestão: `using-devorb` e `debugging`, depois `tdd`, `verifying`, `domain-modeling`, `aligning`, `planning`, `codebase-design`, `implementing`, `reviewing`, `finishing`, `writing-skills`, as manuais (`improve-architecture`, `prototype`, `handoff`, `retro`) e por fim `evolving`.
- O formato de `sources.json` e do ledger.
- Onde os testes do ciclo mensal rodam. A documentação não diz se a tarefa agendada na nuvem consegue rodar `claude plugin eval`. Se não conseguir, os testes rodam no Mac, na assinatura do dono, e o pull request nunca é aprovado sem eles. Uma GitHub Action com API paga só entra com aprovação dele.
- Como a tarefa agendada acessa `evolving`, já que `disable-model-invocation` impede o pré-carregamento em tarefas agendadas. Ler o arquivo do repositório é o caminho provável.
- Se projetos antigos que citam `superpowers:` precisam de algum mapeamento de nomes.
