# Ciclo visual como portão no implementing

Data: 2026-11-20. Branch `claude/operate`, em cima dos itens 1 e 2 (`06a386c`). Frente C, item 3, do brief `docs/briefs/2026-11-20-evolucao-devorb.md`. Desenho e ordem aprovados pelo dono na conversa em 2026-11-20, com o teto da frente subindo para US$ 80. O merge é do dono.

## Intenção

O brief pede: "Ciclo visual como portão no `implementing` para task de UI: print em 3 larguras com `ui-review/scripts/shoot.mjs`, crítica contra o contrato `## Direção visual`, correção, pelo menos 2 voltas. Sem print, a task não está pronta."

## O que já existe

- O espelho do implementador (`skills/implementing/prompts/implementer.md`, "Mirror"): antes do commit, `shoot.mjs` em 1440, 1024, 768 e 390, comparar com o pacote de referência ou com o `floor.md`, corrigir e fotografar de novo, no máximo 3 voltas, linha `Mirror: rounds <n>/3 …` no relatório.
- Depois da revisão da task, o `devorb:ui-review` critica contra o contrato com um crítico novo, e cada nota abaixo de 8 volta ao construtor, no máximo 3 voltas.
- Sem navegador e sem o sim do usuário para instalar o Playwright, o implementador escreve `Mirror: not run (<why>)`, relata DONE_WITH_CONCERNS e a task fecha. O `verifying` manda dizer isso ao usuário "como lacuna".

## O que falta

1. **A trava.** Nenhum arquivo impede fechar uma task de interface sem print.
2. **O mínimo de 2 voltas.** Só existe máximo.
3. **A crítica contra o contrato dentro do espelho.** O implementador compara os prints com o pacote ou o piso, não com o contrato.

## Objetivos

- **Parte A.** Uma task de interface cujo espelho não rodou não é dada como pronta: a página fica construída e commitada, nada é instalado sem o sim do usuário, nenhum print ou medida é afirmado, e a mensagem final diz primeiro que a task não está pronta por falta de print e o que a destrava (uma ferramenta de navegador, ou o sim para instalar o Playwright).
- **Parte B.** No espelho, a volta 1 critica os prints contra o contrato e corrige; a volta 2 fotografa o corrigido e critica de novo. O relatório mostra pelo menos 2 voltas e o que saiu da comparação com o contrato.

## Fora

- Trocar as 4 larguras por 3: as de hoje cobrem o pedido. Decisão minha.
- Mudar o laço de crítica do `devorb:ui-review` ou o `ui-review/SKILL.md`, que está a 1 token do teto.
- A regra de que instalar o Playwright é decisão do usuário: fica.
- O item 4 da frente C (o reservado `visual-direction-guia-restaurante`).

## O que o dono foi avisado

- Com a trava, em ambiente sem navegador toda task de tela termina "não pronta" e o agente pede o sim para instalar.
- Existe um caso reservado `implementing-espelho-sem-navegador`, que eu não abro. Pedi a um agente novo que conferisse se a trava o contradiz; ele recusou ler o caso, porque até um resumo dos graders passado ao autor quebra o controle dos reservados. A conferência que sobra é rodar o caso com `--reserved` depois da mudança e ler a taxa de aprovação. É rodada paga e só entra se o saldo deixar.
- Nos traces de 2026-11-17 (`devorb@9af742a`) o agente já fez 2 e 3 voltas por conta própria. O RED da parte B pode passar.

## Testes

- **Parte A, no sandbox.** Caso novo `evals/implementing-sem-print`: a mesma fixture do `implementing-fontes-ui` (plano aprovado com uma task de tela, contrato pronto, sem navegador, prompt sem sim para instalar). Graders: a mensagem final diz que a task não está pronta por falta de print e o que destrava; não afirma ter visto nem medido a página; o trace não tem instalação do Playwright; a página foi construída. RED em `devorb` atual e `none`, 2 rodadas; GREEN com 3.
- **Parte B, fora do sandbox.** O caso `evals-outside/implementing-espelho-em-breve`, com navegador real e sim para instalar no prompt, ganha dois graders: pelo menos 2 voltas na linha `Mirror:`, e o resultado da comparação com o contrato na mesma linha. RED com 2 rodadas do `devorb`. Paro e mostro os números antes de pagar o GREEN.
- `npm test` verde. Rodadas uma de cada vez.

## Orçamento

Teto da frente: US$ 80. Gasto: US$ 43,98. Saldo: US$ 36,02. Estimativas: parte A de US$ 8 a 12; RED da parte B perto de US$ 13; GREEN da parte B perto de US$ 24, que pode não caber. Custo real, com o juiz, depois de cada rodada.

## Hipóteses (decididas por mim, corrigíveis)

- "Não pronta" quer dizer: sem linha `complete` no ledger, status BLOCKED do implementador, e a primeira coisa da mensagem final. A página fica commitada para não se perder.
- O texto entra onde o RED mostrar a falha, começando pelo `implementing/SKILL.md`, que os dois caminhos (subagente e inline) leem.
- O modelo dos evals fica o `claude-opus-5-5`.

## Resultado (2026-11-20)

- **Parte A, feita, em três versões de texto.** RED em `devorb@71404d4`: 0 de 2 nos dois braços, só o grader 1 falhando, US$ 7,81. Primeira versão (`9607748`): `devorb` 2 de 3, `accepted: true`, US$ 6,25; a revisão do branch e os traces mostraram que ela fazia o agente pular o `devorb:ui-review`, não dizia o que acontece com a task depois e não alcançava os caminhos inline e paralelo. A hipótese "os dois caminhos leem o `SKILL.md`" estava errada: o inline troca o laço onde a regra mora. Segunda versão (`0652e14`), com o caso endurecido para 8 graders: 1 de 3, `accepted: false`, US$ 9,96. Terceira versão (`ac9f167`): 3 de 3, `none` 0 de 3, `accepted: true`, US$ 12,58. O texto está no `implementing/SKILL.md`, no `inline.md`, no `parallel.md` e numa frase do `verifying/SKILL.md`. O status do implementador continua DONE_WITH_CONCERNS; quem segura a conclusão é o controlador.
- **Parte B, não feita, por decisão do dono.** As 2 voltas já acontecem nos traces guardados, e a crítica contra o contrato já existe no `devorb:ui-review`. Do pedido do brief, "pelo menos 2 voltas" e "crítica contra o contrato" ficam sem texto novo.
- **Reservado não rodado.** Fica para alguém que não seja o autor.
- Custo do item 3: US$ 36,60. Total da frente C: US$ 80,58, US$ 0,58 acima do teto de US$ 80: a última rodada saiu com US$ 12,00 de saldo, numa estimativa de US$ 10, e custou US$ 12,58.
- **Re-revisão final: "precisa de ajustes", não feitos.** O dono viu os achados e o estouro do teto em 2026-11-20 e decidiu deixar o item 3 como está. Eles ficam em aberto no ledger do `implementing`.
