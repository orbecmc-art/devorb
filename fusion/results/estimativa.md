# Estimativa de custo dos testes

- Data: 2026-11-11. Task 6, Step 5 do plano da base.
- Modelo: `claude-opus-5-5`, o mesmo de todas as execuções medidas.
- Valores em US$ nocionais, como `claude plugin eval` informa. Quem paga é a assinatura Max do dono (ver seção 5).
- Base: os relatórios de `fusion/results/`, as linhas de base em `fusion/results/baselines/` e os planos da base, do design e do mobile. Nada de `evals-reserved/` foi aberto.

## 1. Custo medido na Task 6

Cada linha dos relatórios soma todas as rodadas daquele caso naquele braço. Os arquivos de cache confirmam: `"runs": 3` e `costUsd` total.

| Execução | Braços que rodaram | Rodadas | Custo |
|---|---|---:|---:|
| Step 3, linha de base `debugging` | `superpowers`, `mattpocock-skills`, `none` | 36 (4 casos × 3 × 3) | US$ 5,23 |
| Step 3, linha de base `using-devorb` | `superpowers`, `mattpocock-skills`, `none` | 27 (3 casos × 3 × 3) | US$ 3,88 |
| Step 3, comparação `debugging` | `devorb` (fontes do cache) | 12 (4 × 3) | US$ 2,32 |
| Step 3, comparação `using-devorb` | `devorb` e `none` (fontes do cache; `none` não tem cache) | 18 (3 × 3 × 2) | US$ 2,69 |
| Step 3, reservado `debugging` (`--reserved`, relatório `2026-11-11-debugging-reserved.md`) | `devorb`, `superpowers`, `mattpocock-skills` | 9 (1 caso × 3 × 3) | US$ 2,92 (estimado antes: US$ 2,80) |
| Step 3, reservado `using-devorb` (`--reserved`, relatório `2026-11-11-using-devorb-reserved.md`) | `devorb`, `superpowers`, `mattpocock-skills`, `none` | 12 (1 caso × 3 × 4) | US$ 2,42 (estimado antes: US$ 1,82) |
| **Medido até agora** | | **114** | **US$ 19,46** |
| Step 4, `debugging --with-ponytail` | `devorb`, `superpowers`, os dois com ponytail | 24 (4 × 3 × 2) | US$ 4,62 (medido; estimado US$ 5,05) |
| **Restante da Task 6** | | **24** | **US$ 4,62 (medido)** |

Os dois reservados terminaram enquanto esta estimativa era escrita, e os relatórios deles ainda não estão no commit. A suíte reservada não tem linhas de base em cache, então os braços de fonte rodaram nela. No reservado de `using-devorb`, duas rodadas do `devorb` deram erro da ferramenta, e a comparação não aprovou: repetir o braço `devorb` custa uns US$ 0,71, coberto pela margem.

A estimativa do Step 4 usa a seção 2: 1 caso R e 3 casos P, com +10% pelo ponytail. O cache do ponytail é outro, porque a chave inclui `withPonytail` e o commit do ponytail, então o braço `superpowers` também roda.

Referência fora da Task 6: a Task 4, Step 5, rodou `evolving` com `--ablation with-without`, 5 casos × 2 rodadas × (com e sem o plugin), ou seja, 20 sessões, por US$ 7,38. A repetição de `evolving-source-failed`, com 2 rodadas, custou mais US$ 0,32. A execução descartada, que deu 0% por causa do git no sandbox, não tem relatório e não entra em nenhuma soma.

## 2. Custo por rodada por tipo de caso

Rodada é uma sessão do agente num caso. Custo por rodada é o custo da linha dividido pelas rodadas.

| Tipo | Caso medido | `devorb` | `superpowers` | `mattpocock-skills` | `none` | Como saiu |
|---|---|---:|---:|---:|---:|---|
| **R**: realista em repositório, até 60 turnos | `debugging-flaky-payment` | 0,379 | 0,319 | 0,236 | 0,215 | Medido: linha ÷ 3 |
| **P**: cenário de pressão, resposta de uma letra | os 3 `debugging-pressure-*` | 0,148 | 0,130 | 0,119 | 0,110 | Medido: soma das 3 linhas ÷ 9 |
| **T**: roteamento ou resposta curta, 8 turnos | os 3 `using-devorb-*` | 0,176 | 0,174 | 0,132 | 0,124 | Medido: soma ÷ 9. `none` é a média das duas execuções, 18 rodadas |
| **L**: fluxo longo, 80 turnos | os 5 `evolving-*` | 0,47 | 0,40 | 0,29 | 0,27 | Derivado. Medido: US$ 0,369 por sessão, misturando com e sem o plugin. A separação usa a razão `devorb`/`none` do tipo R (1,76), e os braços de fonte seguem as razões do tipo R |
| **H**: implementação com subagentes, 150 turnos | nenhum | 0,94 | 0,79 | 0,59 | 0,54 | Estimado: 2 × L |
| **F**: fluxo inteiro, 200 turnos | nenhum | 1,18 | 0,99 | 0,73 | 0,67 | Estimado: 2,5 × L |

