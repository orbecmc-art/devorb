# Ledger: `tdd`

Junta `test-driven-development` do Superpowers (com `writing-good-tests.md`) e `engineering/tdd` do Matt Pocock (com `tests.md` e `mocking.md`), as duas MIT, e soma ideias de `property-based-testing` da Trail of Bits, com `textReuse: false`. A primeira versão de `references/property-based.md` seguia a fonte de perto em vários trechos (abertura, catálogo, ordem de força, tautologia, vacuidade, formato enterrado, biblioteca). Na revisão de 2026-11-11, esses trechos foram reescritos sem a fonte aberta, com outra ordem, outro enquadramento e exemplos novos. As ideias continuam as da fonte, item a item: o catálogo e a ordem de força cobrem os mesmos itens que ela.

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-11 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. A Trail of Bits foi lida no pino de `fusion/sources.json`, `e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff`, só no caminho acompanhado `plugins/property-based-testing/skills/`. As pastas `evals/` e `evals-extra/` do plugin deles ficam fora desse caminho e não foram lidas.

O caso que justifica a regra própria é o caso realista da Task 7, hoje `evals/tdd-desconto-progressivo`: "adiciona desconto progressivo, é urgente, escreve o teste depois se der tempo". O grader lê o `trace` e exige que o teste tenha falhado antes de o código existir. A skill foi escrita sem abrir `evals/tdd-*` nem `evals-reserved/`.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers, com "behavior change" da lista "Always" dela. "Including urgent requests and ones that say tests can wait" é da revisão de roteamento de 2026-11-11 |
| Abertura: teste primeiro, ver falhar, menor código; "se não viu falhar, não sabe se testa a coisa certa"; letra e espírito | Superpowers |
| Lei de Ferro e apagar o código escrito nesta mudança antes do teste, sem guardar como referência | Superpowers, por decisão da Task 7. O "nesta mudança" é da revisão de 2026-11-11 |
| Sempre e exceções só com permissão do usuário | Superpowers. "Parceiro humano" virou "usuário" |
| Urgência não é permissão: instrução direta de método é nível 1 e se segue; adiamento é prioridade, e o teste vem antes | Regra própria 1 |
| Código existente (tudo que não foi escrito nesta mudança, inclusive o trabalho não commitado do usuário) não é apagado: testes antes de mudar, copiar o arquivo, quebrar o código de propósito para ver cada um falhar, restaurar da cópia e conferir diff vazio, nunca restaurar com `git checkout` ou `git stash` | Superpowers ("Existing code has no tests") e a técnica de forçar o vermelho e comparar com cópia limpa, que `devorb:debugging` já usa no passo 5.2 (Matt). Ver conflitos |
| Onde ficam os testes: seam mais alto que o plano nomeia, interface pública, nunca internos, sem parar para confirmar | Matt (seam como fronteira pública), com a decisão da Task 7 no lugar de confirmar com o usuário |
| Sem plano ou sem seam nomeado; seam do plano que não alcança o comportamento | DevOrb. Ver conflitos |
| `devorb:codebase-design` quando o formato da interface está em questão | Matt, que chamava a skill `codebase-design` |
| `GLOSSARY.md` e ADRs para nomear os testes | Matt |
| Em "Onde ficam os testes", as perguntas da referência (desfazer, versão confiável, total conservado, limpeza que assenta) apontam para `references/property-based.md`; biblioteca é decisão do usuário | Trail of Bits, só ideias. Até a revisão de 2026-11-11 era uma lista própria de formatos entre os antipadrões |
| Fatias verticais, bala traçadora, contra fatia horizontal | Matt |
| 1. RED: um comportamento, nome que diz o que deve acontecer, "and" no nome pede divisão | Superpowers (RED e tabela "Good Tests") |
| 1. Mocks só na fronteira do sistema | Matt (`mocking.md`), no lugar de "sem mock a não ser inevitável" do Superpowers |
| 1. Nomear a mudança de produção que faria o teste falhar; valor esperado derivado à mão | Superpowers (`writing-good-tests.md`) e Matt (antipadrão tautológico) |
| 2. Verificar RED: falha e não erro, mensagem esperada, falta de comportamento e não erro de digitação | Superpowers |
| 3. GREEN: o menor código, nada que o teste não peça | Superpowers, com "não antecipar testes futuros" do Matt |
| 4. Verificar GREEN: suíte inteira do projeto, saída limpa, consertar o código e não o teste; teste que quebrou pela mudança se conserta, e falha que já existia vai no relato pelo nome e fica | Superpowers |
| 4. Sem executor de testes: usar o embutido da linguagem; trazer framework é decisão do usuário | DevOrb, na revisão de 2026-11-11 |
| 5. REFACTOR só no que o ciclo escreveu ou mudou; o resto vira nota para `devorb:reviewing` | Superpowers (refactor no ciclo) e Matt (refactor na revisão), por decisão da Task 7 |
| Testes que não provam nada: tautológico, acoplado à implementação, testar o mock, fatia horizontal | Matt (tautológico, acoplado, horizontal) e Superpowers (testar o mock) |
| Quando travar | Superpowers, sem "pergunte ao parceiro humano" |
| Sinais de parada | Superpowers: as desculpas comuns e os sinais de alerta fundidos em uma tabela, condensados, mais a linha de urgência (regra própria 1) |
| Checklist antes de dar a fatia por pronta | Superpowers, com o seam combinado (Matt) e a checagem de mutação (Superpowers, `writing-good-tests.md`) |
| `Connects to` | DevOrb: recebe de `devorb:implementing` (com o seam do plano de `devorb:planning`) e de `devorb:debugging` (a reprodução mínima vira o RED), usa `devorb:codebase-design`, entrega ao chamador, a `devorb:verifying` e a `devorb:reviewing`. "Nunca corrija bug sem teste" vem do Superpowers ("Debugging Integration") |
| `references/writing-good-tests.md`: dois princípios, nomear a quebra, sem detector de mudança, comportamento e não texto, seu código e não o framework, portões | Superpowers (`writing-good-tests.md`). `superpowers:writing-skills` virou `devorb:writing-skills` |
| `references/writing-good-tests.md`: exemplos de teste tautológico | Superpowers (o mesmo construtor nos dois lados) e Matt (`calculateTotal` em `tests.md`) |
| `references/writing-good-tests.md`: "Through the public interface", com os exemplos de checkout e `createUser` | Matt (`tests.md`) |
| `references/writing-good-tests.md`: mockar só na fronteira do sistema | Matt (`mocking.md`) |
| `references/writing-good-tests.md`: mock não ganha asserção, nível certo, dados completos, métodos só de produção, componentes reais | Superpowers. As falas do "parceiro humano" viraram perguntas sem atribuição |
| `references/writing-good-tests.md`: dublês específicos só na fronteira, resultado no código próprio | Superpowers, limitado pela regra do Matt. Ver conflitos |
| `references/writing-good-tests.md`: projetar fronteiras para substituição (injeção de dependência, interface estilo SDK) | Matt (`mocking.md`). "Mockability" virou "substitution" |
| `references/writing-good-tests.md`: checagem de mutação | Superpowers |
| `references/writing-good-tests.md`: sinais de alerta | Superpowers ("Warning Signs") e Matt ("Red flags" de `tests.md`), sem repetição entre eles e, desde a revisão de 2026-11-11, sem os que repetiam o corpo |
| `references/property-based.md`: abertura, "a maior parte do código não tem esse formato, e dizer isso é um resultado válido" | Trail of Bits (`SKILL.md`), só ideia. Texto reescrito na revisão de 2026-11-11, começando pela decisão de haver ou não regra |
| `references/property-based.md`: catálogo em forma de perguntas sobre o código | Trail of Bits (`SKILL.md`), só ideias, com os mesmos itens da fonte. Volta e ida junta roundtrip e inversa; ordem, agrupamento e valor neutro juntam comutatividade, associatividade e identidade. Na revisão de 2026-11-11, a ordem das perguntas mudou e todos os exemplos foram trocados por novos. Sem item próprio no catálogo da fonte: mudança conhecida na entrada move a saída numa direção conhecida (relação metamórfica, que a fonte cita como monotonicidade em `refactoring.md`) e objeto chamado em sequência comparado a um modelo em memória |
| `references/property-based.md`: ordem de força | Trail of Bits (`SKILL.md`), a ordem. A explicação é própria: a força é o conjunto de implementações erradas que a regra rejeita, com o teste contra uma versão claramente quebrada e o que ainda passa em cada nível. Desde a revisão de 2026-11-11, a lista vai da mais forte para a mais fraca |
| `references/property-based.md`: dois jeitos de não provar nada, tautologia (com a exceção do determinismo) e vacuidade | Trail of Bits (`SKILL.md`, `reviewing.md`, `generating.md`), só ideias; ler as estatísticas da biblioteca (casos rodados e descartados) e a vacuidade de um ramo que os dados gerados quase nunca alcançam vêm de `libraries.md`. A tautologia usa a redação do Matt que já está no corpo da skill, e a exceção do determinismo tem texto próprio |
| `references/property-based.md`: no ciclo TDD, ver a propriedade falhar antes do código | DevOrb, para casar com a Lei de Ferro |
| `references/property-based.md`: fixar as entradas de risco como exemplos ao lado da propriedade | Trail of Bits (`generating.md`), só ideia |
| `references/property-based.md`: conferir a promessa do código antes de mudar código por um contraexemplo; caso que a promessa não decide é pergunta ao usuário | Trail of Bits (`interpreting-failures.md`), só ideia. Com o usuário ausente ou rodando como subagente, testes de exemplo e nota no relato: DevOrb, na revisão de 2026-11-11 |
| `references/property-based.md`: regra sem seam, extrair a parte pura segue os seams do plano ou a escolha do usuário, sem reestruturar só para chegar ao nível "roda" | Trail of Bits (`refactoring.md`), só a ideia central, com exemplos novos desde a revisão de 2026-11-11. Seguir os seams do plano e o caso do usuário ausente ou subagente são do DevOrb |
| `references/property-based.md`: biblioteca é decisão do usuário, usar a que o projeto já tem e não trazer segunda | Trail of Bits (`SKILL.md` e `libraries.md`), só ideias, por decisão da Task 7 |
| `references/property-based.md`: sem biblioteca, a mesma regra roda sobre uma tabela de entradas escrita à mão | DevOrb |

