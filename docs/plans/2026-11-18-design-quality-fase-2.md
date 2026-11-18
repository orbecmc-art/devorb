# Qualidade de design, Fase 2: ferramentas robustas, receitas, biblioteca e guia — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** O DevOrb captura e mede de forma confiável os 23 sites de referência do dono, constrói com receitas calibradas por eles, oferece esses sites ao usuário e escolhe o movimento por um dial com números medidos.

**Architecture:** Quatro pilares, na ordem do dono.
- **A:** os scripts da Fase 1 (`collect-in-page.js`, `shoot.mjs`, `rules.mjs`) ganham revelação forçada, prints que não derrubam a execução e um segundo critério de seções. Um teste de aceitação sob demanda (`tools/refs-check.mjs`) prova isso nos 23 sites.
- **B:** a régua de `rules.mjs` é recalibrada pelas referências. As receitas viram arquivos de `references/`: valores em `design-system` (com um script de escala fluida), padrões de abertura e de seção em `visual-direction`, sinais de página gerada no crítico da `ui-review`.
- **C e D:** as referências entram em `ui-sources.json`. O guia da `visual-direction` oferece essas referências e sorteia padrões com histórico. Um estudo de movimento em navegador sem tela alimenta o dial da `motion`.

**Tech Stack:** Node 22 (ESM, `node --test`), Playwright de fora do repositório (`--pw <dir>` ou `DEVORB_PLAYWRIGHT_DIR`), Markdown das skills, `tools/compare.mjs` para os evals.

**Spec:** `docs/specs/2026-11-18-design-quality-fase-2-design.md` (Pilares A a D, Calls 1 a 10, suposições 1 e 2). Fundo: `docs/specs/2026-11-17-design-quality-design.md` §Pilar 4 (guia, receitas, dial) e os estudos em `docs/specs/2026-11-18-referencias/` (`study-A.md`, `study-B.md`, `urls.txt`). Modelo de estilo: `docs/plans/2026-11-17-design-quality-fase-1.md`.

## Global Constraints

Da spec, literais:
- Metas "em ordem de entrega, decisão do dono": ferramentas robustas, receitas calibradas, biblioteca de referências, guia e dial de movimento.
- Anti-metas: "Uma receita que vira molde e faz toda página sair igual. Os padrões são um cardápio escolhido pelo guia, com sorteio e histórico (ideia da taste-skill)." "Um checador que reprova as próprias referências do dono." "Prints ou textos de terceiros commitados no repositório público. Só entram URL, números medidos e descrições escritas por nós."
- "Decisão do dono (2026-11-18): os 23 sites ficam na biblioteca sem checar os termos de uso de cada um. Só entram URL, números medidos e descrições nossas; nada é salvo deles no repositório."
- Fora do escopo: "Competição e três versões (Fase 3), Figma, geração de imagem e app nativo."
- Call 3: "O teste das 23 referências roda sob demanda (`tools/refs-check.mjs`), fora do `npm test`, porque depende de rede e do Playwright."
- Call 4: "Ciclo de testes: completo em `visual-direction` (biblioteca e receitas) e `ui-review` (crítico com sinais de IA). Leve em `design-system` e `motion`. O mesmo critério de orçamento da Fase 1 vale, e cada rodada paga é confirmada antes."
- Suposição 2: "O orçamento das rodadas pagas da Fase 2 ainda não foi definido. Antes da primeira rodada paga, peço o teto." A primeira rodada paga deste plano é a Task 6, Step 6.
- Call 7: "`heading-ratio` dá FAIL abaixo de 2,5 e WARN entre 2,5 e 4,0, com alvo de 4,0." "O `refs-check` exige zero FAIL nas 23 referências, só lista os WARN e trata a saída 2 do `shoot` como resultado, não como erro. Cada referência tem o seu modo em `urls.txt`; persuade é o padrão."
- Call 10: "os 23 sites capturam sem derrubar a execução, Melius e Audienceful incluídos." "O `refs-check` exige zero [`hiddenContent`] em todos."

Do repositório e da Fase 1:
- `SKILL.md` com menos de 20.000 bytes e `ceil(bytes ÷ 4)` até o `ceilingTokens` de `fusion/skills.json` (2.500 nas quatro skills de design, ou seja, até 10.000 bytes). Hoje: `ui-review` 9.982, `motion` 8.943, `visual-direction` 7.128, `design-system` 6.958. Detalhe vai para `references/`. `npm test` aplica as regras.
- Texto de skill em inglês. Plano, ledger, changelog, prompts e graders de eval em português.
- Scripts e receitas escritos pelo DevOrb. `textReuse` continua `false` para taste-skill, Impeccable, Hallmark e gstack (`tests/layout.test.mjs`). Crédito de cada ideia no ledger da skill.
- Larguras: espelho 1440, 1024, 768 e 390; cópia e referências 1440 e 390.
- O Playwright nunca vem das dependências do DevOrb. `<pw>` neste plano é uma pasta fora do repositório com `npm i --prefix <pw> playwright` (o Chromium já está em `~/Library/Caches/ms-playwright`); instalar pede o sim do dono antes. Os testes com navegador rodam com `DEVORB_PLAYWRIGHT_DIR=<pw>` e ficam pulados sem ele.
- Prints de sites de terceiros só em pasta temporária fora do repositório.
- Evals:
  - casos que abrem navegador ficam em `evals-outside/` e rodam com `node tools/compare.mjs --skill <s> --arms devorb,none --outside-sandbox --runs 2`, só com graders `regex` e `llm`, e `--outside-sandbox` não combina com `--reserved`;
  - casos reservados são escritos por um subagente novo que nunca viu o rascunho da skill, ficam em `evals-reserved/`, rodam dentro do sandbox, e quem escreve a skill não abre `evals-reserved/`;
  - nunca duas execuções de `compare.mjs` ao mesmo tempo no mesmo HEAD;
  - o glob `<skill>-*` roda todos os casos da skill na suíte, o que já serve de teste de regressão.
- Corte do crítico: nota abaixo de 8 vira P1; no máximo 3 rodadas.
- Toda mensagem de commit deste plano termina com uma linha em branco e `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

1. **Menus e diálogos fechados.** A revelação forçada não pode pintar um menu, tooltip ou modal fechado por cima das seções. Teste: `hiddenContent` e `__devorbReveal` ignoram `position: fixed` e o que está dentro de `[role=dialog|menu|tooltip|listbox]` (Task 1).
2. **Animação infinita.** `finish()` lança `InvalidStateError` numa animação infinita (marquee, spinner). A revelação pula essa animação e segue. Teste em `__devorbReveal` (Task 1).
3. **Cores em `oklch()`.** Site moderno devolve a cor computada em `oklch()`. `accent-count` lê esse formato e ignora formatos que não conhece, sem gerar NaN nem WARN falso. Teste em `accentHues` (Task 5).
4. **Folha de estilo de outro domínio.** Ler `cssRules` lança `SecurityError`. O estudo de movimento pula a folha e segue. Teste em `hoverTargets` (Task 10).
5. **Print de terceiro dentro do repositório.** `refs-check --out` apontando para dentro do repositório é recusado antes de rodar. Teste da CLI (Task 4).

Sem `## Rollout`: não há migração de dados nem autenticação. O lançamento da versão do plugin é do `devorb:finishing`. A forma de `metrics.json` só ganha campos. `checks.json` ganha dois ids, e quem o lê já trata qualquer id (FAIL vira P1 e WARN vira P2).

---

### Task 1: Revelação forçada e `hiddenContent`

**Files:**
- Create: `skills/ui-review/scripts/reveal-init.js` (script de navegador, sem import)
- Modify: `skills/ui-review/scripts/collect-in-page.js`
- Modify: `skills/ui-review/scripts/shoot.mjs` (`shootPage`)
- Modify: `skills/visual-direction/references/replicate.md:22` (a frase sobre seção `hidden`)
- Modify: `skills/ui-review/references/critique.md` (§Fallbacks, primeiro bullet)
- Create: `tests/fixtures/design/reveal.html`
- Test: `tests/design-shoot.test.mjs`, `tests/design-browser.test.mjs`
- Modify: `fusion/ledger/ui-review.md`

**Seam:** os dois scripts de navegador carregados com `vm.runInNewContext`, como os testes atuais de `collect-in-page.js`. O caminho real passa por `shootPage` em `design-browser.test.mjs`.

