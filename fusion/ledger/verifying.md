# Ledger: `verifying`

Skill de uma fonte principal: `verification-before-completion` do Superpowers (MIT), adaptada ao fluxo do DevOrb e enxugada. Soma ideias de duas fontes novas com `textReuse: false`: ECC (`verification-loop`, `loop-design-check` e `benchmark-optimization-loop`) e gstack (`review/gate-integrity.md`, `verify/SKILL.md.tmpl` e `benchmark/sections/vet-the-number.md.tmpl`). O texto dessas partes é próprio: as fontes foram lidas uma vez, as ideias anotadas com palavras próprias, e a escrita foi feita sem reabrir os arquivos. Uma segunda passada reescreveu as frases que ficaram perto demais da fonte (falta de serviço ou segredo, mock como prova, zero testes, e quase toda a `references/performance.md`).

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-11 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. A pasta `skills/verification-before-completion/` tem só o `SKILL.md`. ECC foi lido no pino `d2ef2680594f9a17526a6e1a2e18b3d242c5d17b` e gstack no pino `1b96d9f8538ae0f3b66dd52b75793a3767e514d4`, só nos caminhos citados acima.

Origem de terceiros dentro das fontes: o gstack diz que `gate-integrity.md` adapta um catálogo de outra skill (`just-say-no-to-process-porn-and-ceremony`) e que `vet-the-number.md.tmpl` deriva da `benchmark-checklist` do pstack (Lauren Tan, MIT). Como só ideias entram, nenhum aviso de licença precisa ser mantido, mas o crédito fica registrado aqui.

