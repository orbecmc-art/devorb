# Ledger: `handoff`

Skill de uma fonte principal: `productivity/handoff` do Matt Pocock (MIT), adaptada ao fluxo do DevOrb, com uma ideia de `context-save` do gstack. Texto do Matt reaproveitado e adaptado, com a licença em `LICENSES/mattpocock-skills-MIT.txt`. O gstack tem `textReuse: false`: dele entram só ideias, escritas com a fonte fechada, sem lista nem frase de abertura espelhadas.

Pinos lidos: `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` e `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`, iguais aos `lastAbsorbed` de `fusion/sources.json`, buscados rasos em pasta temporária, com hooks desligados e sem rodar nada. Do Matt, a pasta inteira da skill (`SKILL.md` e `agents/openai.yaml`). Do gstack, só o caminho acompanhado, `context-save/SKILL.md.tmpl`; o `SKILL.md` gerado e `sections/preamble.md` ficaram fechados, porque o preâmbulo comum está fora pela spec. Para saber quem chama a skill no DevOrb, foram lidos `skills/using-devorb/references/phase-boundaries.md`, `legacy-names.md` e o trecho de `skills/verifying/SKILL.md` sobre handoff anterior.

O caso que justifica as regras próprias é o caso realista da Task 17, como o plano o descreve: um caso por skill, invocado por `/devorb:handoff`, grader `llm` no `last_message`. A skill foi escrita sem abrir `evals/handoff-*` nem `evals-reserved/`.

## Origem por parte

| Parte | Origem |
|---|---|
| Frontmatter: `disable-model-invocation: true`, `argument-hint` | Matt. `argument-hint` mantido palavra por palavra |
| `description` | DevOrb: resumo de uma linha para quem digita o nome, pela regra das skills manuais (`writing-skills/references/SKILL-MECHANICS.md`). Nomeia a pasta temporária, que é o que distingue a skill de `/compact` |
| Abertura: compactar a sessão num arquivo que um agente novo lê e continua; argumentos dizem para que serve a próxima sessão | Matt. "Em qualquer harness ou diretório" vem de `phase-boundaries.md` (o que a skill compra é portabilidade) |
| "Escrever o handoff é o trabalho todo; nenhum outro arquivo muda" | Ideia do gstack (a skill só registra estado, não mexe em código), com palavras próprias |
| Pasta temporária do sistema (`$TMPDIR`, senão `/tmp`; `%TEMP%` no Windows), nunca no workspace | Matt, palavra por palavra no essencial |
| Nome `devorb-handoff-<data>-<tema>.md` e nunca sobrescrever um handoff anterior | Nome: DevOrb. Não sobrescrever: ideia do gstack (arquivos só acrescentados), com palavras próprias |
| "Nada é commitado" | DevOrb, consequência da pasta temporária |
| Apontar em vez de copiar: specs, planos, ADRs, issues, commits, diffs por caminho ou URL | Matt. Os caminhos viraram os do DevOrb (`docs/devorb/specs/`, `docs/devorb/plans/`, `docs/adr/`, `GLOSSARY.md`) e entrou o diff como comando (`git diff main...HEAD`) |
| Escrever só o que não vive em outro lugar: decisões com motivo, pendências, becos sem saída | DevOrb, lado positivo da regra do Matt |
| Ocultar segredos: chaves, tokens, senhas, strings de conexão com credencial, dados pessoais | Matt ("API keys, passwords, PII"), ampliado com tokens e strings de conexão |
| Escrever onde o segredo vive, nunca o valor | Regra própria 3 |
| Cada pendência diz como se sabe: `ran`, `read` ou `assumed` | Ideia do gstack, por decisão da Task 17. Rótulos e definições próprios |
| Relato de subagente, handoff anterior e mensagem de commit contam como `assumed` | Regra própria 1 |
| Quem retoma confere primeiro os `assumed`, e relê os `read` cujos arquivos mudaram depois do commit nomeado | `assumed` primeiro: ideia do gstack, por decisão da Task 17. Reler pelo commit: ideia do gstack (o arquivo grava o commit que descreve, para notar trabalho posterior), com palavras próprias |
| A regra de retomada vai dentro do arquivo | DevOrb: não há skill de retomada, e o próximo agente pode estar em outro harness, sem o DevOrb |
| Modelo do arquivo: cabeçalho com repo, branch, sha, data e não commitados; Next session; Read first; Decisions not written elsewhere; Open items; Dead ends; Suggested skills | DevOrb. Branch e arquivos modificados no cabeçalho são ideia do gstack; "Suggested skills" é do Matt; o resto é próprio. Ordem e nomes das seções diferem dos do gstack |
| Em Suggested skills, skill manual vem com aviso de que o usuário precisa iniciá-la | DevOrb, pela regra de `using-devorb` (skill manual só roda quando o usuário chama) |
| Fecho: caminho do arquivo e uma linha pronta para colar na nova sessão | Regra própria 2 |
| `Connects to` | DevOrb, pelas interfaces da Task 17, `phase-boundaries.md` e `verifying` |

