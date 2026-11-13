# Comparação de versões: design-system

- Data: 2026-11-13
- Suíte: `evals`, casos `design-system-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `none`, `ui-ux-pro-max@4f2dbb6`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| design-system-cafe-moenda | none | 0% | 0.57 | US$ 1.1875 |
| design-system-cafe-moenda | ui-ux-pro-max@4f2dbb6 | 0% | 0.57 | US$ 1.3488 |
| design-system-padaria-pedidos | none | ausente | - | - |
| design-system-padaria-pedidos | ui-ux-pro-max@4f2dbb6 | ausente | - | - |
| design-system-shadcn-padrao | none | 100% | 1.00 | US$ 1.4784 |
| design-system-shadcn-padrao | ui-ux-pro-max@4f2dbb6 | 100% | 1.00 | US$ 1.5616 |

Custo total desta execução: US$ 5.5520 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): `none: design-system-padaria-pedidos`, `ui-ux-pro-max@4f2dbb6: design-system-padaria-pedidos`
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
