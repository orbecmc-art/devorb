# Qualidade de design, Fase 2: custo e resultado final

- Data: 2026-11-18
- Código: `claude/design-quality-fase-2` (do 5e5607f ao HEAD desta task)
- Teto do dono para as rodadas pagas: US$ 70. Gasto real: cerca de US$ 70,5. O teto foi atingido na Task 11.
- Fonte dos custos: o ledger da fase (`.devorb/sdd/2026-11-18-design-quality-fase-2/progress.md`), que soma as rodadas de cada task. Vários arquivos `fusion/results/2026-11-18-*.md` foram sobrescritos por rodadas posteriores com o mesmo nome, então o custo de um arquivo sozinho não mostra a task inteira. A tabela abaixo vem do ledger.

## Custo de cada rodada paga

| Task | Rodada | Custo (US$) | Acumulado (US$) |
|---|---|---|---|
| 6 | RED, `design-system-escala-fluida` e casos antigos, braço `none` | 4,17 | 4,2 |
| 6 | GREEN (f81f408), 4 casos de design-system | 13,40 | 17,6 |
| 7 | RED, `visual-direction-receitas-landing`, `none` | 2,48 | 20,1 |
| 7 | GREEN (35cdc27), 3 casos de visual-direction | 15,86 | 36,0 |
| 8 | RED, `ui-review-sinais-de-ia`, `none` | 1,31 | 37,3 |
| 8 | GREEN fora do eval (8d423d1), só DevOrb | 3,94 | 41,2 |
| 8 | Caso reservado (b2e2c96), DevOrb e `none` | 3,87 | 45,1 |
| 10 | RED, `motion-nivel-suave`, `none` | 0,98 | 46,1 |
| 10 | GREEN antes da correção do dial (0195671) | 2,01 | 48,1 |
| 10 | GREEN depois da correção (380e023) | 1,94 | 50,0 |
| 11 | RED, `visual-direction-guia-leigo`, `none` | 3,65 | 53,6 |
| 11 | GREEN (1126ff4), só DevOrb, 4 casos | 16,87 | 70,5 |

O caso reservado da Task 11 (`evals-reserved/visual-direction-guia-restaurante`) está escrito e não foi rodado, por falta de orçamento. Quem decide rodá-lo é o dono.

## refs-check nas 23 referências

Última rodada completa no código final da Task 5: `refs-check: 23/23 PASS`, zero FAIL, em 1440, 1024, 768 e 390.

- Nenhuma queda, nenhum timeout, `hiddenContent` 0 e pelo menos 2 seções em todos os sites.
- Seis sites dão WARN de heading-ratio só nas larguras estreitas (2,00 a 2,46), porque o h1 real encolhe para 28 a 38px no celular.
- Limite conhecido: cena de rolagem fixada sai em branco no print (hero do sol, parloa, hero do shopify). A barra de zero `hiddenContent` prova que a revelação funciona, não que nenhum print saiu em branco.
- Detalhe por site: `fusion/results/2026-11-18-refs-check.md`.

## Resultados das comparações

| Pilar | Caso | DevOrb | Sem o plugin |
|---|---|---|---|
| B, design-system | escala-fluida | 50% (0,90) | 0% (0,40) |
| B, design-system | cafe-moenda, padaria, shadcn | 100% | 0%, 0%, 100% |
| B, visual-direction | receitas-landing | 100% (1,00) | 0% (0,38) |
| B, ui-review (fora do eval) | sinais-de-ia | 50% (0,67) | 0% (0,17) |
| B, ui-review (reservado) | sinais-sem-navegador | 100% (1,00) | 0% (0,57) |
| B, ui-review (reservado) | critica-painel-sem-navegador | 50% (0,79) | 0% (0,57) |
| D, motion | nivel-suave | 100% (1,00) | 0% (0,80) |
| D, visual-direction | guia-leigo | 50% (0,83) | 0% (0,00) |

Regressão aberta: `visual-direction-arquitetura-clean` caiu de 0,73 (Task 7) para 0,36 (Task 11). O caminho sem pessoa para responder pula as galerias e as fontes. A correção fica com o trabalho "regras-cor-e-referencias".

## Estudo de movimento

`tools/motion-study.mjs` rodou em 5 de 5 sites, sem navegador com tela. Nas entradas medidas, a mediana de duração ficou entre 350 e 700 ms, e o atraso entre itens (stagger) entre 20 e 100 ms. O dial inicial pedia cerca de 250 ms. A diferença levou à correção de tempo do dial (55ea41d), e o caso `motion-nivel-suave` foi de 50% para 100%.
