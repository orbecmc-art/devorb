# Ledger: `aligning`

Junta `brainstorming` do Superpowers (com `builder-check-prompt.md`, `visual-companion.md` e `scripts/`) e `grilling`, `grill-me` e `grill-with-docs` do Matt Pocock, as duas MIT, e soma a ideia de `intent-driven-development` do ECC, com `textReuse: false`. O texto do ECC foi lido uma vez, e a ideia foi escrita depois, com a fonte fechada, em frases próprias: nenhuma lista, exemplo ou frase de abertura dele entrou.

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-11 a `HEAD` dele (`git ls-remote`) estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. O ECC foi lido no pino de `fusion/sources.json`, `d2ef2680594f9a17526a6e1a2e18b3d242c5d17b`, só em `skills/intent-driven-development/`.

A skill foi escrita sem abrir `evals/aligning-*`, nenhum grader nem `evals-reserved/`. O caso realista da Task 10 é "quero um app de agendamento".

`SKILL.md` tem 8.946 bytes (cerca de 2.237 tokens, teto 2.500), depois da revisão de 2026-11-11.

O Superpowers não tem cenários de pressão em `tests/brainstorming`, então não houve cenário de fonte para portar. O `brainstorming` da fonte tem 15.190 bytes.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers (feature, componente, mudança de comportamento, coisa nova), com "or when the user wants an idea or plan questioned hard" do `grilling` do Matt. "Before any plan or code" é do DevOrb, para casar com o `using-devorb` |
| Abertura: você constrói o que acredita que o usuário quer, a crença é mais fina do que parece, entender o porquê decide as cem decisões não ditas | Superpowers, enxugado |
| "O que você sabe?": tudo no pedido, faça e diga; algo não trivial falta, converse | Superpowers |
| Ordem antes de construir: abordagens em mensagem própria, documento, aprovação, `devorb:planning`; tudo na primeira mensagem quando nada está aberto | Superpowers, com `superpowers:writing-plans` trocado por `devorb:planning` |
| Fatos são seus, decisões são do usuário; nunca perguntar o que o projeto responde nem reabrir o decidido | Matt (`grilling`) e Superpowers ("Look Before You Ask") |
| Subagente novo levanta os fatos antes da primeira mensagem, e depois sem bloquear: só as perguntas que dependem do fato esperam | Matt (`grilling`), por decisão da Task 10. O momento (antes da primeira mensagem, em projeto existente ou com contexto apontado) é do Superpowers. "Sem subagente, olhe você mesmo" é do DevOrb, no mesmo espírito da checagem do construtor |
| O código não é intenção: retenção, SLA, preço e conformidade achados nele viram suposição a confirmar | ECC (`intent-driven-development`), só a ideia, com palavras próprias e a lista de quatro itens da Task 10. Ver conflitos |
| Primeira mensagem, nos dois casos, com o exemplo da padaria | Superpowers, enxugado. Preservada por decisão da Task 10 |
| Oferta leve de "só começar" quando o usuário não pediu a conversa, e a skill e a trava terminam se ele aceitar | Superpowers |
| A conversa: perguntar só o que muda o que se constrói; propor com motivo; passos de processo são decisão sua | Superpowers |
| Uma pergunta aberta por mensagem, sem exemplos até saber o porquê; depois, escolhas nomeadas com troca e recomendação | Superpowers ("Get them describing", "Ask one at a time"), por decisão da Task 10 |
| Rodada de sabatina só a pedido, em `references/grilling-round.md` | Matt (`grilling`), por decisão da Task 10. Ver conflitos |
| Palavras simples, vocabulário do usuário, sem jargão de processo, nunca citar a skill | Superpowers, por decisão da Task 10 |
| Perguntas específicas, socráticas, com o exemplo da votação | Superpowers |
| Território a cobrir, nunca lido como lista | Superpowers |
| Como se faz (plataforma, linguagem, bibliotecas): quem fala do como quer opções, quem fala de resultado entrega o como | Superpowers |
| Termo vago ou decisão difícil de reverter: `devorb:domain-modeling` | Matt (`grill-with-docs`, que chama `grilling` e `domain-modeling` juntos) |
| Spike descartável | Superpowers, enxugado ("Agentic work is waterfall" saiu) |
| Devolver em partes de 200 a 300 palavras, o que é dele e o que é proposta, esboço em texto do que se vê | Superpowers ("Play It Back") |
| Fim do entendimento: nada que mude a construção aberto ou suposto em silêncio, e o usuário confirmou a devolução | Matt (`grilling`: fronteira vazia, nada assumido em silêncio, confirmação do entendimento), por decisão da Task 10, posto antes das abordagens do Superpowers |
| 1. Abordagens em mensagem própria | Superpowers |
| 2. Tamanho do trabalho, com a tabela em `references/size-and-red-flags.md` | Superpowers, movido por decisão da Task 10 |
| 3. Documento de design: conteúdo, versão curta, caminho `docs/devorb/specs/YYYY-MM-DD-<topic>-design.md`, commitado | Superpowers, com `docs/superpowers/specs/` trocado. "Suposições a confirmar" entrou na lista pelo ECC. "Você é dona do arquivo e o mantém atual" é da Task 10 |
| 4. Revisor independente com `references/builder-check-prompt.md` e as três pilhas | Superpowers. Preservado por decisão da Task 10 |
| `<HARD-GATE>` | Superpowers, enxugado. Preservado por decisão da Task 10 |
| Companheiro visual: oferta no momento certo, mensagem só com a oferta, recusa vale, decisão por pergunta | Superpowers |
| `references/visual-companion.md` | Superpowers, adaptado: caminho `.devorb/brainstorm/`, só Claude Code, e o agente põe `.devorb/` no `.gitignore` e avisa, porque a pasta guarda a chave da sessão. Ver conflitos |
| `references/grilling-round.md` | Matt (`grilling`), adaptado: formato sem emoji, "frontier" virou "open set", fatos e decisões como no corpo, saída para as abordagens, o caso em que o usuário só queria questionar uma ideia, e `devorb:domain-modeling` durante toda a rodada quando ele pede sabatina com documentos (`grill-with-docs`) |
| `references/size-and-red-flags.md` | Superpowers ("Size the Work" e "Red Flags"), mais três sinais de alerta novos: perguntar ao usuário onde algo está no código (Matt), número achado no código tomado por regra (ECC, só a ideia) e várias perguntas de uma vez (Task 10) |
| `scripts/` (`start-server.sh`, `stop-server.sh`, `server.cjs`, `helper.js`, `frame-template.html`) | Superpowers, cópia levada como unidade por decisão da Task 10. `helper.js` e `frame-template.html` são idênticos byte a byte. Em `server.cjs`, uma linha marcada com comentário `DevOrb:` deixa a telemetria sempre desligada (`SUPERPOWERS_TELEMETRY_DISABLED = true || ...`). Em `start-server.sh` (4 linhas) e `stop-server.sh` (1 comentário), `.superpowers/` virou `.devorb/`, porque `tools/check-skills.mjs` recusa o nome antigo em qualquer arquivo da pasta. Nenhum script foi executado |

