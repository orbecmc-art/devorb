# Comparação de versões: design-system

- Data: 2026-11-13
- Suíte: `evals`, casos `design-system-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@555d715`, `none`, `ui-ux-pro-max@4f2dbb6`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| design-system-cafe-moenda | devorb@555d715 | 100% | 1.00 | US$ 1.8060 |
| design-system-cafe-moenda | none | 0% | 0.57 | US$ 1.3341 |
| design-system-cafe-moenda | ui-ux-pro-max@4f2dbb6 | 0% | 0.71 | US$ 1.5635 |
| design-system-padaria-pedidos | devorb@555d715 | 100% | 1.00 | US$ 1.0193 |
| design-system-padaria-pedidos | none | 0% | 0.60 | US$ 0.6527 |
| design-system-padaria-pedidos | ui-ux-pro-max@4f2dbb6 | 0% | 0.60 | US$ 0.6951 |
| design-system-shadcn-padrao | devorb@555d715 | 100% | 1.00 | US$ 2.5297 |
| design-system-shadcn-padrao | none | 100% | 1.00 | US$ 1.5864 |
| design-system-shadcn-padrao | ui-ux-pro-max@4f2dbb6 | 100% | 1.00 | US$ 1.6339 |

Custo total desta execução: US$ 12.7761 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
