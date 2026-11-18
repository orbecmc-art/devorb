# Qualidade de design, Fase 1: modo cópia, espelho e contrato — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** O DevOrb passa a copiar fielmente uma referência quando pedido, a fotografar e criticar o que constrói antes de entregar, e a levar a direção visual até o subagente que escreve o código.

**Architecture:** Três scripts Node próprios (sem dependência no repositório) medem páginas renderizadas:
- um coletor que roda dentro da página;
- uma biblioteca pura de regras e comparação;
- dois CLIs que usam o Playwright do projeto do usuário.

As skills `visual-direction` (modo cópia e pacote de referência), `implementing` (espelho do construtor) e `ui-review` (crítico de olhos novos) usam esses scripts. As skills de ligação (`aligning`, `planning`, `browser-testing`, `verifying`) passam os caminhos adiante.

**Tech Stack:** Node 22 (ESM, `node --test`), Playwright importado do projeto do usuário e nunca do DevOrb, Markdown das skills, `tools/compare.mjs` e `tools/eval-outside.mjs` para evals.

**Spec:** `docs/specs/2026-11-17-design-quality-design.md`. Seções Pilar 1, 2 e 3, Calls de Claude 1 a 13, decisão do dono 11.

## Global Constraints

- `SKILL.md` com menos de 20.000 bytes, e `bytes ÷ 4` arredondado para cima até o `ceilingTokens` de `fusion/skills.json`. `npm test` aplica as duas regras.
- Texto de skill em inglês. Ledger, changelog, prompts de eval e specs em português.
- Os scripts são escritos pelo DevOrb, só com ideias das fontes. `textReuse` continua `false` para taste-skill, Impeccable, Hallmark e gstack; `tests/layout.test.mjs` exige isso. O crédito vai no ledger da skill.
- Larguras do espelho: 1440, 1024, 768 e 390. Na cópia, 1440 e 390.
- Corte do crítico: nota abaixo de 8 em qualquer dimensão vira P1. No máximo 3 rodadas; se ainda falhar, entrega com os achados explícitos.
- Saída do laço na cópia: a nota de fidelidade do crítico (8 ou mais). O script só reprova sozinho em desvio grosseiro: número de seções diferente, ou razão título/texto mais de 20% abaixo da referência.
- Régua mínima:
  - razão título/texto de pelo menos 3.0 em Persuade e 1.6 em Operate;
  - corpo de 16px ou mais em Persuade;
  - medida de 60 a 75 caracteres;
  - espaçamento em base 4/8.
- Pacote de referência em `design/referencias/<slug>/` no projeto do usuário. No máximo 3 referências. Perguntar antes de commitar conteúdo de terceiros.
- Cópia: estrutura, escala, grid, espaçamento, composição e movimento ficam iguais. Cor, fonte e logo seguem o projeto, salvo pedido. Texto, fotos e logo de terceiros são sempre trocados.
- O DevOrb nunca digita senha. Página atrás de login é capturada no navegador já logado do usuário.
- Prints de sites de terceiros nunca entram no repositório do DevOrb.
- Ciclo de teste completo (RED, GREEN, caso reservado) em `visual-direction`, `implementing` e `ui-review`. Casos leves e baratos nas demais skills tocadas.
- Casos de eval que abrem navegador rodam com `--outside-sandbox`, e `tools/eval-outside.mjs` aceita só graders `regex` e `llm` (`tools/eval-outside.mjs:162`). Alvos: `target: trace`, `target: last_message`, `target: files` ou `target: { source: file, path: … }`. Modelos: `evals/ui-review-equipes/graders/` e `evals/aligning-agendamento/graders/`.
- O dono define o orçamento de cada rodada paga: estimativa total de US$ 60 a 80. Antes de cada rodada, pedir confirmação com a estimativa.

## Review Focus

1. **App com barra lateral.** A referência e a Ligare vivem dentro de um app com barra lateral e cabeçalho fixo. As seções têm que ser as do conteúdo, nunca a barra lateral. Teste: `findSectionsRoot` com fixture de app shell (Task 1).
2. **Revelação por scroll.** Seções que só aparecem ao rolar ficariam com `opacity: 0` no print. Teste: `collectMetrics` marca `hidden: true` em seção com opacidade abaixo de 0.1, e a captura rola a página antes de medir (Task 2 e Task 3).
3. **Playwright ausente no projeto.** O CLI sai com código 3 e imprime o comando de instalação, sem stack trace. Teste: `resolvePlaywright` com import falho (Task 2).
4. **Página muito longa.** O print de página inteira é cortado em 16.000px, e os prints por seção cobrem o resto. Teste: `planShots` com altura de 40.000px (Task 2).
5. **Página atrás de login.** O CLI não consegue entrar. O texto da skill manda usar o navegador logado do usuário, com o coletor colado pela ferramenta de JavaScript. O eval do modo cópia confere esse caminho no rastro (Task 4, grader `login-fallback`).

