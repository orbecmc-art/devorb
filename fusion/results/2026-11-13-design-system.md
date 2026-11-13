# Comparação de versões: design-system

- Data: 2026-11-13
- Suíte: `evals`, casos `design-system-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@20987d7`, `none`, `ui-ux-pro-max@4f2dbb6`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| design-system-cafe-moenda | devorb@20987d7 | 100% | 1.00 | US$ 2.2207 |
| design-system-cafe-moenda | none | 0% | 0.57 | US$ 1.1512 |
| design-system-cafe-moenda | ui-ux-pro-max@4f2dbb6 | 0% | 0.71 | US$ 1.5635 (cache) |
| design-system-padaria-pedidos | devorb@20987d7 | 100% | 1.00 | US$ 1.0936 |
| design-system-padaria-pedidos | none | 0% | 0.60 | US$ 0.6834 |
| design-system-padaria-pedidos | ui-ux-pro-max@4f2dbb6 | 0% | 0.60 | US$ 0.6951 (cache) |
| design-system-shadcn-padrao | devorb@20987d7 | 100% | 1.00 | US$ 2.4471 |
| design-system-shadcn-padrao | none | 100% | 1.00 | US$ 1.8903 |
| design-system-shadcn-padrao | ui-ux-pro-max@4f2dbb6 | 100% | 1.00 | US$ 1.6339 (cache) |

Custo total desta execução: US$ 9.4563 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
