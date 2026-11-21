# Comparação de versões: reviewing

- Data: 2026-11-20
- Suíte: `evals`, casos `reviewing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@90e61f2`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| reviewing-consulta-sem-limite | devorb@90e61f2 | 100% | 1.00 | US$ 0.5786 |
| reviewing-consulta-sem-limite | none | 100% | 1.00 | US$ 0.4004 |
| reviewing-cupom-desconto | devorb@90e61f2 | 100% | 1.00 | US$ 0.6677 |
| reviewing-cupom-desconto | none | 0% | 0.25 | US$ 0.4884 |
| reviewing-piso-de-codigo | devorb@90e61f2 | 100% | 1.00 | US$ 1.2818 |
| reviewing-piso-de-codigo | none | 50% | 0.75 | US$ 0.4912 |

Custo total desta execução: US$ 3.8629 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