- `ui-ux-pro-max` (D2 e D3): estimado igual a `superpowers`.
- Ponytail ligado: estimado em +10% por braço, até a medição do Step 4.
- Média medida das 93 rodadas da Task 6: US$ 0,152.
- `evolving` por sessão: `no-change` 0,23, `planned-only` 0,33, `rehearsal` 0,59, `rewritten` 0,35 e `source-failed` 0,41. O caso principal custa quase o dobro dos casos de uma rodada.
- Conferência com os reservados, que chegaram depois da tabela: o realista saiu a 0,40 por rodada no `devorb` e no `superpowers` e 0,33 no `mattpocock-skills` (US$ 2,92 contra 2,80 estimados, +4%). O de roteamento saiu a 0,24, 0,24, 0,18 e 0,16 (US$ 2,42 contra 1,82, +33%). A tabela continua com os casos dos relatórios já no commit, e a seção 5 mostra o efeito.

**Diferenças por braço:**

- `devorb` custa mais que `superpowers`: +19% no realista, +14% na pressão e +1% no roteamento. No realista, foi o único braço a corrigir o bug na origem (100% contra 0%), e a rodada foi mais longe.
- `mattpocock-skills` custa uns 25% menos que `superpowers` no realista e no roteamento. No roteamento, ele não disparou skill nenhuma.
- `none` é o piso: US$ 0,11 a 0,12 por rodada até num caso de uma letra. Isso é o custo de abrir a sessão. O resto vem do texto que a skill carrega e do trabalho que ela provoca. `devorb` sobre `none`: 1,76× no realista, 1,34× na pressão e 1,42× no roteamento.
- O braço `none` não entra no cache, então roda de novo em toda comparação que o inclui.

## 3. Estimativa por task

**Como as rodadas foram contadas,** pelo comportamento atual de `tools/compare.mjs`:

- R3 (`--baseline-only` sem `--arms`) roda `superpowers`, `mattpocock-skills` e `none` nas tasks da base. As tasks 23, 24 e as do design e do mobile dizem os braços.
- R6 roda só `devorb`, mais `none` quando ele está nos braços. As fontes saem do cache do R3, porque a chave (modelo, rodadas, ponytail, ablação e hash do caso) é a mesma.
- Reservado, só no nível completo: a suíte `evals-reserved` não tem cache, então `devorb` e os braços de fonte rodam.
- Rodadas por caso: 3 no nível completo, 2 no leve, e 3 em `using-devorb` e em `--skill all`, porque o registro não tem `all` e o padrão é 3.
- Cenários de pressão: no pino do Superpowers (`22f0b46`, que hoje também é o último commit da `main`), só existe `tests/systematic-debugging/pressure-scenarios/`. Nenhuma outra skill de nível completo ganha casos de pressão.
- Um caso novo por skill, salvo quando a task pede mais. O tipo de cada caso novo é estimado pela descrição na task.
- R5 do design e do mobile, e o passo final da Task 10: `compare --skill using-devorb --arms devorb,superpowers` roda só `devorb` nos 3 casos de roteamento, com `superpowers` no cache. São 9 rodadas, cerca de US$ 1,59 por task.
- Ordem suposta: base (7 a 17, 23 e 24), depois a Task 21, depois o design (D1 a D7), depois o mobile (M1 a M4). A ordem muda quantos casos cada `--skill all` pega.

