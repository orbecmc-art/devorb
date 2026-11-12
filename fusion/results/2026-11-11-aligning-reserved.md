# Comparação de versões: aligning

- Data: 2026-11-11
- Suíte: `evals-reserved`, casos `aligning-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@6741db2`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| aligning-reembolso-pedido | devorb@6741db2 | 33% | 0.81 | US$ 0.8988 |
| aligning-reembolso-pedido | superpowers@22f0b46 | 0% | 0.52 | US$ 0.6286 (cache) |
| aligning-reembolso-pedido | mattpocock-skills@4ae2317 | 0% | 0.67 | US$ 0.4777 (cache) |

Custo total desta execução: US$ 0.8811 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `aligning-reembolso-pedido`
- Lacunas (nenhum braço passa): nenhuma
