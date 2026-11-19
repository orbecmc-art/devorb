# Changelog

## 1.15.0

- Cor: o par complementar passa a ser dividido por seção em Persuade (`color-finish`, `color-roles` com `complement`, `floor`, `hero-patterns`, `persuade`, `contract` e o tell 3 do crítico). `receitas-landing`: RED 0,75, GREEN 1,00. `ui-review-par-complementar`: RED 0,50, GREEN 1,00.
- Fontes do dono antes de qualquer design: portão na `visual-direction` §4 e no guia, mesmo sem pessoa; entradas `browser` sem navegador ganham uma tentativa de fetch; despacho e caminho inline do `implementing`; o `task-reviewer` exige `Sources:`; o crítico recebe `Sources:`. `implementing-fontes-ui`: 0 para 1,00. `arquitetura-clean`: 0,36 para 0,64 (os graders de fontes voltaram a passar; segue 0% de aprovação porque os graders de Sonner/toast falham: lacuna conhecida).
- Custo: US$ 43,09 de US$ 50 aprovados.
- Lacuna conhecida: faixa vinho (~355°) com laranja (~25°) conta três matizes no `accent-count`.
- Lacuna conhecida: decisão do dono em aberto sobre o piso "No single word set apart inside a heading" para o complemento.

## 1.14.0

- Design, Fase 2: o nível dos 23 sites de referência do dono vira meta mensurável. Pilar A: as ferramentas de captura (`shoot.mjs`, `capture.mjs`) aguentam as 23 referências: revelação forçada de conteúdo escondido com a contagem `hiddenContent`, páginas longas com `clip` e novas tentativas, `shotErrors` por seção, detecção de seções de reserva e `tools/refs-check.mjs`. Resultado: 23/23 sem queda, `hiddenContent` 0, pelo menos 2 seções em cada. Cena de rolagem fixada (hero do sol, parloa, hero do shopify) sai em branco: limite conhecido.
- Pilar B: regras recalibradas pelas referências reais: `body-size` falha abaixo de 13px e avisa de 13 a 14px em Persuade e Read; `heading-ratio` depende da largura (a partir de 1024: FAIL abaixo de 2,5 e WARN abaixo de 4,0; abaixo de 1024: FAIL abaixo de 2,0 e WARN abaixo de 2,5); novas regras `display-weight` e `accent-count`. `refs-check`: 23/23 PASS. O `design-system` ganhou escala fluida e receitas com valores (`escala-fluida`: 50% com 0,90 contra 0% com 0,40; casos antigos sem regressão), a `visual-direction` ganhou o cardápio de padrões de hero e de seção (`receitas-landing`: 100% contra 0%) e o crítico da `ui-review` reconhece sinais de página gerada (fora do eval 50% contra 0%; caso reservado novo 100% contra 0%).
- Pilar C: 22 referências novas em `ui-sources.json`, além do Mobbin que já existia.
- Pilar D: estudo de movimento (`tools/motion-study.mjs`) e dial de intensidade na `motion` (`nivel-suave`: 100% contra 0%, depois de corrigir o tempo das entradas). A `visual-direction` ganhou o guia para quem não sabe pedir design: oferece as referências e sorteia padrões com histórico (`guia-leigo`: 50% com 0,83 contra 0% com 0,00).
- Custo: US$ 70,5 de um teto de US$ 70 do dono, teto atingido. O caso reservado do guia (`evals-reserved/visual-direction-guia-restaurante`) está escrito e não foi rodado. Detalhes em `fusion/results/2026-11-18-design-quality-fase-2.md`.
- Lacuna conhecida: `visual-direction-arquitetura-clean` caiu de 0,73 para 0,36, porque o caminho sem pessoa para responder pula as galerias e as fontes. Fica para o trabalho "regras-cor-e-referencias".
- Lacuna conhecida: o caso reservado `ui-review-critica-painel-sem-navegador` caiu de 100% para 50% (0,79), com voto dividido; fica na lista de observação.

## 1.13.0

