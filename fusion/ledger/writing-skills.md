# Ledger: `writing-skills`

Junta `writing-skills` do Superpowers (com as referências `bulletproofing.md`, `discovery.md`, `flowcharts.md`, `testing-skills-with-subagents.md`, `CLAUDE_MD_TESTING.md`, `persuasion-principles.md`, `graphviz-conventions.dot` e `anthropic-best-practices.md`, mais `render-graphs.js`) e `productivity/writing-for-agents` do Matt Pocock (com `SKILL-MECHANICS.md`), as duas MIT. Nível leve, teto de 5.000 tokens.

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-12 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. As duas fontes foram buscadas com `fetch --depth 1` no commit, com hooks desligados, e nada delas foi executado. O teste `tests/writing-skills/test-render-graphs.sh` do Superpowers foi lido só como dado.

O caso realista da Task 16 é "cria uma skill para X", com grader sobre o `trace` que exige um cenário de linha de base antes do `SKILL.md`. A skill foi escrita sem abrir `evals/writing-skills-*`, nenhum grader nem `evals-reserved/`.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers ("creating new skills, editing existing skills, or verifying skills work") e Matt ("modifying AGENTS.md or CLAUDE.md"), unidos em uma linha "Use when..." |
| Abertura: skill é TDD aplicado a documentos, o ciclo é o de `devorb:tdd` | Superpowers ("Overview" e "REQUIRED BACKGROUND"). `superpowers:test-driven-development` virou `devorb:tdd` |
| Abertura: vale também para `CLAUDE.md`, `AGENTS.md`, template de prompt e arquivo atrás de ponteiro | Matt (abertura do `SKILL.md`) |
| Lei de Ferro "NO SKILL WITHOUT A FAILING TEST FIRST", para skill nova e edição | Superpowers ("The Iron Law") |
| Apagar só o texto escrito nesta mudança antes da linha de base; skill existente fica, reverte-se só a edição sem teste | Superpowers ("Delete it. Start over"), limitado como na `tdd`. Ver conflitos |
| Instrução direta do usuário para pular o teste: seguir e relatar a skill como não testada | DevOrb: aplica a precedência do `devorb:using-devorb` e a regra própria 1 da `tdd` |
| Ponteiro para `references/devorb.md` quando `fusion/skills.json` existe | DevOrb, por decisão da Task 16 |
| Quando uma skill vale: técnica não óbvia, reutilizável; convenção do projeto vai para `CLAUDE.md`/`AGENTS.md`; regra mecânica vira checagem | Superpowers ("When to Create a Skill"), reescrito no positivo como rotas |
| Algo que o modelo já faz bem: nenhuma skill | Matt (no-ops), aplicado à decisão de criar |
| 1. RED: cenário realista com caminhos concretos, três ou mais pressões para disciplina, subagente novo sem a skill, registrar escolhas e racionalizações palavra por palavra | Superpowers ("RED: Write Failing Test" e `testing-skills-with-subagents.md`) |
| 1. Critério de conclusão "quando você consegue citar a falha" | Matt ("Steps and completion criteria") aplicado ao RED do Superpowers |
| 1. Controle sem falha: parar e não escrever skill | Superpowers ("Micro-Test Wording", item 2), levado ao RED inteiro |
| 2. Ajustar a forma à falha: tabela de quatro tipos | Superpowers ("Match the Form to the Failure") |
| 2. Escrever no positivo por padrão; proibição arrasta o comportamento para o contexto; só para falha de disciplina observada ou guarda-corpo, junto com o alvo positivo | Matt ("Negation") e Superpowers ("Why prohibitions backfire"), por decisão da Task 16 |
| 2. Sem cláusula de nuance; cláusula de isenção não delimita | Superpowers, reescrito no positivo ("exceção como condicional própria", "reestruturar") |
| 3. GREEN: o mínimo para as falhas registradas, mesmas cenas com a skill | Superpowers |
| 4. REFACTOR: contra-argumento para cada racionalização nova, depois podar e rodar de novo | Superpowers (REFACTOR) e Matt (poda). "Podar também é edição" é do DevOrb |
| Uma skill por vez, ciclo inteiro antes da próxima | Superpowers ("STOP: Before Moving to Next Skill"), reescrito no positivo |
| Onde a skill mora: `.claude/skills/<nome>/`, `~/.claude/skills/`, `skills/` do plugin | Superpowers ("Personal skills live..."), sem Codex, Gemini e `~/.agents/`, por decisão da Task 16 |
| Frontmatter: nome com letras, dígitos e hífens, pelo que se faz; automática com "Use when..." só gatilhos, terceira pessoa, sem resumo do fluxo; manual com `disable-model-invocation: true` e resumo de uma linha | Superpowers (`discovery.md`) e Matt (`SKILL-MECHANICS.md`, "Invocation"), por decisão da Task 16 |
| Ponteiros de contexto: a redação decide, alvo obrigatório atrás de ponteiro fraco é bug de variância, afiar antes de embutir | Matt ("Context pointers") |
| Citar outra skill pelo nome completo e dizer se é obrigatória; nunca `@`-link | Superpowers (`discovery.md`, "Cross-Referencing") |
| Hierarquia de informação: passos, referência no arquivo, referência revelada; embutir o que todo ramo precisa; co-localização; espalhamento | Matt ("Information hierarchy") |
| Referência a um nível de `SKILL.md`; sumário em referência com mais de 100 linhas | `anthropic-best-practices.md` (Superpowers), só ideias |
| Critérios de conclusão checáveis; limite vago convida conclusão prematura; afiar o limite primeiro | Matt ("Steps and completion criteria") |
| Palavras-guia | Matt ("Leading words") |
| Liberdade proporcional à fragilidade | `anthropic-best-practices.md`, só ideia ("degrees of freedom") |
| Um exemplo excelente e executável, sem narrativa de sessão; fluxograma só para decisão não óbvia ou laço; scripts pelo interpretador; barras normais | Superpowers ("Code Examples", "Anti-Patterns", `flowcharts.md`, "Invoke bundled scripts") e `anthropic-best-practices.md` (barras) |
| Poda: no-ops, fonte única, ambiente como fonte, relevância e sedimento, texto sempre carregado | Matt ("Pruning", "Context pointers") e Superpowers (`discovery.md`, "Move details to tool help", "Eliminate redundancy") |
| "Pulando o teste": tabela de racionalizações | Superpowers ("Common Rationalizations for Skipping Testing"), seis linhas, mais a de lote ("batching") |
| Checklist antes de dar por pronta | Superpowers ("Skill Creation Checklist"), enxugado para seis itens |
| `Connects to` | DevOrb: recebe de `devorb:evolving` e `devorb:retro`, usa `devorb:tdd`, entrega a `devorb:verifying`, por decisão da Task 16 |
| `references/SKILL-MECHANICS.md`: frontmatter, as duas cargas, invocação, referência compartilhada, divisão por sequência e por invocação, skill roteadora | Matt (`SKILL-MECHANICS.md` e "The two loads" e "When to split" do `SKILL.md`) |
| `references/SKILL-MECHANICS.md`: escrever gatilhos, exemplos bons e fracos, nomes | Superpowers (`discovery.md`, SDO 1 a 3) e Matt (um gatilho por ramo) |
| `references/SKILL-MECHANICS.md`: tamanho, 500 linhas, medir a cada edição | `anthropic-best-practices.md` (500 linhas) e Superpowers (`wc -w`) |
| `references/testing.md`: mapeamento, cenários, tipos de pressão, meta-teste, quando a skill aguenta | Superpowers (`testing-skills-with-subagents.md`) |
| `references/testing.md`: testes por tipo de skill | Superpowers ("Testing All Skill Types"), em tabela |
| `references/testing.md`: microteste de redação | Superpowers ("Micro-Test Wording Before Full Scenarios") |
| `references/testing.md`: testar um ponteiro em `CLAUDE.md`/`AGENTS.md` | Superpowers (`CLAUDE_MD_TESTING.md`), condensado em um parágrafo |
| `references/testing.md`: caso de harness com grader sobre o comportamento observado | DevOrb |
| `references/bulletproofing.md`: fechar brechas, espírito e letra, tabela, sinais de alerta, sintomas na descrição | Superpowers (`bulletproofing.md` e REFACTOR de `testing-skills-with-subagents.md`) |
| `references/bulletproofing.md`: princípios de persuasão por tipo de skill e teste ético | Superpowers (`persuasion-principles.md`), condensado em uma tabela |
| `references/devorb.md`: registro, limites de `tools/check-skills.mjs`, caso em `evals/`, `compare.mjs`, reservado, ledger, fontes | DevOrb (spec, receita R1 a R8, `tools/check-skills.mjs`, `tools/compare.mjs`), por decisão da Task 16 |

