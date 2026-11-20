# Comparação de versões: reviewing-consulta

- Data: 2026-11-20
- Suíte: `evals`, casos `reviewing-consulta-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@9977a85`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| reviewing-consulta-sem-limite | devorb@9977a85 | 100% | 1.00 | US$ 1.6096 |
| reviewing-consulta-sem-limite | none | 50% | 0.63 | US$ 0.4123 |

Custo total desta execução: US$ 2.0120 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
