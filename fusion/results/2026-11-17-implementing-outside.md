# Comparação de versões: implementing

- Data: 2026-11-17
- Suíte: `evals-outside`, casos `implementing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@9af742a`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| implementing-espelho-em-breve | devorb@9af742a | 50% | 0.94 | US$ 12.9944 |
| implementing-espelho-em-breve | none | 0% | 0.56 | US$ 2.6244 |

Custo total desta execução: US$ 15.6188 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `implementing-espelho-em-breve`
- Lacunas (nenhum braço passa): nenhuma