## Conflitos resolvidos

- **Uma pergunta ou uma rodada:** o Superpowers pergunta uma de cada vez, aberta, e o Matt faz rodadas com a fronteira inteira, numerada e com resposta recomendada. Pela decisão da Task 10, uma pergunta aberta por mensagem é o padrão, e a rodada fica em `references/grilling-round.md`, só quando o usuário pede.
- **Quem levanta os fatos:** o Superpowers manda o próprio agente ler o projeto antes da primeira mensagem, e o Matt manda um subagente com contexto novo, sem bloquear as perguntas que não dependem dele. Pela Task 10, fatos vêm de subagente. O momento do Superpowers ficou: em projeto existente, o subagente roda antes da primeira mensagem, porque ela precisa dizer como o sistema funciona hoje. Sem ferramenta de subagente, o agente olha sozinho.
- **Ler o código ou perguntar:** o Matt manda não perguntar o que dá para descobrir, e o ECC avisa que regra de negócio não se lê no código. Vale a decisão da spec: o código responde como o sistema age hoje, e retenção, SLA, preço e conformidade achados nele entram no documento como suposição a confirmar, nunca como fato descoberto.
- **Quando o entendimento termina:** o Superpowers passa às abordagens "quando entende o que eles querem", e o Matt exige fronteira vazia e confirmação do usuário. Ficou a condição do Matt, como porta para as abordagens.
- **Sabatina de uma ideia que não vira construção:** o `grilling` do Matt serve também para questionar um plano ou ideia, sem documento. Se o usuário só queria isso, a rodada para no entendimento comum e oferece o documento, sem escrevê-lo sem pedido. É ajuste de encaixe, não regra própria.
- **Tamanho e sinais de alerta:** saíram do corpo para `references/size-and-red-flags.md`, pela Task 10, para caber no teto. O corpo guarda uma linha (mudança pequena tem documento curto; projeto tem o completo e o revisor), porque a trava e o revisor dependem dela.
- **Telemetria no companheiro visual:** `server.cjs` monta na página uma imagem de `primeradiant.com` com a versão do plugin na URL, a menos que `SUPERPOWERS_DISABLE_TELEMETRY`, `DISABLE_TELEMETRY` ou `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` estejam ligadas. Na cópia do DevOrb, uma linha de `server.cjs`, marcada com comentário, deixa a telemetria sempre desligada, sem depender de variável de ambiente. É a única alteração de lógica no código de terceiro e fica apontada para o dono no pull request.
- **Outras ferramentas:** a referência do companheiro trazia instruções para Codex, Gemini CLI e Copilot CLI. A spec limita o DevOrb ao Claude Code, então ficou só a parte do Claude Code, com a nota do Windows.

