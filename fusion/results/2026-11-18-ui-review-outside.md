# Comparação de versões: ui-review

- Data: 2026-11-18
- Suíte: `evals-outside`, casos `ui-review-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@8d423d1`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| ui-review-critica-em-breve | devorb@8d423d1 | 100% | 1.00 | US$ 2.1536 |
| ui-review-sinais-de-ia | devorb@8d423d1 | 50% | 0.67 | US$ 1.7843 |

Custo total desta execução: US$ 3.9379 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `ui-review-sinais-de-ia`
- Lacunas (nenhum braço passa): nenhuma
