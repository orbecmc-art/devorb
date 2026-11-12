# Comparação de versões: browser-testing

- Data: 2026-11-12
- Suíte: `evals-outside`, casos `browser-testing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@b7ff984`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| browser-testing-cadastro-cliente | devorb@b7ff984 | 100% | 1.00 | US$ 0.8244 |
| browser-testing-cadastro-cliente | none | 0% | 0.60 | US$ 0.2742 |

Custo total desta execução: US$ 1.0986 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