- Design, Fase 1: o modo cópia na `visual-direction`. Quando a pessoa pede "igual a este site", a skill entra no nível Replicate (`references/replicate.md`), captura a referência num pacote em `design/referencias/<slug>/` com `scripts/capture.mjs`, mantém todas as seções, os tratamentos de assinatura e a contagem de itens, e nunca publica texto, foto ou logo de terceiros como se fossem do cliente. As regras de "nunca copiar" foram reescritas. Caso `visual-direction-copia-referencia` (fora do eval): sem o plugin 0% (0,63); com o DevOrb 0,67 contra 0,56, aceito com uma lacuna. As regras de preservar seções e contar itens saíram das rodadas reservada e GREEN.
- Um crítico de olhos novos na `ui-review` (`references/critique.md`, 9 dimensões): nota abaixo de 8 vira P1, o bloco sai literal e valor autorizado nunca vira achado. O nível leve passou a completo. Caso `ui-review-critica-em-breve`: sem o plugin 0% (0,56), com o DevOrb 100% (1,00). `ui-review-equipes` segue em 100%.
- O espelho do construtor no `implementing`: o despacho leva o contrato, o `DESIGN.md`, o pacote e o `floor.md`; quem implementa roda `skills/ui-review/scripts/shoot.mjs` em 1440, 1024, 768 e 390, corrige até 3 rodadas e relata a linha `Mirror:`. Caso `implementing-espelho-em-breve`: sem o plugin 0% (0,56); DevOrb 50% (0,94) pelo primeiro avaliador e 100% nos mesmos rastros depois de corrigir o avaliador.
- Ligações: o `aligning` manda pedido de interface pela `visual-direction` nos dois atalhos (caso de pedido de cópia 67% para 100%); o `planning` põe contrato, pacote e critério do espelho nos passos de UI (caso 0% para 100%); o `browser-testing` passa a comparação visual para a `ui-review` quando há pacote; o `verifying` exige a linha `Mirror:` e uma Critique sem nota abaixo de 8 (ou os achados declarados). `Mirror: not run` não é aprovação.
- Scripts próprios, com ideias só de taste-skill, Hallmark, gstack, ai-website-cloner-template e do `mirror.js` do av-design-system do dono: `skills/ui-review/scripts/rules.mjs`, `collect-in-page.js` e `shoot.mjs`, e `skills/visual-direction/scripts/capture.mjs`. Conferidos nas páginas reais do Pilot (9 seções) e da Ligare (3 seções). O Playwright vem do projeto ou de `--pw <dir>`, cai para o Chrome do sistema, e instalá-lo pede o sim explícito do usuário.
- Lacuna conhecida: `aligning-agendamento` já falhava antes (0% desde 2026-11-11).

## 1.12.0

- Um lembrete curto do DevOrb (280 bytes) vai junto de cada mensagem do usuário, por um hook `UserPromptSubmit`: antes de lista de tarefas, plano, leitura ou comando, chamar a skill que o pedido precisa; skill de estilo não conta; pergunta e conversa não precisam. Motivo: em sessões longas do app desktop (com um `AGENTS.md` de 37 mil tokens e o app pedindo a lista de tarefas primeiro), o agente chamava a skill de estilo do dono e pulava a do fluxo, embora as regras do DevOrb tivessem chegado no início da sessão.
- Dois casos de roteamento com uma skill de estilo que o `CLAUDE.md` manda rodar primeiro. Roteamento: 17 casos, todos aprovados.

## 1.11.0

- Decisão do dono: toda skill dispara sozinha pelo assunto da conversa, sem a pessoa precisar saber o nome. As oito que eram manuais (`improve-architecture`, `prototype`, `handoff`, `retro`, `security-audit`, `diagram`, `evolving`, `mobile-release`) ganharam descrições com gatilhos e entraram na tabela de roteamento da `using-devorb`; o comando com barra continua funcionando. Os cuidados ficam: `security-audit` só lê por padrão, `mobile-release` não roda EAS, e `evolving` disparada sozinha para no rascunho (só "roda o ciclo" publica).
- Oito casos de disparo com frases naturais, sem citar a skill: todos em 100%. As skills convertidas seguem em 100% nos seus casos. Custo fixo: base 635 de 706 tokens, design 195 de 250, mobile 103 de 150.

