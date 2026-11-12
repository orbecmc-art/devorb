# Ledger: `domain-modeling`

Skill de uma fonte principal: `engineering/domain-modeling` do Matt Pocock (MIT), com `GLOSSARY-FORMAT.md` e `ADR-FORMAT.md`, adaptada ao fluxo do DevOrb e enxugada. Texto reaproveitado e adaptado, com a licença em `LICENSES/mattpocock-skills-MIT.txt`. Nenhuma fonte nova alimenta esta skill: o mapa de skills da spec liga `domain-modeling` só à `domain-modeling` do Matt, e nenhuma entrada de `fusion/sources.json` além de `mattpocock-skills` cobre glossário ou ADR. Duas ideias vêm de outro arquivo do mesmo pino, `engineering/setup-matt-pocock-skills/domain.md`, que fica dentro do caminho acompanhado `skills/engineering/` (a skill `setup-matt-pocock-skills` em si fica fora, pela spec). Uma frase vem de um conflito já decidido na spec.

Pino lido: `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`, igual ao `lastAbsorbed` de `mattpocock-skills`, buscado raso em pasta temporária, sem rodar nada. Além da pasta da skill, foram lidos os trechos que citam `domain-modeling` em `grill-with-docs`, `ask-matt`, `improve-codebase-architecture`, `setup-matt-pocock-skills/domain.md` e `README.md` da pasta `engineering`, para entender quem chama a skill.

O caso que justifica a regra própria é o caso realista da Task 9, como o plano o descreve: pedido com um termo ambíguo, grader `file_exists` em `GLOSSARY.md` e `llm` no conteúdo. A skill foi escrita sem abrir `evals/domain-modeling-*` nem `evals-reserved/`. O nome da pasta do caso apareceu numa listagem de `evals/`, mas o conteúdo não foi lido.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb. A do Matt dispara quando se discute terminologia ou se edita `GLOSSARY.md` ou ADR. A nova dispara pelo pedido com termo vago ou sobrecarregado, ou por decisão difícil de reverter, e nomeia os dois arquivos. 40 tokens na conta do teto sempre ligado, que soma 178 de 706 |
| Abertura: construir e afiar o modelo enquanto o trabalho é desenhado; só ler `GLOSSARY.md` não é esta skill | Matt |
| Onde ficam os arquivos: um contexto ou vários com `GLOSSARY-MAP.md`, ADRs do sistema na raiz e do contexto dentro dele; perguntar quando o contexto não está claro | Matt (`SKILL.md` e `GLOSSARY-FORMAT.md`). As duas árvores de pastas viraram um parágrafo |
| Criar arquivos só quando há o que escrever | Matt |
| Arquivo ausente não é problema a relatar e não se cria vazio de antemão | Matt (`setup-matt-pocock-skills/domain.md`: "proceed silently", sem sugerir criar antes) |
| Desafiar contra o glossário, afiar palavra vaga, sondar com cenários, conferir o código com exemplos (*cancellation*, *Account*, Orders) | Matt, em lista |
| "O código mostra como o sistema age hoje, não o que o negócio exige" | Spec, "Conflitos já decididos: ler o código ou perguntar" (ideia do ECC `intent-driven-development`, escrita com as palavras da spec) |
| Quando um termo está resolvido; perguntar uma por vez, com o significado recomendado; sem o usuário, ficar com o significado que o código sustenta, escrever e relatar como escolha a confirmar | Regra própria 1. "Uma pergunta por vez" segue a decisão da Task 10 para `devorb:aligning` |
| Gravar cada termo resolvido na hora, no formato da referência, sem acumular | Matt |
| Usar o termo em código, testes e mensagens; sinônimos em _Avoid_ | Matt (`domain.md`, "use the glossary's vocabulary", e a regra "be opinionated" de `GLOSSARY-FORMAT.md`) |
| Glossário só com definições, sem detalhe de implementação, não é spec nem rascunho | Matt. Os exemplos (tabelas, classes, endpoints, bibliotecas) são do DevOrb |
| Requisitos vão para a spec de `devorb:aligning`, escolhas de implementação para o plano ou ADR | DevOrb |
| Teste de três perguntas para ADR; faltou uma, sem ADR | Matt |
| ADR que contradiz outra: dizer em vez de sobrescrever calado; reaberta, a nova substitui a antiga | Matt (`domain.md`, "flag ADR conflicts") com o status `superseded by` de `ADR-FORMAT.md` |
| `Connects to` | DevOrb. `devorb:improve-architecture` como quem também nomeia conceitos vem de `improve-codebase-architecture`, que chama `domain-modeling` no Matt |
| `references/GLOSSARY-FORMAT.md` | Matt, quase inteiro. "Não o que faz" ganhou "nem como o código guarda" |
| `references/ADR-FORMAT.md` | Matt. A lista das três perguntas saiu e aponta para `SKILL.md`; ficou a explicação de cada uma. "Marcar a antiga como `superseded by ADR-NNNN`" é do DevOrb |