---

### Task 1: Regras puras de medição

**Files:**
- Create: `skills/ui-review/scripts/rules.mjs`
- Test: `tests/design-rules.test.mjs`
- Create: `tests/fixtures/design/metrics-ligare.json`, `tests/fixtures/design/metrics-pilot.json`, `tests/fixtures/design/dom-app-shell.json`

**Seam:** as funções exportadas de `rules.mjs`.

**Interfaces:**
- Produces:
  - `type Metrics = { url: string, width: number, root: string, sections: Section[], text: TextSample[], spacing: number[], buttons: string[], images: string[], textColors: string[] }`
  - `type Section = { index: number, top: number, height: number, width: number, bg: string, hidden: boolean, headings: string[] }`
  - `type TextSample = { role: 'h1'|'h2'|'h3'|'body'|'button'|'eyebrow', fontSize: number, lineHeight: number, fontWeight: number, letterSpacing: number, fontFamily: string, lineChars: number }`
  - `type Check = { id: string, status: 'PASS'|'WARN'|'FAIL', detail: string }`
  - `MODE_MIN_RATIO = { persuade: 3.0, operate: 1.6, read: 2.0, experience: 2.0 }`. Read e Experience ficam em 2.0 por call do construtor, registrada no ledger.
  - `headingRatio(m: Metrics): number`: maior `fontSize` de `h1` (ou de `h2` sem `h1`) dividido pela mediana do `fontSize` de `body`.
  - `checkFloor(m: Metrics, mode: keyof MODE_MIN_RATIO): Check[]`, com ids fixos:
    - `heading-ratio`: FAIL abaixo do mínimo do modo.
    - `body-size`: FAIL com mediana de `body` abaixo de 16 em persuade ou read.
    - `measure`: WARN com algum `body` de `lineChars` acima de 75.
    - `spacing-grid`: WARN quando mais de 20% de `spacing` não é múltiplo de 4.
    - `font-sizes`: WARN com mais de 8 tamanhos distintos.
    - `button-styles`: WARN com mais de 3 assinaturas distintas em `buttons`.
    - `text-colors`: WARN com mais de 8 cores de texto distintas.
    - `photo-repeat`: WARN com a mesma `src` em mais de uma imagem.
  - `compareStructure(build: Metrics, ref: Metrics): { grossFail: boolean, reasons: string[], deviations: string[] }`:
    - `grossFail` quando o número de seções visíveis difere, ou quando `headingRatio(build) < 0.8 * headingRatio(ref)`.
    - `deviations` lista, por índice de seção, altura relativa (fração da página) com diferença acima de 25%, e o vão vertical entre seções com diferença acima de 25%.
  - `findSectionsRoot(tree: DomNode): DomNode`, com `type DomNode = { tag: string, role?: string, rect: {x,y,w,h}, children: DomNode[] }`:
    1. começa em `main` ou em `[role=main]`; sem eles, no `body`;
    2. desce enquanto o nó tem um só filho visível;
    3. descarta filhos com largura abaixo de 50% da largura do nó;
    4. as seções são os filhos restantes com altura de 120px ou mais.

- [ ] **Step 1: Escrever os testes que falham**

```js
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { headingRatio, checkFloor, compareStructure, findSectionsRoot } from '../skills/ui-review/scripts/rules.mjs';
const load = (f) => JSON.parse(readFileSync(new URL(`./fixtures/design/${f}`, import.meta.url)));

test('Pilot hero passes the persuade ratio, Ligare fails it', () => {
  assert.ok(Math.abs(headingRatio(load('metrics-pilot.json')) - 3.2) < 0.05);
  const ligare = checkFloor(load('metrics-ligare.json'), 'persuade');
  assert.equal(ligare.find((c) => c.id === 'heading-ratio').status, 'FAIL');
  assert.equal(ligare.find((c) => c.id === 'body-size').status, 'FAIL');
});
test('operate accepts a 2.0 ratio', () => { /* metrics-ligare in operate: heading-ratio PASS */ });
test('every check id is present once', () => { /* the 8 ids, in order */ });
test('ligare vs pilot is a gross fail with both reasons', () => {
  const r = compareStructure(load('metrics-ligare.json'), load('metrics-pilot.json'));
  assert.equal(r.grossFail, true);
  assert.equal(r.reasons.length, 2);
});
test('identical metrics give no deviation', () => { /* compareStructure(p, p) → grossFail false, deviations [] */ });
test('sections come from content, not the sidebar', () => {
  const root = findSectionsRoot(load('dom-app-shell.json'));
  assert.equal(root.tag, 'main');
});
```