**Interfaces:**
- Produces:
  - `reveal-init.js` troca `window.IntersectionObserver` por uma subclasse. A subclasse embrulha o callback e entrega cada entrada como objeto comum com os campos da original mais `isIntersecting: true` e `intersectionRatio: 1`. Os métodos herdados (`observe`, `disconnect`, `takeRecords`) continuam. Sem `IntersectionObserver` na página, o script não faz nada.
  - `window.__devorbReveal(): number`:
    1. chama `finish()` em cada item de `document.getAnimations()` e ignora o que lançar;
    2. marca com `data-devorb-reveal` cada elemento candidato com `opacity` computada abaixo de 0.1 ou `visibility: hidden`;
    3. injeta uma vez `<style>[data-devorb-reveal]{opacity:1!important;visibility:visible!important}</style>`;
    4. devolve quantos elementos marcou.

    Um elemento é candidato quando tem texto ou contém `img, svg, video, canvas, picture`, tem caixa com largura e altura, não é `position: fixed` e não está dentro de `[role=dialog], [role=menu], [role=tooltip], [role=listbox]`.
  - `Metrics.revealed: number`: a contagem do último `__devorbReveal`, ou 0.
  - `Section.hiddenContent: number`: candidatos dentro da seção cuja opacidade efetiva (o produto das opacidades até a seção) fica abaixo de 0.1, ou com `visibility: hidden`.
  - Ordem em `shootPage`:
    1. `context.addInitScript({ path: REVEAL_INIT })` antes do `goto`;
    2. `addScriptTag` do coletor;
    3. rolagem;
    4. `__devorbReveal()`;
    5. `__devorbExpand()`;
    6. medição.

- [ ] **Step 1: Testes que falham** em `tests/design-shoot.test.mjs`:
  - `reveal-init reports every observed entry as visible`. Contexto vm: `window.IntersectionObserver = class { constructor(cb) { this.cb = cb } fire(e) { this.cb(e, this) } disconnect() {} }`. Depois de rodar o script, `new window.IntersectionObserver((e) => got = e).fire([{ target: 't', isIntersecting: false, intersectionRatio: 0, time: 5 }])` dá `[{ target: 't', isIntersecting: true, intersectionRatio: 1, time: 5 }]`, e `typeof obs.disconnect === 'function'`.
  - `reveal-init does nothing without IntersectionObserver`: com `window = {}`, o script não lança.
  - `__devorbReveal finishes animations, skips infinite ones and marks hidden content`: estender `fakePage()`. `getComputedStyle(el)` passa a ler `el.style`, e os elementos ganham `closest`, `setAttribute`, `querySelectorAll('*')` e `innerText`. `document.getAnimations` devolve uma animação que conta `finish()` e outra que lança `InvalidStateError`. Na seção há um `div` com `opacity: '0'` e texto. Esperado: retorno 1, `finish` chamado uma vez, `data-devorb-reveal` no `div` e um `<style>` com `[data-devorb-reveal]` anexado ao `head`.
  - `hiddenContent counts faded text in a section, not fixed overlays or menus`. A seção tem um `p` com `opacity: '0.05'` e texto, que conta; um `div` com `position: 'fixed'`, `opacity: '0'` e texto, que não conta; e um `div` com `visibility: 'hidden'` dentro de um `role=menu`, que também não conta. Esperado: `sections[0].hiddenContent === 1` e `m.revealed === 0`.
  - O fake do teste `the CLI exits 2 …` ganha `addInitScript: async () => {}` no contexto.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-shoot.test.mjs`. Expected: FAIL nos quatro testes novos.
- [ ] **Step 3: Implementar** `reveal-init.js`, `__devorbReveal`, `revealed` e `hiddenContent` em `collect-in-page.js`, e a ordem nova em `shootPage`.
- [ ] **Step 4: Fixture e teste com navegador.** `reveal.html` tem 4 seções, todas escritas pelo DevOrb:
  - um hero estático;
  - itens que entram com `IntersectionObserver` (classe posta ao entrar e tirada ao sair);
  - um bloco com `animation: rise 1s 30s both`, de `opacity: 0` a 1;
  - um parágrafo com `opacity: 0` que nenhum script mostra, e ao lado um `ul role=menu` absoluto com `visibility: hidden`.

  Teste `shootPage reveals observer and keyframe reveals, leaving no hidden content` (`{ skip }`): 4 seções, `hiddenContent` 0 em todas e `revealed === 1`. O 1 é só o parágrafo: o menu não entra.
- [ ] **Step 5: Rodar e ver passar.** Run: `node --test tests/design-shoot.test.mjs`, `DEVORB_PLAYWRIGHT_DIR=<pw> node --test tests/design-browser.test.mjs` e `npm test`. Expected: PASS, e a saída do teste com navegador sem `# SKIP`.
- [ ] **Step 6: Conferir num site real.** Run: `node skills/ui-review/scripts/shoot.mjs https://trymonocle.app/ <tmp>/monocle --widths 1440 --pw <pw>`. Expected: saída 0 ou 2, `hiddenContent` 0 em todas as seções de `metrics.json`, e os `section-*.png` abertos com o Read e sem branco onde havia conteúdo. Anotar o resultado no relatório da task.
- [ ] **Step 7: Textos.**
  - `replicate.md:22`: "`revealed` acima de 0 em `metrics.json` quer dizer que a página revela ao rolar: registre isso como movimento". Sai a frase sobre seção `hidden`.
  - `critique.md`, caminho com ferramenta de navegador: rodar `window.__devorbReveal()` depois da rolagem e antes de `__devorbExpand()`.
  - Ledger: a ideia vem do `mirror.js` do `av-design-system` do dono, só a ideia, sem texto copiado.
- [ ] **Step 8: Commit.** `git commit -m "feat(ui-review): force scroll reveals and count hidden content"`

### Task 2: Página longa, clip e site pesado com `shotErrors`

**Files:**
- Modify: `skills/ui-review/scripts/shoot.mjs` (`planShots`, `shootPage`)
- Test: `tests/design-shoot.test.mjs`, `tests/design-browser.test.mjs`
- Modify: `fusion/ledger/ui-review.md`

**Seam:** `planShots`, exportada, e a CLI com Playwright falso (o padrão `withPlaywright` de `design-shoot.test.mjs`).

**Interfaces:**
- Consumes: a ordem de captura da Task 1.
- Produces:
  - `planShots(pageHeight: number, sections: Section[], viewportHeight = 900): { fullClip: number, perSection: { index: number, scrollTo: number | null, clip: { x: number, y: number, width: number, height: number } }[], skipped: { index: number, reason: 'hidden' | 'empty' }[] }`:
    - `fullClip = min(pageHeight, 16000)`;
    - uma seção `hidden` vai para `skipped` com `'hidden'`, e uma com largura ou altura abaixo de 1 vai com `'empty'`;
    - clip `{ x, y: top, width, height: min(height, pageHeight - top) }`, com `scrollTo: null`, quando `top` mais essa altura cabe em `fullClip`;
    - senão `scrollTo: top` e clip relativo à janela `{ x, y: 0, width, height: min(height, viewportHeight) }`, tirado com `fullPage: false` depois de `window.scrollTo(0, top)`. Depois de `__devorbExpand` quem rola é a janela.
  - `Metrics.shotErrors: { shot: string, error: string }[]`, gravado por `shoot.mjs` em `metrics.json`:
    - `shot` é `'full'` ou `'section-<i>'`;
    - `error` é a primeira linha da mensagem, ou `skipped: hidden` / `skipped: empty`.
  - Todo `page.screenshot` recebe `animations: 'disabled', timeout: 60000`. Se lançar, tenta mais uma vez com `caret: 'hide'`. Se lançar de novo, a falha entra em `shotErrors` e a execução segue.
  - `page.goto(url, { waitUntil: 'domcontentloaded' })`, seguido da espera de rede ociosa que já existe.

- [ ] **Step 1: Testes que falham:**
  - `planShots keeps sections inside the 16000px image and scrolls to the rest`. Com `planShots(40000, [s(0, 1000, 800), s(1, 15500, 2000), s(2, 30000, 3000), s(3, 31000, 0)])`, sendo `s(index, top, height)` de largura 1440, o resultado é:
    - `perSection[0]`: `{ index: 0, scrollTo: null, clip: { x: 0, y: 1000, width: 1440, height: 800 } }`;
    - `perSection[1]`: `{ index: 1, scrollTo: 15500, clip: { x: 0, y: 0, width: 1440, height: 900 } }`;
    - `perSection[2]`: `scrollTo` 30000;
    - `skipped`: `[{ index: 3, reason: 'empty' }]`.
  - `planShots clamps a clip to the page`: `planShots(3000, [s(0, 2500, 1000)])`, com clip de altura 500.
  - O teste atual `planShots shoots only visible sections, by index` passa a conferir `perSection.map((p) => p.index)` igual a `[0, 2]` e `skipped` igual a `[{ index: 1, reason: 'hidden' }]`.
  - `a failing shot is retried once with the caret hidden, then logged, and the run goes on`. O Playwright falso grava as opções de cada `screenshot` e de `goto` num arquivo apontado por `process.env.CALLS`. `full.png` sempre lança `'Timeout 60000ms exceeded.\nCall log: …'`, e `section-0` lança só na primeira vez. Esperado:
    - status 0 ou 2 e `stderr` vazio;
    - `shotErrors` igual a `[{ shot: 'full', error: 'Timeout 60000ms exceeded.' }]`;
    - toda chamada com `animations: 'disabled'` e `timeout: 60000`;
    - as novas tentativas com `caret: 'hide'`;
    - `goto` com `waitUntil: 'domcontentloaded'`.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-shoot.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** `planShots` e o print com nova tentativa em `shootPage`.
