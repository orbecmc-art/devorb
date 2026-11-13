# Comparação final (Task 21)

Data: 2026-11-12. Modelo `claude-opus-5-5`. DevOrb `0.15.0` contra Superpowers `22f0b46`, os dois com o ponytail `96608e0` ligado, como no uso real do dono. Teto de custo subido para US$ 60 por braço só nesta rodada, por decisão do dono, e devolvido a US$ 20 depois.

**Veredito do comparador na rodada geral: `accepted: false`.** Depois das correções de 2026-11-13 (seção abaixo), o único bloqueio que sobra é estrutural: a `evolving` não roda no braço do Superpowers. Nenhum caso piorou em relação ao Superpowers. O que bloqueia são as rodadas da `evolving` no braço do Superpowers, que contam como erro da ferramenta, e a `improve-architecture` abaixo da barra de 2/3 com o ponytail. O dono decide a migração com os pontos abaixo.

## Resultado geral

Relatório: `2026-11-12-all-ponytail.md`. São 27 casos com 3 rodadas por braço, a US$ 50,01.

| | Casos |
|---|---|
| DevOrb melhor | 13: `finishing`, `handoff`, `implementing`, `improve-architecture`, `planning`, `prototype`, `retro`, `reviewing`, `security-audit`, `tdd`, `using-devorb` (2 casos), `writing-skills` |
| Empate | 13, dos quais 5 são da `evolving` (o Superpowers não tem a skill) e 4 são lacunas em que nenhum braço passa |
| Superpowers melhor | 1: `codebase-design-baixa-estoque`, 67% contra 100%, dentro da tolerância de uma rodada |

Destaques: `reviewing` 100% contra 0%; `handoff`, `retro`, `security-audit` e `using-devorb-triggers-feature` 100% contra 0%; `implementing` 67% contra 0%; `finishing` 100% contra 33%.

Lacunas, em que nenhum braço passa:

- `aligning-agendamento`: já era lacuna na Task 10.
- `debugging-pressure-outage`: já era lacuna na Task 6.
- `debugging-flaky-payment`: o arquivo final do DevOrb tem a correção certa, com `get()` vendo as escritas pendentes, mas o juiz Haiku reprovou 2 de 3 votos em cada rodada. Na Task 6 o DevOrb passava em 100%. Julgamento instável, não piora da skill.
- `domain-modeling-aluno-ativo`: com o ponytail, o DevOrb não criou o `GLOSSARY.md` em 2 de 3 rodadas. Na Task 9, sem ponytail, passava em 67%. Não diagnosticado.

## O que bloqueou e o que foi feito

1. **`evolving`.** Com o ponytail ligado, o agente não lê o git empacotado no braço, e o `source-diff` falha. No braço do Superpowers a skill nem existe. O próprio comparador manda comparar a `evolving` só com o DevOrb, com e sem plugin. Rodada à parte (`2026-11-12-evolving-with-without.md`, US$ 10,95, 3 rodadas):

   | Caso | DevOrb |
   |---|---|
   | `evolving-no-change` | 100% |
   | `evolving-rewritten` | 100% |
   | `evolving-source-failed` | 67% |
   | `evolving-planned-only` | 33% (0,67) |
   | `evolving-rehearsal` | 0% (0,94) |

   Os dois últimos casos já perdiam um grader na rodada formal da Task 4, em 2026-11-11.

2. **`improve-architecture` com o ponytail.** Duas rodadas resumiram no chat e não escreveram o relatório HTML. A skill passou a dizer que o arquivo é a entrega mesmo com pedido de brevidade (`16bd400`). Rodada de novo (`2026-11-12-improve-architecture-ponytail.md`), ficou em 33% (0,89): ainda abaixo da barra, contra 0% no Superpowers. A causa da nova falha não foi conferida no trace. Sem o ponytail, a skill passa em 100%.

3. **Caso de fluxo inteiro `flow-small-feature`.** Pedido: "adiciona exportação em CSV da lista de pedidos, pode começar sem perguntas". Foi 1 rodada por braço (`2026-11-12-flow-ponytail.md`, US$ 0,53). Os dois braços tiraram 0%. No trace guardado, o DevOrb com ponytail foi direto ao código: escreveu o teste antes, implementou e conferiu, sem chamar nenhuma skill (`using-devorb`, `aligning`, `planning`, `implementing`, `finishing`). O resultado funciona, mas o fluxo não rodou.

## Correções de 2026-11-13

- **`improve-architecture`:** a falha com o ponytail era do grader. Uma rodada gravou o relatório com `cat > "$F"`, com o caminho `.html` numa variável, e o regex só aceitava `.html` logo depois do `>`. O grader passou a aceitar o caminho em qualquer parte do comando (`56aaefd`). Rodada de novo com o ponytail (`2026-11-13-improve-architecture-ponytail.md`): **100% contra 0%** no Superpowers, `accepted: true`.
- **`domain-modeling`:** falha real. Com o ponytail, o agente chamou a `aligning`, escolheu o sentido certo de "aluno ativo" e explicou a escolha, mas não chamou a `domain-modeling` e não escreveu o `GLOSSARY.md` (0 de 3, com o trace guardado). A `aligning` passou a chamar a `domain-modeling` antes de construir, mesmo em tarefa pequena ou sob regra de mudança mínima, porque o glossário faz parte da tarefa (`7941db1`). Rodada de novo com o ponytail (`2026-11-13-domain-modeling-ponytail.md`): **67% contra 0%**, `accepted: true`.
- Custo: uns US$ 3 de diagnóstico e US$ 3,54 nas duas comparações.

## Custo fixo (Step 3)

`claude plugin details devorb@devorb`, instalado numa configuração temporária: **~655 tokens sempre ligados**, dentro do limite de 706, com as 19 skills cada uma dentro do teto do registro. O hook de início de sessão também injeta o texto da `using-devorb`, uns 850 tokens por sessão. O `details` não conta esse custo, que segue o mesmo modelo do Superpowers.

## Custo desta task

US$ 50,01 na rodada geral, US$ 1,57 na `improve-architecture`, US$ 10,95 na `evolving`, US$ 0,53 no fluxo e uns US$ 0,30 no diagnóstico. Total: cerca de US$ 63.

## Decisões do dono antes da 1.0.0

1. Migrar (subir para `1.0.0` e fazer o merge). Nenhum caso piorou contra o Superpowers, e `improve-architecture` e `domain-modeling` já passam com o ponytail. O que sobra: a `evolving` comparada à parte (`evolving-planned-only` em 33% e `evolving-rehearsal` em 0%, como já era na Task 4) e as lacunas sem braço que passe.
2. Feature pequena com o ponytail ligado. Duas saídas:
   - aceitar que vá direto ao código;
   - fazer a `using-devorb` exigir o fluxo inteiro, o que vai contra a regra do ponytail.
