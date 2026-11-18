# Comparação de versões: implementing

- Data: 2026-11-18
- Suíte: `evals-reserved`, casos `implementing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@5ccbbaf`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| implementing-cashback | devorb@5ccbbaf | 100% | 1.00 | US$ 1.7484 |
| implementing-espelho-sem-navegador | devorb@5ccbbaf | 0% | 0.70 | US$ 11.2493 |

Custo total desta execução: US$ 12.9634 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `implementing-espelho-sem-navegador`
- Lacunas (nenhum braço passa): nenhuma