Os fixtures vêm das medições de 2026-11-17 que estão na spec:
- Pilot: h1 de 56px e corpo de 17.5px.
- Ligare: maior título de 26px e corpo de 13px.

Pilot tem 6 seções e Ligare tem 3. `dom-app-shell.json` tem `aside` de 240px de largura, `header` e `main` com 3 seções.

- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-rules.test.mjs`. Expected: FAIL com `Cannot find module`.
- [ ] **Step 3: Implementar `rules.mjs`** com as assinaturas acima. Funções puras, sem import de fora da biblioteca padrão.
- [ ] **Step 4: Rodar e ver passar.** Run: `node --test tests/design-rules.test.mjs` e `npm test`. Expected: PASS em todos.
- [ ] **Step 5: Commit.** `git commit -m "feat: pure design rules for the mirror and copy mode"`

### Task 2: Coletor na página e CLI `shoot`

**Files:**
- Create: `skills/ui-review/scripts/collect-in-page.js` (script de navegador sem import; define `window.__devorbMetrics = () => Metrics`)
- Create: `skills/ui-review/scripts/shoot.mjs`
- Test: `tests/design-shoot.test.mjs`
- Create: `tests/fixtures/design/hero.html` (página estática com hero, seção escura e tabela)

**Seam:** as funções exportadas `parseArgs`, `planShots` e `resolvePlaywright` de `shoot.mjs`. O caminho com navegador é conferido no Step 6.

**Interfaces:**
- Consumes: `Metrics`, `findSectionsRoot` e `checkFloor` da Task 1. `collect-in-page.js` embute uma cópia de `findSectionsRoot`, porque roda sem import; um teste compara as duas.
- Produces:
  - `parseArgs(argv: string[]): { url: string, out: string, widths: number[], mode: string, scroll: boolean }`. Padrões: widths `[1440,1024,768,390]`, mode `persuade`, scroll `true`.
  - `planShots(pageHeight: number, sections: Section[]): { fullClip: number, perSection: number[] }`, com `fullClip = min(pageHeight, 16000)`.
  - `resolvePlaywright(): Promise<object | null>`.
  - CLI `node shoot.mjs <url> <outDir> [--widths a,b] [--mode m] [--no-scroll]`. Escreve, por largura:
    - `<outDir>/<w>/full.png`;
    - `<outDir>/<w>/section-<i>.png`;
    - `<outDir>/<w>/metrics.json`;
    - `<outDir>/<w>/checks.json`.

    Exit 0 sem FAIL, 2 com algum FAIL e 3 sem Playwright, imprimindo `NEED: npm i -D playwright && npx playwright install chromium` (ou `--prefix <pasta temporária>` quando o usuário não quer a dependência no projeto).
  - Com scroll, desce a página em passos de 80% da altura da janela, espera 300ms por passo, volta ao topo e só então mede. Seção com `opacity` computada abaixo de 0.1 sai com `hidden: true`.

- [ ] **Step 1: Testes que falham:**
  - `parseArgs` aplica os padrões e lê `--widths 1440,390`;
  - `planShots(40000, …)` dá `fullClip` 16000;
  - `resolvePlaywright` devolve `null` quando o import falha (injetar o importador como parâmetro opcional `importer`);
  - a cópia de `findSectionsRoot` em `collect-in-page.js` dá o mesmo resultado da Task 1 no fixture `dom-app-shell.json` (carregar o arquivo com `vm.runInNewContext` e um `window` falso).
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-shoot.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** `collect-in-page.js` (lê `getComputedStyle` e `getBoundingClientRect`, monta `Metrics`) e `shoot.mjs` (Playwright `chromium.launch({headless:true})`, um contexto por largura, `page.addScriptTag({path})`, `page.evaluate(() => window.__devorbMetrics())`).
- [ ] **Step 4: Rodar e ver passar.** Run: `node --test tests/design-shoot.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 5: Commit.** `git commit -m "feat: in-page collector and shoot CLI for the visual mirror"`
- [ ] **Step 6: Conferir com navegador**, numa pasta temporária com Playwright instalado: `node skills/ui-review/scripts/shoot.mjs file://$PWD/tests/fixtures/design/hero.html /tmp/devorb-shoot`. Expected: 4 pastas de largura, cada uma com `full.png`, pelo menos 3 `section-*.png`, `metrics.json` com 3 seções e `checks.json` com os 8 ids. Abrir um `full.png` e conferir que não está em branco. Escrever o resultado no relatório da task.

