# Comparação de versões: visual-direction

- Data: 2026-11-17
- Suíte: `evals-reserved`, casos `visual-direction-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@46dfe79`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-copia-landing-clinica | devorb@46dfe79 | 0% | 0.78 | US$ 2.8202 |
| visual-direction-painel-padaria | devorb@46dfe79 | 67% | 0.91 | US$ 5.0467 |

Custo total desta execução: US$ 7.8389 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `visual-direction-copia-landing-clinica`
- Lacunas (nenhum braço passa): nenhuma