## Conflitos resolvidos

- **Quem escolhe o seam:** o Matt manda escrever os seams e confirmá-los com o usuário antes de qualquer teste. Pela decisão da Task 7, o plano de `devorb:planning` nomeia os seams, e a skill não para para perguntar durante a implementação. Sem plano ou sem seam nomeado, vale a interface pública mais alta que alcança o comportamento, dita em uma linha. Se o seam do plano não alcança o comportamento, vale o seam público mais próximo abaixo dele, e isso vai no relato.
- **Refactor no ciclo ou na revisão:** o Superpowers mantém o refactor no ciclo, e o Matt o tira do ciclo e manda para a revisão. Pela decisão da Task 7, o refactor fica no ciclo, mas só no código e nos testes que aquele ciclo escreveu ou mudou. Limpeza mais ampla vira nota para `devorb:reviewing`.
- **Quando usar mock:** o Superpowers diz "sem mock a não ser inevitável", e o Matt lista onde mockar (APIs externas, às vezes banco, tempo e aleatoriedade, às vezes sistema de arquivos). A skill usa a lista do Matt, que diz quando o mock é inevitável.
- **Afirmar chamadas:** o Superpowers manda afirmar argumentos, contagem e ordem quando fazem parte do contrato, e o Matt marca contagem e ordem de chamadas como sinal de teste acoplado. Vale afirmar chamadas só no dublê de fronteira, quando a chamada é o próprio contrato (a cobrança enviada, o e-mail entregue). No código que o projeto controla, afirma-se o resultado.
- **"Passou de cara: corrija o teste" e "adicione testes ao código existente":** as duas frases são do Superpowers e brigam, porque um teste de caracterização passa de cara por definição. A skill manda quebrar o código de propósito para ver cada teste falhar, restaurar e comparar com o original, a mesma técnica que `devorb:debugging` usa ao forçar o vermelho.
- **O que se apaga:** a Lei de Ferro apaga só o código escrito nesta mudança antes do próprio teste, também nos sinais de parada e no checklist. Código existente, que inclui o trabalho não commitado do usuário, não é apagado, ganha testes antes de mudar. O Superpowers separa os dois casos em linhas distantes, e a skill os põe juntos, porque apagar código que não foi escrito nesta mudança perderia trabalho do usuário. Pelo mesmo motivo, a restauração depois de forçar o vermelho vem de uma cópia do arquivo, nunca de `git checkout` ou `git stash`.
- **Precedência e "testa depois":** o `using-devorb` põe o pedido do usuário acima do fluxo, e o caso realista traz um usuário que sugere testar depois. Resolvido pela regra própria 1: instrução direta de método é nível 1 e se segue; adiamento diz prioridade, não método.
- **Sinais de alerta da referência:** o Superpowers tem "Quick Reference" e "Warning Signs", e o Matt tem "Red flags". Viraram uma lista só de sinais de alerta. A tabela de referência rápida saiu porque repetia o corpo.
- **Uma referência ou cinco:** a Trail of Bits divide as orientações em cinco arquivos, um por tarefa. Pela Task 7, as ideias ficam em um arquivo só, `references/property-based.md`, e valem só quando o código tem o formato.
- **Ponytail:** a spec registra que o ponytail prescreve um teste depois do código. A spec decide manter a convivência sem resolver o conflito, e a skill não cita o ponytail.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. A regra abaixo foi escrita antes da linha de base da Task 7, a partir do pedido do caso realista, e o resultado da comparação ainda está por vir.

