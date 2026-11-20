# Comparação de versões: performance

- Data: 2026-11-20
- Suíte: `evals-reserved`, casos `performance-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@ca964e8`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| performance-painel-pedidos | devorb@ca964e8 | 50% | 0.75 | US$ 1.0626 |
| performance-painel-pedidos | none | 0% | 0.50 | US$ 0.5326 |

Custo total desta execução: US$ 1.5879 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `performance-painel-pedidos`
- Lacunas (nenhum braço passa): nenhuma