### Task 3: CLI `capture`, o pacote de referência

**Files:**
- Create: `skills/visual-direction/scripts/capture.mjs`
- Test: `tests/design-capture.test.mjs`

**Seam:** as funções exportadas `slugFromUrl`, `buildTokens` e `sectionsMarkdown` de `capture.mjs`.

**Interfaces:**
- Consumes: `shoot.mjs` (Task 2), chamado como módulo: exportar de `shoot.mjs` também `shootPage(url, outDir, opts): Promise<Record<number, Metrics>>`, e o CLI passa a usar essa função.
- Produces:
  - CLI `node capture.mjs <url> <projectRoot> [--slug s]`. Grava em `<projectRoot>/design/referencias/<slug>/`:
    - `url.txt`;
    - `notas.md` vazio, com os títulos `## Levar` e `## Não levar`;
    - as pastas `1440/` e `390/` do `shoot`;
    - `tokens.json`;
    - `secoes.md`.
  - Recusa criar um quarto pacote: exit 4 com `MAX 3 referências: <lista>`.
  - `slugFromUrl(url: string): string`: host sem `www.` mais o último segmento do caminho, em kebab-case. Exemplo: `https://base.agenciadevalor.com/pilot` dá `base-agenciadevalor-pilot`.
  - `buildTokens(m: Metrics): { type: {role, fontSize, lineHeight, fontWeight, letterSpacing, fontFamily}[], textColors: string[], sectionBgs: string[], spacing: number[], headingRatio: number }`.
  - `sectionsMarkdown(m1440: Metrics, m390: Metrics): string`, com uma linha por seção: `N. <altura relativa>% · fundo <bg> · títulos: "<h>" · 390: <altura relativa>%`. Termina com a linha `Movimento observado: <preencher olhando os prints e a página>`.

- [ ] **Step 1: Testes que falham:**
  - `slugFromUrl` com o exemplo acima;
  - `buildTokens(metrics-pilot)` dá `headingRatio` de cerca de 3.2;
  - `sectionsMarkdown` com 6 seções dá 6 linhas numeradas e a linha de movimento;
  - um quarto pacote numa pasta temporária com 3 já existentes sai com exit 4 (rodar o CLI por `spawnSync` com `--dry-run`, que pula o navegador).
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-capture.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** `capture.mjs` e a exportação `shootPage` em `shoot.mjs`.
- [ ] **Step 4: Rodar e ver passar.** Run: `node --test tests/design-capture.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 5: Conferir com navegador:** `node skills/visual-direction/scripts/capture.mjs file://$PWD/tests/fixtures/design/hero.html /tmp/devorb-cap`. Expected: pacote completo e `secoes.md` com 3 linhas.
- [ ] **Step 6: Commit.** `git commit -m "feat: capture CLI writes the reference pack"`

### Task 4: `visual-direction` com modo cópia (ciclo completo)

**Files:**
- Modify: `skills/visual-direction/SKILL.md` (primeiro abrir espaço, depois incluir o modo)
- Create: `skills/visual-direction/references/sources.md` (recebe o detalhe da §4: tipos de `reading` e escolha de biblioteca)
- Create: `skills/visual-direction/references/contract.md` (recebe a lista de campos da §6)
- Create: `skills/visual-direction/references/replicate.md`
- Modify: `skills/visual-direction/references/ui-sources.json` (regra 3)
- Modify: `skills/design-system/references/design-md.md:65`
- Modify: `tests/ui-sources.test.mjs` (só se alguma asserção citar a frase antiga)
- Modify: `fusion/ledger/visual-direction.md`
- Create: `evals/visual-direction-copia-referencia/` (`case.yaml`, `scaffold.sh`, `graders/`)
- Create: `evals-reserved/visual-direction-<slug>/`, escrito por um subagente novo que nunca viu o rascunho