## Conflitos resolvidos

- **Onde salvar:** o Matt usa a pasta temporária do sistema; o gstack grava numa pasta de estado por projeto, achada por um binário próprio, e lista os salvos depois. Venceu o Matt, por decisão da Task 17 e porque o DevOrb não traz binários nem estado fora do repositório.
- **Quem retoma:** no gstack, uma skill irmã lê o arquivo e ordena as pendências pelos marcadores. O DevOrb não tem essa skill e o arquivo pode ir para outro harness ou para um colega. Resolvido: a ordem de conferência está escrita no próprio arquivo, e os rótulos são três palavras simples, sem formato que só uma ferramenta leria.
- **Escrita em banco ou migração:** o gstack separa passos que gravam dados e marca se o estado do alvo foi conferido. Ficou fora (ver Fora). Uma pendência assim cai em `read` ou `assumed`, e o `assumed` já é conferido primeiro.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As regras abaixo foram escritas antes de qualquer rodada de comparação, a partir do caso realista como o plano o descreve, e ainda não há resultado que mostre se elas mudam o comportamento.

1. **Afirmação de terceiro é presumida.** O que veio de relato de subagente, handoff anterior ou mensagem de commit é `assumed`, por mais seguro que pareça. Caso: o caso realista da Task 17. Liga a skill a `devorb:verifying`, que já trata essas fontes como afirmação e não evidência; sem a regra, o handoff transforma um "todos os testes passam" alheio em `ran`.
2. **Fechar com a linha de partida.** A resposta final dá o caminho do arquivo e uma linha pronta para colar na nova sessão. Caso: o caso realista da Task 17, grader no `last_message`. O Matt não diz o que responder; sem a regra, o usuário precisa montar o pedido de retomada sozinho.
3. **Segredo vira endereço.** No lugar do valor, o arquivo diz onde o segredo vive (`STRIPE_KEY` em `.env`). Caso: o caso realista da Task 17. O Matt manda redigir, mas um `***` solto deixa o próximo agente sem saber de onde tirar a credencial.

## Fora

- **Do Matt (`agents/openai.yaml`):** metadado de outra ferramenta.
- **Do gstack (`context-save/SKILL.md.tmpl`):** o preâmbulo comum; os blocos de bash que coletam o estado do git e calculam a duração da sessão; o binário de caminhos e o carimbo de identidade do projeto; o saneamento do título em bash; o modo de listar salvos; a persona; o quadro de confirmação; o aviso para usar a skill de retomada; os marcadores em inglês ordenados por outra ferramenta e a varredura que os corrige; os marcadores próprios para passos que gravam dados; a exigência de comprovar com `grep` ou `wc` qualquer afirmação sobre conteúdo de arquivo nas decisões. Tudo isso depende da ferramenta do gstack ou pesaria além do que a ideia pedida pela Task 17 precisa.

## Resultados

A preencher.

## Decisões por commit de fonte

- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/handoff/SKILL.md` | adotado | abertura, pasta temporária fora do workspace, seção de skills sugeridas, apontar em vez de copiar, ocultar dados sensíveis, argumentos como foco da próxima sessão, `argument-hint`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/handoff/SKILL.md` | recusado | `description` ("Compact the current conversation..."), trocada por resumo que nomeia a pasta temporária
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/handoff/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:context-save/SKILL.md.tmpl` | adotado | só ideias, com palavras próprias: cada pendência diz como se sabe, e os presumidos são conferidos primeiro; só registrar estado; não sobrescrever arquivo anterior; gravar o commit descrito
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:context-save/SKILL.md.tmpl` | recusado | preâmbulo, scripts, binários, modo de listar, marcadores para passos que gravam dados, prova de afirmações sobre arquivos, persona