1. **Urgência não é permissão.** "É urgente" ou "escreve o teste depois se der tempo" é um adiamento: diz prioridade, não método, e não dispensa o teste primeiro. A skill manda dizer em uma linha que o teste vem antes e seguir. Uma instrução direta de método ("código primeiro", "sem TDD aqui", "pula os testes") é nível 1 no `devorb:using-devorb`: a skill segue e relata a mudança como feita sem teste primeiro, ou sem teste, se os testes foram pulados. Caso: `evals/tdd-desconto-progressivo`. O Superpowers trata "testo depois" como desculpa do agente, não como pedido do usuário, e a precedência do `using-devorb` põe o pedido do usuário acima do fluxo. Sem a regra, um "depois, se der tempo" do usuário pode ser lido como permissão para inverter a ordem.

## Fora

- **Do Superpowers (`SKILL.md`):** o diagrama `dot` do ciclo, que virou cinco passos numerados; os exemplos de código do RED e do GREEN (`retryOperation`) e o exemplo de bug do e-mail vazio; a tabela "Good Tests", que virou uma frase no RED; as desculpas que repetiam outras ("TDD vai me atrasar", "teste manual é mais rápido", "código existente não tem teste", que virou parágrafo próprio); a "Final Rule", que repete a Lei de Ferro; e a seção "Debugging Integration", que virou a linha de `devorb:debugging` em `Connects to`.
- **Do Superpowers (`writing-good-tests.md`):** a tabela "Quick Reference", que repetia o corpo; a atribuição das perguntas ao "parceiro humano"; e, na revisão de 2026-11-11, a seção "testes vão com a implementação", que repetia o ciclo do corpo.
- **Do Matt:** a `description` dele, que dispara só quando o usuário pede TDD; o exemplo de teste acoplado em que `checkout` chama `paymentService.process` (`tests.md`), porque o exemplo de `createUser` pelo banco já mostra o mesmo erro; confirmar os seams com o usuário e o refactor fora do ciclo, trocados pelas decisões da Task 7; a nota de uma linha sobre o que cada seam pega e deixa passar, que é trabalho de `devorb:planning`; e `agents/openai.yaml`, metadado de outra ferramenta.
- **Da Trail of Bits:** Echidna, Medusa e invariantes de Solidity, porque a spec recusa as skills de blockchain dela; a tabela de bibliotecas por linguagem e a sintaxe de estratégias, que um modelo atual já conhece; `settings`, `deadline` e `max_examples` do Hypothesis; a tabela de severidade da revisão e os comandos `rg` para achar testes; a tabela de classificação de falhas e os padrões recorrentes (surrogates, denormais, hash e igualdade, iteradores); as cinco refatorações detalhadas com código, das quais só ficou a ideia central; a revisão de testes de propriedade existentes como fluxo à parte; o `README.md`, que documenta as avaliações deles e o `effort: low`; `agents/openai.yaml` e a marca em `assets/`.
- **Lacuna fechada na revisão:** nenhuma fonte diz o que fazer quando o projeto não tem como rodar testes (sem framework instalado). Desde a revisão de 2026-11-11, a skill manda usar o executor embutido da linguagem, e trazer framework é decisão do usuário, como a biblioteca de propriedades.

