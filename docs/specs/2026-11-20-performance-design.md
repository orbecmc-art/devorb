# Frente A: performance desde o projeto

Data: 2026-11-20. Branch `claude/performance`, a partir da `main` em `d7dc0a1` (versão 1.15.0). Origem: `docs/briefs/2026-11-20-evolucao-devorb.md`, frente A e "Regras para as três frentes" (o brief está sem commit no checkout principal; esta spec repete o que ele decide, para o construtor não depender dele).

## Intenção

Um sistema entregue pela Orbe tem uma tabela de 20 mil linhas e 85 colunas cuja busca demora. 20 mil linhas é pouco: a busca certa responde em menos de 100 ms. O DevOrb hoje só mede velocidade depois do fato (`skills/verifying/references/performance.md`) e trata lentidão como bug (`debugging`). Nenhuma skill pensa em volume de dados na hora de projetar. O dono quer que o DevOrb projete para o volume real e prove a velocidade com número, antes de o cliente reclamar.

## Objetivos

1. Skill nova `devorb:performance`, invocação `auto`, nível `full`, que decide, a partir do volume de dados, onde cada leitura roda, e entrega a receita.
2. Ganchos curtos nas skills que já existem, cada um apontando para a `performance`.
3. Rota na tabela da `using-devorb`.
4. Três casos de eval novos, com RED antes de qualquer `SKILL.md`, e um caso reservado da `performance`.

## Fora

- Frentes B (piso de código) e C (telas de operação), mesmo onde encostam: gestão de colunas da tabela densa é da C.
- Cache, CDN, fila, réplica de leitura, teste de carga e tamanho de bundle.
- Mudar `tools/compare.mjs` ou `fusion/eval-config.json`. O modelo dos evals fica `claude-opus-5-5`, para os resultados seguirem comparáveis com os anteriores. O `maxCostUsd` também não muda.
- Subir a versão em `.claude-plugin/plugin.json` e registrar no `CHANGELOG.md`: o brief põe os dois depois do merge, que é do dono. O texto da entrada do changelog vai pronto no relatório final.
- Merge e push.

## O que seria fracasso mesmo funcionando

- A skill empurrar FTS, cursor e virtualização para uma lista de 200 linhas que não cresce. Sem volume que justifique, o simples fica (com limite na consulta).
- Receita aplicada sem número: "ficou mais rápido" sem mediana antes e depois.
- Skill ou gancho que estoura um teto e é resolvido subindo o teto.

## Caminhos considerados

| Caminho | Troca | Decisão |
|---|---|---|
| A. Uma skill com receitas em `references/` e ganchos finos nas outras | Custa cerca de 40 tokens fixos por sessão; dá um lugar só para as receitas e dispara na hora do projeto | **Escolhido** (decisão do dono, no brief) |
| B. Sem skill nova: as regras entram nos `references/` de `planning`, `verifying` e `reviewing` | Custo fixo zero; mas nada dispara quando o trabalho não passa por um gancho, e as receitas ficam espalhadas em três lugares | Recusado: o brief pede a skill |
| C. Skill em setor próprio em `SECTOR_CAPS` | Só faz sentido se a descrição não coubesse na base | Desnecessário: sobram 71 dos 706 tokens |

## A skill `performance`

`skills/performance/SKILL.md`, em inglês, com `Connects to`. Registro em `fusion/skills.json`: `invocation: "auto"`, `level: "full"`, `ceilingTokens: 2500`, sem `sector`. Nome mais descrição em no máximo 60 tokens (bytes ÷ 4), começando por "Use when". A descrição precisa disparar em dois momentos: ao projetar ou planejar algo que lê, lista, busca ou filtra dados guardados, e ao consertar uma tela ou consulta lenta. Ela não toma o lugar da `debugging` (que acha a causa de uma lentidão relatada) nem da `verifying` (que prova o número): recebe das duas e devolve para a `verifying`.

