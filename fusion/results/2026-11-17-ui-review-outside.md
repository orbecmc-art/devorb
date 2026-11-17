# Comparação de versões: ui-review

- Data: 2026-11-17
- Suíte: `evals-outside`, casos `ui-review-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@cbba161`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| ui-review-critica-em-breve | devorb@cbba161 | 0% | 0.67 | US$ 2.5916 |
| ui-review-critica-em-breve | none | 0% | 0.56 | US$ 0.7188 |

Custo total desta execução: US$ 3.3104 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `ui-review-critica-em-breve`
