# Frente B: código enxuto e sênior

Data: 2026-11-20. Branch `claude/code-floor`, a partir da `main` em `fb1a5f7` (versão 1.16.0, com a frente A mergeada). Origem: `docs/briefs/2026-11-20-evolucao-devorb.md`, frente B e "Regras para as três frentes". Desenho curto aprovado pelo dono na conversa de 2026-11-20; mudança pequena, sem revisor de spec.

## Intenção

Menos linhas, menos dependências e menos abstração para o mesmo comportamento. Hoje não existe um piso de código equivalente ao `skills/visual-direction/references/floor.md`, e o revisor de task não tem lista de sinais de código júnior.

## Objetivos

1. **Piso de código** em `skills/reviewing/references/code-floor.md`, no formato do `floor.md` de design. Os nove sinais que o revisor recusa, cada um com o conserto: `useEffect` para estado derivado; fetch dentro de loop; `catch` que engole erro; `any`; abstração com um caso de uso só; dependência nova para algo de dez linhas; comentário que narra o código; arquivo que faz tudo; código morto. Um sinal só fica com motivo escrito no relatório. Padrão documentado do repositório vence o piso.
2. **Quem lê o piso:** `skills/implementing/prompts/task-reviewer.md`, `skills/implementing/references/final-review.md` e o resumo de padrões da `reviewing` (`skills/reviewing/references/code-reviewer.md`). O controlador passa o caminho absoluto do piso no despacho, como já faz com o `floor.md` de design (`skills/implementing/SKILL.md`, com o caminho inline em `references/inline.md`).
3. **Portões no `verifying`:** quando o projeto já tem, rodar `tsc --noEmit` em modo estrito, lint, `knip` (código morto e dependência sem uso) e `size-limit` antes de dizer que está pronto. Nunca instalar nem configurar um portão sozinho.
4. **Proposta no `aligning`:** em projeto novo, propor ligar esses portões. **Condicional**: só entra se sobrarem pelo menos US$ 5 do teto depois que os dois primeiros casos estiverem verdes.

## Fora

- Frentes A (já na `main`) e C. Mexer em `tools/`, em `fusion/eval-config.json` (modelo `claude-opus-5-5`) ou em teto de `fusion/skills.json`.
- Skill nova e caso reservado: a B não cria skill.
- Instalar `knip`, `size-limit` ou qualquer ferramenta em projeto do usuário.
- Versão, `CHANGELOG.md`, merge e push: depois, com o dono.

## O que seria fracasso mesmo funcionando

- O piso virar gosto do revisor: recusar código certo porque "dava para ser mais curto". Ele lista sinais, não estilo.
- O revisor recusar o que o repositório do usuário documenta como padrão.
- O `verifying` instalar ou configurar portão que o projeto não tem.

## Caminhos considerados

| Caminho | Troca | Decisão |
|---|---|---|
| A. Um arquivo de piso na `reviewing`, lido por referência pelos revisores e pelo implementador | Um lugar só; o caminho absoluto viaja no despacho | **Escolhido** (o brief pede o arquivo e os leitores) |
| B. Copiar os nove sinais dentro de cada prompt | Sem dependência de caminho; quatro cópias que divergem | Recusado |
| C. Só o revisor lê, o implementador não | Fiel à letra do brief; o código vai e volta na revisão antes de ficar enxuto | Recusado: uma linha no `implementer.md` sai mais barato que uma rodada de correção. Escolha minha, fora do brief |

## Testes

Casos em `evals/`, prompt e graders em português, `scaffold.sh` sem rede. RED antes de qualquer `SKILL.md`; GREEN com `accepted: true` **e** o braço `devorb` em 100% (2 rodadas).

- **`implementing-enxuto`** (justifica o piso e a edição de `implementing/SKILL.md`). Plano aprovado de uma feature pequena, com duas tentações plantadas: uma biblioteca de datas para formatar uma data, e um caso que convida a criar uma fábrica genérica. Graders: `regex` no `package.json`, nenhuma dependência nova; `llm` no arquivo final, sem abstração sem segundo uso e sem código morto. **Linhas adicionadas contra o `none`:** não existe grader que compare braços nem que leia diff; as linhas dos dois braços são contadas a partir dos arquivos finais e registradas no ledger, sem valer aprovação.
- **`verifying-portoes-do-projeto`** (justifica a edição de `verifying/SKILL.md`). Projeto que já tem os portões como scripts do `package.json`; `npm test` passa, um portão falha. Pedido: conferir se já pode fechar. Graders: o agente rodou os portões do projeto antes da resposta final; a resposta relata o portão que falhou e não diz que está pronto.
- **Caso do `aligning`**, só se o item 4 entrar: pedido de projeto novo sem pessoa para responder; a spec escrita propõe os portões como decisão a confirmar.