**Seam:** `node tools/compare.mjs --skill visual-direction …` (eval) e `npm test` (limites).

**Interfaces:**
- Consumes: CLI `capture.mjs` (Task 3); CLI `shoot.mjs` e `collect-in-page.js` (Task 2).
- Produces, para as Tasks 5 a 8, o que o contrato `## Direção visual` passa a carregar, com estes rótulos exatos:
  - `Mode`, `Invention level`;
  - `Motion level: Suave | Equilibrado | Impacto`;
  - `Reference pack: design/referencias/<slug>/ (até 3)`;
  - `Same as reference:` e `Changed:`;
  - `Sections:`, um item por seção com padrão, fonte do texto e movimento;
  - `Do not:`.

- [ ] **Step 1: Abrir espaço.** Mover para `references/sources.md` os bullets da §4 sobre `reading` e escolha de biblioteca, e para `references/contract.md` a lista de campos da §6. A SKILL.md fica com uma linha apontando para cada arquivo. Sem mudança de comportamento. Run: `npm test` e `wc -c skills/visual-direction/SKILL.md`. Expected: PASS e no máximo 7.200 bytes.
- [ ] **Step 2: Escrever o caso RED** `evals/visual-direction-copia-referencia`.
  - **Scaffold.** Uma pasta com `DESIGN.md` da marca fictícia "Prumo":
    - cores azul-petróleo e areia;
    - fonte Geist.

    Um `ref/index.html` escrito pelo DevOrb, MIT, com as qualidades do caso Pilot e em outra marca e outro texto:
    - hero com h1 de 56px bicolor e mockup flutuante;
    - faixa escura com número grande;
    - linha do tempo com 4 pessoas;
    - tabela antes e depois;
    - 6 cards de horário;
    - CTA final.

    Uma frase-marca no texto da referência ("Feche a agenda antes do café") permite checar que o texto não foi copiado.
  - **Prompt.** "copia essa página `ref/index.html` para a nossa página Em breve do módulo Agenda em `index.html` e `styles.css`, com as cores e a fonte do nosso DESIGN.md. Hoje não consigo responder perguntas."
  - **Graders:**
    - `pack` (regex no rastro): `capture.mjs` rodou, ou existe `design/referencias/.+/secoes.md`;
    - `no-copied-text` (regex `not_contains` em `index.html`): a frase-marca;
    - `brand-kept` (regex em `styles.css`): as cores do `DESIGN.md`;
    - `structure` (llm, arquivos `index.html` e `styles.css`, peso 3): mesma sequência de 6 seções, h1 pelo menos 3 vezes maior que o corpo e hero com mockup;
    - `login-fallback` (regex no rastro): a skill lida contém `javascript` e `collect-in-page`. Pinta o item 5 do Review Focus.
  - `runs: 3`, `max_turns: 80`, `allowed_tools` com `Bash`.
- [ ] **Step 3: RED.** Run: `node tools/compare.mjs --skill visual-direction --baseline-only --outside-sandbox`, depois de confirmar o custo com o dono. Expected: pelo menos um braço falha em `pack` ou `structure`. Se todos passarem, reescrever o caso.
- [ ] **Step 4: Escrever o modo cópia.**
  - Na §1, um quarto nível, **Replicate**: entra quando o usuário pede para copiar, clonar, "deixar igual" ou "usar como base". Aponta para `references/replicate.md`.
  - `replicate.md` traz os passos do Pilar 1 da spec:
    1. capturar com `capture.mjs`; atrás de login, usar o navegador logado do usuário mais `collect-in-page.js` pela ferramenta de JavaScript e prints pelo navegador;
    2. preencher `secoes.md` e `notas.md`; perguntar antes de commitar o pacote, e sugerir `design/referencias/` no `.gitignore` quando o conteúdo é de terceiros;
    3. decidir o que fica igual e o que muda: padrão das Global Constraints, perguntando uma vez quando houver pessoa na conversa;
    4. construir seção por seção, com espelho contra `section-<i>.png`;
    5. rodar `compareStructure` e encaminhar ao crítico.
  - Inclui a linha sobre `dembrandt`: só depois de conferir `npx -y dembrandt --help` e gravar o comando exato no arquivo; senão, omitir.
  - Na §4, trocar "Never copy a site, its text or its images" por: copiar a forma quando pedido; nunca publicar texto, fotos ou logo de terceiros como do cliente.
  - Mesma troca na regra 3 de `ui-sources.json` e em `design-md.md:65` (copiar estrutura e escala quando pedido; cores, fontes e assinatura de outra marca só quando o usuário é dono dela).
  - Uma linha nova: com o fluxo de design do DevOrb ativo, não carregar frontend-design, taste-skill, Impeccable nem ui-ux-pro-max, e recomendar desinstalá-las uma vez.
  - `contract.md` ganha os rótulos de Interfaces.