## 1.10.0

- Tasks D7 e M4: os setores entram no fluxo. A `aligning` passa tarefas com interface pela `visual-direction`; o `planning` cita os tokens do `DESIGN.md`; o `implementing` chama `motion` quando algo se move e `native-app` em app; o `verifying` roda `ui-review` depois de `browser-testing` (ou `device-testing` em app); o `reviewing` deixa a estética para a `ui-review`; no `prototype`, cada variante declara um eixo. `design-system`, `motion` e `ui-review` ganham `references/native.md`, e o contrato da `visual-direction` ganha a linha de plataforma.
- Quatro casos de disparo (design e mobile). Skills tocadas comparadas de novo, uma por uma (o teto de US$ 20 por braço segue): nenhuma piora. `using-devorb` passa nos sete casos de roteamento, contra 0% a 100% no Superpowers.
- Tasks D8 e M5, Step 1: custo fixo por setor medido. Base 439 de 706 tokens, design 167 de 250, mobile 71 de 150. O `plugin details` soma 962 porque conta também as descrições das manuais.

## 1.9.0

- `mobile-release`, manual, Task M3: sobe a versão no campo certo, anuncia antes de subir SDK, `targetSdk` ou AGP, troca `QUERY_ALL_PACKAGES` por `<queries>` num config plugin e nunca roda EAS. Comparação: 100% contra 0%. `using-devorb` encaminha tela de app para `native-app` e `device-testing` e lista `mobile-release` entre as manuais.

## 1.8.0

- `device-testing`, Task M2: o par de `browser-testing` para apps. Checagens estáticas, testes (Robolectric em `src/test`), a volta no aparelho e, sem aparelho, a lista do que não foi conferido; nunca "pronto". Comparação: 100% contra 0% nos dois casos.

## 1.7.0

- `native-app`, Task M1: identifica Expo, Kotlin ou nenhum; projeto Expo gerado muda o nativo só por config plugin e instala com `npx expo install`; o idioma web não porta; quatro estados; ação principal fora do teclado; nunca `allowFontScaling={false}`; todo controle com rótulo e papel; no Kotlin, edge-to-edge, `rememberSaveable` e navegação por largura. Comparação: Expo 100% contra 67%, Kotlin empata, reservado 67% contra 100% (dentro da tolerância).

## 1.6.0

- `diagram`, manual, Task D6: tabela quando ela responde; Mermaid em documentação no Git e SVG em peça publicada; até 9 nós, conectores ortogonais, `role="img"` e `<title>`. Comparação: 100% contra 0% sem plugin nos dois casos. `using-devorb` encaminha interface para as três skills automáticas do design e lista `diagram` entre as manuais.

## 1.5.0

- `ui-review`, Task D5: nomeia o modo de cada seção, mede contra `DESIGN.md` e o contrato, o que eles autorizam não vira achado, achados só de P0 a P3, relata e para, e sem navegador diz "só código". Comparação: 100% contra 0% sem plugin.

## 1.4.0

- `motion`, Task D4: anima? → propósito → ferramenta (o que o projeto tem, depois CSS, Motion, GSAP) → propriedade → curva → interrupção → reduced motion, com a tabela do que nunca entregar e os modos de auditar e remover. Comparação: 4 de 5 rodadas contra 0% sem plugin.

## 1.3.0

- `design-system`, Task D3: tokens primitivos e semânticos a partir do contrato de direção, `DESIGN.md` no formato aberto e nunca sobrescrito sem pedido, cores em pares com contraste calculado por um script próprio nos dois temas, `@theme` no Tailwind 4, e o tema padrão do shadcn trocado pelos tokens do projeto (regra do dono). Comparação: 100% contra 0% sem plugin e no UI UX Pro Max nos dois casos que separam; empate no do shadcn.

## 1.2.0