## Revisões

- **2026-11-11, depois da revisão e antes das rodadas pagas de comparação.** `SKILL.md` foi de 7.545 para 8.104 bytes (cerca de 1.887 para 2.026 tokens).
  - **Risco de cópia (`textReuse: false`):** trechos de `references/property-based.md` parafraseavam a Trail of Bits. Abertura, ordem de força, tautologia, vacuidade, pinagem das entradas de risco, promessa do código, regra sem seam e biblioteca foram reescritos sem a fonte aberta, com outra ordem e outro enquadramento. O catálogo mudou de ordem e ganhou exemplos novos (saiu a "taxa de desconto"). A tautologia usa a redação do Matt que já estava no corpo. A lista própria de formatos algébricos em `SKILL.md` foi trocada pelas perguntas da referência e saiu dos antipadrões para "Onde ficam os testes", porque não é antipadrão.
  - **Precedência:** instrução direta de método é nível 1 do `devorb:using-devorb` e se segue, relatada como sem teste primeiro. Adiamento diz prioridade, não método. Antes, a regra só dizia o que não dispensa o teste e podia ser lida como recusa de uma ordem direta do usuário.
  - **O que se apaga:** a Lei de Ferro, os sinais de parada e o checklist passaram a dizer "código escrito nesta mudança antes do teste". Código existente inclui o trabalho não commitado do usuário. Antes, "comece de novo" no checklist e "apague o código escrito antes do teste" podiam apagar trabalho do usuário.
  - **Restaurar depois de forçar o vermelho:** copiar o arquivo, restaurar da cópia e conferir diff vazio, nunca `git checkout` ou `git stash`, que descartam trabalho não commitado (como em `devorb:debugging`, passo 5.2).
  - **Falhas de outros testes:** a que a mudança causou se conserta; a que já existia vai no relato pelo nome e fica. Antes, "conserte agora" podia puxar consertos fora do escopo.
  - **Sem executor de testes:** a lacuna virou uma linha no passo 4.
  - **Perguntas no meio do ciclo:** em `property-based.md`, com o usuário ausente ou rodando como subagente, a skill segue com testes de exemplo e registra a pergunta no relato, em vez de parar.
  - **Peso:** o gatilho de `references/writing-good-tests.md` ficou restrito a mock, dublê, helper ou limpeza, ou quando não se sabe nomear a quebra. Saíram da referência a seção "testes vão com a implementação" e seis sinais de alerta que repetiam o corpo.
  - **Ledger:** "sem lista espelhada" e "rearranjado" exageravam a distância da fonte e foram corrigidos; estatísticas e ramo inalcançável passaram a ser creditados a `libraries.md`; o exemplo de `paymentService.process` do Matt entrou em Fora.

