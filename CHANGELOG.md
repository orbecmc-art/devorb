# Changelog

## 1.1.0

- Task D1, ferramentas do setor de design: `check-skills` soma à parte o custo fixo das skills automáticas de cada setor, com os tetos `design: 250` e `mobile: 150`, e erra com `always-on <setor>: <n> tokens > <limite>`. Os 706 da base não mudam e não contam as skills de setor. Setor sem teto é erro, para nenhuma skill escapar do limite.
- `compare.mjs` ganha o braço `ui-ux-pro-max`: o repositório inteiro no pino de `fusion/sources.json` (não segue o último commit, como o Superpowers e o ponytail), com a raiz como plugin (`.claude-plugin/plugin.json`, skills em `.claude/skills/`) e sem a pasta `stack/`, que é um kit à parte com `.mcp.json`, agentes e configurações próprios.
- Sondagem da leitura de sites no sandbox do `claude plugin eval`: um caso com `WebFetch` em `https://ui.shadcn.com` passou (1 execução, 3 turnos, US$ 0,08, sem erro). O grader `regex` `shadcn` também casaria com a própria URL numa mensagem de falha, e o trace não ficou guardado, então o resultado indica, mas não prova, que o sandbox lê sites. A sondagem foi apagada.

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
