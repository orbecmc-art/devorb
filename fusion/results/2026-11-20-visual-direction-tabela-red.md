# Comparação de versões: visual-direction-tabela

- Data: 2026-11-20
- Suíte: `evals`, casos `visual-direction-tabela-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@2916598`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-tabela-operacao | devorb@2916598 | 50% | 0.95 | US$ 1.7403 |
| visual-direction-tabela-operacao | none | 50% | 0.80 | US$ 0.8153 |

Custo total desta execução: US$ 2.4900 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `visual-direction-tabela-operacao`
- Lacunas (nenhum braço passa): nenhuma