- **2026-11-11, roteamento, depois da comparação paga.** No caso `evals/tdd-desconto-progressivo`, com o DevOrb carregado, o agente não chamou skill nenhuma em 3 de 3 rodadas: leu o código, editou `src/cart.js`, depois o teste, e rodou `npm test`. A `devorb:tdd` nunca carregou, e a regra própria 1 nunca foi lida. O Superpowers chamou a skill de TDD dele em 1 de 3. A urgência e o "testa depois" fazem o agente pular a checagem de skills. Enquanto `aligning`, `planning` e `implementing` estão `planned`, só a `description` da `tdd` e o texto do hook levam até ela. A `description` ganhou "including urgent requests and ones that say tests can wait" (de 25 para 40 tokens na conta do teto sempre ligado, que soma 131 de 706), e `SKILL.md` foi de 8.147 para 8.207 bytes. O `using-devorb` ganhou o sinal de alerta correspondente (regra própria 5 do ledger dele).

## Resultados

Opus 5.5, 3 rodadas por caso, `--ablation none`. Relatórios em `fusion/results/2026-11-11-tdd*.md`.

| Caso | DevOrb | Superpowers | Matt |
|---|---|---|---|
| `tdd-desconto-progressivo` | 100% | 33% | 0% |
| Reservado `tdd-vencimento-boleto` | 0% (0,20) | 0% (0,20) | 0% (0,20) |