| Task | Skill | Nível | Casos (tipo) | Rod./caso | Braços que rodam | Rodadas | Custo est. |
|---|---|---|---|---:|---|---:|---:|
| 7 | `tdd` | completo | 1 R, 1 reservado R | 3 | R3: sp, matt, none. R6: devorb. Reservado: devorb, sp, matt | 21 | US$ 6,25 |
| 8 | `verifying` | completo | 1 R, 1 reservado R | 3 | R3: sp, matt, none. R6: devorb. Reservado: devorb, sp | 18 | US$ 5,54 |
| 9 | `domain-modeling` | leve | 1 R | 2 | R3: sp, matt, none. R6: devorb | 8 | US$ 2,30 |
| 10 | `aligning` | completo | 1 T, 1 reservado T, mais `using-devorb` (3 T) | 3 | R3: sp, matt, none. R6: devorb. Reservado: devorb, sp, matt. `using-devorb`: devorb | 30 | US$ 4,85 |
| 11 | `planning` | leve | 1 R | 2 | R3: sp, matt, none. R6: devorb | 8 | US$ 2,30 |
| 12 | `codebase-design` | leve | 1 T | 2 | R3: sp, matt, none. R6: devorb | 8 | US$ 1,21 |
| 13 | `implementing` | completo | 1 H, 1 reservado H | 3 | R3: sp, matt, none. R6: devorb. Reservado: devorb, sp, matt | 21 | US$ 15,52 |
| 14 | `reviewing` | leve | 1 L (dois eixos em subagentes) | 2 | R3: sp, matt, none. R6: devorb | 8 | US$ 2,85 |
| 15 | `finishing` | leve | 1 R | 2 | R3: sp, matt, none. R6: devorb | 8 | US$ 2,30 |
| 16 | `writing-skills` | leve | 1 R | 2 | R3: sp, matt, none. R6: devorb | 8 | US$ 2,30 |
| 17 | `improve-architecture`, `prototype`, `handoff`, `retro` | leve | 4 (L, R, R, T) | 2 | R3: sp, matt, none. R6: devorb | 32 | US$ 8,66 |
| 23 | `browser-testing` | leve | 1 L, mais a sondagem de Chromium (1 rodada R) | 2 | Sondagem: devorb. R3: none. R6: devorb, none | 7 | US$ 2,39 |
| 24 | `security-audit` | leve | 1 L (verificador em subagente) | 2 | R3: none. R6: devorb, none | 6 | US$ 2,01 |
| **Base** | | | | | | **183** | **US$ 58,48** |
| D2 | `visual-direction` | completo | 2 L, 1 reservado L | 3 | R3: none, ui-ux-pro-max. R6: devorb, none. Reservado: devorb, none, ui-ux-pro-max. R5 | 42 | US$ 13,40 |
| D3 | `design-system` | leve | 3 L | 2 | R3: none, ui-ux-pro-max. R6: devorb, none. R5 | 33 | US$ 9,99 |
| D4 | `motion` | leve | 1 R | 2 | R3: none. R6: devorb, none. R5 | 15 | US$ 3,20 |
| D5 | `ui-review` | leve | 1 R (o reforço do Review Focus 5 conta no mesmo caso, estimado) | 2 | R3: none. R6: devorb, none. R5 | 15 | US$ 3,20 |
| D6 | `diagram` | leve | 2 (R, T) | 2 | R3: none. R6: devorb, none. R5 | 21 | US$ 4,05 |
| **Design (D2 a D6)** | | | | | | **126** | **US$ 33,85** |
| M1 | `native-app` | completo | 2 R, 1 reservado R | 3 | R3: none. R6: devorb, none. Reservado: devorb, none. R5 | 33 | US$ 8,23 |
| M2 | `device-testing` | leve | 2 R | 2 | R3: none. R6: devorb, none. R5 | 21 | US$ 4,82 |
| M3 | `mobile-release` | leve | 1 R | 2 | R3: none. R6: devorb, none. R5 | 15 | US$ 3,20 |
| M4, Steps 2 e 4 | `using-devorb` | — | 7 T (3 da base, 2 da D7, 2 novos do mobile, estimado) | 3 | Step 2: devorb, sp (um caso novo refaz o glob inteiro no sp). Step 4, a repetição: devorb | 63 | US$ 11,06 |
| M4, Step 4 | `--skill all` | — | 47 (17 R, 14 L, 11 T, 3 P, 1 H, 1 F) | 3 | devorb, sp (o sp roda os 47, pelo mesmo motivo) | 282 | US$ 97,73 |
| **Mobile (M1 a M4)** | | | | | | **414** | **US$ 125,04** |
| 21 | `--skill all --with-ponytail` | — | 29 (os 12 de hoje, 16 novos da base e `flow-small-feature` como F) | 3 | devorb, sp, com ponytail (+10%) | 174 | **US$ 69,01** |

**Totais:**