- [ ] **Step 4: Teste com navegador** `shootPage shoots a 24000px page without failing` (`{ skip }`): gravar numa pasta temporária um HTML com 24 seções de 1000px, cada uma com fundo e um `h2`. Esperado: `section-23.png` existe, `shotErrors` igual a `[]` e `full.png` existe.
- [ ] **Step 5: Rodar e ver passar.** Run: `node --test tests/design-shoot.test.mjs`, `DEVORB_PLAYWRIGHT_DIR=<pw> node --test tests/design-browser.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 6: Conferir em sites reais.** Run: `shoot.mjs` em `https://www.shopify.com/editions/winter2026` e `https://www.melius.com/`, `--widths 1440 --pw <pw>`. Expected: saída 0 ou 2, sem stack trace; `shotErrors` listado no relatório da task.
- [ ] **Step 7: Commit.** `git commit -m "feat(ui-review): long pages and heavy sites never abort the shoot"`

### Task 3: Segundo critério de seções

**Files:**
- Modify: `skills/ui-review/scripts/rules.mjs`
- Modify: `skills/ui-review/scripts/collect-in-page.js` (cópia do algoritmo, `__devorbTree`)
- Create: `tests/fixtures/design/dom-billow-shape.json` (sintético: só tags e retângulos, sem texto nem classe)
- Test: `tests/design-rules.test.mjs`, `tests/design-shoot.test.mjs`
- Modify: `fusion/ledger/ui-review.md`

**Seam:** `findSections` de `rules.mjs`, e a cópia em `collect-in-page.js` conferida pelo teste de igualdade que já existe.

**Interfaces:**
- Produces:
  - `findSections(tree: DomNode): { root: DomNode, nodes: DomNode[] }`:
    1. começa com `sectionNodes(findSectionsRoot(tree))` e devolve esse resultado se ele tem 2 nós ou mais;
    2. senão, `start` é o nó `main` ou `[role=main]`, ou a própria árvore;
    3. em `start` e em cada descendente, conta os filhos com `rect.w ≥ 0.9 × start.rect.w` e `rect.h ≥ 120`;
    4. fica o nó com mais desses filhos (no empate, o primeiro em pré-ordem); com 2 ou mais, devolve esse nó e esses filhos;
    5. senão, devolve o resultado do passo 1.
  - `window.__devorbFindSections` (a cópia). `__devorbMetrics` passa a usar `findSections`, e `root` é a tag do nó escolhido. `findSectionsRoot`, `sectionNodes` e `findScroller` não mudam.
  - `window.__devorbTree(): DomNode`: o `toNode(document.body)`, serializável, para ajudar a depurar.

- [ ] **Step 1: Ver a forma real da Billow.** Acrescentar primeiro `window.__devorbTree` ao coletor (uma linha, sem mudar a medição). Numa pasta temporária, abrir `https://www.billow.so/` a 1440 com o Playwright de `<pw>`, injetar o coletor e gravar `JSON.stringify(window.__devorbTree())` só com tags, `role` e `rect`, sem texto. Achar o nível em que o primeiro critério para com 0 ou 1 seção. O fixture sintético reproduz essa forma: a mesma profundidade, as caixas sem altura ou estreitas e o número de blocos. Se a Billow já der 2 ou mais, registrar isso e usar a forma de um wrapper com `display: contents` (caixa 0×0) entre `main` e 9 blocos de 1440×800.
- [ ] **Step 2: Testes que falham:**
  - `the second rule finds the sections behind a wrapper with no box`: no fixture, `sectionNodes(findSectionsRoot(t)).length ≤ 1` e `findSections(t).nodes.length` igual ao número de blocos do fixture.
  - `the second rule picks the level with most full-width blocks`. Árvore sintética: `main` (1440) com dois wrappers 0×0, um com 4 blocos de 1440×600 e outro com 2. Esperado: `nodes.length === 4`.
  - `the first rule wins when it already finds two or more`: `findSections(load('dom-app-shell.json')).nodes.length === 3`, com `root.tag === 'main'`.
  - No teste de igualdade do coletor, cada árvore (`shell`, `narrowAndShort`, `ligare` e o fixture novo) dá em `window.__devorbFindSections` o mesmo `root` e os mesmos nós que `findSections`.
- [ ] **Step 3: Rodar e ver falhar.** Run: `node --test tests/design-rules.test.mjs tests/design-shoot.test.mjs`. Expected: FAIL.
- [ ] **Step 4: Implementar** `findSections` e a cópia. O comentário de `collect-in-page.js` passa a citar também `findSections`.
- [ ] **Step 5: Rodar e ver passar.** Run: os dois arquivos, `DEVORB_PLAYWRIGHT_DIR=<pw> node --test tests/design-browser.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 6: Conferir na Billow.** Run: `shoot.mjs https://www.billow.so/ <tmp>/billow --widths 1440,390 --pw <pw>`. Expected: 2 seções ou mais nas duas larguras; o estudo A contou cerca de 13. Anotar o número.
- [ ] **Step 7: Commit.** `git commit -m "feat(ui-review): fallback section detection for wrapper-heavy pages"`

### Task 4: `tools/refs-check.mjs` e a primeira rodada nas 23 referências

**Files:**
- Create: `tools/refs-check.mjs`
- Test: `tests/refs-check.test.mjs`
- Modify: `docs/specs/2026-11-18-referencias/urls.txt` (terceira coluna `experience` em `onlines` e `shopify-editions`; o resto fica no padrão)
- Create: `fusion/results/2026-11-18-refs-check.md` (o relatório, só texto e números)

**Seam:** as exportações `parseUrls`, `judgeSite` e `report`, mais a CLI pela recusa de `--out`. A rodada real é o Step 6, fora do `npm test`.

**Interfaces:**
- Consumes: CLI `shoot.mjs` (saídas 0, 2 e 3), `metrics.json` com `sections[].hiddenContent` e `shotErrors` (Tasks 1 e 2), `checks.json` e `MODE_MIN_RATIO` de `rules.mjs`.
- Produces:
  - `parseUrls(text: string): { slug: string, url: string, mode: string }[]`:
    - cada linha é `<slug> <url> [mode]`, e linhas vazias ou começadas por `#` são puladas;
    - o modo padrão é `persuade`;
    - um modo fora de `MODE_MIN_RATIO` lança `line <n>: unknown mode <m>`, e um slug repetido lança `line <n>: duplicate slug <s>`.
  - `judgeSite({ dir: string, widths: number[], exit: number | null, stderr?: string }): { status: 'PASS' | 'FAIL', reasons: string[], warns: string[], shotErrors: string[] }`. Motivos de FAIL:
    - `exit` nulo dá `timeout`;
    - `exit` fora de 0 e 2 dá `run failed (exit <n>): <última linha do stderr>`;
    - por largura, falta de `metrics.json` dá `no metrics at <w>`;
    - cada FAIL de `checks.json` dá `FAIL <id> at <w>`;
    - menos de 2 seções visíveis dão `<n> sections at <w>`;
    - soma de `hiddenContent` acima de 0 dá `hidden content <n> at <w>`.

    `warns` traz `<id> at <w>` e `shotErrors` traz `<w>/<shot>: <error>`.
  - `report(results: ({ slug: string, mode: string } & ReturnType<judgeSite>)[]): string`:
    - uma linha por site, `- <slug> (<mode>): PASS|FAIL[ — <motivos com "; ">]`;
    - embaixo, linhas `  WARN: …` e `  shotErrors: …` quando há;
    - a última linha é `refs-check: <p>/<n> PASS`.
  - CLI `node tools/refs-check.mjs [--urls <file>] [--out <dir>] [--only a,b] [--widths 1440,390] [--pw <dir>]`:
    - padrões: `urls` é `docs/specs/2026-11-18-referencias/urls.txt` do repositório e `out` é `join(tmpdir(), 'devorb-refs-check')`;
    - um `--out` dentro do repositório sai com 1 e `OUT INSIDE REPO: <dir>`, sem criar nada;
    - roda `shoot.mjs` site a site, por `spawnSync` com `timeout: 600000`;
    - a saída 3 do `shoot` imprime o `NEED` e sai com 3;
    - grava `<out>/report.md`, imprime o relatório e sai com 0 se todos passam, senão com 1.