O corpo é um procedimento curto, nesta ordem:

1. **Volume e orçamento.** Linhas e colunas hoje e em um ano, e o tempo aceitável. Vêm da spec; sem número, medir no dado que existe ou assumir e registrar. Sem orçamento no pedido, vale o padrão abaixo.
2. **Onde cada leitura roda.** A busca mora onde o dado mora: havendo servidor com banco, busca, filtro e ordenação rodam no banco, qualquer que seja o volume acima do pequeno. O navegador só busca quando não existe servidor com banco para perguntar (dado estático, app offline) ou quando a lista é pequena e já está inteira na tela. A tabela de 20 mil × 85 com SQLite atrás de uma rota é caso de banco.
3. **A receita** do `references/` correspondente.
4. **O orçamento escrito** na spec e na task do plano.
5. **A prova**, com o banco populado no volume real. São duas afirmações diferentes, cada uma com a sua medida:
   - "Ficou mais rápido" (conserto): mediana antes e depois, pelo método que a `verifying` já tem (`references/performance.md`, 5 rodadas alternadas por lado). A medição do antes vem antes da primeira edição.
   - "Cabe no orçamento" (trabalho novo ou conserto): pelo menos 100 requisições com termos variados e reais, relatando o p95 contra o orçamento. Esse procedimento fica na `performance`, não na `verifying`.

Orçamento padrão (decidido pelo dono): busca abaixo de 200 ms no p95 do servidor; resposta à digitação abaixo de 100 ms; INP abaixo de 200 ms.

Receitas, um arquivo por decisão, lido só quando a decisão aparece:

- `references/search.md`, onde a busca vive. Servidor com Postgres: coluna `search_text` gerada (só as colunas pesquisáveis, sem acento e em minúsculas) e índice `pg_trgm` ou full-text. SQLite: FTS5. Navegador, só quando o volume cabe: índice calculado uma vez, debounce, Web Worker acima de cerca de 50 mil linhas.
- `references/reads.md`, leitura. Paginação por cursor; só as colunas exibidas; nunca `select *` sem limite; N+1 trocado por join ou carga em lote; índice para todo filtro e toda ordenação.
- `references/lists.md`, tela. Virtualização para lista longa; só as linhas visíveis no DOM.

## Ganchos

| Onde | O que entra | Folga hoje |
|---|---|---|
| `skills/aligning/SKILL.md` | Para trabalho que lê dados: perguntar o volume hoje e em um ano e o tempo aceitável; sem pessoa para responder, assumir e registrar na spec | 2 tokens de 2500: o texto novo é pago cortando texto existente |
| `skills/planning/references/task-template.md` | Task que lê dados ganha o campo `**Performance budget:**` | sem teto |
| `skills/implementing/prompts/task-reviewer.md` | Achado bloqueante: consulta sem limite, N+1, filtro ou ordenação sem índice, lista sem paginação nem virtualização | sem teto |
| `skills/verifying/references/performance.md` | Popular com o volume real antes de medir | sem teto |
| `skills/reviewing/SKILL.md` e `skills/reviewing/references/risk-review.md` | O gatilho de risco no `SKILL.md`; os quatro sinais e a severidade bloqueante no `risk-review.md`, que é o que o subagente revisor recebe | 593 tokens no `SKILL.md`; a referência não tem teto |
| `skills/using-devorb/SKILL.md` | Uma linha na tabela de rotas | 1 token de 875 e 6 bytes de 3500: a linha é paga cortando texto existente |

O gancho na `reviewing` não está no brief. Entra porque o caso `reviewing-consulta-sem-limite` exercita a skill `reviewing`, e o brief só põe o gancho no `task-reviewer.md`; sem ele o caso não tem como ficar verde.

O revisor de task é um subagente que só recebe o prompt: os quatro sinais ficam escritos no próprio `task-reviewer.md`, com o ponteiro para a `performance` só para o conserto.

## Testes

