# Comparação de versões: using-devorb

- Data: 2026-11-11
- Suíte: `evals-reserved`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@1fd9bb2`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-fechamento-outubro | devorb@1fd9bb2 | 100% | 1.00 | US$ 0.7092 |
| using-devorb-fechamento-outubro | superpowers@22f0b46 | 100% | 1.00 | US$ 0.7183 |
| using-devorb-fechamento-outubro | mattpocock-skills@4ae2317 | 0% | 0.50 | US$ 0.5256 |
| using-devorb-fechamento-outubro | none | 0% | 0.50 | US$ 0.4681 |

Custo total desta execução: US$ 2.4212 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: `devorb@1fd9bb2: using-devorb-fechamento-outubro (2)`

## Decisão

- Aprovado: não (rodadas com erro da ferramenta)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma

## Anotação do coordenador (escrita à mão)

Os 2 "erros" do braço `devorb` são `exit 1: Reached maximum number of turns (8)`. O agente chamou a skill certa no começo e continuou depurando até o limite de 8 turnos do caso. As 3 rodadas tiveram nota 1, com todos os graders aprovados. O `compare.mjs` desta execução contava o limite de turnos como erro da ferramenta. Pela regra corrigida no commit seguinte (`fix: count a run that hits max_turns as agent behavior`), esses erros não bloqueiam, e a decisão é: aprovado, sim, sem regressões nem casos abaixo da barra. Não foi preciso rodar de novo.