- [ ] **Step 1: Testes que falham** em `tests/refs-check.test.mjs`:
  - `parseUrls` com e sem modo e com comentário; `unknown mode` e `duplicate slug` lançam com o número da linha.
  - `the repo's urls.txt holds the 23 references with their modes`: 23 itens; `onlines` e `shopify-editions` em `experience`, o resto em `persuade`.
  - `judgeSite` sobre pastas temporárias com `metrics.json` e `checks.json` escritos pelo teste:
    - 2 seções, `hiddenContent` 0 e só WARN, com `exit: 2`, dão PASS com os WARN listados;
    - um FAIL de `body-size` dá `FAIL body-size at 1440`;
    - `hiddenContent` 3 dá `hidden content 3 at 390`;
    - `exit: null` dá `timeout`, e `exit: 1` dá `run failed (exit 1): …`;
    - a pasta 390 ausente dá `no metrics at 390`.
  - `report` de um PASS e um FAIL termina com `refs-check: 1/2 PASS`.
  - `the CLI refuses an --out inside the repo`: status 1, mensagem `OUT INSIDE REPO` e a pasta não existe depois.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/refs-check.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** `tools/refs-check.mjs` e a coluna de modo em `urls.txt`.
- [ ] **Step 4: Rodar e ver passar.** Run: `node --test tests/refs-check.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 5: Commit.** `git commit -m "feat: refs-check, the on-demand acceptance run over the 23 references"`
- [ ] **Step 6: Primeira rodada (aceitação do Pilar A).** Run: `node tools/refs-check.mjs --pw <pw>`, em segundo plano. Precisa de rede e não tem custo de API.

  Expected nesta task: nenhum motivo `run failed`, `timeout`, `hidden content` ou `sections at`. Um `FAIL body-size` ou `FAIL heading-ratio` é esperado até a Task 5 e fica listado.

  Qualquer outro motivo vai para `devorb:debugging`:
  1. reproduzir a forma num teste das Tasks 1 a 3;
  2. corrigir no script;
  3. rodar de novo só o site com `--only`.

  Conferir também `capture.mjs` num site pesado: `node skills/visual-direction/scripts/capture.mjs https://www.melius.com/ <tmp>/proj --pw <pw>`. Expected: saída 0 e o pacote completo.
- [ ] **Step 7: Registrar.** Copiar o relatório (texto, sem prints) em `fusion/results/2026-11-18-refs-check.md`, com a data, a versão do Chromium e o tempo de cada site. `git commit -m "docs: first refs-check run over the 23 references"`

### Task 5: Régua recalibrada

**Files:**
- Modify: `skills/ui-review/scripts/rules.mjs`
- Modify: `skills/ui-review/scripts/collect-in-page.js` (`fills`)
- Modify: `skills/visual-direction/references/floor.md` (seção nova `## Measured`)
- Modify: `skills/ui-review/references/critique.md:23` (linha de `typography`: "about 16px or more on a landing page" passa a "14 to 16px on a landing page, with a lead of 18 to 22px")
- Test: `tests/design-rules.test.mjs`, `tests/design-shoot.test.mjs`
- Modify: `fusion/results/2026-11-18-refs-check.md`, `fusion/ledger/ui-review.md`, `fusion/ledger/visual-direction.md`

**Seam:** `checkFloor` e `accentHues` de `rules.mjs`. A prova contra as referências é o `refs-check` (Task 4).

**Interfaces:**
- Consumes: `refs-check` (Task 4).
- Produces:
  - `MODE_MIN_RATIO = { persuade: 2.5, operate: 1.6, read: 2.0, experience: 2.0 }` e `MODE_TARGET_RATIO = { persuade: 4.0 }`.
  - `checkFloor(m, mode): Check[]`, com 10 ids nesta ordem: `heading-ratio`, `body-size`, `measure`, `spacing-grid`, `font-sizes`, `button-styles`, `text-colors`, `photo-repeat`, `display-weight`, `accent-count`.
    - `heading-ratio`: FAIL abaixo do mínimo do modo; WARN abaixo do alvo, quando o modo tem alvo.
    - `body-size`: FAIL com mediana abaixo de 13 em persuade ou read; sem amostra, continua FAIL. WARN em read de 13 até menos de 14.
    - `font-sizes`: WARN com mais de 12 tamanhos distintos.
    - `display-weight`: WARN quando alguma amostra `h1` ou `h2` tem `fontSize ≥ 48`, `fontWeight ≥ 700` e `letterSpacing ≥ 0`. O detalhe cita os tamanhos.
    - `accent-count`: WARN quando `accentHues([...m.textColors, ...(m.fills ?? []), ...m.sections.map((s) => s.bg)]).length > 2`.
  - `accentHues(colors: string[]): number[]`:
    - lê `rgb()` e `rgba()` (alfa até 0.1 é ignorado) e `oklch()` (com `%` e `/ alfa`);
    - é saturada a cor `rgb` com saturação HSL de 0.35 ou mais e luminosidade de 0.15 a 0.9, e a cor `oklch` com croma de 0.08 ou mais;
    - junta matizes a menos de 30° em grupos (circular, 350° e 10° no mesmo grupo) e devolve um matiz por grupo;
    - formato desconhecido é ignorado. Fica um comentário `shortcut:`: mistura matiz HSL e OKLCH, e vale trocar quando um caso real contar errado.
  - `Metrics.fills: string[]`: a cor de fundo computada de cada amostra `button`, sem repetição.

- [ ] **Step 1: Testes que falham** em `tests/design-rules.test.mjs`, ajustando os atuais:
  - O teste do Pilot e da Ligare passa a ser `Pilot warns on the persuade ratio target, Ligare fails the 2.5 floor`:
    - Pilot (3.2): `heading-ratio` WARN e `body-size` PASS;
    - Ligare em persuade: `heading-ratio` FAIL (2.0) e `body-size` PASS (13).
  - `read warns on a 13px body`: Ligare em read dá `body-size` WARN.
  - `a 12.5px body fails in persuade`.
  - `ratio 2.9 warns and 4.2 passes in persuade`, com amostras sintéticas.
  - `display-weight warns only on heavy, untracked display type`:
    - h1 72/700/0 dá WARN;
    - 72/500/-3.6 dá PASS;
    - 46/900/0 dá PASS.
  - `accentHues`:
    - `['rgb(151, 142, 255)', 'rgb(10, 10, 10)', 'rgb(255, 255, 255)', 'rgb(115, 115, 115)']` dá 1 matiz;
    - vermelho, verde e azul puros dão 3, e o `checkFloor` dá `accent-count` WARN;
    - azul em 220° e 230° dá 1;
    - `'oklch(0.62 0.19 260)'` dá 1 matiz;
    - `'color(display-p3 1 0 0)'` dá `[]`.
  - `every check id is present once`: os 10 ids na ordem.
  - `Pilot passes every check in persuade` passa a ser `Pilot passes every check in persuade except two warnings`: `heading-ratio` WARN (3.2) e `display-weight` WARN (o h1 do fixture é 56/700/0); o resto PASS.
  - `warning checks trip on their limits` passa a empurrar 10 tamanhos novos de `h3`, para `font-sizes` passar de 12.
  - Em `design-shoot.test.mjs`, o teste do `fakePage` confere `m.fills` igual a `[]`.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-rules.test.mjs tests/design-shoot.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** a régua, `accentHues` e `fills`.
- [ ] **Step 4: Textos.**
  - `floor.md` ganha `## Measured`, até 8 linhas: os números que `shoot.mjs` confere e o que é FAIL e o que é WARN, como acima, dizendo que vêm das 23 referências.
  - Trocar a linha de `typography` em `critique.md`.
  - `grep -rnE '16 ?px|body-size' evals-outside/*/graders evals/*/graders`. Expected: nenhum grader exige o FAIL de corpo de 16px. `ui-review-critica-em-breve` continua com sentido porque a página dele mede 26/13 = 2.0, FAIL em `heading-ratio`. Se aparecer um grader que dependa da regra velha, corrigi-lo nesta task.
- [ ] **Step 5: Rodar e ver passar.** Run: `npm test`. Expected: PASS.
- [ ] **Step 6: `refs-check` de novo.** Run: `node tools/refs-check.mjs --pw <pw>`. Expected: `refs-check: 23/23 PASS`, com zero FAIL e os WARN listados.

  Se uma referência der FAIL:
  1. conferir primeiro a medição com `devorb:debugging` (por exemplo, texto legal de 12px puxando a mediana do corpo) e corrigir o coletor com um teste;
  2. mudar um limiar além da Call 7 só com o sim do dono.

  Acrescentar o relatório em `fusion/results/2026-11-18-refs-check.md`.
