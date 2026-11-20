# Comparação de versões: aligning-volume

- Data: 2026-11-20
- Suíte: `evals`, casos `aligning-volume-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@182823b`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| aligning-volume-de-dados | devorb@182823b | 0% | 0.00 | US$ 0.6100 |
| aligning-volume-de-dados | none | 0% | 0.00 | US$ 0.5412 |

Custo total desta execução: US$ 1.1430 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `aligning-volume-de-dados`
