# Ledger: `improve-architecture`

Skill manual de uma fonte principal: `engineering/improve-codebase-architecture` do Matt Pocock (MIT), com `HTML-REPORT.md`, adaptada ao fluxo do DevOrb e enxugada. Texto reaproveitado e adaptado, com a licença em `LICENSES/mattpocock-skills-MIT.txt`. Nenhuma fonte nova alimenta esta skill: o mapa de skills da spec liga `improve-architecture` só à `improve-codebase-architecture` do Matt.

Pino lido: `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`, igual ao `lastAbsorbed` de `mattpocock-skills`, buscado raso em pasta temporária, com hooks desligados e sem rodar nada. Além da pasta da skill (`SKILL.md`, `HTML-REPORT.md`, `agents/openai.yaml`), foram lidos o que ela cita, `productivity/grilling/SKILL.md`, e a página `docs/engineering/improve-codebase-architecture.md`, fora dos caminhos acompanhados, só para entender o uso.

A skill foi escrita sem abrir `evals/improve-architecture-*` nem `evals-reserved/`. Nenhuma regra própria foi justificada por cenário ainda: o caso realista da Task 17 (invocado por `/devorb:improve-architecture`, grader `llm` no `last_message`) é de outro agente.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` e `disable-model-invocation: true` | Matt, com o resumo de uma linha reescrito ("question" no lugar de "grill") para a regra de skill manual de `devorb:writing-skills` |
| Abertura: oportunidades de aprofundamento, testabilidade e navegação por agente | Matt |
| "É um levantamento: não muda código; o refactor escolhido segue o fluxo normal" | Matt (`docs/engineering/improve-codebase-architecture.md`, "It never changes the code"), trazido para o corpo |
| Vocabulário de arquitetura por `devorb:codebase-design`, de domínio por `GLOSSARY.md`, ADRs não são rediscutidas | Matt, com os nomes trocados pelos do DevOrb |
| Escopo antes de varrer; direção dada pelo usuário vence | Matt. "Uma spec com 'como deixar essa mudança fácil?'" vem da página de docs do Matt, que chama esse o pedido mais eficaz |
| Pontos quentes pelo `git log` | Matt (`git log --oneline`). O comando que conta arquivos por frequência é DevOrb (ver regras próprias) |
| Sem ponto quente claro, ampliar e dizer no relatório | Matt; "dizer no relatório" é DevOrb, e o cabeçalho do relatório ganhou o escopo |
| Ler `GLOSSARY.md` e ADRs primeiro | Matt |
| Subagente novo para explorar, com perguntas de atrito | Matt. A alternativa "sem ferramenta de subagente, explore você" é o padrão da casa (`aligning`, `codebase-design`) |
| Teste de exclusão em todo suspeito; só "concentra" vira candidato | Matt (`SKILL.md` e página de docs) |
| Relatório HTML na pasta temporária do sistema, aberto para o usuário, com caminho absoluto | Matt |
| Cartão por candidato e "Top recommendation" | Matt |
| Conflito com ADR | Matt |
| "Nada de interfaces ainda" e parar na pergunta "Which of these would you like to explore?" | Matt. "Pare até ele responder" é DevOrb, explícito |
| Questionar o candidato escolhido | Matt chama `grilling`. Aqui é `devorb:aligning`, que faz a rodada de perguntas sob pedido e leva o refactor a uma spec e a `devorb:planning` |
| Efeitos em `GLOSSARY.md` e oferta de ADR na rejeição | Matt, por `devorb:domain-modeling`. "Crie o arquivo só quando precisar" saiu: `domain-modeling` já decide isso |
| Comparar interfaces alternativas por `devorb:codebase-design` (design-it-twice) | Matt |
| `Connects to` | DevOrb, pela interface da Task 17 e pelo `Connects to` de `codebase-design`, que já recebe "um candidato escolhido de `devorb:improve-architecture`" |
| `references/HTML-REPORT.md` | Matt, quase inteiro. As cinco seções de padrões de diagrama viraram parágrafos; "/codebase-design" virou `devorb:codebase-design`; a tag de categoria de dependência aponta para `codebase-design` |
| Escapar `<`, `>`, `&` e `"` de nomes vindos do código, rótulos do Mermaid entre aspas e versões exatas de Tailwind e Mermaid nos CDNs | DevOrb |
| Mermaid sem `securityLevel: "loose"` | DevOrb (ver conflitos) |

## Conflitos resolvidos