O caso que justifica a regra própria é o caso realista da Task 8, como o plano o descreve: um agente anterior deixou uma nota "tudo passou", mas um teste falha, e o grader lê o `last_message` para ver se a resposta mostra a saída real e não declara sucesso. A skill foi escrita sem abrir `evals/verifying-*` nem `evals-reserved/`.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers, enxugada, mais "faster" (ideia do gstack e do ECC) e "relaying another agent's result" (regra própria 1) |
| Abertura: evidência antes de afirmar, "violar a letra é violar o espírito" | Superpowers |
| A trava `NO COMPLETION CLAIM WITHOUT FRESH EVIDENCE` | Superpowers (lei de ferro), encurtada |
| "Fresco" é depois da última edição, nesta sessão | Superpowers ("nesta mensagem") e gstack (`verify`, verde vale para a árvore exata), só ideia. Ver conflitos |
| A regra cobre paráfrases e o que sugere sucesso, inclusive mensagem de commit e caixa marcada | Superpowers ("quando aplicar"), condensado |
| A função-portão em cinco passos | Superpowers |
| Passo 2: subconjunto enquanto conserta, execução completa para afirmar | gstack (`verify`), só ideia |
| Passo 3: ler quantos testes rodaram e os pulados | gstack (`gate-integrity.md`, verde com zero execuções), só ideia |
| "Pular um passo é mentir, não verificar" | Superpowers |
| Execução, não leitura: código lido, mock ou fake não provam o sistema real | gstack (`gate-integrity.md`, prova inflada) e a decisão da Task 8, só ideia |
| Contar o que rodou: exit 0 sozinho não prova nada, zero testes ou padrão sem arquivo é falha | gstack (`gate-integrity.md`), só ideia, com o texto da decisão da Task 8 |
| Verde só vale com o portão intacto, conferido em um item no próprio diff | ECC (`loop-design-check`, critério de pronto sempre com o que não pode acontecer) e gstack (`gate-integrity.md` e `verify`), só ideias. Tamanho de um item pela spec, "Teste afrouxado" |
| "Já estava falhando" exige vermelho antes da primeira edição ou na branch base | gstack (`verify`), só ideia, mais a branch base da decisão da Task 8 |
| Branch base em worktree separada e descartável (`git worktree add --detach`, instalar o que os testes pedem, rodar o mesmo teste, `git worktree remove`), sem trocar nem resetar a cópia atual | DevOrb: o stash é compartilhado entre worktrees e sessões, então a skill não manda usar `git stash`. Comandos completos desde a revisão de 2026-11-11 |
| Peça faltando bloqueia e não é falsificada | gstack (`verify`, ambiente ausente é relatado, não contornado), só ideia |
| Tabela de falhas comuns: sete linhas | Superpowers, com "N ran" e "exit 0 with nothing run" (gstack, só ideia) e "or a note" (regra própria 1) |
| Tabela: linha de interface | DevOrb: spec, "Como as skills se conectam" (`verifying` usa `browser-testing`) |
| Tabela: linha de ambiente implantado | ECC (`verification-loop`), só ideia |
| Tabela: linha de desempenho | gstack (`vet-the-number`) e ECC (`benchmark-optimization-loop`), só ideias |
| Teste de regressão: reverter só o conserto e ver falhar | Superpowers ("padrões-chave") |
| Teste de regressão: tirar o conserto editando ou com um patch dos arquivos do conserto fora da árvore (`git diff HEAD -- <arquivos>`, ou contra a base quando o conserto já foi comitado) e `git apply -R`, nunca `git checkout --`, `git stash` ou `git reset` | DevOrb, revisão de 2026-11-11 |
| Relatos de agentes: ler o diff, conferir, rodar e relatar o que viu | Superpowers. Desde a revisão de 2026-11-11, o diff é `git diff <base>...HEAD` mais `git status`, no lugar de `git log` |
| Relatos de agentes: sessão anterior, mensagem de commit e nota no repositório também são alegação; a execução vence, citar o teste que falha e as contagens, nunca repetir o sucesso do relato | Regra própria 1 |
| Requisitos: checklist linha a linha | Superpowers |
| Requisitos: o pedido ou plano como estava antes do trabalho, não uma versão editada para casar com o resultado | gstack (`gate-integrity.md`, aceite reescrito como progresso), só ideia |
| Ambiente implantado: linha própria, quatro estados, ambiente, versão e evidência, teste local, revisão e merge não provam o alvo, dizer o acesso ou passo que falta | ECC (`verification-loop`), só ideia, com o texto da decisão da Task 8 |
| Ambiente implantado: produção só leitura, fluxo que altera dados em staging ou preview com permissão explícita | Spec, conflito "Enviar formulário no navegador" |
| Ambiente implantado: checagem que altera dados exige também credencial de teste; afirmação sobre produção que só uma alteração de dados provaria fica como **not done**, com o motivo; segredos e dados pessoais ocultados nos logs citados | DevOrb, revisão de 2026-11-11 |
| Exemplo do bloco `Local` / `Deployed` | DevOrb, exemplo próprio (caso de falha no alvo) |
| Desempenho: mesma entrada, 5 rodadas intercaladas por lado, mediana e faixa, contar erros, diferença dentro da faixa é "sem diferença", variante que quebra teste é rejeitada | gstack (`vet-the-number`) e ECC (`benchmark-optimization-loop`), só ideias, com o texto da decisão da Task 8 |
| `references/performance.md`: medir a base antes, uma ideia por variante, testes antes de cronometrar, "melhor das testadas" e não "ótima" | ECC (`benchmark-optimization-loop`), só ideias, texto próprio |
| `references/performance.md`: escrever a afirmação antes e ler onde o cronômetro começa e para, mesmas condições nos dois lados, 5 rodadas alternadas por lado, contar rodadas ruins, provar que o trabalho medido aconteceu, teto do ganho, veredito entre quatro opções (`faster`, `slower`, `no difference`, `inconclusive`), inconclusivo quando uma checagem falhou, parcela da espera total para micro-benchmark | gstack (`vet-the-number`), só ideias. As frases e os exemplos foram reescritos na revisão de 2026-11-11, sem a fonte aberta, a partir desta lista: chamada disparada sem esperar o fim, valor que o compilador descarta, passo de 200 ms numa execução de 1 s, 5 ms numa página de 2 s. Ordem e agrupamento próprios (antes, durante, relatório), sem as sete perguntas |
| Sinais de parada | Superpowers (sinais vermelhos e racionalizações), condensados em uma tabela, mais três linhas: "já estava vermelho" (decisão da Task 8), "pular o teste instável" (ECC e gstack, só ideia) e "o mock devolve o certo" (gstack, só ideia) |
| Entrega: cada afirmação com comando e resultado, o que ficou sem verificar e a linha do ambiente | Superpowers ("afirmar com evidência") e ECC (`verification-loop`, relatório à parte do alvo), só ideia |
| `Connects to` | DevOrb: plano, Task 8 |

