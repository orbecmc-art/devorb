# Comparação de versões: reviewing-piso

- Data: 2026-11-20
- Suíte: `evals`, casos `reviewing-piso-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@b9a8bae`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| reviewing-piso-de-codigo | devorb@b9a8bae | 0% | 0.25 | US$ 0.5735 |
| reviewing-piso-de-codigo | none | 0% | 0.25 | US$ 0.3838 |

Custo total desta execução: US$ 0.9503 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `reviewing-piso-de-codigo`
