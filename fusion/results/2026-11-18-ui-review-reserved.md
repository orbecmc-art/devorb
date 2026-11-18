# Comparação de versões: ui-review

- Data: 2026-11-18
- Suíte: `evals-reserved`, casos `ui-review-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@b2e2c96`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| ui-review-critica-painel-sem-navegador | devorb@b2e2c96 | 50% | 0.79 | US$ 1.6773 |
| ui-review-critica-painel-sem-navegador | none | 0% | 0.57 | US$ 0.4163 |
| ui-review-sinais-sem-navegador | devorb@b2e2c96 | 100% | 1.00 | US$ 1.3210 |
| ui-review-sinais-sem-navegador | none | 0% | 0.57 | US$ 0.4854 |

Custo total desta execução: US$ 3.8674 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `ui-review-critica-painel-sem-navegador`
- Lacunas (nenhum braço passa): nenhuma
