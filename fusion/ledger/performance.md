# Ledger: `performance`

Skill sem fonte externa. Nasce de um caso real: um sistema entregue pela Orbe tem uma tabela de 20 mil linhas e 85 colunas cuja busca demora, e nenhuma skill do DevOrb pensava em volume de dados na hora de projetar. Todo o texto é próprio, escrito a partir da spec `docs/specs/2026-11-20-performance-design.md` e das falhas do RED do caso `evals/performance-busca-planilha`, lidas palavra por palavra em `fusion/results/2026-11-20-performance-red.md` antes de existir qualquer linha da skill.

O caso reproduz a tabela real: um app Node com `node:sqlite`, 20 mil linhas, `id` mais 84 colunas de texto, uma busca que roda `SELECT *` e filtra tudo em JS, e uma tela que pede a busca a cada tecla. O pedido é "O cliente reclama que a busca da planilha demora. Resolve. Hoje não consigo responder perguntas."

O que o RED mostrou, nas 4 rodadas (2 com o DevOrb sem esta skill, 2 sem plugin):

- **Mediram antes de mexer.** Esse grader já passava.
- **Deixaram a busca em JS.** Todas trocaram a leitura por tecla por uma cópia da tabela guardada na memória do servidor ("a planilha é lida e normalizada uma vez e guardada em memória") e seguiram filtrando com `includes`. Nenhuma levou a busca para o banco. Limite de linhas só no servidor, e `SELECT *` mantido.
- **Relataram faixa, não mediana.** "A busca levava de 250 a 500 ms. Agora leva de 1 a 5 ms", sem mediana e sem o número de rodadas.

A skill foi escrita sem abrir `evals-reserved/`. Os graders do caso visível foram lidos para entender o cenário, e o texto diz o que um engenheiro sênior faria, não a redação dos graders.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Spec, com o texto fixado no plano (Task 2). Dispara em dois momentos: ao projetar ou planejar algo que lê dados guardados, e ao consertar tela ou consulta lenta |
| Abertura e o aviso de medir antes da primeira edição | Regra própria 6 |
| Passo 1: volume hoje e em um ano, tempo aceitável, contar ou assumir e registrar | Spec ("A skill `performance`", passo 1) |
| Orçamento padrão: busca abaixo de 200 ms no p95 do servidor, resposta à digitação abaixo de 100 ms, INP abaixo de 200 ms | Decisão do dono, registrada na spec e no plano |
| Lista pequena: só o limite na consulta, e a skill para ali | Regra própria 4 |
| Passo 2: a busca mora onde o dado mora; navegador só sem servidor com banco ou com lista pequena já inteira na tela | Regra própria 1 |
| Passo 2: a cópia da tabela na memória do servidor é a mesma varredura com um cache na frente | Regra própria 1, com as palavras do RED |
| Passo 3: ponteiro para cada referência, com a condição de leitura | Spec ("um arquivo por decisão, lido só quando a decisão aparece") e `writing-skills` (ponteiro que diz quando ler) |
| Passo 3: os quatro sinais | Regra própria 7 |
| Passo 3: tabela larga lista só as colunas que uma linha de lista precisa, numa consulta só, e a linha completa é lida por id | Regra própria 11 |
| Passo 4: orçamento na spec e no campo `**Performance budget:**` da task | Regra própria 8 |
| Passo 5: banco no volume real antes de medir | Spec (passo 5) |
| Passo 5: "ficou mais rápido" pela `devorb:verifying`, "cabe no orçamento" com 100 requisições e p95 | Regra própria 5 |
| Passo 5: sem porta local, medir a função que a rota chama e dizer isso | Regra própria 5, com o `listen EPERM` do RED |
| Passo 5: uma linha por afirmação, com mediana ou p95 e o número de rodadas; a faixa acompanha a mediana | Regra própria 2 |
| Passo 5: a linha "Faster" traz também a faixa de cada lado e as rodadas ruins | `devorb:verifying` ("Performance claims"), que exige as duas coisas junto das medianas. Ver Revisões |
| Passo 5: uma linha do relato para as colunas escolhidas numa tabela larga | Regra própria 11 |
| `references/search.md` | Regra própria 9 |
| `references/reads.md` e `references/lists.md` | Regra própria 10 |
| `Connects to` | Spec: recebe de `aligning`, `planning` e `debugging`, devolve para `verifying` |

## Conflitos resolvidos

Sem fonte externa, não há conflito entre fontes. Ficam registradas as escolhas entre leituras possíveis da spec e do brief:

- **Contagem de linhas ou lugar do dado:** o brief dizia que o navegador busca "só quando o volume cabe". A spec leu isso como "sem servidor com banco, ou lista pequena já inteira na tela". A skill segue a spec: quem decide onde a busca roda é onde o dado mora. O RED confirma a escolha, porque 20 mil linhas "cabem" na memória e foi por aí que todas as rodadas escaparam do banco.
- **5 rodadas ou 100 requisições:** a `verifying` mede "ficou mais rápido" com 5 rodadas alternadas por lado, e o orçamento do dono é em p95, que 5 rodadas não dão. São duas afirmações, cada uma com a sua medida. O método da primeira continua na `verifying`, e a skill só aponta para ele.
- **`debugging` ou `performance` numa lentidão relatada:** a `debugging` acha a causa e manda medir a base. A `performance` decide onde a leitura passa a rodar e qual prova fecha o conserto. A skill diz isso em uma linha na abertura e não repete o processo da `debugging`.
- **Receita no corpo ou em referência:** o corpo guarda o que toda leitura precisa (limite, colunas, os quatro sinais). O que só um ramo usa (Postgres, SQLite, navegador, cursor, virtualização) fica nas três referências.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. Todas têm o mesmo caso de origem, a tabela real de 20 mil × 85, e o caso de eval `evals/performance-busca-planilha`. Onde o RED mostrou a falha, ela está citada.

1. **A busca mora onde o dado mora. Com servidor e banco, busca, filtro e ordenação rodam no banco, por um índice, e a rota devolve uma página. Carregar a tabela uma vez e filtrar na memória do servidor é a mesma varredura com um cache na frente.** RED: 4 de 4 rodadas fizeram exatamente isso, e o grader `search-in-database` falhou com 3 de 3 votos em todas. A proibição entra porque a falha foi observada, e vem junto do alvo positivo (texto normalizado no banco, atrás de um índice).
2. **O relato traz uma linha por afirmação, com a mediana (ou o p95) e o número de rodadas. A faixa acompanha a mediana e nunca a substitui.** RED: 4 de 4 rodadas deram faixa ("250 a 500 ms", "1 a 5 ms"), e o grader `reports-medians` falhou com 3 de 3 votos. A forma é um modelo de três linhas para preencher, porque a falha foi deixar de fora um elemento de algo que o agente já produz.
3. **Volume e orçamento vêm antes de qualquer decisão: linhas e colunas hoje e em um ano, e o tempo aceitável. Sem número, contar o dado que existe ou assumir, e registrar qual dos dois. Sem orçamento no pedido, vale o padrão do dono.** Sem medição própria nesta skill. O caso `evals/aligning-volume-de-dados` mede o gancho na `aligning`.
4. **Lista que fica abaixo de cerca de mil linhas em um ano: só o limite na consulta, e a skill para ali.** O número é da spec ("Hipóteses"). A regra existe para a skill não empurrar FTS, cursor e virtualização para uma lista de 200 linhas, que a spec lista como fracasso mesmo funcionando. O texto foi estruturado para os passos 2 a 5 não alcançarem a lista pequena. Sem caso de eval: o revisor lê o texto.
5. **Duas provas, uma para cada afirmação.** "Ficou mais rápido": mediana antes e depois pelo método da `verifying`. "Cabe no orçamento": pelo menos 100 requisições com termos variados e reais, no volume real, com o p95 contra o orçamento. Quando o ambiente não abre porta, mede-se a função que a rota chama, e o relato diz isso. O tamanho da amostra (100) é da spec. A cláusula da porta vem do RED: uma rodada relatou `listen EPERM` e outras três disseram que o sandbox bloqueia porta local.
6. **Num conserto, a medição do antes vem antes da primeira edição.** O grader `measures-before-edit` já passava no RED. A frase fica na abertura porque a prova é o passo 5 de um procedimento em ordem, e sem ela a ordem dos passos empurraria a medição para depois da mudança.
7. **Toda leitura tocada sai sem nenhum dos quatro sinais: consulta sem limite, consulta por linha dentro de um laço (N+1), filtro ou ordenação sem índice, lista sem paginação nem virtualização.** A redação em inglês dos quatro sinais é única e será repetida igual nas Tasks 4 e 5 do plano (`task-reviewer.md` e `risk-review.md`). RED: todas as rodadas mantiveram `SELECT *` sem limite na consulta. As colunas saíram desta regra e viraram a regra própria 11, depois do GREEN 1.
8. **O orçamento fica escrito: na spec, junto do volume, e em cada task do plano que lê dados, no campo `**Performance budget:**`. Conserto sem spec nem plano diz o orçamento no relato.** Sem medição própria. O campo entra no modelo de task na Task 3 do plano.
9. **`references/search.md`.** Postgres: coluna `search_text` gerada (só as colunas pesquisáveis, sem acento e em minúsculas) com índice `pg_trgm`, ou full-text para palavra inteira. SQLite: FTS5. Navegador, só sem servidor com banco ou com lista pequena já na tela: índice montado uma vez, debounce, Web Worker acima de cerca de 50 mil linhas. Outros bancos: uma linha. Os valores são da spec. Três avisos vieram de rodar a receita de SQLite na fixture do caso, em pasta temporária: o termo `xyzzy-inexistente` sem aspas falha com `no such column: inexistente`, um termo de 2 caracteres não casa nada no tokenizador `trigram`, e a montagem do índice em 20 mil × 84 levou 766 ms, com busca abaixo de 0,1 ms.
10. **`references/reads.md` e `references/lists.md`.** Leitura: paginação por cursor, só as colunas que uma linha de lista precisa (regra própria 11), nunca `select *` sem limite, N+1 trocado por join ou carga em lote, índice para todo filtro e toda ordenação. Tela: paginar primeiro, virtualizar a lista longa, só as linhas visíveis no DOM. Os valores são da spec. Sem medição própria: o caso visível só julga `src/planilha.js` e a última mensagem.
11. **Tabela larga (mais de cerca de 12 colunas): uma consulta só devolve a página, com o id e as poucas colunas que dizem a uma pessoa qual é o registro. Nada lê as outras colunas até alguém abrir a linha, e aí uma leitura por id traz a linha completa. Uma leitura por linha listada, para preencher uma coluna ou achar o que casou, é o N+1 da regra 7. A tela que desenha todas as colunas faz parte da lentidão e não serve de guia para a consulta. Sem ninguém para dizer quais colunas identificam um registro, o agente escolhe pelos dados e nomeia as colunas no relato. Tabela estreita lista as colunas que mostra.** Caso: GREEN 1 em `devorb@cfb95e2`, DevOrb 0% (0,50), US$ 1,66, relatório `fusion/results/2026-11-20-performance-green-1.md`. As 2 rodadas já buscaram no SQLite com FTS5 `trigram` e `LIMIT`, e relataram medianas com o número de rodadas. As 2 falharam só nas colunas: uma terminou com `SELECT p.* FROM planilha_fts f JOIN planilha p`, a outra montou a lista com `PRAGMA table_info(planilha)` e nomeou as 84 colunas mais o `id`. Nenhuma das duas tratou as colunas como decisão no relato. Causa no texto: a primeira versão dizia "each query names the columns its screen shows", e a tela da fixture desenha as 85 células de cada linha, então "as colunas que a tela mostra" eram todas. A regra troca a tela pela pergunta "o que uma linha de lista precisa", com uma condição que se vê na tabela (o número de colunas, que o passo 1 já anota) e uma linha própria no modelo de relato. O limite de cerca de 12 colunas é meu. Medido na fixture, em pasta temporária: uma página de 50 linhas tem 82 KB com todas as colunas e 5 KB com três colunas mais o texto que casou (`snippet()` do FTS5), com mediana de 0,42 ms. O texto que casou saiu da regra depois do GREEN 2 e ficou só como opção em `references/search.md`, quando o índice o devolve na mesma consulta (ver Revisões).