- [ ] **Step 7: Ledger e commit.** Registrar a régua recalibrada e o porquê de cada número, apontando para a spec. `git commit -m "feat(ui-review): floor checks recalibrated against the 23 references"`

### Task 6: Escala fluida e receitas de valores em `design-system` (ciclo leve)

**Files:**
- Create: `skills/design-system/scripts/fluid-scale.mjs`
- Create: `skills/design-system/references/typography.md`, `color-finish.md`, `space-radius.md`
- Modify: `skills/design-system/SKILL.md` (§2, bullets **Type** e **Spacing and radius**: uma frase cada apontando para o arquivo; `Connects to` → Uses)
- Test: `tests/design-fluid.test.mjs`
- Create: `evals/design-system-escala-fluida/` (`case.yaml`, `scaffold.sh`, `graders/`)
- Modify: `fusion/ledger/design-system.md`

**Seam:** `fluidScale` e a CLI de `fluid-scale.mjs`; o eval por `node tools/compare.mjs --skill design-system …`.

**Interfaces:**
- Produces:
  - `fluidScale({ minWidth, maxWidth, minBase, maxBase, minRatio, maxRatio, steps }: { minWidth: number, maxWidth: number, minBase: number, maxBase: number, minRatio: number, maxRatio: number, steps: number[] }): { step: number, minPx: number, maxPx: number, clamp: string }[]`:
    - `minPx = minBase × minRatio^step` e `maxPx = maxBase × maxRatio^step`;
    - inclinação `(maxPx − minPx) ÷ (maxWidth − minWidth)` e intercepto `minPx − inclinação × minWidth`;
    - `clamp(<menor ÷ 16>rem, <intercepto ÷ 16>rem + <inclinação × 100>vw, <maior ÷ 16>rem)`, cada número com `Number(x.toFixed(4))`, a soma sempre com ` + ` e o sinal no número.
  - CLI `node fluid-scale.mjs --min-width <n> --max-width <n> --min-base <n> --max-base <n> --min-ratio <n> --max-ratio <n> --steps <a>..<b>`: imprime uma linha `--step-<n>: <clamp>;` por passo, com o negativo como `--step--1`. Argumento faltando ou inválido: saída 1 com o uso.
  - Valores das receitas, com palavras nossas, todos da spec:
    - `typography.md`: Pilar B, Tipografia, e a lista curta de pares gratuitos. Os presets da escala vêm do Pilar 4 da Fase 1: larguras 360 e 1440; razões 1.25 a 1.333 em Persuadir, 1.2 em Ler e 1.125 a 1.2 em Operar.
    - `color-finish.md`: Pilar B, Cor e acabamento.
    - `space-radius.md`: Pilar B, Espaço e raio, e o h1 de 32 a 64px no mobile.

- [ ] **Step 1: Testes que falham** em `tests/design-fluid.test.mjs`. Base: `{ minWidth: 360, maxWidth: 1440, minBase: 15, maxBase: 16, minRatio: 1.25, maxRatio: 1.333 }`.
  - O passo 0 dá `clamp(0.9375rem, 0.9167rem + 0.0926vw, 1rem)`.
  - O passo 1 dá `clamp(1.1719rem, 1.1182rem + 0.2387vw, 1.333rem)`.
  - O passo 6 dá `minPx` de cerca de 57.22 e `maxPx` de cerca de 89.76, dentro do título de 56 a 96px da spec.
  - Inclinação negativa: `minBase: 16, maxBase: 15, minRatio: 1.2, maxRatio: 1.2, steps: [0]` dá `clamp(0.9375rem, 1.0208rem + -0.0926vw, 1rem)`.
  - A CLI com `--steps -1..0` imprime duas linhas, a primeira começando com `--step--1: clamp(`. Sem `--max-width`, sai com 1.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-fluid.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** `fluid-scale.mjs`.
- [ ] **Step 4: Rodar e ver passar.** Run: `node --test tests/design-fluid.test.mjs`. Expected: PASS.
- [ ] **Step 5: Caso RED** `evals/design-system-escala-fluida` (dentro do sandbox).
  - **Scaffold:** a spec aprovada da landing do "Lote", ferramenta fictícia de logs de deploy, com `## Direção visual` em Persuade, setor devtools, `Type:` com Geist e Geist Mono, e um `styles.css` com `:root {}` vazio. Sem `DESIGN.md`.
  - **Prompt:** "monta os tokens e o DESIGN.md dessa landing a partir da spec. Hoje não respondo perguntas."
  - **Graders:**
    - `fluid` (regex em `styles.css`): `[\s\S]*clamp\([\s\S]*clamp\([\s\S]*clamp\(`;
    - `type-recipe` (llm em `DESIGN.md`, peso 3): título de 56 a 96px com peso de 400 a 500 e tracking negativo, corpo de 14 a 16px e lead de 18 a 22px;
    - `finish-recipe` (llm em `DESIGN.md`): uma cor de destaque além dos neutros, borda fina no lugar de sombra nos cartões, padding de seção de 96 a 160px e raio de 4 a 8px.
  - `runs: 2`.
- [ ] **Step 6: RED. Esta é a primeira rodada paga do plano.** Antes, pedir ao dono o teto de gasto da Fase 2 e confirmar a estimativa desta rodada. O glob roda também os casos que já existem: `cafe-moenda`, `padaria-pedidos` e `shadcn-padrao`. Run: `node tools/compare.mjs --skill design-system --baseline-only`. Expected: algum braço falha em `fluid` ou `type-recipe`. Se todos passarem, reescrever o caso.
- [ ] **Step 7: Escrever as receitas.**
  - As três `references/` com os números da spec, cada uma com a regra "a direção fixa o que a spec fixa" e um exemplo gerado pela CLI (valores gerados, nunca texto copiado).
  - Onde uma receita toca um reflexo de `floor.md` (rótulo em mono, halo), ela diz qual razão da página permite mantê-lo. Nenhuma receita contradiz o Floor.
  - Pares de fontes: de 5 a 8, por categoria (produto e devtools, editorial, consumo, luxo e restaurante, fintech). Cada face é conferida em `https://fonts.google.com/specimen/<Nome>`, com a licença OFL e os pesos usados; face não conferida fica fora.
  - `SKILL.md` aponta para os arquivos e para o script. Run: `wc -c skills/design-system/SKILL.md`. Expected: até 10.000.
- [ ] **Step 8: GREEN.** Confirmar o custo. Run: `node tools/compare.mjs --skill design-system --arms devorb,none`. Expected: `accepted: true` e os três casos antigos sem regressão.
- [ ] **Step 9: Ledger e commit.** Crédito do método ao Utopia (só a ideia), resultados e custos. Run: `npm test`. `git commit -m "feat(design-system): fluid type scale and value recipes from the references"`

### Task 7: Cardápio de padrões em `visual-direction` (ciclo completo, parte 1)

**Files:**
- Create: `skills/visual-direction/references/hero-patterns.md`, `section-patterns.md`
- Modify: `skills/visual-direction/references/contract.md` (`First screen:` cita um id `hero:`; cada item de `Sections:` cita um id `section:` ou `custom`)
- Modify: `skills/visual-direction/SKILL.md` (§5 passo 3 e §6: uma linha apontando para os dois arquivos)
- Test: `tests/design-patterns.test.mjs`
- Create: `evals/visual-direction-receitas-landing/`
- Modify: `fusion/ledger/visual-direction.md`

**Seam:** os arquivos de padrões lidos pelo teste; o eval por `node tools/compare.mjs --skill visual-direction …`.

**Interfaces:**
- Consumes: os valores da Task 6, citados por nome de arquivo.
- Produces, para as Tasks 8 e 11:
  - Cabeçalho de cada padrão: `` ### `<kind>:<kebab-id>` — <nome> ``, seguido das linhas `When:`, `Sketch:`, `Measures:` e `Mobile:`.
  - Ids de abertura: `hero:centred-product-halo`, `hero:split-header-bleeding-ui`, `hero:copy-left-ui-right-halo`, `hero:object-cut-by-fold`, `hero:full-photo-display-type`, `hero:type-performs-product`, `hero:tilted-content-wall`, `hero:left-headline-product-video`, `hero:copy-and-form-card`, `hero:giant-word-on-canvas`.
  - Ids de seção: `section:live-ui-bento`, `section:proof-grid`, `section:stat-cards-mono`, `section:alternating-rows-fading-ui`, `section:numbered-steps`, `section:two-tone-statement`, `section:mono-spec-table`, `section:configurator-pricing`, `section:hairline-faq`, `section:dark-contrast-band`, `section:closing-cta-echo`, `section:giant-wordmark-footer`.
  - `section-patterns.md` termina com `## Mobile recomposition`: a abertura alinha à esquerda, o CTA ocupa a largura toda, o visual secundário cai ou vira carrossel, e o h1 fica entre 32 e 64px.