- `visual-direction`, Task D2 do setor de design: o modo vem do que o visitante quer fazer (Persuade, Operate, Read, Experience), três níveis de invenção, material antes da forma (o que falta vira lacuna visível, nada inventado), as fontes de referência fixas do dono no corpo da skill, escolha de biblioteca por tarefa, direção tirada do mundo do público com teste do espelho, e um contrato `## Direção visual` gravado na spec. Ideias de Impeccable, Hallmark, taste-skill, frontend-design, Emil, ECC, gstack, genjutsu e Monich, escritas com palavras próprias.
- Comparação: Clínica Serena 100% contra 0% sem plugin e 0% no UI UX Pro Max; reservado (painel em projeto com identidade) 100% contra 33% e 33%; o caso das fontes fixas é lacuna, com a maior nota no DevOrb.
- `compare.mjs` libera o `WebFetch` nos casos que o pedem; o sandbox lê sites.

## 1.1.0

- Task D1, ferramentas do setor de design: `check-skills` soma à parte o custo fixo das skills automáticas de cada setor, com os tetos `design: 250` e `mobile: 150`, e erra com `always-on <setor>: <n> tokens > <limite>`. Os 706 da base não mudam e não contam as skills de setor. Setor sem teto é erro, para nenhuma skill escapar do limite.
- `compare.mjs` ganha o braço `ui-ux-pro-max`: o repositório inteiro no pino de `fusion/sources.json` (não segue o último commit, como o Superpowers e o ponytail), com a raiz como plugin (`.claude-plugin/plugin.json`, skills em `.claude/skills/`) e sem a pasta `stack/`, que é um kit à parte com `.mcp.json`, agentes e configurações próprios.
- Sondagem da leitura de sites no sandbox do `claude plugin eval`: o `WebFetch` lê sites. Uma segunda rodada, com o trace guardado e grader estrito (`TITLE: ` contra `FETCH-FAILED`), mostrou o conteúdo de `https://ui.shadcn.com` ("shadcn/ui - The Foundation for your Design System"). A sondagem não fica no repositório.

## 1.0.0

- Lançamento: as 19 skills da base comparadas contra o Superpowers, com o ponytail ligado, sem nenhum caso pior (`fusion/results/final.md`).
- `using-devorb`: feature pequena também entra pela `aligning`, que a dimensiona; regra de estilo de plugin muda como trabalhar, nunca se o fluxo roda; "sem perguntas" tira as perguntas, não os passos. Duas linhas repetidas das bandeiras vermelhas saíram para caber no limite de 3.500 bytes.
- Decisões do dono registradas no progresso, incluindo a revisão dos scripts copiados do Superpowers.

## 0.15.1

- Task 21, comparação final com o ponytail ligado: `aligning` chama `domain-modeling` mesmo em tarefa pequena ou sob regra de mudança mínima (67% contra 0% no Superpowers), e `improve-architecture` trata o relatório HTML como a entrega mesmo com pedido de brevidade (100% contra 0%). O grader do HTML aceita o caminho numa variável. Caso novo `flow-small-feature`. Detalhes em `fusion/results/final.md`.

## 0.15.0

- `browser-testing`, da Anthropic (`webapp-testing`, Apache-2.0), com ideias do Spartan e do ECC escritas com palavras próprias: usa primeiro os testes de navegador do projeto e, sem eles, um script Playwright headless; sobe o servidor em segundo plano, espera a porta e encerra no fim; olha a página antes de agir; registra erros de console e de rede; testa em 1280 px e em 375 px com toque; em produção, só leitura. `references/playwright.md` traz um script que foi rodado contra o caso realista.
- `tools/eval-outside.mjs` e `compare.mjs --outside-sandbox`: o Chromium não abre no sandbox do `claude plugin eval`, então os casos de `evals-outside/` rodam com `claude -p --restricted` numa pasta temporária, com o login do dono e sem as configurações, plugins e MCP dele. Comparação: 100% contra 0% sem plugin.

## 0.14.0

- `writing-skills`, do Superpowers: linha de base sem a skill antes de escrever, com subagentes novos, e teste depois. Instrução direta para pular o teste vale e a skill sai como não testada. Caso realista mudado para `skills/`, porque o sandbox do eval nega escrita em `.claude/skills/`. Comparação: 100% contra 50% no Superpowers.