- [ ] **Step 5: GREEN.** Run: `node tools/compare.mjs --skill visual-direction --arms devorb,none --outside-sandbox`, depois `--reserved`. Expected: `accepted: true` nas duas. `regressions` ou `belowBar` voltam ao Step 4. `gaps` vão para o ledger.
- [ ] **Step 6: Ledger e limites.** Registrar no ledger:
  - a origem das ideias (ai-website-cloner: fases; taste-skill: shoot e consistência; o `mirror.js` do dono: neutralizar revelações);
  - a call de razão 2.0 em Read e Experience;
  - os resultados das rodadas.

  Run: `npm test`. Expected: PASS.
- [ ] **Step 7: Commit.** `git commit -m "feat(visual-direction): replicate mode and reference pack"`

### Task 5: `ui-review` com crítico de olhos novos (ciclo completo)

**Files:**
- Modify: `skills/ui-review/SKILL.md`
- Create: `skills/ui-review/references/critique.md` (prompt do crítico, régua de 9 dimensões, 3 exemplos próprios de crítica boa)
- Modify: `fusion/skills.json` (`ui-review.level`: `light` passa a `full`)
- Modify: `fusion/ledger/ui-review.md`
- Create: `evals/ui-review-critica-em-breve/`
- Create: `evals-reserved/ui-review-<slug>/`, por subagente novo

**Seam:** `node tools/compare.mjs --skill ui-review …` e `npm test`.

**Interfaces:**
- Consumes: CLI `shoot.mjs` e `checks.json` (Task 2); `compareStructure` (Task 1); rótulos do contrato (Task 4).
- Produces, para a Task 6 e para `verifying`, o bloco do relatório:

  ```
  Critique (fresh reviewer): <dimension>: <0-10> — a 10 here: <one line> — gap: <one line>
  ```

  As 9 dimensões, nesta ordem: `hierarchy`, `layout-grid`, `spacing-rhythm`, `typography`, `color-contrast`, `visual-moment`, `motion`, `finish`, `reference-fidelity` (`n/a` sem pacote). Cada nota abaixo de 8 vira uma linha `[P1]` em Findings, com classe `Conceptual mismatch` ou `Local defect`.

- [ ] **Step 1: Caso RED** `evals/ui-review-critica-em-breve`.
  - **Scaffold.** Uma página "Em breve" que segue os tokens de um `DESIGN.md` e que é feia do jeito da Ligare:
    - faixa chapada com título de 26px;
    - corpo de 12–13px;
    - coluna esquerda com 3 linhas e um vazio embaixo;
    - nenhum momento visual.

    Junto, um pacote de referência pronto em `design/referencias/ref-agenda/`: `secoes.md`, `tokens.json` e prints gerados pelo DevOrb a partir do `ref/index.html` da Task 4, nunca de site de terceiros.
  - **Prompt.** "revisa a interface dessa página contra a referência e o DESIGN.md; não consigo responder perguntas."
  - **Graders:**
    - `critique` (llm, `last_message`, peso 3): bloco `Critique` com as 9 dimensões, notas abaixo de 8 em `hierarchy` e `reference-fidelity`, e P1 para cada uma;
    - `fresh` (regex no rastro): um `Agent` despachado com `critique.md`;
    - `no-edits` (regex): arquivos inalterados, como no grader `index-unchanged` de `ui-review-equipes`;
    - `token-pass` (llm): não acusa token errado onde os tokens estão certos.