## Fora

- **Cache, CDN, fila, réplica de leitura, teste de carga e tamanho de bundle:** fora pela spec.
- **Gestão de colunas da tabela densa** (o usuário escolher, ordenar e fixar colunas): é da frente C. A skill só decide o que a consulta da lista devolve numa tabela larga (regra própria 11).
- **Como medir uma comparação** (rodadas alternadas, faixa, rodadas ruins, veredito): fica em `verifying/references/performance.md`. A skill aponta para lá.
- **Como achar a causa de uma lentidão:** é da `debugging`.
- **Receita própria para MySQL, SQL Server e outros bancos:** uma linha ("mesma ideia, índice equivalente"), como decidido na spec.
- **O `innerHTML` sem escape que as rodadas do RED notaram na fixture:** é segurança, não velocidade.
- **Como medir resposta à digitação e INP:** a skill dá os dois orçamentos e manda relatar como não medido quando não há navegador. O roteiro de medição em navegador não entrou, porque nenhum caso o exercita.

## Revisões

- **2026-11-20, rodada de conserto 1, depois do GREEN 1 e da revisão da task.** `SKILL.md` foi de 4.316 para 4.935 bytes (cerca de 1.079 para 1.234 tokens).
  - **Colunas de tabela larga:** regra própria 11. No passo 3, a frase "Each query names the columns its screen shows; a table too wide to show whole lists a few columns and loads the full row on demand" saiu, e entrou o parágrafo "Wide table". O modelo de relato ganhou a linha "Columns:". `references/reads.md` trocou a seção "Only the displayed columns" por "Only the columns a list row needs", e `references/search.md` ganhou o texto que casou (`snippet()` no FTS5), para a linha explicar por que veio quando as colunas listadas não contêm o termo.
  - **`content-visibility` saiu de `references/lists.md`** (achado Important da revisão). A frase oferecia `content-visibility: auto` como "opção leve" dentro de "Virtualization", cuja regra é só as linhas visíveis no DOM. Com `content-visibility` todas as linhas continuam no DOM, e a própria checagem do arquivo (o número de linhas no DOM fica estável) falharia.
  - **A linha "Faster" do modelo de relato** ganhou a faixa de cada lado e as rodadas ruins (achado Minor da revisão): a `verifying` exige as duas junto das medianas, e o modelo deixava as duas de fora.
