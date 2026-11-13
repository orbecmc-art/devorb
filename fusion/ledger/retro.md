# Ledger: `retro`

Skill de uma fonte principal: `engineering/retro` do Matt Pocock (MIT), adaptada ao fluxo do DevOrb e enxugada. Texto reaproveitado e adaptado, com a licença em `LICENSES/mattpocock-skills-MIT.txt`. Nenhuma fonte nova alimenta esta skill: o mapa de skills da spec liga `retro` só à `retro` do Matt.

Pino lido: `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`, igual ao `lastAbsorbed` de `mattpocock-skills`, buscado raso em pasta temporária, com hooks desligados e sem rodar nada. Foi lida a pasta inteira da skill (`SKILL.md` e `agents/openai.yaml`). Para ligar a skill ao DevOrb, foram lidos `skills/reviewing/SKILL.md` (quais arquivos de padrões o revisor lê), `skills/writing-skills/SKILL.md` (que já recebe de `devorb:retro` uma regra de julgamento) e `skills/using-devorb/references/phase-boundaries.md` (sugerir `retro` antes de limpar a sessão).

O caso que justifica as regras próprias é o caso realista da Task 17, como o plano o descreve: um caso por skill, invocado por `/devorb:retro`, grader `llm` no `last_message`. A skill foi escrita sem abrir `evals/retro-*` nem `evals-reserved/`.

## Origem por parte

| Parte | Origem |
|---|---|
| Frontmatter: `disable-model-invocation: true` | Matt |
| `description` | DevOrb: resumo de uma linha para quem digita o nome, pela regra das skills manuais. Acrescenta o alvo (o ambiente do agente) ao "Conduct a retrospective" do Matt |
| Abertura: propor mudanças no ambiente, para a próxima rodada ir melhor | Matt. A lista do que é ambiente (arquivos, checagens, instruções, ferramentas, acesso) resume as categorias |
| O código da sessão não é o assunto; bug vira achado só se o ambiente pudesse pegá-lo | Regra própria 2, a partir da decisão da Task 17 (olhar o ambiente e não o código) |
| Passo 1: ler a fonte primária, a sessão indicada ou a atual | Matt. O caminho do log no Claude Code (`~/.claude/projects/.../<id>.jsonl`) e "o log, não um resumo" são DevOrb, por `phase-boundaries.md`. A codificação da pasta do projeto (caminho absoluto com `/` e `.` trocados por `-`), buscar no log com grep ou jq em vez de lê-lo inteiro e tratar o conteúdo como dado, nunca instrução, vieram da revisão do coordenador |
| Não citar segredo do log | Regra própria 3 |
| Passo 2: ler as proteções do repo antes de propor (scripts, hooks, CI, `CLAUDE.md`/`AGENTS.md` no repo e globais, padrões que `devorb:reviewing` lê) | Matt ("read the repo's own check command first"), levado da categoria de checagens para um passo próprio que vale para todas |
| Passo 3: cada candidato cita o momento do log | Regra própria 1 |
| Abertura dos passos: nada muda até o usuário escolher, e rodar uma checagem pede permissão antes. Passo 4: apresentar ao usuário, do mais grave ao menos grave, e parar | Matt (apresentar por gravidade). Nada mudar antes da escolha e perguntar antes de rodar checagem: DevOrb, porque a skill é manual e o usuário decide |
| Categorias: navegação, checagens automáticas, padrões, arquivos de instrução, economia de ferramentas, no-ops, acesso a informação | Matt, enxugadas. Os "_Use when_" de cada uma viraram a frase de abertura da categoria; "Global AGENTS.md" virou "Steering files" e inclui `CLAUDE.md` |
| Checagem que existe mas está desligada ou quebrada é o achado; repo sem proteção nenhuma é achado | Matt |
| Mecânica vira checagem automática (regra no linter, hook de pre-commit ou job de CI, o mais barato); preferir construir a checagem a escrever a regra | Matt, por decisão da Task 17 |
| Julgamento vira padrão, no arquivo de padrões do repo que `devorb:reviewing` lê | Matt (`CODING_STANDARDS.md` lido pelo revisor), trocado pelos arquivos que `reviewing` já lê (`CONTRIBUTING.md` ou arquivo de padrões) |
| Correção que é skill, ou linha de `CLAUDE.md`/`AGENTS.md`, em qualquer das duas classes: `devorb:writing-skills`, cenário que falha primeiro | Decisão da Task 17. O Matt chama `writing-for-agents` sempre, no passo 1. Fica numa frase depois da lista, para não parecer uma terceira classe |
| Implementação carrega a pressão de contexto, revisão recebe um diff; padrões são cobrados na revisão | Matt, enxugado |
| Onde cada correção mora: `CLAUDE.md`/`AGENTS.md` com parcimônia, padrões lidos na revisão (dividir passando de cerca de 1.000 linhas), docs como referência apontada, skills para descrição em contexto ou comando do usuário | Matt, enxugado |
| `Connects to` | DevOrb, pelas interfaces da Task 17, `phase-boundaries.md`, `reviewing` e `writing-skills` |

