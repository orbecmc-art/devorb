# Comparação de versões: performance

- Data: 2026-11-20
- Suíte: `evals`, casos `performance-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@182823b`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| performance-busca-planilha | devorb@182823b | 0% | 0.33 | US$ 1.0062 |
| performance-busca-planilha | none | 0% | 0.33 | US$ 0.6465 |

Custo total desta execução: US$ 1.6480 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `performance-busca-planilha`