- **2026-11-20, rodada de conserto 2, depois do GREEN 2.** GREEN 2 em `devorb@b5c0ea0`: DevOrb 50% (0,75), sem plugin 0% (0,33), US$ 1,79, relatório `fusion/results/2026-11-20-performance-green-2.md`. `SKILL.md` foi de 4.935 para 5.039 bytes (cerca de 1.260 tokens).
  - **O que aconteceu.** A rodada 0 passou nos três graders: índice FTS5 com uma coluna por coluna da tabela, uma consulta com `JOIN`, cinco colunas nomeadas, `snippet()` e cursor. A rodada 1 falhou em `search-in-database` (3 de 3 votos): montou um índice FTS5 de uma coluna só, com o texto da linha concatenado e normalizado em JS, buscou os ids e depois, para saber qual coluna casou, rodou `SELECT id, c01, …, c84 FROM planilha WHERE id = ?` uma vez por id e procurou o termo nos 84 valores em JS. Devolveu poucas colunas e nomeou-as no relato, mas leu do banco 50 linhas de 85 colunas, uma consulta por linha.
  - **Causa no texto.** Duas frases da skill. A rodada de conserto 1 pôs "the text that matched" entre o que a lista de uma tabela larga devolve, sem dizer de onde ele vem; com um índice de texto concatenado, o agente não tinha como tirá-lo do índice e releu as linhas. E o passo 2 e a `search.md` diziam "put the normalized text in the database" e "normalize once, at write time", que descrevem justamente o texto normalizado em JS e copiado para o índice. O relato da rodada 1 ainda avisa que esse índice "não se atualiza sozinho".
  - **O que mudou.** No `SKILL.md`, o texto que casou saiu da regra da tabela larga e do modelo de relato, e a regra passou a dizer que uma consulta só devolve a página e que uma leitura por linha listada é o N+1 dos quatro sinais. A proibição entra porque a falha foi observada, e vem depois do alvo positivo. No passo 2, "Put the normalized text in the database, behind an index" virou "Let the database normalize and index the text". Em `references/search.md`, "Normalize once, at write time" virou "The database normalizes" (tokenizador ou coluna gerada), o texto que casou ficou como opção só quando o índice o devolve na mesma consulta, com "Never re-read rows to find the match", e a seção de SQLite diz uma coluna FTS por coluna pesquisável, não uma coluna de texto concatenado. Em `references/reads.md`, entrou a linha "One query returns the page".
  - **Medido na fixture**, em pasta temporária, 7 termos × 9 execuções, página de 50 linhas: ids e depois uma leitura de 85 colunas por linha com varredura em JS, mediana de 0,93 ms; uma consulta com `JOIN` e três colunas, 0,05 ms; a mesma consulta com `snippet()`, 0,45 ms. As três cabem no orçamento de 200 ms: a regra existe pelo padrão (uma ida ao banco por linha, que cresce com a página e com a distância do banco), não por esse número.

## Resultados

Opus 5.5, 2 rodadas por caso, `--ablation none`, braços `devorb` e `none`.

| Caso | Fase | Commit | DevOrb | Sem plugin | Custo | Relatório |
|---|---|---|---|---|---|---|
| `performance-busca-planilha` | RED | `devorb@182823b` | 0% (0,33) | 0% (0,33) | US$ 1,65 | `fusion/results/2026-11-20-performance-red.md` |

- RED, por grader, nas 4 rodadas: `measures-before-edit` passa, `search-in-database` falha (3 de 3 votos), `reports-medians` falha (3 de 3 votos).

## Decisões por commit de fonte

Nenhuma. A skill não tem fonte externa, e nenhuma entrada de `fusion/sources.json` a alimenta.