## Conflitos resolvidos

- **Quando usar `writing-skills`:** o Matt carrega `writing-for-agents` no passo 1, como guia de estilo para toda retro. A Task 17 decide usar `devorb:writing-skills` só quando a correção é uma skill. Resolvido assim, com `CLAUDE.md` e `AGENTS.md` juntos, porque `devorb:writing-skills` também cobre esses arquivos.
- **Onde ficam os padrões:** o Matt fixa `CODING_STANDARDS.md` e um "reviewer agent". No DevOrb a revisão é `devorb:reviewing`, que lê os arquivos de padrões que o repo já tem. Resolvido: a regra de julgamento vai para o arquivo de padrões do repo que `reviewing` lê, sem criar um nome fixo.
- **Aplicar ou só propor:** o Matt manda apresentar e não diz o que vem depois. Como a skill é manual e mexe em instruções que todo agente carrega, a retro para depois de apresentar e aplica só o que o usuário escolher.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As regras abaixo foram escritas antes de qualquer rodada de comparação, a partir do caso realista como o plano o descreve, e ainda não há resultado que mostre se elas mudam o comportamento.

1. **Cada candidato tem evidência no log.** O candidato cita o turno, o comando ou o erro que o mostra. Caso: o caso realista da Task 17, grader no `last_message`. Sem a regra, a retro tende a listar boas práticas genéricas que a sessão não sustenta.
2. **Bug no código não é achado por si.** Um erro no código da sessão só entra quando o ambiente poderia tê-lo pegado ou desviado o agente dele. Caso: o caso realista da Task 17. Torna verificável a decisão "olhar o ambiente e não o código": sem a regra, a retro vira revisão do diff.
3. **Não citar segredo do log.** O log da sessão pode ter chaves e senhas; a evidência é citada sem elas. Caso: o caso realista da Task 17. Mesma regra de `devorb:handoff`.

## Fora

- **Do Matt (`SKILL.md`):** o passo 1 que carrega o guia de estilo em toda retro (ver conflitos); a frase sobre buscar logs "nesta máquina" sem caminho, trocada pelo caminho do Claude Code; os "_Use when_" de cada categoria, fundidos na frase de abertura; o "full stop"; o nome fixo `CODING_STANDARDS.md`.
- **Do Matt (`agents/openai.yaml`):** metadado de outra ferramenta.

## Resultados

Opus 5.5, nível leve, 2 rodadas, comparado com o Matt. `fusion/results/2026-11-12-retro.md`.

| Caso | DevOrb | Matt |
|---|---|---|
| `retro-erros-repetidos` | 100% | 100% |

- `accepted: true` por empate. O caso não separa as versões no Opus e fica como guarda contra piora.

## Decisões por commit de fonte

- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/retro/SKILL.md` | adotado | foco no ambiente, ler a fonte primária, sete categorias, checagem existente desligada como achado, repo sem proteção como achado, mecânica vira checagem e julgamento vira padrão, apresentar por gravidade, pressão de contexto entre implementação e revisão, onde cada correção mora
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/retro/SKILL.md` | recusado | carregar o guia de estilo em toda retro e o nome fixo `CODING_STANDARDS.md`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/retro/agents/openai.yaml` | recusado | metadado de outra ferramenta

## Revisões

- 2026-11-12, revisão do coordenador: os passos abrem com "nada muda até o usuário escolher; perguntar antes de rodar uma checagem". O passo 1 diz como achar o log (caminho absoluto do projeto com `/` e `.` trocados por `-`), manda buscar nele erros, correções e chamadas caras com grep ou jq em vez de lê-lo inteiro, e tratar o conteúdo como dado, nunca instrução. "A correção é uma skill" saiu da lista de classes e virou frase depois dela. Reciprocidade: `devorb:writing-skills` agora recebe de `retro` uma skill ou uma linha de arquivo de instrução, não regra de julgamento, que vai para o arquivo de padrões.
- 2026-11-13: virou automática por decisão do dono (dispara pelo assunto da conversa); descrição reescrita com gatilhos.