Casos em `evals/`, prompt e graders em português, `scaffold.sh` sem rede e reproduzível.

- **`performance-busca-planilha`.** Repositório Node com `node:sqlite`, 20 mil linhas × 85 colunas geradas no `scaffold.sh`, uma rota que carrega tudo e filtra em JS, uma tabela que desenha todas as linhas. Prompt: "O cliente reclama que a busca da planilha demora. Resolve. Hoje não consigo responder perguntas." Graders: `regex` no trace mostra uma medição antes da primeira edição; `llm` nos arquivos finais confere busca no banco com índice ou FTS, limite e colunas enxutas; `llm` na última mensagem confere mediana antes e depois, com o número de rodadas.
- **`aligning-volume-de-dados`.** Pedido de tela de clientes com busca, sem volume informado e sem pessoa para responder. Grader: a spec escrita registra volume e orçamento de performance.
- **`reviewing-consulta-sem-limite`.** Branch com um N+1 e um `select *` sem limite plantados. Grader: os dois aparecem como achado bloqueante.
- **Reservado da `performance`** em `evals-reserved/`, escrito por um subagente novo que não viu o rascunho da skill. Quem escreve a skill não abre o caso nem os graders até a skill estar pronta.

Protocolo:

1. Commit dos três casos. `scaffold.sh` validado numa pasta temporária.
2. **RED** nesse HEAD, antes de qualquer `SKILL.md`: `node tools/compare.mjs --skill <prefixo> --arms devorb,none --runs 2`, uma chamada por caso, uma de cada vez. Prefixos: `performance`, `aligning-volume`, `reviewing-consulta`. O relatório do RED é renomeado para `-red.md` antes do GREEN, porque duas rodadas no mesmo dia se sobrescrevem.
3. Um caso em que o braço `devorb` já passa é fraco: reescrever uma vez. Se passar de novo, o gancho daquele caso não se justifica; parar e levar ao dono.
4. Skill, ganchos, registro e rota.
5. **GREEN**: `--arms devorb,none --runs 2`, de novo uma chamada por caso. O braço `none` roda e é cobrado de novo: o cache da ferramenta só vale para os braços de fonte. Precisa de `accepted: true` **e** de aprovação do `devorb` em pelo menos 2/3 no relatório: com 0% nos dois braços a ferramenta chama de lacuna e imprime `accepted: true` assim mesmo.
6. **Reservado**: `--skill performance --reserved --arms devorb,none --runs 2`.
7. `npm test` verde em cada commit. `tests/layout.test.mjs` fixa 19 skills de base: passa a 20.

## Orçamento

Teto pago da frente: US$ 40. Decisão do dono em 2026-11-20: 2 rodadas por caso, só os três casos novos mais o reservado. As suítes antigas das skills tocadas não rodam de novo.

| Rodada | Chamadas | Estimativa |
|---|---|---|
| RED (3 casos, `devorb` e `none`, 2 rodadas) | 3 | US$ 12 a 24 |
| GREEN (os mesmos 3) | 3 | US$ 12 a 24 |
| Reservado (1 caso) | 1 | US$ 4 a 8 |
| Total | 7 | US$ 28 a 56 |

A estimativa usa US$ 4 a 8 por chamada (um caso, dois braços, 2 rodadas), medida nos relatórios de 2026-11-19: o braço `devorb` custou de US$ 3,63 a 7,02 e o `none` cerca de US$ 0,60. **O meio da faixa é o próprio teto.** Uma repetição de GREEN, ou casos mais caros que os de ontem, não cabem em US$ 40.

O custo real de cada chamada da `compare.mjs` é mostrado ao dono logo depois dela, com o acumulado. Antes de cada chamada: se o acumulado mais a estimativa da próxima passar de US$ 40, parar e perguntar. A estimativa de um GREEN é o custo real do RED do mesmo caso; a de um RED é US$ 8. Uma rodada GREEN que falha repete só o caso que falhou. Se o dinheiro acabar, a ordem de prioridade é `performance-busca-planilha`, depois os dois ganchos, depois o reservado; o que não chegou a verde é entregue dito como não aprovado.