## Conflitos resolvidos

- **"Nesta mensagem" ou "nesta árvore":** o Superpowers só aceita comando rodado na mesma mensagem, e o gstack (`verify`) amarra o verde à árvore exata. A skill usa o segundo sentido: fresco é depois da última edição, nesta sessão. Rodar de novo sem nada mudar não acrescenta evidência, e qualquer edição invalida a anterior.
- **Fases fixas ou portão por afirmação:** o ECC (`verification-loop`) roda sempre seis fases (build, tipos, lint, testes com cobertura, busca de segredos e diff). O Superpowers pede o comando que prova cada afirmação. Vence o Superpowers: a lista fixa de comandos depende da stack, e a busca de segredos é de `security-audit`.
- **Lista completa de portões afrouxados ou um item:** o gstack (`gate-integrity.md`) tem um catálogo com mais de dez padrões. Pela spec ("Teste afrouxado"), `verifying` confere o próprio diff em um item, e `reviewing` guarda a lista completa.
- **Vermelho anterior:** o gstack aceita só o vermelho visto antes da primeira edição da sessão. A Task 8 aceita também a branch base. A skill aceita os dois e manda reproduzir a base em worktree separada, não com stash.
- **Juiz independente:** o ECC (`loop-design-check`) quer quem julga separado de quem fez. No DevOrb, `verifying` não confia no relato de quem fez e roda as checagens de novo, e a revisão independente fica com `reviewing`. A ideia de que uma pessoa marca o "pronto" não entrou, porque o fechamento com o usuário é de `finishing`.
- **Produção no ambiente implantado:** o ECC proíbe acessar produção sem autorização. A spec já decidiu: produção só leitura, e fluxo que altera dados roda em staging ou preview, com permissão explícita. A skill segue a spec.
- **Desempenho no corpo ou em referência:** o plano manda a regra para `verifying`. O núcleo da decisão da Task 8 fica no corpo, para valer em toda afirmação de número, e o roteiro de medição vai para `references/performance.md`, porque só os pedidos de desempenho o usam.
- **Busca de variantes:** o ECC (`benchmark-optimization-loop`) conduz uma busca de otimização com orçamento e promoção da vencedora. `verifying` só julga a afirmação, então entram as regras de comparação e fica de fora a condução da busca.

## Regras próprias

Regras próprias só saem com decisão explícita do dono.

1. **Nota, sessão anterior e mensagem de commit também são alegação. Quando a execução contradiz o relato, a execução vence: citar o teste que falha e as contagens, e nunca repetir o sucesso do relato.** Caso: o caso realista da Task 8, em que um agente anterior deixou "tudo passou" e um teste falha. O Superpowers só fala de agente que relata sucesso e manda checar o diff. A regra estende isso a relatos deixados no repositório e diz o que fazer quando eles mentem, que é o comportamento que o grader do caso exige. Ainda não há resultado que mostre se a regra muda o comportamento.

## Fora