## Conflitos resolvidos

- **Quando dispara:** a `description` do Matt só dispara quando o assunto já é terminologia ou os arquivos. No DevOrb a skill é automática e chamada por `devorb:aligning`, então dispara pelo pedido que traz o termo ambíguo, mesmo antes de alguém falar em glossário.
- **Perguntar ou seguir:** o Matt supõe o usuário presente na conversa e manda perguntar. No DevOrb a skill pode rodar como subagente ou num pedido sem conversa. Resolvido pela regra própria 1.
- **Ler o código ou perguntar:** o Matt manda conferir o que o usuário diz contra o código. A spec já decidiu que o código responde como o sistema age hoje, e regra de negócio achada nele é suposição a confirmar. A skill traz essa frase logo depois do exemplo do Matt.
- **Glossário e spec:** o Matt diz que o glossário não é spec. No DevOrb a spec tem dono, `devorb:aligning`, então a skill diz para onde vão requisitos e escolhas de implementação.
- **Teste de três perguntas em dois lugares:** o Matt repete a lista em `SKILL.md` e em `ADR-FORMAT.md`. Ficou só em `SKILL.md`, que decide se a referência é aberta, e a referência guarda a explicação de cada pergunta.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. A regra abaixo foi escrita antes de qualquer rodada de comparação, a partir do pedido do caso realista como o plano o descreve, e ainda não há resultado que mostre se ela muda o comportamento.

1. **Termo resolvido e trabalho sem o usuário.** Um termo está resolvido quando o usuário escolhe o significado, ou quando o pedido, o código e o glossário apontam para o mesmo. Fora disso, pergunta-se ao usuário, uma pergunta por vez, com o significado recomendado. Trabalhando sem o usuário (como subagente, ou com ordem de seguir sem perguntas), fica-se com o significado que o código sustenta, grava-se o termo e ele vai no relato como escolha a confirmar. Caso: o caso realista da Task 9, pedido com um termo ambíguo. O Matt só diz "quando um termo é resolvido" e supõe o usuário na conversa. Sem a regra, o agente sem usuário para numa pergunta e não grava nada, ou escolhe calado um significado e o código passa a carregá-lo sem registro.

## Fora

- **Do Matt (`SKILL.md`):** as duas árvores de pastas, que viraram um parágrafo; a `description`, trocada (ver conflitos); os links `./GLOSSARY-FORMAT.md` e `./ADR-FORMAT.md`, que viraram caminhos em `references/`.
- **Do Matt (`ADR-FORMAT.md`):** a lista repetida das três perguntas. "Levaria um trimestre para trocar" virou "levaria meses".
- **Do Matt (`setup-matt-pocock-skills/domain.md`):** a lista do que ler antes de explorar, que é hábito das skills que consomem o glossário (`devorb:tdd` e `devorb:debugging` já leem); o formato de citação "_Contradicts ADR-0007…_"; e o resto da skill de configuração, fora pela spec.
- **Do Matt (`improve-codebase-architecture`):** a frase pronta para oferecer ADR quando o usuário recusa um candidato. É do fluxo de `devorb:improve-architecture` (Task 17).
- **Do Matt (`grill-with-docs`):** chamar `grilling` e `domain-modeling` juntas. É de `devorb:aligning` (Task 10).
- **Do Matt (`agents/openai.yaml`):** metadado de outra ferramenta.

## Resultados

A preencher.

## Decisões por commit de fonte

- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/domain-modeling/SKILL.md` | adotado | abertura, onde ficam os arquivos, criar só quando há o que escrever, desafiar, afiar, sondar com cenários, conferir o código, gravar na hora, glossário sem implementação e teste de três perguntas para ADR
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/domain-modeling/SKILL.md` | recusado | `description` que só dispara quando o assunto já é terminologia; árvores de pastas
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/domain-modeling/GLOSSARY-FORMAT.md` | adotado | base de `references/GLOSSARY-FORMAT.md`, quase inteiro
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/domain-modeling/ADR-FORMAT.md` | adotado | base de `references/ADR-FORMAT.md`: modelo, seções opcionais, numeração, explicação das três perguntas e o que merece ADR
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/domain-modeling/ADR-FORMAT.md` | recusado | lista repetida das três perguntas, que fica só em `SKILL.md`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/domain-modeling/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/setup-matt-pocock-skills/domain.md` | adotado | só três ideias: arquivo ausente não se relata nem se cria antes, usar o vocabulário do glossário e apontar conflito com ADR em vez de sobrescrever
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/setup-matt-pocock-skills/domain.md` | recusado | lista do que ler antes de explorar, já coberta nas skills que consomem o glossário, e formato de citação de conflito