- [ ] **Step 2: RED.** Run: `node tools/compare.mjs --skill ui-review --baseline-only --outside-sandbox`, depois de confirmar o custo. Expected: o braço com a skill atual falha em `critique` ("Ugly is not a rule").
- [ ] **Step 3: Escrever.**
  - Nova seção "Visual critique", depois da §5:
    1. rodar `shoot.mjs` com o modo do contrato;
    2. levar o `checks.json` aos Findings (FAIL vira P1, WARN vira P2);
    3. com pacote de referência, rodar `compareStructure`;
    4. despachar um subagente novo com `references/critique.md`, os prints, o pacote e o contrato, e nada do código;
    5. copiar o bloco `Critique` no relatório.
  - Sem ferramenta de subagente, o próprio revisor critica só pelos prints e diz isso.
  - Ajustar o que contradiz o crítico:
    - na abertura, "It decides no taste" passa a "taste is judged only through the written rubric";
    - em §6, "No grade, score or total anywhere" passa a "no grade outside the Critique block";
    - na tabela de stop signs, "Ugly is not a rule" passa a "Ugly is judged by the rubric, with a fresh reviewer".
  - `critique.md` traz:
    - a régua: cada dimensão com o que olha e como seria o 10;
    - o formato de saída;
    - 3 exemplos próprios no formato do UICrit (problema, onde, por que importa, correção), com crédito da ideia no ledger e nenhum texto copiado;
    - a regra: o crítico não vê o código e não sabe quem construiu.
- [ ] **Step 4: GREEN.** Run: `node tools/compare.mjs --skill ui-review --arms devorb,none --outside-sandbox` e `--reserved`. Expected: `accepted: true`, e `ui-review-equipes` sem regressão.
- [ ] **Step 5: Ledger.** Origem das ideias: gstack (nota de 0 a 10 com "como seria o 10"), Hallmark (revisor de contexto limpo), UICrit (exemplos), taste-skill (checagens). Registrar os resultados. Run: `npm test`. Expected: PASS.
- [ ] **Step 6: Commit.** `git commit -m "feat(ui-review): fresh-eyes visual critique with a written rubric"`

### Task 6: `implementing` com espelho do construtor (ciclo completo)

**Files:**
- Modify: `skills/implementing/SKILL.md:78` (regra do despacho)
- Modify: `skills/implementing/prompts/implementer.md` (passo do espelho antes do self-review, linha 38, e campo no relatório, linha 120)
- Modify: `fusion/ledger/implementing.md`
- Create: `evals/implementing-espelho-em-breve/`
- Create: `evals-reserved/implementing-<slug>/`, por subagente novo

**Seam:** `node tools/compare.mjs --skill implementing …` e `npm test`.

**Interfaces:**
- Consumes: CLI `shoot.mjs` (Task 2); rótulos do contrato (Task 4); `references/floor.md` de `visual-direction`.
- Produces, para `verifying` e para o revisor da task, o campo no relatório do implementador:

  ```
  Mirror: rounds <n>/3 · shots <dir> · checks FAIL <n> WARN <n> · vs reference: <grossFail yes/no>
  ```

- [ ] **Step 1: Caso RED** `evals/implementing-espelho-em-breve`.
  - **Scaffold.** Spec aprovada com `## Direção visual` nos rótulos da Task 4, pacote de referência gerado do `ref/index.html` da Task 4 e plano de uma task: a página Em breve em HTML e CSS.
  - **Prompt.** O mesmo estilo de `implementing-resgate-extrato`: executar o plano sozinho.
  - **Graders:**
    - `mirror-ran` (regex no rastro): `shoot.mjs` rodou depois da primeira escrita de `index.html` e antes do último commit;
    - `report-field` (regex no relatório `task-1-report.md`): `Mirror: rounds`;
    - `result` (llm, arquivos, peso 3): h1 pelo menos 3 vezes maior que o corpo e as seções na ordem do contrato;
    - `brief-carries` (regex no rastro): o despacho cita `design/referencias/` e `floor.md`.
- [ ] **Step 2: RED.** Run: `node tools/compare.mjs --skill implementing --baseline-only --outside-sandbox`, depois de confirmar o custo. Expected: falha em `mirror-ran` ou `brief-carries`.
- [ ] **Step 3: Escrever.**
  - **Na linha 78 da SKILL.md:** uma task com interface nomeia no despacho:
    - o caminho do contrato;
    - o `DESIGN.md`;
    - o pacote de referência;
    - o `references/floor.md` de `devorb:visual-direction`;
    - a ordem de rodar o espelho.
  - **Em `implementer.md`:** o novo passo 4 "Mirror", só para brief com interface:
    1. subir a página;
    2. rodar `shoot.mjs` com o modo do contrato;
    3. olhar os prints contra o pacote ou a régua;
    4. corrigir;
    5. repetir, no máximo 3 rodadas;
    6. escrever o campo `Mirror:` no relatório.

    Sem Playwright e sem navegador, o relatório diz "Mirror: not run (<why>)" e o status é `DONE_WITH_CONCERNS`.