- [ ] **Step 1: Teste que falha** `tests/design-patterns.test.mjs`. Com a regex ``/^### `(hero|section):([a-z0-9-]+)`/gm``:
  - `hero-patterns.md` tem 10 ids e `section-patterns.md` tem 12, iguais às listas acima e sem repetição;
  - cada bloco tem `When:`, `Sketch:`, `Measures:` e `Mobile:`;
  - `section-patterns.md` tem `## Mobile recomposition`.
  
  Run: `node --test tests/design-patterns.test.mjs`. Expected: FAIL.
- [ ] **Step 2: Caso RED** `evals/visual-direction-receitas-landing` (dentro do sandbox).
  - **Scaffold:** a spec aprovada do "Lote", sem `## Direção visual`, com 3 números reais dados e uma lista do que o produto faz. Sem `DESIGN.md`.
  - **Prompt:** "constrói a landing da spec em `index.html` e `styles.css`. Hoje não respondo perguntas."
  - **Graders:**
    - `patterns` (regex na spec): um `hero:[a-z0-9-]+` e pelo menos três `section:[a-z0-9-]+`;
    - `type-recipe` (llm em `styles.css`, peso 3): no computador, h1 de 56px ou mais, peso de 400 a 500, tracking negativo e corpo de 14 a 16px, com a conversão de unidades de `heading-scale.md`;
    - `finish` (llm em `styles.css`): no máximo uma cor de destaque saturada, cartões com borda fina e sombra só em UI flutuante;
    - `no-tells` (llm em `index.html`, peso 2): sem títulos genéricos tipo "Feature 1/2/3", sem trio de cartões iguais de ícone como estrutura, sem número além dos 3 dados, e o hero com UI construída em HTML, não ícone;
    - `mobile` (llm em `styles.css`): numa media query de 640px ou menos, hero alinhado à esquerda, CTA com largura toda e h1 entre 32 e 64px.
  - `runs: 2`.
- [ ] **Step 3: RED.** Confirmar o custo. Run: `node tools/compare.mjs --skill visual-direction --baseline-only`. Expected: algum braço falha em `type-recipe`, `no-tells` ou `mobile`. `patterns` falha em todo braço de base por construção, e por isso não conta como RED.
- [ ] **Step 4: Escrever.**
  - Os dois arquivos de padrões, com palavras nossas, a partir das sínteses dos dois estudos e sem nomear site. O topo de cada arquivo diz:
    - é um cardápio, não um molde;
    - `Measures` são as faixas em que o `devorb:design-system` escolhe os valores, e o contrato cita o id, nunca o número;
    - o padrão respeita `floor.md`, e onde uma referência faz o que o Floor proíbe (palavra solta destacada, caixa-alta espaçada, cadeia de pontos), o padrão traz a versão que respeita o Floor;
    - halo, rótulo em mono e número de seção só entram com a razão da página na linha `Floor:`.
  - Os rótulos novos em `contract.md`.
  - A linha nova na `SKILL.md`. Run: `wc -c skills/visual-direction/SKILL.md`. Expected: até 10.000.
- [ ] **Step 5: Rodar o teste.** Run: `node --test tests/design-patterns.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 6: GREEN.** Confirmar o custo. Run: `node tools/compare.mjs --skill visual-direction --arms devorb,none`. Expected: `accepted: true`, e `visual-direction-arquitetura-clean` e `visual-direction-clinica-serena` sem regressão. O caso reservado da skill fica para a Task 11.
- [ ] **Step 7: Ledger e commit.** Origem: estudos A e B (nossos); a ideia do cardápio com sorteio vem da taste-skill, só como ideia. `git commit -m "feat(visual-direction): hero and section pattern menu with measures"`

### Task 8: Sinais de página gerada no crítico (`ui-review`, ciclo completo)

**Files:**
- Modify: `skills/ui-review/references/critique.md` (seção nova `## Tells of a generated page`; linhas 6 e 8 da régua)
- Modify: `skills/ui-review/SKILL.md` só se for preciso, sem passar de 10.000 bytes
- Create: `evals-outside/ui-review-sinais-de-ia/`
- Create: `evals-reserved/ui-review-<slug>/`, escrito por subagente novo
- Modify: `fusion/ledger/ui-review.md`

**Seam:** `node tools/compare.mjs --skill ui-review …` e `npm test`.

**Interfaces:**
- Consumes: os ids `display-weight` e `accent-count` (Task 5) e o cardápio da Task 7, como o que substitui cada sinal.
- Produces:
  - Os 7 sinais da spec, cada um com o que se vê no print e o que entra no lugar:
    - ícone onde devia haver UI real;
    - tudo centralizado;
    - destaque demais;
    - números genéricos;
    - título em negrito com tracking normal;
    - mobile só empilhado;
    - "Feature 1/2/3".
  - Na régua:
    - o 10 de `finish` é nenhum sinal visível; cada sinal visto aparece no gap, e com um sinal ou mais `finish` fica em 7 ou menos;
    - em `visual-moment`, ícone no lugar de UI real ou "Feature 1/2/3" como momento da página deixa a nota em 5 ou menos.

- [ ] **Step 1: Caso RED** `evals-outside/ui-review-sinais-de-ia`.
  - **Scaffold:** a página do "Lote" com `DESIGN.md` que declara os tokens usados (assim nenhum achado de token é legítimo) e todos os sinais:
    - h1 de 64px com peso 800 e `letter-spacing: 0`;
    - roxo, rosa e verde-água como destaques;
    - três cartões iguais de ícone, "Feature 1/2/3";
    - "10x mais rápido" e "99% de satisfação";
    - tudo centralizado;
    - mobile que só empilha.
  - **Prompt:** "revisa a interface dessa landing (`index.html` com `styles.css`) contra o DESIGN.md. Hoje não consigo responder perguntas. Pode instalar o que precisar para renderizar a página."
  - **Graders:**
    - `tells` (llm em `last_message`, peso 3): bloco Critique com `finish` abaixo de 8, e o gap ou os achados nomeiam pelo menos três dos sete sinais;
    - `new-checks` (regex em `last_message`, `match: contains`): `display-weight` e `accent-count` aparecem os dois, em qualquer ordem;
    - `fresh` (regex no rastro): cópia do `fresh.md` de `ui-review-critica-em-breve`;
    - `no-edits` (regex no arquivo): `index.html` como o scaffold deixou, no molde de `no-edits-index.md`.
  - `runs: 2`.
- [ ] **Step 2: RED.** Confirmar o custo. Run: `node tools/compare.mjs --skill ui-review --baseline-only --outside-sandbox`. Expected: algum braço falha em `tells`.
- [ ] **Step 3: Escrever** a seção dos sinais e as duas linhas da régua em `critique.md`. Se a `SKILL.md` §4 ("Here live the AI tells…") precisar citar a lista nova, cortar o mesmo tanto de bytes na mesma seção. Run: `wc -c skills/ui-review/SKILL.md`. Expected: até 10.000.
- [ ] **Step 4: GREEN.** Confirmar o custo. Run: `node tools/compare.mjs --skill ui-review --arms devorb,none --outside-sandbox --runs 2`. Expected: `accepted: true`, e `ui-review-critica-em-breve` sem regressão. `regressions` ou `belowBar` voltam ao Step 3.
- [ ] **Step 5: Caso reservado.** Despachar um subagente novo que nunca viu `critique.md` nem este rascunho. O brief leva só o Pilar B da spec (os sinais) e o formato de `evals-reserved/`. Ele escreve `evals-reserved/ui-review-<slug>/`, dentro do sandbox, sem navegador (o caminho "from code"). Quem escreve a skill não abre a pasta.
- [ ] **Step 6: Rodada reservada.** Confirmar o custo. Run: `node tools/compare.mjs --skill ui-review --arms devorb,none --reserved`. Expected: `accepted: true`, com os reservados da Fase 1 sem regressão. Lacunas vão para o ledger.
- [ ] **Step 7: Ledger e commit.** Origem dos sinais: estudos A e B. Registrar resultados e custos. Run: `npm test`. `git commit -m "feat(ui-review): the critic scores generated-page tells"`

### Task 9: Biblioteca das referências em `ui-sources.json`

**Files:**
- Modify: `skills/visual-direction/references/ui-sources.json`:
  - 22 entradas novas;
  - Awwwards e Minimal Gallery com `reading: "browser"`;
  - uma regra nova: ofereça primeiro as entradas `reference`, filtradas pelo estilo e desempatadas pelo setor, e depois as páginas `byStyle` das galerias; das referências só se guardam URL, números medidos e descrições nossas.