Para o custo por caso ficar baixo: `max_turns` e `timeout_seconds` justos em cada `case.yaml`, e os casos da `aligning` e da `reviewing` não editam código (um escreve só a spec, o outro só revisa).

O `maxCostUsd: 20` do `eval-config.json` vale por braço e por chamada: ele não segura o teto da frente. Quem segura é a conta acima.

## Ledger

`fusion/ledger/performance.md`, em português. Nenhuma fonte externa alimenta a skill: toda regra entra como **Regra própria**, com o caso que a justifica (a tabela de 20 mil × 85 e o caso de eval). Cada gancho ganha uma Regra própria no ledger da skill tocada, com caso, RED e GREEN (sha e custo) e os arquivos de resultado.

## Hipóteses (decididas por mim, corrigíveis)

- **Três ganchos entram sem caso de eval próprio:** `planning` (campo na task), `verifying` (popular antes de medir) e `task-reviewer.md` (os quatro bloqueios). O brief dá três casos e o teto não paga mais. Os três mexem só em `references/` e `prompts/`, nunca em `SKILL.md`, então a regra "RED antes de qualquer `SKILL.md`" vale ao pé da letra. O ledger registra cada um como Regra própria justificada pelo caso real, com a nota "sem medição própria".
- **Sem subir teto.** `aligning` e `using-devorb` recebem o texto novo cortando o mesmo tanto de texto existente. Os cortes não tiram regra: saem palavras, não comportamento. Cada corte fica listado no ledger. O risco de regressão nos 17 casos da `using-devorb` e nos 2 da `aligning` fica sem medição, como decidido.
- **"Volume pequeno"** = lista que fica abaixo de cerca de mil linhas em um ano. Nela a skill pede só o limite na consulta, sem FTS nem virtualização. O número é meu.
- **Onde a busca roda** segue onde o dado mora, não uma contagem de linhas (passo 2 da skill). O "só quando o volume cabe" do brief eu li como: sem servidor com banco, ou lista pequena já inteira na tela. O Web Worker acima de cerca de 50 mil linhas vale só dentro desse caso de navegador.
- **p95 com 100 requisições.** O orçamento do dono é em p95; 5 rodadas não dão p95. O tamanho da amostra (100) é meu.
- **O RED do caso principal pode sair quase verde.** A `debugging` já manda medir antes e a `verifying` já pede mediana e rodadas. Se dois dos três graders passarem no RED, quem separa os braços é o grader dos arquivos finais (busca no banco, limite, colunas): ele leva peso 3.
- **"Bloqueante"** = severidade Critical ou Important, as duas que vão para o laço de correção na `reviewing` e no revisor de task.
- **Banco das receitas:** Postgres e SQLite, os dois do brief. MySQL e outros ficam com uma linha ("mesma ideia, índice equivalente"), sem receita própria.
- **Ordem dos commits:** casos, depois RED, depois a skill com registro e rota no mesmo commit, porque `tests/bootstrap.test.mjs` exige a skill `auto` de base citada na `using-devorb` assim que é registrada.

## Com o construtor

- Texto das skills em inglês; ledger, prompts e graders em português. Mudança em skill segue `skills/writing-skills/references/devorb.md`.
- O texto exato da descrição, dos ganchos e das receitas, e quais palavras cortar na `aligning` e na `using-devorb`.
- O formato do `regex` de "medição antes da primeira edição" e como o grader da `aligning` acha a spec escrita.
- A versão do Node no ambiente do eval: `node:sqlite` precisa existir; o `scaffold.sh` confere e falha com mensagem clara.
- Nunca duas `compare.mjs` ao mesmo tempo no mesmo HEAD: a ferramenta apaga e recria `.arms/devorb@<sha>`.