## Conflitos resolvidos

- **Positivo ou proibição:** o Matt manda escrever no positivo, porque a negação torna o comportamento proibido mais disponível. O Superpowers escreve muita coisa como proibição ("Don't create for", "Do NOT", "No exceptions"). Pela decisão da Task 16, o padrão é positivo, e a proibição fica para falha de disciplina observada, pela própria regra do Superpowers de ajustar a forma à falha. Ficaram como proibição só a Lei de Ferro e a tabela de racionalizações de pular o teste, porque pular a linha de base é a falha de disciplina que o Superpowers observou e que o caso realista da Task 16 cobra. "Não crie para", "não faça em lote" e as cláusulas de nuance viraram rotas e passos no positivo.
- **Descrição:** o Superpowers quer só gatilhos, começando com "Use when". O Matt abre a dele com o que a skill é e manda, em skill manual, um resumo voltado ao humano. A referência da Anthropic pede "o que faz e quando usar". Pela decisão da Task 16 e por `tools/check-skills.mjs`, skill automática usa "Use when..." só com gatilhos, e skill manual usa resumo de uma linha com `disable-model-invocation: true`.
- **"Apague" e skill existente:** o Superpowers manda apagar a skill escrita antes do teste e trata edição sem teste como a mesma violação. Aplicado a uma edição, isso apagaria uma skill que já existia. Como na `tdd`, apaga-se só o texto escrito nesta mudança antes da linha de base; a skill existente fica e só a edição sem teste é revertida.
- **Testar skill de referência:** o `SKILL.md` do Superpowers manda testar referência ("test retrieval"), e `testing-skills-with-subagents.md` lista "pure reference skills" entre as que não se testam. Vale o `SKILL.md` e a decisão da Task 16 (nenhuma skill sem teste antes): referência se testa com cenários de busca e uso. A lista "Don't test" saiu.
- **Linguagem de autoridade:** `persuasion-principles.md` recomenda "YOU MUST", "Never" e "No exceptions". O Matt alerta contra a negação. A linguagem de autoridade ficou só em `references/bulletproofing.md`, para falha de disciplina; o resto da skill é positivo.
- **O que fica no arquivo:** o Superpowers decide por contagem de linhas (embutir padrões com menos de 50 linhas, separar referência com mais de 100). O Matt decide por ramo (embutir o que todo ramo precisa, revelar o que só alguns alcançam). Vale o teste de ramo do Matt, com a regra da Anthropic de um nível de profundidade e o sumário acima de 100 linhas.
- **Tamanho:** o Superpowers dá metas em palavras (menos de 150, 200 ou 500). No DevOrb valem os tetos em tokens de `fusion/skills.json`, ditos em `references/devorb.md`. Fora do DevOrb, a skill diz "bem abaixo de 500 linhas" (Anthropic) e "o projeto pode ter tetos próprios".
- **Seções obrigatórias:** o checklist do Superpowers exige "Quick reference table" e "Common mistakes section" e um todo por item. Pela poda do Matt, seção que não muda comportamento é carga; o checklist ficou com seis itens e sem seções obrigatórias.