- Modify: `skills/visual-direction/references/sources.md` (uma linha com a mesma ordem)
- Test: `tests/ui-sources.test.mjs`
- Modify: `fusion/ledger/visual-direction.md`

**Seam:** `tests/ui-sources.test.mjs` sobre o JSON e o `urls.txt`.

**Interfaces:**
- Consumes: `parseUrls` (Task 4) para ler `urls.txt`.
- Produces, para a Task 11:
  - forma da entrada: `{ name, from: 'reference', url, kind: 'reference', for, styles, sectors, uses, license: 'Third-party site: study only, never copy its text, images or logo', access: 'free', reading: 'browser' }`;
  - `SECTORS = ['saas', 'devtools', 'fintech', 'restaurante', 'agencia', 'portfolio', 'editorial', 'ecommerce']`;
  - `USES = ['landing', 'product-page', 'coming-soon', 'institutional']`;
  - `styles` só com os que já existem.
  - Mobbin continua como a entrada `screens` que já existe e não é duplicada (Call 8). A linha `mobbin` de `urls.txt` aponta para ela.
  - Etiquetas: `styles` / `sectors` / `uses`. Melius e Audienceful não foram estudados: as etiquetas e o `for` deles saem dos prints do `refs-check` (Task 4), olhados antes de escrever.

    | slug | styles | sectors | uses |
    |---|---|---|---|
    | framer | product, bold | saas | landing, product-page |
    | bordo | clean | restaurante | institutional |
    | shopify-editions | bold, animated | ecommerce, editorial | landing |
    | orior | clean, ai | saas | landing |
    | interfere | clean, product | devtools | landing |
    | aave | clean, animated | fintech | landing |
    | aifont | playful | editorial | product-page |
    | hoy | clean, animated | saas | landing |
    | monocle | clean | saas | landing |
    | billow | clean | saas | landing |
    | futureagi | bold, ai | devtools | landing |
    | onlines | playful, bold | agencia, portfolio | institutional |
    | sol | clean, ai | saas | landing |
    | patensify | playful | saas | coming-soon |
    | raycast-keyboard | bold, product | devtools, ecommerce | product-page |
    | parloa | clean, ai | saas | landing |
    | accessgrid | clean, product | devtools | landing |
    | staycloud | bold | devtools, ecommerce | landing |
    | vercel | clean | devtools | landing |
    | agenciadevalor | bold | agencia | landing |

- [ ] **Step 1: Testes que falham** em `tests/ui-sources.test.mjs`:
  - `KINDS` ganha `'reference'`, e uma lista `REFERENCES` com os 22 nomes é igual a `names('reference')`. A soma total ganha `+ REFERENCES.length`.
  - `every reference in urls.txt is in the library`: cada URL de `parseUrls(urls.txt)`, sem a barra final, é o `url` de alguma entrada; isso inclui a Mobbin.
  - `every reference is complete`: `reading === 'browser'`, pelo menos um estilo que existe, pelo menos um setor de `SECTORS`, pelo menos um uso de `USES`, `for` preenchido e nenhum `byStyle`.
  - `a clean brief has a gallery it can read without a browser` sai. Entram `galleries and references read only in a browser` e `a clean brief has at least four references to offer`.
  - `the guide's order travels with the list`: as `rules` citam `reference` e `byStyle`.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/ui-sources.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Escrever** as 22 entradas. Cada `for` é uma linha nossa sobre o que estudar ali, a partir dos estudos A e B, por exemplo "two-tone headline, real product UI cropped at the fold". Depois a regra e a linha em `sources.md`.
- [ ] **Step 4: Rodar e ver passar.** Run: `npm test`. Expected: PASS.
- [ ] **Step 5: Commit.** `git commit -m "feat(visual-direction): the owner's 23 references in the source library"`

### Task 10: Estudo de movimento e o dial (`motion`, ciclo leve)

**Files:**
- Create: `tools/motion-study.mjs`, `tools/motion-in-page.js` (script de navegador sem import)
- Test: `tests/motion-study.test.mjs`
- Create: `skills/motion/references/dial.md`
- Modify: `skills/motion/SKILL.md`: uma linha em §1 ("a page's contract `Motion level` picks its row in `references/dial.md`") e uma linha na tabela de References
- Create: `evals/motion-nivel-suave/`
- Modify: `fusion/ledger/motion.md`

**Seam:** as funções puras `staggerOf` e `summarize` de `motion-study.mjs` e `hoverTargets` de `motion-in-page.js` (por vm); o eval por `compare.mjs --skill motion`.

**Interfaces:**
- Consumes: `parseUrls` (Task 4), `resolvePlaywright` de `shoot.mjs`.
- Produces:
  - `type MotionSample = { source: 'load' | 'scroll' | 'hover', kind: 'animation' | 'transition', property: string, duration: number, delay: number, easing: string, target: string }`.
  - `window.__devorbMotion(source): MotionSample[]` lê `document.getAnimations()` (`effect.getTiming()`, e `transitionProperty` nas transições).
  - `window.__devorbHoverTargets(max = 20): { x: number, y: number }[]`:
    - junta os seletores com `:hover` das folhas de estilo, pulando as que lançam ao ler `cssRules`;
    - tira o `:hover`, roda `querySelectorAll` (seletor inválido é pulado) e devolve o centro dos elementos visíveis.
  - `window.__devorbMotionLibs(): string[]` lista o que estiver presente entre `gsap`, `ScrollTrigger`, `lenis` e `framer` (atributos `data-framer-*`).
  - `staggerOf(delays: number[]): number | null`: a mediana das diferenças positivas entre os atrasos únicos em ordem; `null` com menos de 2 atrasos.
  - `summarize(samples: MotionSample[]): { count: number, duration: { min: number, median: number, max: number }, easings: [string, number][], staggerMs: number | null }`, com `easings` nos 5 mais frequentes.
  - CLI `node tools/motion-study.mjs [--only a,b] [--out <dir>] [--pw <dir>]`:
    - padrão: `aave`, `hoy`, `vercel`, `framer` e `raycast-keyboard`, de `urls.txt`;
    - por site, a 1440: carregar, ler (`load`), rolar em passos de 80% da janela lendo a cada passo (`scroll`), passar o mouse por cada alvo e ler depois de 100ms (`hover`);
    - grava `<out>/<slug>.json` e `<out>/summary.md`;
    - `out` padrão em `tmpdir()`, nunca dentro do repositório.

- [ ] **Step 1: Testes que falham:**
  - `staggerOf([0, 40, 80, 120])` dá 40, `staggerOf([0, 0])` dá `null` e `staggerOf([0, 30, 90])` dá 45.
  - `summarize` de 3 amostras (150, 250 e 400ms) dá a mediana 250 e o easing mais comum primeiro.
  - `hoverTargets skips a cross-origin sheet and an invalid selector`. Contexto vm com `document.styleSheets` assim: uma folha cujo getter `cssRules` lança `SecurityError`, uma com `.btn:hover` e uma com `::-moz-x:hover`. `querySelectorAll('.btn')` devolve um elemento visível. Esperado: 1 alvo, sem lançar.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/motion-study.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** e rodar até passar. Run: `node --test tests/motion-study.test.mjs` e `npm test`. Expected: PASS.
- [ ] **Step 4: Rodar o estudo.** Run: `node tools/motion-study.mjs --pw <pw>`. Precisa de rede e não tem custo de API.

  Expected: 5 resumos com duração, curvas, stagger e bibliotecas. Um site com `gsap` ou `ScrollTrigger` e poucas animações anda por script: anotar isso, e não ler como "sem movimento".

  Só se um site bloquear o navegador sem tela, pedir ao dono para usar o navegador dele (Call 9). Commit da ferramenta: `git commit -m "feat: headless motion study tool"`
- [ ] **Step 5: Caso RED** `evals/motion-nivel-suave` (dentro do sandbox).
  - **Scaffold:** uma landing editorial pronta e estática, com spec cujo contrato diz `Motion level: Suave`.
  - **Prompt:** "anima a entrada das seções dessa página conforme a spec. Hoje não respondo perguntas."
  - **Graders:**
    - `soft-level` (llm em `styles.css`, peso 3): toda entrada é fade com deslocamento de 4 a 12px, sem escala, rotação, parallax ou cena presa;
    - `reduced` (regex em `styles.css`): `prefers-reduced-motion`;
    - `timing` (llm em `styles.css`): entradas de até cerca de 300ms e cascata com total abaixo de 300ms.
  - RED: confirmar o custo. Run: `node tools/compare.mjs --skill motion --baseline-only`. Expected: algum braço falha em `soft-level`.
