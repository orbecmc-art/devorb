# Duas regras do dono: par complementar e fontes antes do design

Data: 2026-11-18. Branch `claude/regras-cor-referencias-0b0e2b`, a partir da ponta da Fase 2 (`claude/design-quality-fase-2`). Integra depois que a Fase 2 entrar.

## Intenção

O dono viu a página do Pilot (fundo claro com azul-marinho no título em dois tons e no CTA; uma faixa escura e quente onde o laranja complementar assume: palavras do título, número enorme, rótulos de cargo, anéis dos avatares) e disse: "ficou melhor do que uma cor só, traz vida". Hoje o DevOrb manda "uma cor de destaque" e o crítico trata duas como sinal de página gerada. Segunda preferência: antes de qualquer design ser executado, o agente abre a lista de referências e bibliotecas do dono (`ui-sources.json`) e diz o que consultou e o que pulou.

## Objetivos

1. **Par complementar.** Numa página Persuade, o destaque principal pode, e por padrão deve, vir com o seu complemento (matiz a 150°–210° de distância), cada um dono das suas seções ou faixas: por exemplo o principal nas seções claras e o complemento na faixa escura que contrasta. Nunca os dois brigando no mesmo elemento ou bloco. Um par deliberado não é "destaque demais"; três ou mais matizes saturados, ou dois matizes misturados no mesmo bloco, continuam sendo.
2. **Fontes antes do design, como portão.** Antes de construir ou reestilizar página, tela ou componente, o agente lê `ui-sources.json` e diz na resposta quais entradas consultou e quais pulou, com o motivo. Vale em `visual-direction` (SKILL.md e `guide.md`), no despacho do `implementing` para tarefas de UI (o implementador lê as fontes antes de construir, não só o contrato) e no `ui-review` (a crítica anota quando o build ignorou as fontes escolhidas).

## Fora

- Operate e Read: continuam com um destaque ou nenhum; o par é regra de Persuade. Experience segue a obra.
- Check novo no `rules.mjs` para "dois matizes no mesmo bloco": quem julga é o crítico pelas capturas. O `accent-count` (WARN acima de 2 grupos de matiz) já deixa o par passar.
- Mudar comportamento da Fase 2 além do que as duas regras pedem.

## Onde muda

- `skills/design-system/references/color-finish.md`: "One accent" vira "One accent, or a complementary pair", com como escolher o complemento e como dividir por seção.
- `skills/design-system/references/color-roles.md`: papel `complement` ao lado de `accent`.
- `skills/visual-direction/references/floor.md`: linha do `accent-count` explica que o par passa; os spent looks não proíbem par (Dark neon fala de um acento com brilho, segue valendo).
- `skills/visual-direction/references/persuade.md` e `contract.md`: o contrato diz qual seção é de cada cor.
- `skills/visual-direction/references/hero-patterns.md`: o halo "no matiz do único destaque" vira "no matiz do destaque daquela seção".
- `skills/ui-review/references/critique.md`: o sinal "Too many highlights" e a nota 10 de `color-contrast` passam a aceitar o par dividido por seção; acrescenta-se a anotação de fontes ignoradas.
- `skills/visual-direction/SKILL.md` §4 e `guide.md`: portão duro. `skills/implementing/SKILL.md` (regra de despacho de UI) e `prompts/implementer.md` (Mirror): o implementador lê `ui-sources.json` antes do primeiro arquivo de UI. `skills/ui-review/SKILL.md` §1/§6: lê a linha `Sources:` do contrato e o crítico recebe as fontes escolhidas.
- Teste unitário em `tests/design-rules.test.mjs`: paleta tipo Pilot (marinho + laranja + faixa escura quente) passa no `accent-count`; três matizes avisam.

## Testes (eval)

- Regra 1, `visual-direction-receitas-landing`: o critério "um destaque" do `finish.md` sai e entra um grader `color-pair.md`: duas cores saturadas complementares, cada uma em seções próprias, nunca as duas no mesmo bloco.
- Regra 1, crítico: caso novo leve `ui-review-par-complementar` (landing estática com par marinho/laranja dividido por seção, sem navegador): o relatório não acusa o par como destaque demais nem tira ponto de `color-contrast` por ele.
- Regra 2: caso novo leve `implementing-fontes-ui` (plano aprovado com uma tarefa de UI e contrato pronto): regex no trace exige ler `ui-sources.json`, ou despachar o implementador com `ui-sources.json` no prompt, antes do primeiro Edit/Write em `.html`, `.css` ou `.tsx`. Mesmo padrão do `visual-direction-arquitetura-clean`.

- Regra 2, regressão: `visual-direction-arquitetura-clean` caiu de 0,73 para 0,36 na última rodada GREEN da Fase 2 (devorb@1126ff4), porque o caminho "ninguém para responder" do `guide.md` §2 pula galerias e fontes. O portão vale também nesse caminho: sem pessoa, o agente pula o quadro e a captura, mas não a leitura das fontes nem a galeria do estilo. O caso já existente serve de RED (falha hoje) e de GREEN.

RED antes de editar as skills: rodar os três casos no braço `devorb` na versão atual e nos de base, só esses casos (`--skill <prefixo do caso>`).

## Orçamento

Estimativa: RED cerca de US$ 20 (o RED do `arquitetura-clean` já existe na rodada da Fase 2), GREEN cerca de US$ 30 com o `arquitetura-clean` (uns US$ 4 por rodada). Teto proposto: US$ 50 no total; custo real relatado depois de cada rodada.

## Hipóteses (decididas por mim, corrigíveis)

- "Complementar ou quase" = distância de matiz de 150° a 210° no círculo HSL/OKLCH.
- O par é padrão em Persuade, não obrigação: a spec ou o `DESIGN.md` que fixa uma cor só vence.
- Faixa escura vinho (matiz perto de 355°) com laranja (perto de 25°) conta como dois matizes no `accent-count` (distância 30°): limite conhecido, anotado no ledger, sem mudança no código.

## Com o construtor

Texto das skills em inglês, ledgers em português; `npm test` verde; cada SKILL.md dentro do teto de `fusion/skills.json` (`ui-review` está em 2.496 de 2.500: o texto novo sai de references ou troca palavras).
