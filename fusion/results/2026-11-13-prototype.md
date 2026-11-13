# Comparação de versões: prototype

- Data: 2026-11-13
- Suíte: `evals`, casos `prototype-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@20987d7`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| prototype-tarifa-estacionamento | devorb@20987d7 | 100% | 1.00 | US$ 0.9824 |
| prototype-tarifa-estacionamento | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.8807 (cache) |

Custo total desta execução: US$ 0.9769 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
