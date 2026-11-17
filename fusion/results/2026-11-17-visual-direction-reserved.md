# Comparação de versões: visual-direction

- Data: 2026-11-17
- Suíte: `evals-reserved`, casos `visual-direction-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@d873e93`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-copia-landing-clinica | devorb@d873e93 | 0% | 0.71 | US$ 1.7583 |
| visual-direction-copia-landing-clinica | none | 0% | 0.74 | US$ 0.6318 |
| visual-direction-painel-padaria | devorb@d873e93 | 50% | 0.86 | US$ 2.6027 |
| visual-direction-painel-padaria | none | 100% | 1.00 | US$ 1.1990 |

Custo total desta execução: US$ 6.1573 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `visual-direction-painel-padaria`
- Lacunas (nenhum braço passa): `visual-direction-copia-landing-clinica`