- [ ] **Step 4: GREEN.** Rodar `node tools/compare.mjs --skill implementing --arms devorb,superpowers --outside-sandbox` e depois `--reserved`. O braço `superpowers` vem do ledger de `implementing`. Expected: `accepted: true`, e `implementing-resgate-extrato` sem regressão.
- [ ] **Step 5: Ledger e `npm test`.** Expected: PASS.
- [ ] **Step 6: Commit.** `git commit -m "feat(implementing): builder mirror step for UI tasks"`

### Task 7: Ligações leves (`aligning`, `planning`, `browser-testing`, `verifying`)

**Files:**
- Modify: `skills/aligning/SKILL.md`. Linha "If they take it… do the work through the normal flow": acrescentar que tarefa com interface ainda passa por `devorb:visual-direction`, que pula as perguntas e não a direção. O tamanho líquido não cresce, porque está em 2.492 de 2.500 tokens: cortar o mesmo tanto na mesma seção.
- Modify: `skills/planning/SKILL.md`. No bullet "UI step": o passo de interface nomeia também o contrato, o pacote de referência e o critério de pronto do espelho (`Mirror:` sem FAIL, crítico com 8 ou mais).
- Modify: `skills/browser-testing/SKILL.md:48`. "With no stored reference image…" passa a: com pacote de referência, a comparação visual é do `devorb:ui-review`; sem pacote, segue inconclusiva.
- Modify: `skills/verifying/SKILL.md:51`. Interface só é dada como pronta com o campo `Mirror:` do implementador e o bloco `Critique` do `ui-review` sem nota abaixo de 8, ou com os achados explícitos ao usuário.
- Create: `evals/aligning-manda-ver-tela/`. Caso leve: o usuário diz "pode mandar ver, faz a landing" numa pasta com spec. Grader regex no rastro: `Skill` com `visual-direction` antes do primeiro `Write` em `.html` ou `.tsx`. `runs: 2`.
- Create: `evals/planning-tela-com-referencia/`. Caso leve: spec com `## Direção visual` e pacote. Grader regex no plano escrito: `design/referencias/` e `Mirror`. `runs: 2`.

**Seam:** `npm test`, mais os dois casos leves com `node tools/compare.mjs --skill aligning --arms devorb` e `--skill planning --arms devorb`.

**Interfaces:**
- Consumes: os rótulos do contrato (Task 4), o bloco `Critique` (Task 5) e o campo `Mirror:` (Task 6).
- Produces: nada novo.

- [ ] **Step 1:** Escrever os 2 casos leves e rodá-los com `--baseline-only`, depois de confirmar o custo. Expected: falham.
- [ ] **Step 2:** Fazer as 4 edições.
- [ ] **Step 3:** Run: `npm test` e os 2 casos com `--arms devorb`. Expected: PASS e `accepted: true`. Os casos existentes `aligning-agendamento`, `planning-multa-atraso` e `verifying-nota-tudo-passou` sem regressão, rodando só os que o diff toca.
- [ ] **Step 4: Commit.** `git commit -m "feat: carry the visual contract and mirror through the flow"`

### Task 8: Fechamento da fase

**Files:**
- Modify: `CHANGELOG.md` (entrada da Fase 1, em português)
- Modify: `docs/specs/2026-11-08-devorb-design.md` §Setor de design. Fronteiras de `ui-review` (julga estética pela régua) e fluxo com o espelho; uma linha cada, apontando para a spec nova.
- Create: `fusion/results/2026-11-17-design-quality-fase-1.md`: custo real de cada rodada e resultados.

**Seam:** `npm test`.

- [ ] **Step 1:** Escrever as três mudanças.
- [ ] **Step 2:** Run: `npm test`. Expected: PASS.
- [ ] **Step 3: Commit.** `git commit -m "docs: close design quality phase 1"`

## Depois do plano: teste de aceitação (fora deste repositório)

Com a Fase 1 integrada e o plugin atualizado na máquina do dono, refazer a página Em breve do Google na Ligare com o Pilot como referência:
1. capturar com o navegador logado;
2. seguir o modo cópia;
3. rodar o espelho;
4. passar pelo crítico.

O dono julga. O resultado e os números (razão título/texto, desvios e notas do crítico) vão para `fusion/results/`, sem prints do Pilot. Só depois disso as Fases 2 e 3 ganham plano.