## Regras próprias

Nenhuma. As mudanças além das fontes vêm de decisões da Task 10 ou da spec (ver conflitos).

## Fora

- **Do Superpowers (`SKILL.md`):** "parceiro humano", que virou "usuário"; "Specs are often incomplete, so confirm before you build on one", coberto pelo eco da primeira mensagem; o parágrafo "Do recon", coberto pelo subagente de fatos; "Agentic work is waterfall, but very, very fast"; a lista detalhada de quando mostrar em vez de contar, resumida na oferta do companheiro; "segurar a parte da devolução até a oferta do companheiro", que pesava no teto; "brainstorm them one at a time", que virou "align on them one at a time" na referência; o exemplo "talk, business, renovation" da `description`, porque o DevOrb é de desenvolvimento.
- **Do Superpowers (`visual-companion.md`):** as seções de Codex, Gemini CLI, Copilot CLI e "Other environments".
- **Dos scripts:** nada foi cortado. Ficam com a marca do Superpowers (título "Superpowers Brainstorming", texto "Superpowers v" e link para o repositório deles) e com `readSuperpowersVersion`, que lê o `package.json` três pastas acima. O da raiz do DevOrb não tem `version`, então a página mostra "vunknown".
- **Do Matt:** `grill-me` e `grill-with-docs` só chamam outras skills, então viraram o gatilho da rodada e a linha de `devorb:domain-modeling`; o formato com emoji da rodada; `agents/openai.yaml` dos três, metadado de outra ferramenta.
- **Do ECC:** os critérios de aceite numerados, os dois níveis de profundidade, o modelo de documento, a tabela de categorias de risco, a revisão de spec existente, os exemplos de passa e falha, a regra de não escrever no repositório nem bloquear a implementação (o DevOrb tem trava e documento próprios), e as regras sobre segredos e testes destrutivos, que pertencem a `planning`, `verifying` e `reviewing`. A ideia de critério observável pode servir a `devorb:planning` (Task 11), mas não entrou aqui.

## Resultados

Opus 5.5, 3 rodadas, `--ablation none`. `fusion/results/2026-11-11-aligning*.md`.

| Caso | DevOrb | Superpowers | Matt |
|---|---|---|---|
| `aligning-agendamento` | 0% (0,60) | 0% (0,60) | 0% (0,47) |
| Reservado `aligning-reembolso-pedido` | 67% (0,89) | 0% (0,52) | 0% (0,67) |

