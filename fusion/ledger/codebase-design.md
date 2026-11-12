# Ledger: `codebase-design`

Skill de uma fonte principal: `engineering/codebase-design` do Matt Pocock (MIT), com `DEEPENING.md` e `DESIGN-IT-TWICE.md`, adaptada ao fluxo do DevOrb e enxugada. Texto reaproveitado e adaptado, com a licença em `LICENSES/mattpocock-skills-MIT.txt`. Nenhuma fonte nova alimenta esta skill: o mapa de skills da spec liga `codebase-design` só à `codebase-design` do Matt, e nenhuma entrada de `fusion/sources.json` além de `mattpocock-skills` cobre desenho de módulos.

Pino lido: `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`, igual ao `lastAbsorbed` de `mattpocock-skills`, buscado raso em pasta temporária, com hooks desligados e sem rodar nada. Além da pasta da skill, foram lidos os trechos que citam `codebase-design` em `README.md` da pasta `engineering`, `ask-matt`, `improve-codebase-architecture` (`SKILL.md` e `HTML-REPORT.md`) e `tdd`, para entender quem chama a skill. A citação em `in-progress/setup-ts-deep-modules` ficou fora, porque a pasta `in-progress` está fora pela spec.

O caso que justifica a regra própria é o caso realista da Task 12, como o plano o descreve: onde colocar o seam em um módulo raso, grader `llm` no `last_message`. A skill foi escrita sem abrir `evals/codebase-design-*` nem `evals-reserved/`. O nome da pasta do caso apareceu num `git status`, mas o conteúdo não foi lido.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb. A do Matt começa com "Shared vocabulary" e lista seis gatilhos, inclusive "quando outra skill precisa do vocabulário". A nova começa com "Use when" e dispara por decidir interface ou seam, julgar módulo raso ou tornar código testável pela interface. 40 tokens na conta do teto sempre ligado, que soma 247 de 706 |
| Abertura: módulos profundos, interface pequena, seam limpo, alavancagem, localidade e testabilidade | Matt |
| "Vocabulário a consultar, não uma sessão a rodar" | Matt (`tdd/SKILL.md`, que descreve assim a `codebase-design`) |
| Glossário: Module, Interface, Implementation, Depth, Seam, Adapter, Leverage, Locality, com os _Avoid_ | Matt, palavra por palavra. "Reach for" virou "Say"; o motivo de evitar *boundary* ficou só nos enquadramentos rejeitados |
| Nomes de domínio vêm do `GLOSSARY.md`, nomes de arquitetura vêm daqui | Matt (`improve-codebase-architecture/SKILL.md`), apontando para `devorb:domain-modeling` |
| Relações entre os termos | Matt. A lista de cinco itens virou um parágrafo |
| Princípios: profundidade é da interface, seams internos e externo, teste de exclusão, a interface é a superfície de teste, um adaptador é hipótese e dois são reais | Matt, palavra por palavra |
| Perguntas ao desenhar a interface | Matt. A lista de três perguntas virou uma frase |
| Desenhar para testabilidade: receber dependências, devolver resultados, superfície pequena | Matt. Os dois blocos de código viraram exemplos em linha com os mesmos nomes |
| Enquadramentos rejeitados | Matt, palavra por palavra |
| Uma recomendação, não um cardápio, com a evidência e as opções recusadas em uma linha | Regra própria 1. "Be opinionated... not a menu" vem do Matt (`DESIGN-IT-TWICE.md`), levado para toda decisão |
| Seam que o plano de `devorb:planning` já nomeia fica; mudar é mudança de plano, dita em voz alta | DevOrb, pela decisão da Task 7 (os seams vêm do plano) e da Task 11 (seams nomeados no plano) |
| Trabalho sem o usuário: decidir e relatar como escolha a confirmar | Regra própria 1 |
| Quando abrir `DESIGN-IT-TWICE.md`: usuário pede opções ou `devorb:improve-architecture` entrega um candidato | Matt (`improve-codebase-architecture/SKILL.md`, "want to explore alternative interfaces") |
| `Connects to` | DevOrb, pelas interfaces da Task 12 e da Task 17 |
| `references/DEEPENING.md` | Matt, quase inteiro. As quatro categorias viraram lista numerada; a frase sobre seams internos, que já está em `SKILL.md`, ficou só com a regra de não expô-los |
| `references/DESIGN-IT-TWICE.md` | Matt, quase inteiro. "Sub-agents" virou "subagents"; links trocados por caminhos |
| Sem como criar subagentes, escrever os desenhos um por restrição, terminando cada um antes do próximo | DevOrb, adaptação ao Claude Code: a skill pode rodar dentro de um subagente ou sem a ferramenta de agentes |

## Conflitos resolvidos

