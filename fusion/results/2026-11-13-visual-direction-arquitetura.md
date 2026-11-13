# Comparação de versões: visual-direction-arquitetura

- Data: 2026-11-13
- Suíte: `evals`, casos `visual-direction-arquitetura-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@af8adfb`, `none`, `ui-ux-pro-max@4f2dbb6`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-arquitetura-clean | devorb@af8adfb | 0% | 0.48 | US$ 12.9973 |
| visual-direction-arquitetura-clean | none | 0% | 0.18 | US$ 1.1537 |
| visual-direction-arquitetura-clean | ui-ux-pro-max@4f2dbb6 | 0% | 0.18 | US$ 1.3511 (cache) |

Custo total desta execução: US$ 14.1187 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `visual-direction-arquitetura-clean`
