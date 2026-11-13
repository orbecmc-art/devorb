# Comparação de versões: prototype

- Data: 2026-11-12
- Suíte: `evals`, casos `prototype-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@d391c04`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| prototype-tarifa-estacionamento | devorb@d391c04 | 100% | 1.00 | US$ 0.9721 |
| prototype-tarifa-estacionamento | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.8807 |

Custo total desta execução: US$ 1.8471 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