## Regras próprias

Nenhuma regra própria nova. A linha de precedência ("instrução direta para pular o teste: seguir e relatar como não testada") aplica a regra própria 1 da `tdd` e a precedência do `devorb:using-devorb`, sem caso próprio que a justifique aqui.

## Fora

- **Do Superpowers (`SKILL.md`):** Codex, Gemini, Copilot CLI e `~/.agents/skills/`, por decisão da Task 16; a tabela "TDD Mapping" no corpo, que foi para `references/testing.md`; as definições de tipo de skill (técnica, padrão, referência), que viraram a tabela de testes por tipo; "Directory Structure" e "File Organization" com os exemplos `pptx` e `defense-in-depth`, que viraram uma linha em "Where it lives"; a lista "Anti-Patterns" com ícones, que virou uma frase; "Discovery Workflow", que repete os gatilhos; a seção "Deployment" (commit, push no fork, PR de volta), que é trabalho de `devorb:finishing`; "Create a todo for EACH checklist item".
- **Do Superpowers (referências):** `render-graphs.js` e seu teste `tests/writing-skills/test-render-graphs.sh`, que exigem Graphviz e servem a fluxogramas `dot`, que o DevOrb não usa; `graphviz-conventions.dot` e `flowcharts.md`, de que só ficou a frase "fluxograma só para decisão não óbvia ou laço"; o modelo de `SKILL.md` com seções fixas de `discovery.md`; os exemplos de compressão de texto e "Real-World Impact"; o registro de iterações do exemplo de TDD em `testing-skills-with-subagents.md`; os quatro cenários e as quatro variantes literais de `CLAUDE_MD_TESTING.md`, condensados em um parágrafo; as citações completas de `persuasion-principles.md` (ficou o estudo de 2025 em uma linha) e os princípios reciprocidade e simpatia, que viraram "deixe de fora".
- **`anthropic-best-practices.md` inteiro:** 46 KB de documentação da Anthropic copiada no Superpowers, cujo texto não é do autor da licença MIT; passaria sozinho do dobro do teto. Ficaram só ideias (graus de liberdade, um nível de profundidade, sumário acima de 100 linhas, 500 linhas, barras normais) e o link para a visão geral oficial. Saíram testar com Haiku, Sonnet e Opus (o DevOrb fixa o modelo do dono em cada rodada), o formato JSON de avaliação, o fluxo "Agent A e Agent B", scripts utilitários, "solve, don't punt", dependências de pacote, referências de ferramenta MCP e os exemplos de PDF, BigQuery e DOCX.
- **Do Matt:** a `description` dele (começa pelo que a skill é); `agents/openai.yaml`, metadado de outra ferramenta; a parte de "Demand" e "legwork" dos critérios de conclusão, que ficou implícita no exemplo "each modified model accounted for".