## 0.13.0

- `finishing`, do Superpowers (suíte verde antes do menu, detecção de ambiente, menu de opções, descarte só com `discard` digitado, limpeza por procedência, nunca `--force`) e do Matt Pocock (corpo de pull request com Resumo, Evidência e Perigo de merge). Pull request abre como rascunho por padrão; rebase só a pedido. Comparação: empate com o Superpowers (100%), Matt 0%.

## 0.12.0

- `security-audit`, manual, com ideias da Trail of Bits, do gstack e da Cloudflare escritas com palavras próprias: só leitura por padrão, checagem local apenas com o comando exato aprovado pelo usuário, segredo confirmado sem olhar o valor, alertas do GitHub só lidos, escala de quatro níveis. `using-devorb` lista a skill entre as manuais. Comparação: 100% contra 0% sem plugin.

## 0.11.0

- Quatro skills manuais do Matt Pocock: `improve-architecture` (pontos quentes contados pelo git log, levantamento sem refactor), `prototype` (pergunta no topo, arquivo descartável, comando para rodar, protótipo não vira código real pela skill), `handoff` (afirmação de terceiro é presumida, segredo vira endereço, linha pronta para a próxima sessão) e `retro` (evidência do log em cada candidato, sem citar segredo). Comparação contra o Matt: `improve-architecture` e `handoff` 100% contra 0%; `retro` e `prototype` empatam (o caso do `prototype` foi alinhado com o HTML único que a skill manda fazer).

## 0.10.0

- `reviewing`, do Matt Pocock e do Superpowers: dois eixos em revisores novos, revisão de risco como terceiro revisor só quando um gatilho dispara, intervalo com edições não comitadas e arquivos novos, e passadas separadas quando não há subagente. Comparação: 100% contra 0% no Superpowers e 50% no Matt.

## 0.9.0

- `implementing`, do Superpowers (subagente novo por task, revisão por task, quatro paradas, ledger), com a regra do Karpathy no prompt de quem implementa e no do revisor. Plano contra spec no que se constrói é parada; paralelo só com a marca do plano e merge verificado. Os seis scripts do Superpowers vêm com só caminhos e nomes trocados (SHA-256 no ledger). Comparação: 100% contra 67% no Superpowers e 0% no Matt; reservado 100% (Superpowers 0%, Matt 100%).

## 0.8.0

- `codebase-design`, do Matt Pocock (fonte única): vocabulário exato, teste de exclusão, um adaptador é hipótese e dois são reais, enquadramentos rejeitados. Comparação: empate com o Matt, aceito.

## 0.7.0

- `planning`, do Superpowers e do Matt: o documento da `aligning` é a spec, tasks em fatias verticais com `### Task N:`, interfaces, restrições globais e seams; plano de migração, interface pública, autenticação ou release de produção traz `## Rollout`; antes das tasks, conferir o histórico da base e cada comando citado. Comparação: empate com o Superpowers, aceito.

## 0.6.0

- `aligning`, do Superpowers e do Matt: uma pergunta aberta por vez, sem construir antes da aprovação, fatos por subagente e decisões do usuário, revisor independente, companheiro visual com os scripts do Superpowers (telemetria sempre desligada na cópia). Regra de negócio achada no código é suposição a confirmar. Comparação: aceita; no reservado, 67% contra 0% no Superpowers e no Matt.

## 0.5.0

- `domain-modeling`, do Matt Pocock (fonte única): glossário atualizado na hora, ADR só com o teste das três perguntas, arquivos só quando precisa. Escolha delegada pelo usuário conta como escolha dele. Comparação: 67% contra 0% no Matt.

## 0.4.0

- `verifying`: adaptada do Superpowers (a função-portão, a tabela de falhas comuns, reverter para ver o vermelho e conferir relatos de agentes pelo diff), com ideias do ECC e do gstack escritas com palavras próprias: ambiente implantado relatado à parte, verde só vale se nenhum teste foi apagado, pulado ou afrouxado, zero testes é falha, "já estava vermelho" exige vermelho antes da primeira edição, e afirmação de desempenho com rodadas alternadas, mediana e faixa (detalhe em `references/performance.md`). Reverter e voltar à branch base sem `stash`, `reset` nem `checkout` sobre o trabalho do usuário. 1.787 de 2.500 tokens.
- Comparação: `accepted: true`. O caso realista, em três versões, passa em todos os braços até sem plugin e fica como guarda contra piora.

