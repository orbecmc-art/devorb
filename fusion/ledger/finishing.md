# Ledger: `finishing`

Junta `finishing-a-development-branch` do Superpowers e `engineering/pr` do Matt Pocock, as duas MIT, e soma ideias de dois arquivos do gstack (`modernize/SKILL.md.tmpl` e `document-release/SKILL.md.tmpl`), com `textReuse: false`. O texto das partes do gstack é próprio: os dois arquivos foram lidos uma vez, e as três ideias da Task 15 foram escritas com as fontes fechadas. Uma segunda passada, ainda sem reabrir as fontes, reescreveu as frases que tinham ficado perto demais delas: a abertura sobre ausência de conflito (a forma "não diz nada sobre se ainda faz sentido"), a lista do que a branch pode ter perdido na base (que seguia a ordem e os itens do `modernize`), os três exemplos de explicação de hunk do `range-diff` (mesmos itens, mesma ordem) e a lista de superfície pública, que ficou só com os quatro itens da Task 15 (comando, flag, variável, rota).

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-12 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`, com `skills/engineering/pr/` inteiro (`SKILL.md`, `CREDITS.md`, `agents/openai.yaml`). gstack em `1b96d9f8538ae0f3b66dd52b75793a3767e514d4`, só os dois arquivos citados acima. As seções `{{SECTION:audit-scope}}` e `{{SECTION:release-body}}` e o preâmbulo do `document-release` são incluídos de outros arquivos, fora dos caminhos acompanhados, e não foram lidos.

Origem de terceiros dentro das fontes: o `CREDITS.md` do `pr` diz que o menu de visuais do Resumo (pseudocódigo, árvore de chamadas, árvore de componentes, árvore de arquivos, Mermaid, diffs) e a orientação de posicionamento vêm quase literalmente da skill `show-me` de Dex Horthy (HumanLayer). Como `references/pr-body.md` traz uma versão condensada desse menu, o crédito foi levado para `LICENSES/NOTICE.md`. A licença do repositório da HumanLayer não foi conferida: o texto chega ao DevOrb pela MIT do Matt.

O caso que justificaria as regras próprias é o caso realista da Task 15, como o plano o descreve: terminar uma branch com teste falhando, e o grader lê o `last_message` para ver que o merge não é oferecido. A skill foi escrita sem abrir `evals/finishing-*` nem `evals-reserved/`.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers ("implementação completa, decidir como integrar"), com as quatro saídas nomeadas, e Matt ("escrever o corpo de um pull request"), para que `/pr` (mapeado em `skills/using-devorb/references/legacy-names.md`) caia aqui |
| Só o corpo de um pull request: template do repositório ou `references/pr-body.md`, com uma rodada nova da suíte como evidência | Matt (`pr`, que só escreve o corpo), na revisão de 2026-11-12 |
| Abertura: provar verde, mostrar o que o usuário decide, oferecer, fazer só o escolhido | Superpowers ("Core principle"), com a decisão da Task 15 de nunca fazer push, merge, abrir pull request ou marcá-lo pronto sem a escolha do usuário |
| 1. Suíte verde antes do menu, rodada na árvore a integrar; vermelho para tudo, não há menu, e `devorb:debugging` é oferecido, sem começar sozinho | Superpowers (Step 1 e a desculpa "passou antes nesta sessão"), por decisão da Task 15. Oferecer `devorb:debugging` em vez de consertar código durante `finishing` é do DevOrb, na revisão de 2026-11-12 |
| 2. Detectar o ambiente (`GIT_DIR`, `GIT_COMMON`, `WORKTREE_PATH` capturado antes de mudar de pasta) e a tabela de menus | Superpowers (Step 2), condensado |
| 3. Confirmar a branch base, perguntar com o melhor palpite | Superpowers (Step 3), por decisão da Task 15 |
| 4. Ausência de conflito não prova nada; se a base andou, listar o que a branch dá por certo e ler os commits novos da base desde o merge-base, inclusive em arquivos que a branch não tocou | gstack (`modernize`, Steps 2 e 3), só ideia, com a Task 15. Texto próprio |
| 4. Rebase só a pedido do usuário ou por regra do projeto | Regra própria 2 |
| 4. Branch com commits de merge não se rebaseia, porque o `range-diff` não mostra o que eles resolveram | gstack (`modernize`, Step 4), só ideia. Texto próprio |
| 4. Rodar `git rebase origin/<base>`; explicar cada hunk mudado do `range-diff` em uma linha; parar no primeiro hunk sem explicação e mostrá-lo ao usuário; rodar a suíte de novo, e vermelho para como no passo 1 | gstack (`modernize`, Step 4), só ideia, com a Task 15 ("cada hunk"). Texto próprio, sem a lista de exemplos da fonte |
| 5. Extrair do diff o que alguém de fora digita ou chama (comando, flag, variável de ambiente, rota), incluindo renomeado e removido, procurar nomes antigos e novos nos documentos, apontar o que envelheceu com `file:line` | gstack (`document-release`, Step 1.5), só ideia, com a lista da Task 15. Procurar o nome antigo e o novo e deixar o conserto para o usuário são do DevOrb, seguindo o "apontar" da Task |
| 6. Resumo antes do menu: suíte, base, documentos, itens USER DECIDES, "Rulings I made" e "Deferred minors" | DevOrb: interfaces de `devorb:reviewing` (USER DECIDES, restaurar ou manter com motivo) e de `devorb:implementing` (as duas listas) |
| 6. Os itens USER DECIDES se resolvem antes de mostrar o menu; o motivo de manter vai no corpo do pull request ou na mensagem do commit de merge | DevOrb, na revisão de 2026-11-12 |
| Sem remoto: pular o `fetch` e o `git pull`, e usar `<base>` no lugar de `origin/<base>` | DevOrb, na revisão de 2026-11-12 |
| 6. Restaurar é uma correção com `devorb:tdd`, e o fluxo recomeça no passo 1 | Regra própria 3 |
| 7. Menu de exatamente três opções, duas em HEAD destacado; descarte fora do menu, só a pedido explícito; esperar a resposta | Superpowers (Step 4), por decisão da Task 15 (merge, pull request ou manter) |
| 8. Merge local a partir da raiz principal, suíte no resultado, vermelho deixa tudo no lugar e oferece `devorb:debugging`, verde limpa e apaga a branch com `-d` | Superpowers (Option 1). A opção 1 diz no menu que remove a branch e o worktree, e o relato traz a branch do checkout principal antes e depois: DevOrb, na revisão de 2026-11-12. "Push da base é outro pedido" é do DevOrb, explicitando o que a fonte já não fazia |
| 8. Pull request: push, abrir contra a base com a CLI da forja ou, sem ela, pela URL de criação que a forja imprime no push, relatar a URL, manter o worktree | Superpowers (Option 2) |
| 8. Pull request como rascunho onde a forja tem rascunho, a não ser que o usuário ou as instruções do projeto peçam pronto | Regra própria 1 |
| 8. Template do repositório vence; sem ele, `references/pr-body.md` | Superpowers ("following the repo's PR template") e Matt (template), por decisão da Task 15 |
| 8. Manter: relatar branch e caminho | Superpowers (Option 3) |
| 8. Descarte: mostrar branch, commits e worktree, exigir `discard` digitado, nada mais vale; `git branch -D` | Superpowers ("If your human partner asks to discard"), por decisão da Task 15 |
| Limpeza: só depois de merge ou descarte confirmado; worktree sob `.worktrees/` ou `worktrees/` sai com `git worktree remove` e `prune`; o resto é do host | Superpowers (Step 6). "Superpowers criou este worktree" virou o fallback de git de `devorb:implementing` (`references/worktree.md`) |
| Limpeza: remoção recusada nunca usa `--force`; mostrar o `status` e perguntar entre commit, mover ou apagar | Superpowers (Step 6), por decisão da Task 15 |
| Racionalizações | Superpowers ("Common Rationalizations"), seis linhas; "sem conflito, então é seguro" é a ideia do gstack (`modernize`) em forma de linha da tabela |
| `Connects to` | DevOrb: recebe de `devorb:implementing` (a branch e as três listas, "Rulings I made", "Deferred minors" e "User decides", esta com os USER DECIDES de `devorb:reviewing`) ou de `devorb:reviewing` rodada sozinha, com os USER DECIDES dela ou do usuário; usa `devorb:verifying`, `devorb:debugging`, `devorb:tdd` e `references/pr-body.md`; fim do fluxo |
| `references/pr-body.md`: template Resumo, Evidência e Perigo de merge (porta, raio de impacto) | Matt (`pr/SKILL.md`), adaptado. "Merge Danger" virou "Merge danger" |
| `references/pr-body.md`: menu de visuais do Resumo, condensado em uma linha por visual, com um só exemplo de `diff` | Matt (`pr/SKILL.md`), que credita a `show-me` de Dex Horthy (`CREDITS.md`). Crédito em `LICENSES/NOTICE.md` |
| `references/pr-body.md`: evidência antes e depois, captura de tela é a mais forte, execução a seguinte | Matt. Usar a rodada de `devorb:verifying` com as contagens é do DevOrb |
| `references/pr-body.md`: porta de mão única ou dupla e raio de impacto | Matt, com exemplos novos de porta de mão única (migração, API publicada, mensagem enviada) |
| `references/pr-body.md`: levar ao Perigo de merge os commits da base de que a branch depende, os documentos envelhecidos e cada USER DECIDES com a resposta | gstack (`document-release`, dívida de documentação no corpo do pull request), só ideia, estendida pelo DevOrb aos achados dos passos 4 e 6 |

## Conflitos resolvidos

- **Template do pull request:** o Superpowers manda seguir o template e as convenções do repositório quando existirem; o Matt traz um template próprio para todo pull request. Pela Task 15, o template do repositório vence, e o do Matt só vale sem ele. Mesmo com o template do repositório, a evidência é a mesma.
- **Base que andou:** o Superpowers faz `git pull` na base e o merge, e confia na suíte do resultado. O gstack diz que merge limpo não prova nada e manda ler os commits da base. A skill mantém os dois: o passo 4 lê a base antes do menu, para o usuário decidir sabendo, e a suíte no resultado continua depois do merge. A leitura cobre o que os testes não pegam.
- **Rebase e push forçado:** o `modernize` do gstack rebaseia e faz push com `--force-with-lease` preso ao SHA observado. O Superpowers só aceita push forçado a pedido explícito. A skill rebaseia só a pedido ou por regra do projeto (regra própria 2) e não faz push forçado sem pedido, como no Superpowers.
- **Documentos envelhecidos:** o `document-release` do gstack corrige sozinho o que é fato tirado do diff e só pergunta o que é narrativo. A Task 15 manda apontar. A skill aponta com `file:line`, e o usuário decide se corrige antes de integrar.
- **Veredito do gstack:** o `modernize` decide entre modernizar, retrabalhar ou fechar um pull request antigo, muitas vezes de outra pessoa. O DevOrb termina a própria branch, e o menu é o do Superpowers, pela Task 15. Os vereditos ficaram de fora.
- **Marcar pronto:** o Superpowers só manda abrir o pull request. A Task 15 e `devorb:implementing` proíbem marcar pronto sem a escolha do usuário. Resolvido pela regra própria 1: abre como rascunho onde a forja tem rascunho, a não ser que o usuário peça pronto.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. Nenhuma tem resultado de comparação ainda.

1. **Pull request abre como rascunho onde a forja tem rascunho, a não ser que o usuário ou as instruções do projeto peçam um pronto.** Escolher "abrir pull request" no menu não diz se ele está pronto para revisão, e a Task 15 proíbe marcar pronto sem a escolha do usuário. Rascunho é o lado reversível. Sem caso próprio ainda.
2. **Rebase só a pedido do usuário ou por regra do projeto.** Nenhuma fonte manda rebasear ao terminar: o Superpowers faz merge, e o `modernize` rebaseia porque o trabalho dele é reviver pull request antigo. Rebase reescreve o histórico e, num pull request aberto, exige push forçado. Sem caso próprio ainda.
3. **Cada USER DECIDES restaurado é uma correção com `devorb:tdd`, e o fluxo volta ao passo 1.** `devorb:reviewing` diz que o usuário decide restaurar ou manter, mas não diz o que acontece depois de restaurar. Voltar ao passo 1 garante que a suíte verde e o resumo antes do menu valem para a árvore que vai ser integrada. Sem caso próprio ainda.

## Fora

- **Do Superpowers:** o anúncio no início; a lista de comandos de teste por linguagem; a frase de abertura exata do menu e o "Which option?"; a tabela "Quick Reference", que repetia o corpo; as desculpas que viraram frase do corpo ("passou antes nesta sessão", "parecem ter terminado, ofereço o descarte", "'pode jogar fora' vale como confirmação", "remoção recusada, `--force` só termina a limpeza", "a falha no resultado do merge deve ser instável"). "Parceiro humano" virou "usuário".
- **Do Matt:** o `metadata.credits` do frontmatter, que virou `LICENSES/NOTICE.md`; `agents/openai.yaml`, metadado de outra ferramenta; os exemplos de cada visual (pseudocódigo, árvore de chamadas, de componentes e de arquivos, Mermaid, os quatro diffs e o bloco TypeScript inteiro), condensados em uma linha por visual e um só exemplo de `diff`.
- **Do gstack (`modernize`):** ler o pull request como afirmação em três frases, o filtro de texto de terceiros (binário), comentários com identidade de bot e o Capy, o caminho de pull request de fork, o push com `--force-with-lease` preso ao SHA observado, os vereditos MODERNIZE, REWORK e CLOSE, nunca fechar pull request, idade não é evidência, e ler o diff de fork como entrada não confiável antes de rodar testes. A skill termina a própria branch, não revive a de outra pessoa.
- **Do gstack (`document-release`):** o mapa de cobertura Diátaxis, a deriva de diagramas, o polimento de CHANGELOG, a subida de VERSION, os TODOS, o binário de termos proibidos, os modos ligados ao `ship` e a subagente, e editar documentos sozinho. Só a extração da superfície pública e o apontamento entraram, pela Task 15.
- **Interface com `implementing`:** durante esta fusão, `skills/implementing/references/final-review.md` passou a entregar três listas a `devorb:finishing`, com "User decides" ao lado de "Rulings I made" e "Deferred minors". O `Connects to` e o passo 6 citam a lista por esse nome.

## Revisões

- **2026-11-12, revisão do commit `b8e7345`, antes das rodadas de comparação.** `SKILL.md` foi de 7.651 para 8.257 bytes (cerca de 1.913 para 2.065 tokens).
  - **Suíte vermelha:** `finishing` não conserta código. Oferece `devorb:debugging` e não o começa sem pedido, no passo 1 e no merge com resultado vermelho.
  - **USER DECIDES:** se resolvem antes de mostrar o menu, e o motivo de manter vai no corpo do pull request ou na mensagem do commit de merge, em vez de só "registrar".
  - **Recebe também de `devorb:reviewing` rodada sozinha,** com os USER DECIDES dela, como já dizia o `Connects to` de `reviewing`.
  - **Rebase:** o comando `git rebase origin/<base>` passou a aparecer; "cada patch" virou "cada hunk", como na Task 15; a suíte vermelha depois do rebase para como no passo 1; a frase sobre o hunk sem explicação foi reescrita com estrutura própria, sem reabrir o gstack.
  - **Sem remoto:** usar `<base>` no lugar de `origin/<base>` e pular o `git pull`. Antes, o comentário dentro do bloco não alcançava o merge-base, o `log`, o `range-diff` nem o passo 8.
  - **Merge local:** a opção 1 do menu diz que remove a branch e o worktree, e o relato traz a branch do checkout principal antes e depois.
  - **Pull request:** sem CLI da forja, a URL de criação que a forja imprime no push (do Superpowers, que tinha saído); rascunho a não ser que o usuário ou as instruções do projeto peçam pronto.
  - **Só o corpo do pull request:** uma linha manda usar o template do repositório ou `references/pr-body.md`, com uma rodada nova da suíte como evidência, para o gatilho "writing a pull request body" da `description` não arrastar o menu inteiro.

## Resultados

A preencher depois das rodadas de comparação (R6).

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/finishing-a-development-branch/SKILL.md` | adotado | suíte verde antes do menu, detecção de ambiente, confirmação da base, menu de três opções (duas em HEAD destacado), execução de cada opção, descarte com `discard` digitado, limpeza por procedência, nunca `--force`, racionalizações
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/finishing-a-development-branch/SKILL.md` | recusado | anúncio no início, lista de comandos de teste, tabela "Quick Reference", desculpas que viraram frase do corpo
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/pr/SKILL.md` | adotado | base de `references/pr-body.md`: template Resumo, Evidência e Perigo de merge, menu de visuais condensado, evidência antes e depois, porta e raio de impacto; a `description` alimenta o "corpo de pull request" da skill
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/pr/SKILL.md` | recusado | exemplos de cada visual, exceto um `diff`; `metadata.credits` no frontmatter, que virou `LICENSES/NOTICE.md`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/pr/CREDITS.md` | adotado | crédito a Dex Horthy (`show-me`, HumanLayer) levado para `LICENSES/NOTICE.md`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/pr/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:modernize/SKILL.md.tmpl` | adotado | só ideias: ausência de conflito não prova nada, ler os commits da base desde o merge-base atrás do que a branch dá por certo, inclusive fora dos arquivos dela, explicar cada patch mudado do `range-diff`, não rebasear branch com commits de merge
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:modernize/SKILL.md.tmpl` | recusado | vereditos, afirmação em três frases, filtro de texto, identidade de bot, caminho de fork, push com lease preso ao SHA, regras sobre fechar pull request de outra pessoa
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:document-release/SKILL.md.tmpl` | adotado | só ideias: extrair do diff a superfície pública alterada, inclusive renomeada e removida, procurar nos documentos e apontar o que envelheceu; levar a dívida ao corpo do pull request
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:document-release/SKILL.md.tmpl` | recusado | mapa Diátaxis, deriva de diagramas, CHANGELOG, VERSION, TODOS, termos proibidos, modos `ship` e subagente, edição automática de documentos