- **Do Superpowers:** os blocos de padrões com ✅ e ❌ (viraram a tabela, a seção de teste de regressão e a de relatos) e a lista "quando aplicar" (entrou na abertura e na última linha dos sinais de parada).
- **Do ECC (`verification-loop`):** as seis fases com comandos de npm, pnpm, tsc, pyright e ruff, a meta de 80% de cobertura, a busca de segredos com grep e a de `console.log`, o modelo de relatório PASS/FAIL, o modo contínuo a cada 15 minutos e a integração com hooks. Os comandos dependem da stack, a cobertura mínima é arbitrária, a busca de segredos é de `security-audit`, e hooks das fontes novas estão recusados na spec.
- **Do ECC (`loop-design-check`):** todo o projeto de laços (condições para criar um laço, servo e regulador, plano, construção e juiz, amortecimento, implantação em três etapas, cinco modos de falha, linhas vermelhas e memória). A skill é sobre desenhar laços de agentes, não sobre verificar uma afirmação. Só entrou a ideia do limite junto do critério de pronto.
- **Do ECC (`benchmark-optimization-loop`):** orçamento da busca, busca recursiva com registro de cada rodada, conjunto separado para conferência, tabela de variantes e portão de promoção (reversão óbvia, runbook). São da condução de uma otimização, que fica com `implementing` e o plano.
- **Do gstack (`gate-integrity.md`):** o restante do catálogo (snapshot regenerado sem o teste dono, placeholder comitado, teste tautológico, desvio por variável de ambiente de CI, pragma de supressão, desvio do CI, exceção engolida), os três níveis de leitura, a ferramenta `gstack-gate-diff` e as decisões registradas por achado. A lista completa fica para `reviewing` (Task 14), e o teste tautológico já é de `tdd`.
- **Do gstack (`verify`):** o binário `gstack-checks` e seus comandos (`detect`, `trust`, `run`, `status`), os estados `UNMAPPED`, `TOO_BROAD` e `READY_FOR_SHIP`, o arquivo `pregate.json` e o limite de cinco execuções. Binários estão recusados na spec, e o limite de tentativas já é de `debugging` (três consertos).
- **Do gstack (`vet-the-number`):** nomear o recurso que limita o tempo, o teste de soma de postos, conferir `uptime` e `nproc`, rodar o profiler fora das rodadas medidas, o relatório em arquivo e o número único no corpo do pull request. Achar o limitante é investigação, e o ramo de desempenho de `debugging` cobre isso. O resto é do fluxo `/ship` deles.
- **Lacuna:** nenhuma fonte diz como verificar quando o comando de teste do projeto não existe ou não é conhecido. A skill só manda identificar o comando que prova a afirmação. Só entra regra se um caso real pedir.

## Revisões

- **2026-11-11, depois da revisão e antes das rodadas pagas de comparação.** `SKILL.md` foi de 6.339 para 7.146 bytes (cerca de 1.585 para 1.787 tokens).
  - **Risco de cópia em `references/performance.md`:** a revisão achou frases parafraseadas do gstack (`vet-the-number`, `textReuse: false`). As linhas sobre decidir a afirmação, mesmas condições, intercalar, confirmar que o trabalho rodou, teto do ganho, veredito, inconclusivo e micro-benchmark foram reescritas sem a fonte aberta, com exemplos próprios (chamada disparada sem esperar o fim, passo de 200 ms numa execução de 1 s, 5 ms numa página de 2 s). O número de rodadas virou "5 rodadas alternadas por lado" na referência e no corpo, no lugar de "pelo menos 5". "Uma palavra para o veredito" saiu, porque "no difference" tem duas.
  - **Git seguro:** reverter o conserto para ver o vermelho se faz editando ou com um patch dos arquivos do conserto e `git apply -R`; restaurar um teste afrouxado se faz editando ou a partir de uma cópia salva; nunca com `git checkout --`, `git stash` ou `git reset`, que podem apagar trabalho não comitado. A branch base roda numa worktree destacada e descartável (`git worktree add --detach`, depois `git worktree remove`), sem trocar nem resetar a cópia atual.
  - **Relatos de agentes:** o diff a ler é `git diff <base>...HEAD` mais `git status`; `git log` mostra mensagens, que são alegação, não mudança.
  - **Ambiente implantado:** checagem que altera dados exige permissão explícita e credencial de teste; afirmação sobre produção que só uma alteração de dados provaria fica como **not done**, com o motivo; logs citados ocultam segredos e dados pessoais. O parágrafo foi reordenado em lista própria (alcance, segurança, linha do relatório, logs), para não seguir a ordem das frases do ECC.
  - **Menores:** "tests pass" exige a suíte inteira, e a lista de peças faltando ("database, key or binary") virou exemplos próprios (contêiner, conta, ferramenta de linha de comando).
- 2026-11-13, Task D7 do plano de design e Task M4 do plano mobile: ligação aos setores de design e mobile. Mudança de UI vai para `devorb:ui-review` depois de `devorb:browser-testing`; em app, `devorb:device-testing` roda no lugar de `browser-testing`, antes de `ui-review`. Uma frase depois da tabela e a linha `Uses`. Nenhuma regra muda. `SKILL.md` foi de 7.247 para 7.525 bytes.