| Bloco | Rodadas | Custo |
|---|---:|---:|
| Task 6, Step 4 (medido) | 24 | US$ 4,62 |
| Base (Tasks 7 a 17, 23 e 24) | 183 | US$ 58,48 |
| Design (D2 a D6) | 126 | US$ 33,85 |
| Mobile (M1 a M4) | 414 | US$ 125,04 |
| Task 21 | 174 | US$ 69,01 |
| Subtotal estimado | 921 | US$ 291,43 |
| Margem para repetições, 25% | | US$ 72,86 |
| **Total a gastar, no escopo do Step 5** | | **US$ 364,29** |

O Step 4 terminou durante a escrita e custou US$ 4,62, US$ 0,43 abaixo do estimado. Os totais acima ainda contam a estimativa de US$ 5,05.
| Já gasto e medido na Task 6 | 114 | US$ 19,46 |

**Fora da lista do Step 5, mas nos planos:**

| Task | O que roda | Rodadas | Custo |
|---|---|---:|---:|
| D1, Step 0 | Sondagem de leitura de sites, 1 rodada T no devorb | 1 | US$ 0,18 |
| D7, Steps 2 e 5 | `using-devorb` com 5 T (devorb e sp, depois devorb de novo), e `--skill all` com 40 casos (devorb e sp) | 285 | US$ 93,06 |
| Com a margem de 25% | | 286 | US$ 116,55 |
| **Total com D1 e D7** | | | **US$ 480,84** |

**Margem de 25%,** pelo seguinte:

- Uma skill com `regressions` ou `belowBar` volta para R4, e o novo R6 roda de novo só `devorb` e `none`, já que as fontes ficam no cache. Isso é cerca de 40% do custo da skill. Supondo que metade das skills precise de uma volta, dá uns 20%.
- O braço `superpowers` segue o último commit da `main`. Um commit novo derruba as linhas de base dele, e elas rodam de novo. Somei 5%.
- O que se viu até aqui: das três skills comparadas no Mac, `evolving` teve uma execução inteira descartada e uma repetição de 2 rodadas. `debugging` e `using-devorb` passaram na primeira comparação, porque as correções vieram antes.
- A margem também cobre o portão da D2 (duas páginas com a skill e duas sem, se não saírem das rodadas do eval) e a correção dos reservados prevista no Step 3 da Task 6.

## 4. Tempo estimado de relógio

Os relatórios não gravam duração. Os tempos abaixo saem do horário dos arquivos de cache, dos relatórios e dos commits:

| Execução | Rodadas | Tempo | US$ por minuto |
|---|---:|---|---:|
| Linha de base `debugging` (`0ad5513` às 19:38, cache do `superpowers` às 19:40:42, do `mattpocock-skills` às 19:42:41, relatório às 19:44:33) | 36 | cerca de 6 min, uns 2 min por braço | 0,9 |
| Linha de base `using-devorb` (19:44:33 a 19:46:51) | 27 | 2,3 min | 1,7 |
| Comparação `debugging` (`7f0e4bf` às 19:58:37, relatório às 20:01:47) | 12 | até 3,2 min | 0,7 ou mais |
| Comparação `using-devorb` (20:01:47 a 20:03:36) | 18 | 1,8 min | 1,5 |
| **Task 6, Step 3 sem os reservados** | **93** | **cerca de 13,5 min** | **1,0** |
| Reservado `debugging` (`1fd9bb2` às 20:04:02, relatório às 20:08:39) | 9 | até 4,6 min | 0,6 ou mais |
| Reservado `using-devorb` (20:08:39 a 20:10:40) | 12 | 2,0 min | 1,2 |
| `evolving`, na Task 4, uma rodada por vez (início entre 17:30 e 17:47, relatório às 18:07:54) | 20 | 20 a 37 min | 0,2 a 0,37; 0,6 a 1,1 com 3 por vez |

A concorrência dessas execuções não está no relatório. O commit `0ad5513`, que passa `--concurrency` para a ferramenta, saiu às 19:38, logo antes. Supus 3.

**Regra usada:** tempo = custo ÷ US$ 0,8 por minuto com `--concurrency 3`, numa faixa de 0,6 a 1,1. Caso curto rende mais por minuto. Caso longo rende menos, porque cada leva de 3 espera a rodada mais lenta.

| Bloco | Custo | Tempo central | Faixa |
|---|---:|---:|---:|
| Task 6, Step 4 (medido) | US$ 4,62 | 6 min | 5 a 8 min |
| Base | US$ 58,48 | 1,2 h | 0,9 a 1,6 h |
| Design (D2 a D6) | US$ 33,85 | 0,7 h | 0,5 a 0,9 h |
| Mobile (M1 a M4) | US$ 125,04 | 2,6 h | 1,9 a 3,5 h |
| Task 21 | US$ 69,01 | 1,4 h | 1,0 a 1,9 h |
| Margem | US$ 72,86 | 1,5 h | 1,1 a 2,0 h |
| **Total, no escopo do Step 5** | **US$ 364,29** | **7,6 h** | **5,5 a 10,1 h** |
| D1 e D7, com margem | US$ 116,55 | 2,4 h | 1,8 a 3,2 h |