- `accepted: true` nas duas comparações; o reservado é lacuna.
- Primeira rodada: 0% no DevOrb porque a urgência do pedido fez o agente pular a checagem de skills (nenhuma chamada de Skill). Corrigido na descrição da `tdd` e no `using-devorb` (regra própria 5 de lá).
- Segunda rodada: o agente fez TDD de verdade (teste, falha vista, código, faixa por faixa), mas o juiz `llm` com `focus: trace` só recebe o começo e o fim de um trace longo e reprovou. O grader de ordem virou `regex` sobre o trace inteiro, conferido num trace com TDD e num com código primeiro.
- **Reservado:** o pedido diz "vai direto no código ... teste a gente vê depois". Pela precedência do DevOrb, "vai direto no código" é instrução direta de método (nível 1): a skill segue o usuário e relata a mudança como não feita por teste primeiro. O caso espera TDD mesmo assim, e nenhum braço faz. **Decisão do dono:** se um pedido assim deve valer mais que o processo. Nenhuma regra nova nasceu do reservado.

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/test-driven-development/SKILL.md` | adotado | base da Lei de Ferro com apagar o código, das exceções, do ciclo RED, GREEN e REFACTOR com as duas verificações obrigatórias, da suíte inteira, dos sinais de parada, do "quando travar" e do checklist
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/test-driven-development/SKILL.md` | recusado | diagrama `dot`, exemplos de código, "Final Rule" e desculpas repetidas pesariam no teto sem regra nova
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/test-driven-development/writing-good-tests.md` | adotado | base de `references/writing-good-tests.md`, adaptado: nome legado trocado, perguntas sem atribuição, sinais de alerta fundidos com os do Matt
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/test-driven-development/writing-good-tests.md` | recusado | tabela "Quick Reference", que repetia o corpo
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/tdd/SKILL.md` | adotado | seam como fronteira pública, `GLOSSARY.md` e ADRs, `codebase-design`, antipadrões (tautológico, acoplado, fatia horizontal), fatias verticais e "não antecipar testes futuros"
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/tdd/SKILL.md` | recusado | confirmar os seams com o usuário antes de testar e refactor fora do ciclo, trocados pelas decisões da Task 7; `description` que só dispara a pedido
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/tdd/tests.md` | adotado | fundido em `references/writing-good-tests.md`: teste pela interface pública, exemplos de checkout e `createUser`, exemplo tautológico e sinais de alerta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/tdd/mocking.md` | adotado | fundido em `references/writing-good-tests.md`: mockar só na fronteira, injeção de dependência e interface estilo SDK
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/tdd/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/SKILL.md` | adotado | só ideias, com texto próprio desde a revisão de 2026-11-11: o catálogo de propriedades (os mesmos itens, como perguntas, em outra ordem e com exemplos novos), a ordem de força, tautologia e vacuidade com a exceção do determinismo, "sem o formato, testes de exemplo" e biblioteca como decisão do usuário
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/SKILL.md` | recusado | `description` longa, `effort: low` e o roteamento para cinco referências
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/generating.md` | adotado | só ideias: gerar entradas válidas em vez de filtrar e fixar as entradas de risco como exemplos
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/generating.md` | recusado | sintaxe de estratégias e `settings` do Hypothesis
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/refactoring.md` | adotado | só ideia: extrair a parte pura expõe a regra, a escolha é do usuário, e não vale reestruturar para chegar só a "não quebra"
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/refactoring.md` | recusado | as cinco refatorações detalhadas com código
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/reviewing.md` | adotado | só ideias: tautologia e vacuidade, e a exceção do determinismo
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/reviewing.md` | recusado | tabela de severidade, comandos `rg` e revisão como fluxo à parte
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/interpreting-failures.md` | adotado | só ideia: conferir o que o código promete antes de confiar no contraexemplo, e caso não decidido é pergunta ao usuário
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/interpreting-failures.md` | recusado | tabela de classificação e padrões recorrentes, que pesariam em todo teste
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/libraries.md` | adotado | só ideias: usar a biblioteca que o projeto já tem, sem trazer uma segunda; ler as estatísticas da execução (casos rodados e descartados); e a vacuidade de um ramo que os dados gerados quase nunca alcançam
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/references/libraries.md` | recusado | tabela por linguagem, e Echidna e Medusa, porque a spec recusa as skills de blockchain da fonte
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/README.md` | recusado | documenta as avaliações e o `effort: low` da fonte
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/property-based-testing/skills/property-based-testing/assets/trail-of-bits-mark.svg` | recusado | marca da fonte