## 0.3.0

- `tdd`: do Superpowers (Lei de Ferro, apagar código escrito antes do teste, RED e GREEN verificados) e do Matt Pocock (seams, fatias verticais, teste tautológico), com uma referência que funde as três de testes e outra de testes por propriedade, com ideias da Trail of Bits em palavras próprias. Regra própria: urgência não é permissão; instrução direta de método do usuário vale e é relatada.
- Comparação: `accepted: true`, 100% no DevOrb contra 33% no Superpowers e 0% no Matt. O reservado é lacuna em todos os braços, porque o pedido manda ir direto ao código (decisão do dono).
- `using-devorb`: uma linha a mais nas bandeiras vermelhas, para a urgência não pular a checagem de skills (no caso da `tdd`, o DevOrb não chamava skill nenhuma).
- Graders de ordem viram `regex` sobre o trace inteiro: o juiz `llm` com `focus: trace` só vê o começo e o fim de um trace longo.

## 0.2.0

- Primeira skill pelo processo de fusão: `debugging`, a partir da skill do teste de fusão (Superpowers e Matt Pocock), com ideias da Trail of Bits, do Spartan e do ECC escritas com palavras próprias. A skill compara segredos pelo nome, pela presença ou por hash, nunca pelo valor; permite conter uma queda sem dispensar a causa; e corrige a causa e as variantes sem misturar outras mudanças. Tem 2.248 dos 2.500 tokens.
- Ledgers de `debugging` e `using-devorb` em `fusion/ledger/`, com origem por parte, regras próprias, o que ficou fora, decisões por commit de fonte e resultados.
- Comparação no Opus 5.5, 3 rodadas por caso: `debugging` passa em 100% no caso de pagamentos, contra 0% no Superpowers e no Matt (67% no Superpowers com o ponytail ligado). `using-devorb` dispara a skill certa em todas as rodadas, inclusive com nome antigo. Os reservados também passam. `accepted: true` em todas as comparações; o cenário de queda total segue como lacuna em todos os braços.
- Casos de `using-devorb` (gatilho de trabalho novo, gatilho de bug e nome antigo) e um reservado de cada skill, escritos por agentes que não viram a skill.
- `compare.mjs`: `--concurrency` passa `-j` ao eval, e uma rodada que atinge o limite de turnos do caso conta como comportamento do agente, não como erro da ferramenta. `check-skills` não aceita mais `constructor` como skill do registro e exige `ceilingTokens` em toda entrada.
- Custo medido na Task 6 e estimativa do restante em `fusion/results/estimativa.md`.

## 0.1.9

