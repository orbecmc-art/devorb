# Comparação de versões: design-system

- Data: 2026-11-18
- Suíte: `evals`, casos `design-system-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| design-system-cafe-moenda | none | 0% | 0.57 | US$ 1.3133 |
| design-system-escala-fluida | none | 0% | 0.20 | US$ 0.7326 |
| design-system-padaria-pedidos | none | 0% | 0.60 | US$ 0.6393 |
| design-system-shadcn-padrao | none | 100% | 1.00 | US$ 1.5101 |

Custo total desta execução: US$ 4.1746 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