Isso é só o tempo das rodadas. Fica de fora o tempo de escrever casos e skills e o tempo parado esperando o limite de uso da assinatura voltar.

## 5. Premissas e incertezas

- **Dinheiro nocional, limite de uso.** O US$ desta estimativa é o que `claude plugin eval` informa, e é o que `--max-cost-usd` limita: US$ 20 por chamada, ou seja, por braço do comparador (`fusion/eval-config.json`). A assinatura Max do dono não cobra esses dólares. O limite real dela é de uso, por janela de tempo, então a pergunta prática é quantas rodadas cabem numa janela, e não quanto custam. A relação entre US$ nocional e uso da assinatura não foi medida.
- **`--skill all` passa do teto por braço.** Estimado: Task 21 com `devorb` em US$ 37 e `superpowers` em US$ 32; D7 com US$ 46 e US$ 39; M4 com US$ 53 e US$ 45. Com o teto de US$ 20, o braço para no meio, os casos do `devorb` ficam ausentes e a comparação não aprova. Antes dessas tasks, o dono decide entre subir o teto só nessa chamada ou rodar skill por skill. Rodar por skill custa o mesmo e gera mais relatórios.
- **Rodadas do caso de fluxo.** A Task 21 pede 1 rodada em `flow-small-feature`, mas `--skill all` usa 3 em todos os casos. Contei 3. Com `--runs 1`, a Task 21 cairia para cerca de US$ 23, mas todos os casos teriam uma rodada só.
- **Cache por glob.** Hoje, um caso fora do cache faz o braço rodar o glob inteiro (`tools/compare.mjs`, linha 362, já marcado como atalho). No M4, isso faz o `superpowers` rodar os 47 casos, por cerca de US$ 45, quando só 7 são novos, por cerca de US$ 6. Separar o cache por caso economizaria uns US$ 39 no M4 e parte da D7.
- **R3 das skills leves.** A spec diz que o nível leve compara só com a fonte principal, mas o comando do R3 no plano não passa `--arms`, então roda três braços. Contei três. Passar `--arms <fonte principal>` no R3 das Tasks 9, 11, 12, 14, 15, 16 e 17 economizaria cerca de US$ 10.
- **Tipos dos casos novos** saíram das descrições nas tasks. H e F não têm nenhuma medição. Com subagentes, cada um abre o próprio contexto, e o custo real de `implementing`, `reviewing`, `security-audit` e do fluxo inteiro pode ser 2 a 3 vezes o estimado.
- **Amostra pequena.** O tipo R vem de um só caso, com 3 rodadas por braço. O tipo L separa com e sem o plugin por uma razão emprestada do tipo R. Conte com uns ±30% em cada tipo. Os reservados já mostram isso: o realista saiu 4% acima do estimado, e o de roteamento, 33% acima. Com o tipo T 33% mais caro em tudo, o subtotal da base, do design, do mobile e da Task 21 sobe cerca de US$ 17 (6%).
- **Braços sem medição:** `ui-ux-pro-max` foi estimado igual a `superpowers`, e o ponytail em +10%. O Step 4 da Task 6 mediu o ponytail: US$ 4,62 em 24 rodadas, cerca de +17% sobre as mesmas rodadas sem ele (US$ 0,19 por rodada contra 0,17).
- **Reservados:** um por skill de nível completo, com o tipo do caso principal. `evals-reserved/` não foi aberto; os custos da Task 6 saíram só dos relatórios.
- **Casos por task:** D5 com um caso (o reforço do Review Focus 5 na mesma página), M4 com dois casos de disparo e D7 com dois. Se cada um virar um caso a mais, a soma sobe pouco, mas cada `--skill all` posterior também cresce.
- **Graders `llm`:** supus que o custo informado já inclui o juiz. Os casos novos usam mais graders `llm` que os de pressão.
- **Ordem das tasks:** com a Task 21 depois do design e do mobile, ela pega 47 casos e custa cerca de US$ 108, em vez de US$ 69.
- **Superpowers:** hoje a `main` está no pino `22f0b46`, de 2026-11-03. Cada commit novo derruba o cache desse braço, e isso está na margem.
