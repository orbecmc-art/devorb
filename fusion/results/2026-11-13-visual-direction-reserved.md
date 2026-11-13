# Comparação de versões: visual-direction

- Data: 2026-11-13
- Suíte: `evals-reserved`, casos `visual-direction-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@fdde35f`, `none`, `ui-ux-pro-max@4f2dbb6`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-painel-padaria | devorb@fdde35f | 100% | 1.00 | US$ 3.3271 |
| visual-direction-painel-padaria | none | 33% | 0.82 | US$ 1.9118 |
| visual-direction-painel-padaria | ui-ux-pro-max@4f2dbb6 | 33% | 0.82 | US$ 2.2900 (cache) |

Custo total desta execução: US$ 5.2000 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