- `accepted: true` nos dois. O caso realista é lacuna: nenhum braço passa no juiz de "exatamente uma pergunta aberta", que conta como duas qualquer pergunta com mais de uma incógnita.
- Três rodadas de ajuste: pergunta com uma só incógnita, sem anúncio de skill nem nome de processo na primeira mensagem, sem menu numerado nem pedido extra, e regra de negócio do código como suposição. No reservado o DevOrb foi de 0% para 33% e depois 67%.
- O grader `one-open-question` deixou de contar a oferta curta de seguir direto, que a Task 10 manda preservar.

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/SKILL.md` | adotado | base da primeira mensagem, da conversa, da devolução em partes, das abordagens, do documento de design, do revisor, da trava e da oferta do companheiro visual
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/SKILL.md` | recusado | "Do recon", "Agentic work is waterfall", a lista longa de quando mostrar e o adiamento da devolução até a oferta, que pesariam no teto sem regra nova
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/builder-check-prompt.md` | adotado | cópia do prompt em `references/builder-check-prompt.md`, com uma linha de abertura própria
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/visual-companion.md` | adotado | `references/visual-companion.md`, com `.devorb/`, só Claude Code e `.devorb/` no `.gitignore` pelo agente
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/visual-companion.md` | recusado | instruções de Codex, Gemini CLI e Copilot CLI
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/scripts/server.cjs` | adotado | cópia com uma linha marcada que deixa a telemetria sempre desligada; código de terceiro, revisar antes do merge
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/scripts/helper.js` | adotado | cópia sem alteração; código de terceiro
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/scripts/frame-template.html` | adotado | cópia sem alteração
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/scripts/start-server.sh` | adotado | cópia com `.superpowers/` trocado por `.devorb/` em 4 linhas; código de terceiro
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/brainstorming/scripts/stop-server.sh` | adotado | cópia com `.superpowers/` trocado por `.devorb/` em 1 comentário; código de terceiro
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/grilling/SKILL.md` | adotado | fatos por subagente sem bloquear, decisões do usuário, condição de término, e a rodada numerada com recomendação em `references/grilling-round.md`
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/grilling/SKILL.md` | recusado | a rodada como padrão, trocada pela pergunta única da Task 10; o formato com emoji
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/grill-me/SKILL.md` | adotado | só o gatilho: pedir para ser sabatinado abre a rodada
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/grill-with-docs/SKILL.md` | adotado | só a ligação com `devorb:domain-modeling` durante a conversa
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/grilling/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/productivity/grill-me/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/grill-with-docs/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/intent-driven-development/SKILL.md` | adotado | só a ideia, com texto próprio: o código mostra como o sistema age hoje, e retenção, SLA, preço e conformidade achados nele são suposição a confirmar
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/intent-driven-development/SKILL.md` | recusado | critérios de aceite, níveis de profundidade, modelo de documento, tabela de riscos, exemplos de passa e falha, e as regras de não escrever no repositório e não bloquear a implementação

## Revisões

- 2026-11-11: `scripts/server.cjs` do Superpowers carregava um logo de `primeradiant.com` com a versão do plugin na URL a cada página, a menos que uma variável de ambiente desligasse. Na cópia do DevOrb a telemetria fica sempre desligada (uma linha, marcada no código). Fica registrado para o dono no pull request. A página ainda mostra a marca "Superpowers" com "vunknown", porque o `package.json` da raiz não tem `version`: inofensivo.
- 2026-11-11, revisão do coordenador do commit `6bf3b29`. `SKILL.md` foi de 8.794 para 8.946 bytes (cerca de 2.199 para 2.237 tokens).
  - **Descrição do código de terceiro:** o ledger e `references/visual-companion.md` diziam que `server.cjs` era cópia sem alteração e que a telemetria dependia de `DISABLE_TELEMETRY=1`. Agora dizem que uma linha marcada a desliga sempre. `DISABLE_TELEMETRY=1` saiu da referência. A página mostra "vunknown", não a versão do DevOrb.
  - **Pedido completo e a trava:** "Before building, in order" virou "Otherwise, before building, in order", para o pedido que já diz tudo ("make the icon cornflower blue") não contradizer a trava.
  - **Aprovação na primeira mensagem:** depois de aprovado o design curto, escrever o documento curto como aprovado e chamar `devorb:planning`, como no Superpowers.
  - **Quem já disse "só faça":** a oferta de pular a conversa vale também para quem já pediu para construir direto.
  - **Fatos depois da primeira mensagem:** a frase virou "Dispatch one for later facts too; don't wait on it, only questions that depend on the fact do".
  - **Revisor:** "one round only" na volta com as perguntas do usuário, como no Superpowers.
  - **Sem jargão:** a oferta de spike usa "a quick throwaway version", e o território a cobrir não diz "anti-goals" ao usuário.
  - **Sabatina com documentos:** `references/grilling-round.md` mantém `devorb:domain-modeling` durante toda a rodada quando o usuário pede.
  - **`.gitignore`:** o agente põe `.devorb/` no `.gitignore` e avisa, porque a pasta guarda a chave da sessão. Antes, só lembrava o usuário.
- 2026-11-12, depois da primeira comparação (lacuna em todos os braços): as respostas do DevOrb tinham uma pergunta principal, mas composta ("quem vai usar e o que precisa") ou com um segundo pedido, e abriam com "Usando o fluxo de alinhamento". A primeira pergunta passou a ter uma só incógnita, e a primeira mensagem não tem linha de anúncio nem nome de skill. O grader `one-open-question` deixou de contar a oferta curta de seguir direto, que a Task 10 manda preservar.
- 2026-11-12, segunda comparação: a pergunta ainda juntava incógnitas ("quem, o quê e com quem"), vinha com opções numeradas ou com um "corrija o que entendi errado" a mais, e um prazo do código apareceu como fato. A primeira mensagem passou a pedir uma só coisa ao usuário, com exemplos do que evitar, e regra de negócio achada no código aparece como suposição.