Protocolo igual ao da frente A: `node tools/compare.mjs --skill <prefixo> --arms devorb,none --runs 2`, uma chamada por caso, uma de cada vez, `--concurrency 1` no caso de `implementing` (rodada longa: um timeout do caso vira erro de ferramenta e anula o `accepted`). Relatório do RED renomeado para `-red.md`. Um caso em que o `devorb` já passa no RED é fraco: reescrever uma vez; se passar de novo, o gancho não se justifica e não é construído.

## Orçamento

Teto pago: US$ 20. O custo real de cada chamada é mostrado ao dono logo depois dela, com o acumulado. Antes de cada chamada: se o acumulado mais a estimativa da próxima passar de US$ 20, parar e perguntar.

| Caso | Por chamada | RED mais GREEN |
|---|---|---|
| `implementing-enxuto` | US$ 4 a 8 (rodadas antigas de `implementing`: 3,63 a 7,02 no `devorb`, cerca de 0,60 no `none`) | US$ 8 a 16 |
| `verifying-portoes-do-projeto` | US$ 0,75 a 1,50 | US$ 1,50 a 3 |

O custo de um mesmo caso já variou três vezes entre rodadas; a faixa é estimativa, não promessa. Uma repetição do caso caro provavelmente não cabe. Ordem de prioridade: `implementing-enxuto`, depois `verifying`, depois `aligning`. As suítes antigas de `implementing` e `verifying` não rodam de novo.

## Ledger

Cada regra entra como **Regra própria** no ledger da skill tocada (`reviewing`, `implementing`, `verifying`, e `aligning` se entrar), com o caso que a justifica, RED e GREEN (sha e custo) e os arquivos de resultado. Nenhuma fonte externa.

## Hipóteses (decididas por mim, corrigíveis)

- **A sandbox do eval não tem rede.** A tentação da biblioteca de datas pode não morder (instalar falha); a fábrica genérica e o código morto carregam o caso. O RED mostra.
- **Portões do fixture são scripts locais** com os nomes dos portões (`typecheck`, `lint`, `knip`, `size`), sem `node_modules`: sem rede não dá para ter `tsc` nem `knip` de verdade. A regra da skill fala das ferramentas reais.
- **Severidade:** sinal do piso sem motivo é Important, o mesmo nível dos sinais de volume da frente A.
- **`any` e `useEffect`** só valem em projeto TypeScript e React; o piso diz isso em cada linha.
- O piso não repete os quatro sinais de volume da frente A; aponta para eles.

## Com o construtor

- O texto exato do piso, dos ganchos e dos graders. Texto das skills em inglês; ledger, prompts e graders em português. Mudança em skill segue `skills/writing-skills/references/devorb.md`.
- `aligning/SKILL.md` tem 13 bytes de folga: se o item 4 entrar, o texto novo é pago cortando o mesmo tanto, sem tirar regra.
- `npm test` verde em cada commit; cada `SKILL.md` dentro do teto.
- Nunca duas `compare.mjs` ao mesmo tempo no mesmo HEAD.

## O que mudou na execução (2026-11-20)

Os RED mostraram que dois dos três itens não tinham falha para corrigir. O que segue vale no lugar dos trechos acima que dizem o contrário.

- **`implementing-enxuto` é caso fraco.** Renomeado para `implementing-enxuto-recibo` (a `compare.mjs` escolhe por `<prefixo>-*`). No RED, `devorb` e `none` passaram 2 de 2 e escreveram o mesmo arquivo de 20 a 22 linhas, sem biblioteca e sem fábrica. Fica em `evals/` como o caso do brief, registrado como fraco; não justifica edição de `SKILL.md`.
- **A reescrita permitida virou um caso de revisão**, `reviewing-piso-de-codigo`: branch que funciona e carrega quatro sinais (um `catch {}` que engole erro, uma fábrica de um uso só, uma biblioteca de datas para um formato, uma função exportada que ninguém chama). RED: `devorb` 0%, `none` 0%. É esse caso que justifica o piso e a edição de `skills/reviewing/SKILL.md`.
- **`skills/implementing/SKILL.md` não é editado**: não há caso de `implementing` em RED. O caminho do piso chega ao revisor de task e ao implementador pelas notas de preenchimento dos próprios prompts.
- **Os portões no `verifying` não foram construídos (objetivo 3).** O caso `verifying-portoes-do-projeto` passou nos dois braços duas vezes: com os portões como scripts do `package.json` e, reescrito, só como configuração e ferramentas instaladas. O modelo já acha e roda os portões sem a regra. O caso fica em `evals/` na segunda forma.
- **A proposta no `aligning` não foi construída (objetivo 4)**: dependia do verde do objetivo 3.
- **Comparação de linhas do brief:** `src/recibo.js` com 21 e 20 linhas no `devorb`, 21 e 22 no `none`. Empate.