- [ ] **Step 6: Escrever `dial.md`.**
  - A tabela dos três níveis do Pilar 4 da Fase 1.
  - Os números de lá, com palavras nossas: abrir em cerca de 250ms e fechar em cerca de 150ms; cascata de cerca de 40ms, com total abaixo de 300ms; nunca quicar nem atrasar um fechamento.
  - Por nível, as faixas medidas no estudo (duração mediana, curvas, stagger), sem nomear site.
  - "Com referência, o ritmo dela é o que vale"; `prefers-reduced-motion` é obrigatório; React Bits e transitions.dev só por instalação do registry, em stack React, respeitando a licença.
  - Depois a linha em §1 e a da tabela. Run: `wc -c skills/motion/SKILL.md`. Expected: até 10.000.
- [ ] **Step 7: GREEN.** Confirmar o custo. Run: `node tools/compare.mjs --skill motion --arms devorb,none`. Expected: `accepted: true` e `motion-prumo-paleta-modal` sem regressão.
- [ ] **Step 8: Ledger e commit.** Origem: estudo próprio dos 5 sites e as regras públicas do transitions.dev, só a ideia. Resultados e custos. `git commit -m "feat(motion): motion dial with numbers measured on the references"`

### Task 11: O guia e o sorteio com histórico (`visual-direction`, ciclo completo, parte 2)

**Files:**
- Create: `skills/visual-direction/references/guide.md`
- Create: `skills/visual-direction/scripts/draw.mjs`
- Modify: `skills/visual-direction/SKILL.md`: passo novo `## 0. Guide` antes de §1, até 3 linhas apontando para `guide.md`; `Connects to` → Uses
- Test: `tests/design-draw.test.mjs`
- Create: `evals/visual-direction-guia-leigo/`
- Create: `evals-reserved/visual-direction-<slug>/`, por subagente novo
- Modify: `fusion/ledger/visual-direction.md`

**Seam:** as exportações de `draw.mjs` e a CLI; o eval por `compare.mjs --skill visual-direction`.

**Interfaces:**
- Consumes:
  - os ids da Task 7;
  - as entradas `reference` da Task 9;
  - `shoot.mjs` e `capture.mjs`, com `--widths 1440,390`;
  - `Motion level` e `dial.md` da Task 10.
- Produces:
  - `patternIds(markdown: string): string[]`, com a regex da Task 7.
  - `usedIds(texts: string[]): string[]`: os ids `(hero|section):[a-z0-9-]+` na ordem da última aparição, com os textos em ordem cronológica.
  - `draw(fits: string[], used: string[], count: number, rand = Math.random): string[]`:
    - primeiro os `fits` não usados, embaralhados por Fisher-Yates com `rand`;
    - depois os usados, do uso mais antigo para o mais recente;
    - corta em `count`.
  - CLI `node draw.mjs --fits <id,…> --count <n> [--specs <dir>]`:
    - `specs` padrão: `docs/devorb/specs`, lida em ordem de nome de arquivo; pasta ausente é histórico vazio;
    - imprime um id por linha;
    - um id fora dos arquivos de padrões sai com 1 e `UNKNOWN: <id>`.
  - `guide.md`, com o Pilar D da spec e o guia do Pilar 4 da Fase 1:
    - começa pelo que já se sabe e pergunta só o que falta, uma coisa por vez, sempre com recomendação e o porquê;
    - sem pessoa na conversa, decide pela recomendação e registra;
    - oferece de 4 a 6 referências `reference` filtradas pelo estilo e desempatadas pelo setor, e pede para abrir o navegador;
    - com o sim, roda `shoot.mjs` em cada uma, numa pasta temporária;
    - monta um `board.html` local, nunca commitado, com o print de 1440 de cada uma e a recomendação, e o abre;
    - o usuário escolhe uma, ou manda o próprio link, e ela vira pacote com `capture.mjs`;
    - nenhuma serve: as páginas `byStyle` das galerias; Godly e Recent só para ver;
    - para os padrões: listar os que cabem no modo e no material, rodar `draw.mjs` para a abertura e para as seções, escolher entre os sorteados com a razão, e gravar os ids no contrato;
    - o nível de movimento sai do dial.

- [ ] **Step 1: Testes que falham** em `tests/design-draw.test.mjs`:
  - `patternIds` dos dois arquivos dá 10 e 12 ids.
  - `usedIds(['… hero:a … section:b', '… hero:a'])` dá `['section:b', 'hero:a']`.
  - `draw(['hero:a', 'hero:b', 'hero:c'], ['hero:b'], 2, () => 0)` não traz `hero:b`.
  - Com `fits` todos usados, `draw` devolve primeiro o mais antigo.
  - A CLI numa pasta temporária com duas specs que citam `hero:centred-product-halo`, e `--fits hero:centred-product-halo,hero:object-cut-by-fold --count 1`, imprime `hero:object-cut-by-fold`.
  - `--fits hero:nope` sai com 1 e `UNKNOWN: hero:nope`.
- [ ] **Step 2: Rodar e ver falhar.** Run: `node --test tests/design-draw.test.mjs`. Expected: FAIL.
- [ ] **Step 3: Implementar** `draw.mjs` e rodar até passar. Run: `node --test tests/design-draw.test.mjs`. Expected: PASS.
- [ ] **Step 4: Caso RED** `evals/visual-direction-guia-leigo` (dentro do sandbox).
  - **Scaffold:** a spec aprovada da landing de uma clínica de fisioterapia, sem `## Direção visual`, sem material e sem `DESIGN.md`.
  - **Prompt:** "a spec da landing está aprovada; agora quero o visual. Não entendo nada de design."
  - **Graders:**
    - `one-question` (llm em `last_message`, peso 2): uma única pergunta ao usuário, com recomendação e o porquê;
    - `offers-refs` (llm em `last_message`, peso 3): oferece abrir de 4 a 6 referências pelo nome de site, para o usuário escolher, pedindo licença para abrir o navegador ou já mostrando os prints;
    - `no-build` (regex no rastro, `match: not_contains`): nenhum `Write` em `.html` ou `.css`.
  - `runs: 2`.
- [ ] **Step 5: RED.** Confirmar o custo. Run: `node tools/compare.mjs --skill visual-direction --baseline-only`. Expected: algum braço falha em `offers-refs` ou `one-question`.
- [ ] **Step 6: Escrever** `guide.md` e o passo 0. Run: `wc -c skills/visual-direction/SKILL.md` e `npm test`. Expected: até 10.000 e PASS.
- [ ] **Step 7: GREEN.** Confirmar o custo. Run: `node tools/compare.mjs --skill visual-direction --arms devorb,none`. Expected: `accepted: true`, com `receitas-landing`, `arquitetura-clean` e `clinica-serena` sem regressão. Depois rodar o caso de cópia: `node tools/compare.mjs --skill visual-direction --arms devorb,none --outside-sandbox --runs 2`, de novo com o custo confirmado. Expected: `visual-direction-copia-referencia` sem regressão.
- [ ] **Step 8: Caso reservado.** Um subagente novo, que nunca viu as receitas, o guia nem este rascunho, recebe só os Pilares B a D da spec e o formato de `evals-reserved/`. Ele escreve `evals-reserved/visual-direction-<slug>/`, dentro do sandbox. Confirmar o custo. Run: `node tools/compare.mjs --skill visual-direction --arms devorb,none --reserved`. Expected: `accepted: true`, com os reservados das fases anteriores sem regressão.
- [ ] **Step 9: Ledger e commit.** Origem: o sorteio com histórico vem da taste-skill, só como ideia; a ordem do guia vem da spec. Resultados e custos. `git commit -m "feat(visual-direction): guide offers the references and draws patterns with history"`

### Task 12: Fechamento da fase

**Files:**
- Modify: `CHANGELOG.md` (entrada da Fase 2, em português; o número da versão e o `plugin.json` ficam com o `devorb:finishing`)
- Modify: `docs/specs/2026-11-08-devorb-design.md:256` §Setor de design: uma linha apontando para a spec da Fase 2
- Create: `fusion/results/2026-11-18-design-quality-fase-2.md`: custo real de cada rodada paga contra o teto do dono, o resumo final do `refs-check` (23/23) e os números do estudo de movimento

**Seam:** `npm test`.

- [ ] **Step 1:** Escrever as três mudanças.
- [ ] **Step 2:** Run: `npm test`. Expected: PASS.
- [ ] **Step 3:** Run: `node tools/refs-check.mjs --pw <pw>` uma última vez no HEAD final. Expected: `refs-check: 23/23 PASS`.
- [ ] **Step 4: Commit.** `git commit -m "docs: close design quality phase 2"`