- `tools/compare.mjs`, o comparador de versões: monta um braço por versão em `.arms/` (`devorb` com a árvore de trabalho, inclusive o que ainda não foi commitado, `superpowers` e `mattpocock-skills` baixados no commit, sem `.git`, e `none`, um plugin vazio), roda `claude plugin eval` em cada um e decide se o DevOrb passa: sem regressão contra a melhor linha de base, com tolerância de uma rodada, e pelo menos 2/3 de aprovação. Caso em que nenhum braço passa é lacuna, não reprovação. O relatório em português vai para `fusion/results/<data>-<skill>.md` (com `-reserved`, `-ponytail`, a ablação e `-baseline` no nome quando for o caso, para uma rodada não apagar a outra), com aprovação, pontuação e custo por caso e por braço, casos que não carregaram, rodadas parciais e rodadas com erro da ferramenta.
- O download das fontes não roda nada delas. Mas a avaliação carrega cada braço como plugin, então os hooks das fontes, como o SessionStart do Superpowers e do ponytail, rodam durante a comparação. Isso é aceito para a linha de base ser justa, e as duas seguem o commit mais recente.
- Cada braço leva só a suíte que está rodando: a sondagem mostrou que uma rodada normal consegue ler `evals-reserved/` pela raiz do plugin. Com `--with-ponytail`, o ponytail é copiado para dentro do braço e cada caso ganha `plugins:` com o braço e o ponytail.
- Por decisão do dono, o braço `superpowers` e o ponytail usam sempre o commit mais recente da branch principal, conferido na hora. `mattpocock-skills` usa o `lastAbsorbed`. Linhas de base dessas fontes ficam em `fusion/results/baselines/<fonte>@<sha>/` e são reaproveitadas por caso enquanto o caso, o modelo, as rodadas, o ponytail e a ablação forem os mesmos.
- Modelo dos testes: `claude-opus-5-5`, com teto de US$ 20 por braço (cada chamada de `claude plugin eval`). O ponytail entra em `fusion/sources.json` sem ser acompanhado e sem emprestar texto.
- Os 5 casos `evals/evolving-*` não carregavam: o `pattern` com `: ` sem aspas era YAML inválido. As expressões ficaram iguais, agora entre aspas, e um teste impede que isso volte.
- git dentro do sandbox do Mac: o `/usr/bin/git` é um atalho do `xcrun`, que o sandbox bloqueia. Cada braço agora leva uma cópia do git real, posta no PATH da rodada. O cache do `source-diff` virou um repositório bare, porque o sandbox não deixa gravar `.git/config`.
- Graders `llm` com `focus: files` viam só os nomes dos arquivos criados, nunca o conteúdo. Agora cada grader lê o arquivo que julga, e um teste barra o foco `files`.
- Cenários de depuração da Task 5: o bug de pagamentos do teste de fusão, os três cenários de pressão do Superpowers traduzidos e com o nome da skill neutro, e um caso reservado escrito por um agente que não viu os outros.

## 0.1.8

- Roteiro de lançamento no registro de progresso: o lançamento, na `1.0.0`, é trocar o Superpowers pelo DevOrb depois das fusões da base, que rodam no Mac. Design e mobile vêm em seguida.
- Skill manual `security-audit` planejada na base (Task 24), com a da Cloudflare como espinha e as ideias da skill que o dono enviou num zip. `reviewing` ganha duas ideias de segurança.
- Setor mobile na spec e no plano `docs/plans/2026-11-10-devorb-mobile.md`: `native-app`, `device-testing` e `mobile-release`, esta manual, com as skills da Expo, do Android, do Material 3 e de mobile do genjutsu e do Emil.
- `motion` ganha referências de GSAP, Motion, transitions.dev e three.js, e `ui-review`, ideias do genjutsu e do reanimate. getdesign.md entra nas fontes de referência de UI.
- Fontes acompanhadas: 27, com 133 caminhos. Ficam fora, por decisão do dono, jogos, Higgsfield e os MCPs do Mobbin e do Figma.
- Testes: a `security-audit` só entra em `using-devorb` quando estiver pronta, o registro tem as 3 skills mobile, e as fontes mobile só emprestam ideias.

## 0.1.7

- Fontes de referência de UI fixas, pedidas pelo dono, em `fusion/ui-sources.json`: as 13 da descrição do vídeo "UI Libraries for Claude Code", de Griffin Wooldridge, mais seis galerias de sites inteiros aprovadas por ele. São fundações, especialistas, componentes de destaque, o Mobbin e as galerias, com estilo, licença, acesso, como cada uma abre e as regras de uso. A Awwwards tem páginas separadas por estilo. A Task D2 as leva para dentro de `visual-direction`, que passa a consultá-las primeiro.
- A `pick-ui-library` do Emil passa a ser acompanhada na revisão mensal.
- Spec, plano do design e registro de progresso atualizados. Um teste garante que a lista do dono continua completa.

## 0.1.6

- Registro de progresso sem as linhas que ainda tratavam o setor de design como à espera do merge.

## 0.1.5

