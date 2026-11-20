# Comparação de versões: performance

- Data: 2026-11-20
- Suíte: `evals-reserved`, casos `performance-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@be1df8a`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| performance-painel-pedidos | devorb@be1df8a | 100% | 1.00 | US$ 1.1666 |
| performance-painel-pedidos | none | 0% | 0.50 | US$ 0.5743 |

Custo total desta execução: US$ 1.7330 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
