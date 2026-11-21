# Comparação de versões: reviewing-piso

- Data: 2026-11-20
- Suíte: `evals`, casos `reviewing-piso-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@1296a9e`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| reviewing-piso-de-codigo | devorb@1296a9e | 100% | 1.00 | US$ 0.5874 |
| reviewing-piso-de-codigo | none | 0% | 0.25 | US$ 0.3723 |

Custo total desta execução: US$ 0.9512 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