- Setor de design na spec e no plano `docs/plans/2026-11-09-devorb-design.md`: cinco skills planejadas (`visual-direction`, `design-system`, `motion`, `ui-review` e `diagram`, esta manual), marcadas com `"sector": "design"` no registro. Nenhuma foi escrita ainda.
- Nove fontes novas, só como ideias: Impeccable, Hallmark, taste-skill, `frontend-design`, as skills do Emil Kowalski, `scroll-craft`, Paper Shaders, `diagram-design` e UI UX Pro Max. ECC e gstack acompanham mais caminhos de design.
- Testes: nenhuma fonte acompanha código, a Impeccable acompanha a fonte e não as cópias geradas, e uma skill de design só entra em `using-devorb` quando estiver pronta.

## 0.1.4

- Duas fontes novas em `fusion/sources.json`, só como ideias: 7 skills do ECC (antigo `everything-claude-code`) e 8 arquivos do gstack. Elas alimentam as fusões de `aligning`, `planning`, `debugging`, `verifying`, `browser-testing`, `reviewing`, `finishing` e `handoff`. Nenhuma skill nova: o registro continua com 18.
- Testes garantem que o gstack acompanha arquivos de origem, nunca o `SKILL.md` gerado, pasta ou código, e que as duas fontes só emprestam ideias.
- Spec, plano e registro de progresso atualizados, com as candidatas ao projeto de design e sem as linhas que ainda tratavam o merge do ciclo mensal como pendente.

## 0.1.3

- `fusion/routine-prompt.md`, o prompt da execução mensal, e a explicação do ciclo no `README.md`.
- Casos `evals/evolving-*`, com uma fonte de exemplo que traz uma melhoria real, instruções embutidas, um hook novo e uma mudança que contradiz uma regra própria.
- `tools/source-diff.mjs` compara cada fonte com o último commit absorvido, só nos caminhos acompanhados, e aponta skills novas, hooks, scripts, nomes de arquivo estranhos e caminhos que sumiram. Ele só lê objetos do git, sem extrair nem executar nada da fonte, e `--show` e `--diff` leem um arquivo por índice, para o nome dele nunca chegar a um shell. Histórico reescrito aparece como `sha-missing`.
- Skill `evolving`, manual: a revisão mensal das fontes. Classifica as mudanças, funde as ideias adotadas dentro dos tetos e escreve o pull request em português pelo modelo em `references/pr-template.md`, com hooks, scripts, nomes estranhos e instruções embutidas em destaque no topo, citados em blocos cercados. A mensagem final começa com uma linha de status, e `PARCIAL` ou `FALHOU` abrem uma issue. Há uma revisão por vez, e fonte que só alimenta skills `planned` não avança o pino nem gera pull request. Versão nova e pull request só existem quando uma skill muda ou um pino avança. O agendamento ainda não está ligado.
- `fusion/pr-draft.md` no `.gitignore`.

## 0.1.2

- Quatro fontes novas em `fusion/sources.json`, acompanhando só as pastas escolhidas: Karpathy, `webapp-testing` da Anthropic, Trail of Bits e Spartan.
- `textReuse: false` marca as fontes das quais só entram ideias, escritas com palavras próprias. Fonte que empresta texto precisa de `licenseFile`, e a licença Apache 2.0 do `webapp-testing` entrou em `LICENSES/`.
- Skill `browser-testing` no registro, ainda planejada. A base passa de 17 para 18 skills.
- `using-devorb` ganha essa skill na tabela de etapas e fica com a descrição mais curta. Pular etapa agora depende de o nível 1 da precedência dizer isso explicitamente, o que inclui instruções do projeto.

## 0.1.1

- Verificador de skills (`tools/check-skills.mjs`), que roda dentro de `npm test`.
- Hook de início de sessão, compatível com Mac e Windows, que injeta a skill `using-devorb` em toda sessão.
- Skill `using-devorb`: a regra de checar skills antes de responder, a precedência, a tabela de etapas e as referências de nomes antigos, fronteiras de fase e notas do Claude Code.

## 0.1.0

- Estrutura inicial do repositório: manifestos do plugin e do marketplace, registro das 17 skills da base, fontes fixadas por commit e licenças MIT do Superpowers e das skills do Matt Pocock.
