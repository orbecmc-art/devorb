# Ledger: `prototype`

Skill manual de uma fonte principal: `engineering/prototype` do Matt Pocock (MIT), com `LOGIC.md` e `UI.md`, adaptada ao fluxo do DevOrb e enxugada. Texto reaproveitado e adaptado, com a licença em `LICENSES/mattpocock-skills-MIT.txt`. O mapa de skills da spec liga `prototype` também a uma ideia de Emil `prototype`, mas o plano a coloca no Step 4 da Task D7 do setor de design ("cada variante declara um eixo"), não na Task 17. Ela não entrou aqui.

Pino lido: `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`, igual ao `lastAbsorbed` de `mattpocock-skills`, buscado raso em pasta temporária, com hooks desligados e sem rodar nada. Além da pasta da skill (`SKILL.md`, `LOGIC.md`, `UI.md`, `agents/openai.yaml`), foi lida a página `docs/engineering/prototype.md`, fora dos caminhos acompanhados, só para entender o uso.

A skill foi escrita sem abrir `evals/prototype-*` nem `evals-reserved/`. Nenhuma regra própria foi justificada por cenário ainda: o caso realista da Task 17 (invocado por `/devorb:prototype`, grader `llm` no `last_message`) é de outro agente.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` e `disable-model-invocation: true` | DevOrb. A do Matt é automática ("Use when the user wants to sanity-check..."); a nova é o resumo de uma linha das skills manuais |
| "Código descartável que responde uma pergunta; a pergunta decide a forma" | Matt |
| "Se o que construir já está decidido, a skill é a errada" | Matt (`docs/engineering/prototype.md`, a pergunta sobre agentes que mandam prototipar quando deviam implementar), com `devorb:planning` no lugar de `/implement` |
| Escolher o ramo: lógica ou interface, e o padrão quando o usuário não está | Matt |
| Escrever a pergunta no topo antes do código | Matt (`LOGIC.md` e `UI.md`, passo 1), subido para o corpo porque vale para os dois ramos |
| Regras 1 a 5: descartável e marcado, fácil de rodar, sem persistência, sem acabamento, mostrar o estado | Matt. "`prototype` no nome" vem de `UI.md`; "dê ao usuário o comando ou o caminho" e "nunca o banco real do projeto" são DevOrb |
| Chamar a skill é a permissão para `devorb:tdd` pular testes, só no protótipo | DevOrb: `devorb:tdd` lista protótipos descartáveis como exceção que exige permissão do usuário |
| Regra 6: o protótipo como fonte primária num branch `prototype/<name>` nunca mesclado | Matt (`SKILL.md`; o nome `prototype/<name>` vem da página de docs) |
| A resposta (pergunta, veredito e branch) vai para a spec em `docs/devorb/specs/` | Matt, com "implementation issue" trocado pelo arquivo de spec, por decisão da Task 17 |
| Sem spec ainda, a resposta vai ao usuário e `devorb:aligning` a põe na spec | DevOrb |
| "Depois da resposta": manter algo é pedido novo; o código real passa por `devorb:planning`, com testes | DevOrb, alinhado ao portão de `devorb:aligning` ("keeping it is a new request"). O Matt manda dobrar a decisão no código real na própria skill (ver conflitos) |
| `Connects to` | DevOrb, pela interface da Task 17 |
| `references/LOGIC.md` | Matt, quase inteiro. "Lifts into the real module" virou "ponto de partida para o módulo real", que entra por `devorb:planning`; "usar os nomes do `GLOSSARY.md`" é DevOrb |
| `references/UI.md` | Matt, quase inteiro. As duas subformas viraram parágrafos; o passo 6 junta as duas limpezas numa só e manda o vencedor por `devorb:planning`; "dê também o comando que sobe o app" é DevOrb |

## Conflitos resolvidos

- **Quem dobra a decisão no código real:** no Matt, a própria `prototype` leva o veredito ao código ("Fold any validated decision into the real code"), reescrevendo a variante vencedora. No DevOrb, código real passa pelo portão de `devorb:aligning` e por `devorb:planning`, com `devorb:tdd`; e `aligning` já diz que manter um protótipo é pedido novo. Resolvido: a skill para no veredito registrado na spec e no branch; o código real é construído pelo fluxo normal.
- **"Implementation issue":** o DevOrb não usa issues como unidade de trabalho; a spec de `devorb:aligning` é o registro durável. Resolvido pela decisão da Task 17: a resposta e o ponteiro para o branch vão para a spec. Quando o protótipo vem antes da spec, o ponteiro passa por `devorb:aligning`.
- **Testes:** o Matt diz "sem testes"; `devorb:tdd` exige teste antes de código, com protótipo descartável como exceção só com permissão do usuário. Resolvido: chamar `/devorb:prototype` é essa permissão, e só para o protótipo.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As regras abaixo foram escritas antes de qualquer rodada de comparação, a partir das decisões da Task 17, e ainda não há resultado que mostre se elas mudam o comportamento.

1. **O protótipo não vira código real pela própria skill.** O veredito vai para a spec, o protótipo para o branch `prototype/<name>`, e o código real é construído por `devorb:planning`, com testes. Motivo: sem a regra, "fold into the real code" faz o agente mesclar código escrito sem testes, pulando o portão de `devorb:aligning` e a exceção limitada de `devorb:tdd`.
2. **A pergunta escrita antes do código, e a forma de rodar entregue.** A pergunta fica no topo do protótipo, visível, e o usuário recebe o comando ou o caminho absoluto para abrir. Motivo: a Task 17 manda preservar "fácil de rodar"; o Matt pede isso em cada ramo, e a skill manual precisa garantir os dois mesmo quando só o `SKILL.md` é lido.

## Fora

- **Do Matt (`SKILL.md`):** a `description` automática; os links `[LOGIC.md](LOGIC.md)` e `[UI.md](UI.md)`, trocados por caminhos.
- **Do Matt (`LOGIC.md` e `UI.md`):** os links para `SKILL.md`; os subtítulos das duas subformas; "AFK".
- **Do Matt (`agents/openai.yaml`):** metadado de outra ferramenta.
- **Da página de docs:** `wayfinder`, tickets de decisão e `handoff` para rodar em outra sessão, que não estão no fluxo da skill; a história da versão em terminal.
- **Emil `prototype`:** fica para o Step 4 da Task D7 do plano de design.

## Resultados

A preencher depois de R6 (nível leve, comparado com o Matt).

## Decisões por commit de fonte

- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/prototype/SKILL.md` | adotado | escolher entre lógica e interface, as seis regras, o protótipo como fonte primária num branch fora do principal
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/prototype/SKILL.md` | recusado | `description` automática; dobrar a decisão no código real dentro da skill; "implementation issue" (trocado pela spec)
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/prototype/LOGIC.md` | adotado | base de `references/LOGIC.md`: pergunta no topo, módulo puro, HTML único para não desenvolvedor, passeios guiados, anti-padrões
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/prototype/UI.md` | adotado | base de `references/UI.md`: subformas A e B, variantes estruturalmente diferentes, `?variant=`, barra flutuante oculta em produção, anti-padrões
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/prototype/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:docs/engineering/prototype.md` | adotado | só ideias, fora dos caminhos acompanhados: o nome `prototype/<name>` do branch e a skill errada quando o que construir já está decidido
