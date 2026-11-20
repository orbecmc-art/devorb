# Comparação de versões: performance

- Data: 2026-11-20
- Suíte: `evals`, casos `performance-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@301bf5e`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| performance-busca-planilha | devorb@301bf5e | 100% | 1.00 | US$ 1.2809 |
| performance-busca-planilha | none | 0% | 0.33 | US$ 0.7493 |

Custo total desta execução: US$ 2.0242 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