- **Quando dispara:** a `description` do Matt começa pelo que a skill é ("Shared vocabulary") e inclui "quando outra skill precisa do vocabulário". O verificador exige "Use when" nas automáticas, e as skills do DevOrb que precisam do vocabulário a citam pelo nome (`devorb:tdd`, `devorb:improve-architecture`), então esse gatilho saiu.
- **Quem decide o seam:** no Matt, `codebase-design` é a bancada onde o seam é escolhido. No DevOrb o plano já nomeia os seams de cada task e `devorb:tdd` não para para confirmá-los. Resolvido: seam do plano fica, e propor outro é mudança de plano, dita ao usuário ou no relato.
- **Usuário presente:** o Matt supõe o usuário na conversa, inclusive no `DESIGN-IT-TWICE.md` ("show this to the user"). No DevOrb a skill pode rodar como subagente, chamada por `devorb:tdd` no meio de uma task. Resolvido pela regra própria 1 e pela alternativa sem subagentes.
- **"Um adaptador é hipótese" em dois lugares:** o Matt repete o princípio em `SKILL.md` e em `DEEPENING.md`. Ficou nos dois, porque a versão de `DEEPENING.md` traz o detalhe que muda a decisão: produção e teste contam como dois adaptadores.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. A regra abaixo foi escrita antes de qualquer rodada de comparação, a partir do caso realista como o plano o descreve, e ainda não há resultado que mostre se ela muda o comportamento.

1. **Decidir com evidência, também sem o usuário.** A resposta é uma recomendação só: onde fica o seam, o que a interface expõe e a evidência (teste de exclusão, quantos adaptadores são reais, quais chamadores e testes o atravessam), com cada opção recusada em uma linha. Trabalhando sem o usuário (como subagente, ou com ordem de seguir sem perguntas), decide-se e relata-se a escolha como uma a confirmar. Caso: o caso realista da Task 12, onde colocar o seam em um módulo raso, com grader no `last_message`. O Matt só pede opinião forte dentro do `DESIGN-IT-TWICE.md`. Sem a regra, a resposta tende a listar opções sem escolher, ou a parar numa pergunta quando não há usuário.

## Fora

- **Do Matt (`SKILL.md`):** os dois diagramas em ASCII de módulo profundo e raso, que repetem a definição de **Depth**; os dois blocos de código TypeScript, que viraram exemplos em linha; a lista de relações, que virou parágrafo; as três perguntas em lista, que viraram frase; a `description` (ver conflitos).
- **Do Matt (`DEEPENING.md`):** os subtítulos por categoria; a frase repetida sobre seams internos.
- **Do Matt (`DESIGN-IT-TWICE.md`):** os links `[SKILL.md](SKILL.md)` e `[DEEPENING.md](DEEPENING.md)` repetidos em cada passo, trocados por um caminho por menção.
- **Do Matt (`agents/openai.yaml`):** metadado de outra ferramenta.
- **Do Matt (`improve-codebase-architecture/HTML-REPORT.md`):** as regras de prosa do relatório ("se o termo não está no glossário, procure um que esteja"). São do fluxo de `devorb:improve-architecture` (Task 17).

## Resultados

Opus 5.5, nível leve, comparado com o Matt. `fusion/results/2026-11-11-codebase-design.md`.

| Caso | DevOrb | Matt |
|---|---|---|
| `codebase-design-baixa-estoque` | 100% | 100% |

- `accepted: true` por empate. O caso não separa as versões no Opus e fica como guarda contra piora.

## Decisões por commit de fonte

- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/codebase-design/SKILL.md` | adotado | abertura, glossário exato com os _Avoid_, relações, princípios (teste de exclusão, interface como superfície de teste, um adaptador é hipótese e dois são reais), testabilidade e enquadramentos rejeitados
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/codebase-design/SKILL.md` | recusado | diagramas em ASCII, blocos de código longos e `description` com gatilho para outras skills
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/codebase-design/DEEPENING.md` | adotado | base de `references/DEEPENING.md`: quatro categorias de dependência, disciplina de seam e substituir em vez de empilhar testes
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/codebase-design/DESIGN-IT-TWICE.md` | adotado | base de `references/DESIGN-IT-TWICE.md`: enquadrar, subagentes paralelos com restrições diferentes, comparar e recomendar
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/codebase-design/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/tdd/SKILL.md` | adotado | só a ideia: a skill é referência a consultar, não sessão a rodar
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/improve-codebase-architecture/SKILL.md` | adotado | só duas ideias: domínio pelo `GLOSSARY.md` e arquitetura por esta skill; `DESIGN-IT-TWICE.md` quando se quer explorar interfaces alternativas

## Revisões

- 2026-11-12, revisão antes das rodadas: com o usuário presente, a recomendação espera o sim dele; sozinho, o seam que o plano nomeia fica, e o resto é decidido e relatado; testes antigos apagados ao aprofundar um módulo são listados no relato com o teste que os substitui.
