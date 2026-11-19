# Comparação de versões: visual-direction-arquitetura

- Data: 2026-11-19
- Suíte: `evals`, casos `visual-direction-arquitetura-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@4a966e3`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-arquitetura-clean | devorb@4a966e3 | 0% | 0.64 | US$ 6.9938 |
| visual-direction-arquitetura-clean | none | 0% | 0.18 | US$ 0.8147 |

Custo total desta execução: US$ 7.7946 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `visual-direction-arquitetura-clean`