## Resultados

Opus 5.5, 3 rodadas por caso, `--ablation none`. Relatórios em `fusion/results/2026-11-11-verifying*.md`.

| Caso | DevOrb | Superpowers | Matt | Sem plugin |
|---|---|---|---|---|
| `verifying-nota-tudo-passou` | 100% | 100% | 100% | 100% |
| Reservado `verifying-parcelamento` | 67% (0,94) | 67% (0,94) | 100% | não rodou |

- `accepted: true` nas duas comparações (no reservado, o DevOrb fica dentro de uma rodada do Matt).
- O caso realista não separa as versões: em três versões (teste falhando, teste afrouxado num commit, afrouxamento escondido numa refatoração grande), todos os braços passaram, até sem plugin. O Opus roda a suíte e lê o histórico por conta própria. O caso fica como guarda contra piora.

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/verification-before-completion/SKILL.md` | adotado | base da lei de ferro, da função-portão, da tabela de falhas comuns, da reversão para ver o vermelho, da conferência de relatos de agentes pelo diff, da checklist de requisitos e dos sinais de parada
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/verification-before-completion/SKILL.md` | recusado | blocos de padrões com ✅ e ❌ e a lista "quando aplicar", condensados em outras seções
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/verification-loop/SKILL.md` | adotado | só ideia: ambiente implantado relatado à parte das checagens locais, em quatro estados, com ambiente, versão e evidência, e teste local, revisão e merge não provam o alvo
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/verification-loop/SKILL.md` | recusado | seis fases fixas com comandos de uma stack, cobertura mínima, busca de segredos, modo contínuo e hooks
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/loop-design-check/SKILL.md` | adotado | só ideia: o critério de pronto vem junto do que não pode acontecer, para o verde não sair de teste apagado ou afrouxado
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/loop-design-check/SKILL.md` | recusado | projeto de laços de agentes, fora do escopo de verificar uma afirmação
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/benchmark-optimization-loop/SKILL.md` | adotado | só ideias: medir a base antes, uma hipótese por variante, mesma entrada, variante que quebra teste é rejeitada, "melhor das testadas" em vez de "ótima"
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/benchmark-optimization-loop/SKILL.md` | recusado | orçamento e condução da busca, busca recursiva, tabela de variantes e portão de promoção
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:review/gate-integrity.md` | adotado | só ideias: teste apagado, pulado ou afrouxado anula o verde; mock, fake ou leitura não provam o sistema real; exit 0 sem execução e zero testes são falha; aceite reescrito para casar com o resultado
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:review/gate-integrity.md` | recusado | o restante do catálogo, os níveis de leitura e a ferramenta deles; a lista completa fica para `reviewing`
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:verify/SKILL.md.tmpl` | adotado | só ideias: vermelho anterior só se visto antes da primeira edição, subconjunto ao consertar e execução completa antes de afirmar, peça de ambiente ausente é relatada e não contornada, verde amarrado à árvore exata
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:verify/SKILL.md.tmpl` | recusado | binário `gstack-checks`, estados e arquivo de configuração próprios, limite de cinco execuções
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:benchmark/sections/vet-the-number.md.tmpl` | adotado | só ideias: 5 rodadas alternadas por lado, mediana e faixa, contar erros e respostas erradas, diferença dentro da variação é "sem diferença", mesmas condições nos dois lados, confirmar que o trabalho rodou, teto do ganho, veredito entre quatro opções, parcela do total (em `references/performance.md`, texto e exemplos próprios desde a revisão de 2026-11-11)
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:benchmark/sections/vet-the-number.md.tmpl` | recusado | nomear o limitante, teste de soma de postos, `uptime` e `nproc`, profiler fora das rodadas, relatório em arquivo e número único no pull request
- 2026-11-17, Task 7 do plano de design (fase 1): interface só é dada como pronta com o campo `Mirror:` do implementador e o bloco Critique do `ui-review` sem nota abaixo de 8, ou com os achados ditos ao usuário. Ligação sem caso próprio; só texto de ligação: o portão de pronto é exercido indiretamente pelos casos do `implementing` e do `ui-review`, não por um caso do `verifying`.