## Resultados

A preencher depois das rodadas de comparação (R6).

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/SKILL.md` | adotado | Lei de Ferro, ciclo RED, GREEN e REFACTOR para documentos, ajustar a forma à falha, microteste de redação, quando criar skill, regras de exemplo e script, tabela de racionalizações e checklist
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/SKILL.md` | recusado | links e caminhos de Codex e Gemini, estrutura de diretórios com exemplos, anti-padrões com ícones, "Discovery Workflow", seção de deployment e seções obrigatórias do checklist
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/bulletproofing.md` | adotado | base de `references/bulletproofing.md`, com nome legado trocado
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/discovery.md` | adotado | fundido em `references/SKILL-MECHANICS.md` e no corpo: gatilhos sem fluxo, palavras-chave, nomes, citar skill pelo nome, sem `@`-link
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/discovery.md` | recusado | modelo de `SKILL.md` com seções fixas e metas em palavras, trocadas pelos tetos do projeto
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/testing-skills-with-subagents.md` | adotado | base de `references/testing.md`: mapeamento, cenários, pressões, meta-teste e quando a skill aguenta
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/testing-skills-with-subagents.md` | recusado | lista "Don't test" de skills de referência, registro de iterações, "Real-World Impact" e "Quick Reference" que repetia o corpo
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/CLAUDE_MD_TESTING.md` | adotado | condensado em um parágrafo de `references/testing.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/persuasion-principles.md` | adotado | condensado em uma tabela de `references/bulletproofing.md`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/flowcharts.md` | recusado | só a frase de quando usar fluxograma ficou no corpo
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/graphviz-conventions.dot` | recusado | o DevOrb não usa fluxogramas `dot`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/render-graphs.js` | recusado | script que exige Graphviz e serve a fluxogramas `dot`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/writing-skills/references/anthropic-best-practices.md` | recusado | 46 KB de documentação da Anthropic; ficaram só ideias e o link para a visão geral oficial
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/writing-for-agents/SKILL.md` | adotado | ponteiros de contexto, hierarquia de informação, critérios de conclusão, palavras-guia, escrita no positivo e poda
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/writing-for-agents/SKILL.md` | recusado | `description` que começa pelo que a skill é
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/writing-for-agents/SKILL-MECHANICS.md` | adotado | base de `references/SKILL-MECHANICS.md`, com a decisão da Task 16 sobre descrições
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/writing-for-agents/agents/openai.yaml` | recusado | metadado de outra ferramenta