- **Quem questiona:** o Matt chama `grilling`, que pergunta em rodadas numeradas até a árvore de decisões esvaziar. No DevOrb não há skill de grilling solta; `devorb:aligning` faz a rodada sob pedido (`references/grilling-round.md`) e termina numa spec aprovada. Resolvido: o candidato vai para `devorb:aligning`, e o refactor segue spec, plano e implementação, como a página de docs do Matt já descreve ("você faz o refactor depois, pelo fluxo normal").
- **Mermaid `securityLevel: "loose"`:** o Matt libera HTML e cliques nos rótulos. Os rótulos vêm de nomes do código do usuário, e o relatório não precisa de nada que o nível padrão bloqueie. Ficou o padrão (`strict`), e a regra de escapar nomes.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As regras abaixo foram escritas antes de qualquer rodada de comparação, a partir das decisões da Task 17, e ainda não há resultado que mostre se elas mudam o comportamento.

1. **Pontos quentes contados, não lidos a olho.** O exemplo `git log --since=... --name-only --format= -- . ':!*.lock' ':!package-lock.json' ':!pnpm-lock.yaml' | grep . | sort | uniq -c | sort -rn | head -30` dá a frequência por arquivo, sem lockfiles nem arquivos gerados, e o `git log --oneline` do mesmo trecho diz do que tratavam as mudanças. O escopo usado (direção do usuário ou pontos quentes e o trecho de histórico lido) aparece no cabeçalho do relatório. Motivo: a Task 17 manda preservar os pontos quentes pelo git log; "ande um bom trecho do `git log --oneline`" deixa o agente julgar frequência lendo mensagens, e o relatório não mostrava de onde veio o escopo.
2. **Levantamento, não refactor.** A skill não muda código, e o candidato escolhido segue pelo fluxo normal (`devorb:aligning`, spec, `devorb:planning`). Motivo: a página de docs do Matt diz isso, mas o `SKILL.md` não; no DevOrb, sem a frase, o "explore" depois da escolha pode virar edição direta, pulando o portão de `aligning`.

## Fora

- **Do Matt (`SKILL.md`):** "Call the Skill tool with..." (trocado por `devorb:*`); a criação preguiçosa do `GLOSSARY.md`, que é regra de `devorb:domain-modeling`; o link `[HTML-REPORT.md](HTML-REPORT.md)`, trocado por caminho.
- **Do Matt (`HTML-REPORT.md`):** `securityLevel: "loose"`; os subtítulos de cada padrão de diagrama.
- **Do Matt (`agents/openai.yaml`):** metadado de outra ferramenta. O `allow_implicit_invocation: false` dele corresponde ao `disable-model-invocation: true`.
- **Da página de docs:** a tabela de quatro situações de uso e a tabela de significado dos selos. Ficou só a ideia de apontar a skill para uma spec.

## Resultados

Opus 5.5, nível leve, 2 rodadas, comparado com o Matt. `fusion/results/2026-11-12-improve-architecture.md`.

| Caso | DevOrb | Matt |
|---|---|---|
| `improve-architecture-calculo-preco` | 100% (1,00) | 0% (0,33) |

- `accepted: true`.

## Decisões por commit de fonte

- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/improve-codebase-architecture/SKILL.md` | adotado | escopo antes de varrer, pontos quentes pelo git log, subagente para explorar, teste de exclusão, relatório HTML na pasta temporária antes de qualquer interface, conflito com ADR, efeitos em glossário e ADR, design-it-twice
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/improve-codebase-architecture/SKILL.md` | recusado | chamada a `grilling` (trocada por `devorb:aligning`) e criação preguiçosa do glossário (já em `domain-modeling`)
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/improve-codebase-architecture/HTML-REPORT.md` | adotado | base de `references/HTML-REPORT.md`: esqueleto, cartão, padrões de diagrama, estilo e vocabulário
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/improve-codebase-architecture/HTML-REPORT.md` | recusado | `securityLevel: "loose"` do Mermaid
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/improve-codebase-architecture/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:docs/engineering/improve-codebase-architecture.md` | adotado | só ideias, fora dos caminhos acompanhados: a skill não muda código, e apontá-la para uma spec

## Revisões

- 2026-11-12, revisão antes das rodadas: a contagem de pontos quentes exclui lockfiles (`':!*.lock' ':!package-lock.json' ':!pnpm-lock.yaml'`) e arquivos gerados, que inflam a frequência sem ser arquitetura; o relatório escapa também `"` e põe os rótulos do Mermaid entre aspas (`A["nome"]`), porque nomes do código podem quebrar a sintaxe; os CDNs ficam fixados em versões exatas (Tailwind `3.4.16`, Mermaid `11.4.1`), em vez de `mermaid@11` e da última do Tailwind.
