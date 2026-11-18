# Comparação de versões: design-system

- Data: 2026-11-18
- Suíte: `evals`, casos `design-system-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@f81f408`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| design-system-cafe-moenda | devorb@f81f408 | 100% | 1.00 | US$ 2.3391 |
| design-system-cafe-moenda | none | 0% | 0.57 | US$ 1.3073 |
| design-system-escala-fluida | devorb@f81f408 | 50% | 0.90 | US$ 2.0686 |
| design-system-escala-fluida | none | 0% | 0.40 | US$ 0.7559 |
| design-system-padaria-pedidos | devorb@f81f408 | 100% | 1.00 | US$ 1.4904 |
| design-system-padaria-pedidos | none | 0% | 0.60 | US$ 0.5957 |
| design-system-shadcn-padrao | devorb@f81f408 | 100% | 1.00 | US$ 2.7000 |
| design-system-shadcn-padrao | none | 100% | 1.00 | US$ 2.1828 |

Custo total desta execução: US$ 13.3953 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `design-system-escala-fluida`
- Lacunas (nenhum braço passa): nenhuma
