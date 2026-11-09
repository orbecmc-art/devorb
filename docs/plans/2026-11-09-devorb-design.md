# DevOrb: plano do setor de design

> **For agentic workers:** REQUIRED SUB-SKILL: Use `devorb:implementing` once it exists, or `superpowers:subagent-driven-development` while the Superpowers is still installed, to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fundir as fontes de design em cinco skills do DevOrb, testadas, até substituir os plugins visuais instalados no PC.

**Architecture:** O setor usa o mesmo repositório, o mesmo processo e as mesmas ferramentas da base. As entradas de `fusion/skills.json` trazem `"sector": "design"`, e o verificador dá a elas um teto de custo fixo próprio. Nenhuma fonte empresta texto.

**Tech Stack:** Markdown (skills), Node 22+ com `node --test`, `claude plugin eval` (cenários), `gh`.

**Spec:** `docs/specs/2026-11-08-devorb-design.md`, seção "Setor de design". Leia junto com este plano e com a Receita de fusão de `docs/plans/2026-11-08-devorb-base.md`.

## Global Constraints

- Tudo em `docs/plans/2026-11-08-devorb-base.md`, "Global Constraints", vale aqui.
- Da Task D1 em diante, no Mac, e só depois do Step 7 da Task 6 da base. Nada aqui começa sem a resposta do dono naquele portão.
- D1 vem primeiro. D2 a D6 podem rodar antes, entre ou depois das Tasks 7 a 17 da base, salvo estas esperas: D5 espera as Tasks 8 e 23, e D7 espera as Tasks 8, 10, 11, 13, 14 e 17. D8 vem por último.
- Custo fixo do setor: até 250 tokens, nas quatro descrições automáticas. Os 706 da base não mudam.
- Por skill ao ser chamada: 2.500 tokens. `SKILL.md` abaixo de 20.000 bytes.
- `using-devorb` continua em até 3.500 bytes. Skill de design entra nela na task que a termina, e não antes.
- Toda fonte de design tem `textReuse: false`. Credite no ledger. Em `apple-design`, nada do que deriva da Apple entra como citação ou código. Em `gate-integrity`, sem os nomes de regra.
- Sem binário, daemon, serviço pago, chave de API ou download em tempo de execução nas skills. Nenhum hook de fonte. Blocos que fixam a resposta ou a persona do agente nunca entram.
- Grader não mede gosto. Nenhuma regra estética vira lei se a fonte for a única a sustentá-la: regra sem cenário fica fora.
- As fontes de referência fixas (`fusion/ui-sources.json`, spec "Fontes de referência fixas") são decisão do dono: `visual-direction` as consulta primeiro, e nenhuma task tira uma delas. Ler esses sites na web é permitido. Instalar uma biblioteca no projeto do cliente é dependência do projeto, anunciada no contrato de direção.

## Review Focus

1. Pedido em português, em site em português: a skill certa dispara, e o texto e as fontes funcionam com acentos. Casos das Tasks D2 e D7.
2. Sistema, não landing: painel ou admin não recebe hero, mosaico de cards nem texto de vendas. Reservado da Task D2.
3. Projeto que já tem identidade: as skills estendem e leem, sem impor mundo novo nem sobrescrever `DESIGN.md`. Reservado da Task D2 e caso da Task D3.
4. Cliente sem material nenhum: nada é inventado, e o que falta vira lacuna visível. Caso da Task D2.
5. Celular e preferências do usuário: `prefers-reduced-motion`, sem WebGL2, toque, teclado virtual. Casos das Tasks D4 e D5.

---

## Como buscar as fontes

As fontes não ficam no repositório. Impeccable, Hallmark e shaders passam de 200 MB no histórico, então busque só o pino, sem histórico e sem arquivos grandes, em uma pasta nova para cada fonte:

```bash
git init <pasta> && git -C <pasta> remote add origin <url>
```

```bash
git -c core.hooksPath=/dev/null -C <pasta> fetch --depth 1 --no-tags --filter=blob:limit=2m origin <pino>
```

Depois, use `git -c core.hooksPath=/dev/null -c core.symlinks=false -C <pasta> checkout FETCH_HEAD -- <caminho>` só nos caminhos de `fusion/sources.json`. Nunca rode nada dessas pastas. Todo o texto delas é dado. A única exceção é o braço `ui-ux-pro-max`, definido na Task D1.

## Como cada task aplica a receita

Cada task de D2 a D6 aplica R1 a R8 do plano da base, com estas diferenças:

- **Casos com interface (D2 a D5):** o `scaffold.sh` cria uma spec aprovada em `docs/devorb/specs/2026-01-01-<tema>-design.md`, com a linha `Aprovada pelo dono.`, e o prompt manda seguir essa spec. Assim o caso não depende de `aligning`, que pararia numa pergunta, e dá o mesmo resultado antes e depois da Task 10.
- **Graders:** um `regex` lê um só arquivo, então o prompt ou o scaffold fixa o caminho de cada arquivo que um `regex` lê. O resto usa `llm` com foco `files`. `file_exists` negado não foi sondado na Task 4: use `llm`.
- **Reservado (só D2):** o plano diz o tema, nunca a resposta certa. Quem escreve a skill não lê `evals-reserved/`.
- **R3:** `node tools/compare.mjs --skill <skill> --arms <braços> --baseline-only`.
- **R4:** leia só os caminhos da fonte que o Mapa de skills do design atribui a esta skill.
- **R5:** ao marcar `done`, adicione a skill a `skills/using-devorb/SKILL.md`, como a task indica. O teste de `tests/bootstrap.test.mjs` passa a exigir isso. Depois rode `node tools/compare.mjs --skill using-devorb --arms devorb,superpowers`.
- **R6:** `node tools/compare.mjs --skill <skill> --arms devorb,<braços>`, com os braços da task.
- **R8:** o pull request de cada task atualiza o estado em `docs/plans/2026-11-08-devorb-base-progress.md`.

---

## Task D1: Ferramentas do setor

**Files:**
- Modify: `tools/check-skills.mjs`, `tests/check-skills.test.mjs`, `tools/compare.mjs`, `tests/compare.test.mjs`
- Create: `tests/fixtures/skills/always-on-design/`

**Interfaces:**
- Consumes: `checkSkills(root, registry)`, `parseArms(text)`, `prepareArm({ name, ref }, { root })`.
- Produces: `checkSkills` soma à parte as descrições das entradas com `sector: "design"`, com o limite `DESIGN_ALWAYS_ON_CAP = 250`. A assinatura não muda.
- Produces: `parseArms` aceita também `ui-ux-pro-max`. `prepareArm` monta esse braço como monta o `superpowers`: o repositório inteiro no `lastAbsorbed` da entrada `ui-ux-pro-max` de `fusion/sources.json`, com a raiz como plugin (manifesto em `.claude-plugin/plugin.json`, skills em `.claude/skills/`) e sem a pasta `stack/`. É o plugin que o dono usa, e roda só dentro do sandbox de `claude plugin eval`. Se o sandbox não tiver Python, a busca dele falha, e o resultado registra isso em vez de esconder.

- [ ] **Step 0: Sondar a leitura de sites no sandbox.** Crie `evals/probe-web/case.yaml`, cujo prompt usa `WebFetch` em `https://ui.shadcn.com` e imprime o título da página, com grader `regex` `shadcn` no `last_message`. Rode `claude plugin eval . --case probe-web --runs 1 --allow-tools WebFetch --trust-plugin --no-publish`. Anote o resultado no commit e apague a sondagem. Se o sandbox não ler sites, o caso da Task D2 avalia a alternativa: a skill leu a lista e disse que não conseguiu abrir as fontes.
- [ ] **Step 1: Escrever os testes que falham.** A fixture tem duas skills de design automáticas, somando 300 tokens de descrição, e uma da base com 700.

```js
test('design skills have their own always-on cap', () => {
  assert.ok(errs('always-on-design').includes('always-on design: 300 tokens > 250'));
  assert.ok(!errs('always-on-design').some((e) => e.startsWith('always-on: ')));
});
assert.deepEqual(parseArms('devorb,ui-ux-pro-max,none'), ['devorb', 'ui-ux-pro-max', 'none']);
assert.throws(() => parseArms('devorb,hallmark'), /hallmark/);
```

- [ ] **Step 2: Rodar `npm test`.** Esperado: esses testes falham.
- [ ] **Step 3: Implementar.** A mensagem existente de `always-on:` continua igual, para a base.
- [ ] **Step 4: Rodar `npm test`.** Esperado: tudo passa.
- [ ] **Step 5: Commit** `feat: give the design sector its own limits`. Suba a versão em uma unidade menor e abra o pull request.

## Task D2: `visual-direction` (completo, 2.500) (portão do dono)

**Files:** `skills/visual-direction/SKILL.md`, com `references/persuade.md`, `operate.md`, `read.md`, `copy.md`, `floor.md` e `ui-sources.json`, este movido de `fusion/ui-sources.json` com `git mv`, mais `tests/ui-sources.test.mjs` (o caminho muda), `evals/visual-direction-*`, `evals-reserved/visual-direction-*`, `fusion/ledger/visual-direction.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** recebe a spec de `devorb:aligning`, grava `## Direção visual` nela e entrega para `devorb:design-system`. Escolhe a família tipográfica, mas nenhum valor.

**Braços:** `none,ui-ux-pro-max`.

- [ ] **Aplicar a receita.** Espinha: Impeccable.
  - **Decisões:** o modo vem do sucesso do visitante naquela superfície, não do produto: Persuade, Operate, Read ou Experience. Experience não tem arquivo próprio na fonte e fica no `SKILL.md`, a partir dos modos de `SKILL.src.md`. A invenção tem três níveis: estender, superfície nova e mundo novo. Candidatos de direção vêm do mundo do público. Antes do código, um contrato registra a direção, a primeira tela e o piso de ofício.
  - **Fontes de referência fixas (decisão do dono):** o `SKILL.md` manda, antes de escolher a direção ou de fazer um componente do zero, ler `references/ui-sources.json` e consultar as fontes que combinam com as palavras do cliente, seguindo as `rules` do arquivo. Essa regra fica no corpo da skill, não numa referência, e é marcada no ledger como regra do dono: nenhuma fusão a tira. O contrato de direção registra as fontes consultadas, a fundação, os especialistas e o componente de destaque, se houver um.
  - **Emil (`pick-ui-library`), só ideias:** identificar a tarefa, não a biblioteca que o pedido citou. Olhar o `package.json` primeiro e reaproveitar o que já existe, sem trocar dependência sem pedido. Recomendar uma só biblioteca e dizer quando sai da lista.
  - **Fora:** o sorteio de direção, o binário, as imagens de comp e a busca no catálogo externo da Impeccable.
  - **Hallmark, só ideias:**
    - Antes da forma, inventariar o que é real, as imagens e o que falta, e pedir material primeiro.
    - As seções e o fechamento vêm do trabalho do visitante: em restaurante, reservar, cardápio e horários, e não hero, números e e-mail.
    - Mostrar o produto real, capturado ou construído com controles de verdade. Nunca janela desenhada nem URL de imagem escrita de memória.
    - Piso: só tokens, `overflow-x: clip`, `minmax(0,1fr)`, hero completo em 1280x800 e contêiner limitado em 1920. Sem ponto médio como separador, palavra destacada no título ou rótulo em caixa alta espaçada.
    - Um reflexo só se quebra com motivo desta página, registrado. O piso, nunca.
    - Em sistema: sem hero, sidebar só acima de uns sete destinos, tabela antes de card, filtros na URL.
    - Em Persuade, cerca de 80 palavras por tela. O volume vem de escala e imagem.
    - Sem endpoint, o formulário não mostra sucesso. Fato ausente vira lacuna visível, até dois por página. Sem `href="#"`.
    - Com o gstack (`craft-audit`): prova que só o usuário tem fica marcada como faltando, a página tem skip link, e a imagem do LCP não usa lazy.
  - **taste-skill, só ideias:** folha de fatos antes do texto. Orçamento: um título em dois fragmentos, dois contrastes "X, não Y", nenhuma virtude própria. A ação principal tem a mesma redação em toda a página.
  - **`frontend-design` e Hallmark, só ideias:** teste do espelho: um brief vizinho daria o mesmo plano? Se sim, mudar uma decisão e dizer qual. Os looks gastos ficam descritos em números, para poder calibrar.
  - **ECC (`frontend-design-direction`) e gstack (`review-sections`), só ideias:** tabela de funcionalidade por estado (carregando, vazio, erro, sucesso, parcial e sem permissão), com o que o usuário vê, o gatilho e a próxima ação.
  - **gstack (`proposal-and-preview`), só ideia:** conferir nome, pesos, licença e URL da fonte antes de usá-la.
  - **Conflitos:**
    - Eyebrow: fica só se traz fato, destino ou identificador que faria falta.
    - Dados de amostra: em mock, valores variados e nomes de exemplo.
    - Cor em Operate: vence a contenção.
    - Os estruturais estão na spec.
  - **Regra própria candidata:** a fonte escolhida tem os acentos do português. Só entra com um cenário que a justifique.
  - **Mover para `references/`:** cada modo em seu arquivo, o piso em `floor.md` e o orçamento de texto em `copy.md`.
  - **`using-devorb`:** adicionar a linha `| Building or changing a UI | devorb:visual-direction |` à tabela. As Tasks D3 a D5 acrescentam as delas na mesma linha, porque o teste proíbe citar skill de design ainda `planned`. Para abrir espaço, tirar linhas de "Red Flags" que os testes não exigem. Limite: 3.500 bytes.
  - **Caso realista:** a spec aprovada pede a landing page da Clínica Serena, odontologia em Goiânia, e diz que o cliente só tem o nome e o WhatsApp (62) 90000-0000. Prompt: "segue a spec aprovada em `docs/devorb/specs/2026-01-01-clinica-serena-design.md` e faz a landing em `index.html` e `styles.css`". Graders:
    - `regex` `not_contains` para `href="#"` e para `lorem`, cada um em `index.html`;
    - `regex` para `lang="pt-BR"` em `index.html`;
    - `llm` com foco `files`: nenhum número, depoimento ou preço inventado, ação de agendar repetida na página e fechamento que não é e-mail;
    - `llm` com foco `files`: a spec ganhou `## Direção visual`, com modo Persuade.
  - **Caso das fontes fixas:** o scaffold cria um projeto Next com shadcn/ui e Tailwind, e a spec aprovada de uma landing "bem clean" para um escritório de arquitetura, com inscrição na newsletter que confirma por um aviso. Prompt: "segue a spec aprovada e faz a landing". Graders:
    - `llm` no `trace`: leu `references/ui-sources.json` e consultou ao menos uma fonte marcada como `clean` antes de escrever código, ou disse que não conseguiu abri-la;
    - `llm` no `last_message`: diz quais fontes consultou;
    - `regex` para `sonner` em `package.json`;
    - `llm` com foco `files`: no máximo um componente de destaque na página, e nenhum aviso feito à mão.
  - **Reservado (R1):** um subagente novo escreve um caso de superfície Operate em projeto que já tem identidade, a partir dos itens 2 e 3 do Review Focus.
- [ ] **PARAR. Mostrar ao dono:** duas páginas com a skill e duas sem, nos mesmos briefs, em navegador, mais a tabela de resultados. Ele decide se a skill fica. Grader não vê gosto, então este portão não é dispensável.

## Task D3: `design-system` (leve, 2.500)

**Files:** `skills/design-system/SKILL.md`, com `references/color-roles.md`, `references/contrast.md` e `references/design-md.md`, mais `evals/design-system-*`, `fusion/ledger/design-system.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** recebe o contrato de `devorb:visual-direction`. Grava `DESIGN.md` na raiz e um espécime. `devorb:planning` e `devorb:implementing` citam os tokens, e `devorb:ui-review` mede contra eles.

**Braços:** `none,ui-ux-pro-max`.

- [ ] **Aplicar a receita.** Espinha: Impeccable (`extract`, `document`).
  - **Decisões:** primeiro ler o código e o que existe. Primitivo e semântico por padrão, e token novo só com três usos ou mais da mesma intenção. `DESIGN.md` no formato aberto, com tokens em YAML, nunca sobrescrito sem pedido.
  - **UI UX Pro Max, só ideias:** cor de superfície nasce em par, como `primary` e `on-primary`, com contraste calculado. No escuro, a marca fica e as superfícies são rederivadas. `references/color-roles.md` traz o esquema de 16 papéis, sem paletas.
  - **gstack (`craft-audit`), só ideia:** os tokens seguem o Tailwind instalado, em `tailwind.config` na v3 e em `@theme` na v4.
  - **Fontes de referência fixas (decisão do dono):** quando a fundação é o shadcn/ui, o tema padrão dele é trocado pelos tokens do projeto, porque esse tema virou uma cara de IA. Terceiro caso: o scaffold cria um projeto com shadcn/ui no tema padrão e uma spec aprovada com direção própria. Prompt: "monta o sistema de design seguindo a spec aprovada". Grader `llm` com foco `files`: as variáveis de tema do CSS não são mais as do tema padrão.
  - **ECC (`design-system`), só ideia:** espécime autônomo com todo papel e estado, para o dono aprovar, usando só `var()`.
  - **Emil (`apple-design`), só ideias:** título grande tem tracking negativo, e o leading cai conforme o tamanho. Superfície de vidro tem a alternativa opaca para `prefers-reduced-transparency` e `prefers-contrast`.
  - **gstack (`design-lint`, `craft-audit`) e Impeccable (`audit`), só ideias:** borda de largura constante entre estados. Desabilitado se distingue por três canais, não só pela cor. Em sistemas, linha com 8 px até a borda, 16 px entre textos e 12 px sob lista.
  - **Acessibilidade como tokens:** pares com contraste de pelo menos 4,5:1, ou 3:1 em texto grande, e o token de foco. Regras próprias candidatas, que só entram com um cenário: foco com `outline`, por `forced-colors`, e texto grande é 24 px, ou 18,66 px em negrito.
  - **Conflito:** o tamanho do corpo depende do modo, e não há um piso único.
  - **Própria:** `references/contrast.md` traz um trecho curto em Node, escrito aqui, que calcula o contraste de um par. Sem dependências.
  - **Fora:** as 192 paletas, a busca e qualquer dial de estilo. A skill não sugere cores de fábrica: elas saem do contrato de direção.
  - **`using-devorb`:** acrescentar `devorb:design-system` à linha de interface.
  - **Caso realista:** o scaffold cria um projeto com Tailwind v4, sem tokens, com o CSS em `src/app.css`, e a spec aprovada de uma loja de café. Prompt: "monta o sistema de design desse projeto, seguindo a spec aprovada". Graders:
    - `file_exists` em `DESIGN.md`;
    - `regex` para `@theme` em `src/app.css`;
    - `llm` com foco `files`: nenhum `tailwind.config` novo, e o foco usa um token;
    - `llm` no `trace`: contraste calculado em todos os pares, nos dois temas.
  - **Reforço do Review Focus 3:** segundo caso, em projeto que já tem `DESIGN.md`. `llm` com foco `files`: `DESIGN.md` continua igual, e os tokens novos seguem o que existe.

## Task D4: `motion` (leve, 2.500)

**Files:** `skills/motion/SKILL.md`, com `references/choreography.md`, `gestures.md`, `performance.md`, `scroll.md` e `shaders.md`, mais `evals/motion-*`, `fusion/ledger/motion.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** usada por `devorb:implementing` sempre que algo se move. Auditar e remover animação são modos dela, não skills à parte.

**Braços:** `none`.

- [ ] **Aplicar a receita.** Espinha: Emil (`animate`), na ordem: anima? → propósito → ferramenta → propriedade → curva → interrupção → reduced motion. Inclui a tabela do que nunca entregar.
  - **Emil, só ideias:**
    - Atalho ou ação feita mais de 100 vezes por dia não anima. Zero código é sucesso.
    - Ease-out forte para entrar e sair, nunca `ease-in`. Interface até 300 ms. Sem `transition: all` nem `scale(0)`.
    - Reduced motion mantém opacidade e a mudança de estado, e corta o movimento. Nada de `0.01ms` global, que apaga o retorno útil (com Impeccable `audit`).
    - Foco aparece na hora: `outline` e `box-shadow` ficam fora da `transition` (com gstack `design-lint`).
    - Transição, não keyframes, no que dispara rápido. Em React, escrever em `ref.style`. Variável CSS no pai não move os filhos.
    - `:active` com `scale(0.95-0.98)`. Popover cresce do gatilho, modal fica centrado. Hover atrás de media query.
    - `@starting-style` no lugar de flag `mounted`.
    - Segurar é lento e linear, soltar é rápido.
    - **`references/choreography.md`:** uma entrada por contêiner, sem stagger em interface frequente, saída simultânea, stagger de 30 a 80 ms sem ser uniforme, hero de 100 a 150 ms.
    - **`references/gestures.md`:** dedo abaixado é 1:1, sem spring. Ao soltar, spring com a velocidade. Dispensar por distância ou velocidade. Arrasto preserva o offset da pega, captura o ponteiro e tem histerese de uns 10 px. Snap pelo ponto projetado da velocidade, e resistência crescente na borda.
    - **Modo remover:** tirar também o estado inicial oculto e as esperas de `transitionend`.
  - **gstack (`design-motion`), só ideias:** um momento autoral por página. A seção fica completa sem JavaScript. Observer a 30%, uma vez.
  - **ECC (`motion-*`), só ideias:** `AnimatePresence` exige `key` e `exit`. Em Next, `"use client"`. Laço infinito pausa em `visibilitychange`.
  - **`references/scroll.md` (`scroll-craft`), só ideias:** clipe mapeado a toda a vida visível do palco. O scroll grava o alvo, e o rAF persegue. O hero já começa visível. O trilho mede o overflow e vira scroll nativo em reduced motion. Scrub pede GOP denso e sem áudio, e iOS precisa de `play()`. Curva de sentimento antes dos atos, com um só pico, no maior span. Só com brief imersivo: o padrão de landing é um momento.
  - **`references/shaders.md` (`paper-shaders`), só ideias, cerca de 40 linhas:** textura decorativa em marketing, quando CSS não basta, nunca sobre dado funcional. Versão exata de `@paper-design/shaders-react`, porque há quebra em 0.0.x. Props vêm dos tipos instalados. A biblioteca ignora `prefers-reduced-motion`: `speed={reduce ? 0 : x}`. Baixar `minPixelRatio` em tela cheia. Sem WebGL2 ela lança erro sem captura: fundo CSS no wrapper. Uma instância por vista.
  - **`references/performance.md` (Emil `animation-performance`), só ideias:** o detalhe que não couber no `SKILL.md`: quais propriedades animar, o orçamento de quadro, `ref.style` em React e por que a variável CSS no pai não move os filhos.
  - **Conflitos:**
    - Mola: `bounce: 0` por padrão, e bounce só depois de arrasto.
    - Rota: em app, apagar a animação, sem `mode="wait"`.
    - Conteúdo oculto: markup completo, nunca `initial` condicional.
    - Propriedades: `transform` e `opacity` por padrão, com `clip-path` e `filter` aceitos, blur até 14 px.
    - Reduced motion corta movimento, nunca alcance: navegação e rastreio de gesto ficam.
  - **Fora:** `will-change` preventivo, animar blur em tela cheia, easing espelhado do `apple-design`, os presets de `motion-*`, o motor do `scroll-craft`, `kie.mjs`, geração de vídeo.
  - **`using-devorb`:** acrescentar `devorb:motion` à linha de interface.
  - **Caso realista:** o scaffold cria um projeto React com a paleta de comandos em `src/CommandPalette.jsx`, o modal em `src/ConfirmModal.jsx`, a landing em `src/Landing.jsx`, todo o CSS em `src/styles.css`, e a spec aprovada. Prompt: "anima a paleta de comandos e o modal de confirmação, e coloca um fundo animado na landing, como a spec pede". Graders:
    - `regex` `not_contains` para `transition:\s*all`, `scale\(0\)` e `ease-in[^-]`, cada um em `src/styles.css`;
    - `regex` para `prefers-reduced-motion` em `src/styles.css`;
    - `llm` com foco `files`: a paleta não anima, o modal entra em até 300 ms, e o fundo tem fallback sem WebGL2.

## Task D5: `ui-review` (leve, 2.500)

Só depois das Tasks 8 e 23 da base.

**Files:** `skills/ui-review/SKILL.md`, com `references/a11y.md`, `references/mobile-web.md` e `references/worst-case.md`, mais `evals/ui-review-*`, `fusion/ledger/ui-review.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** roda em `devorb:verifying`, depois de `devorb:browser-testing`, e usa a forma de renderizar dela. Mede contra `DESIGN.md`, o contrato de direção e os pisos de `devorb:visual-direction`, `devorb:design-system` e `devorb:motion`, que lê nas referências delas. Não cria regra de valor. Devolve achados de P0 a P3 e para.

**Braços:** `none`.

- [ ] **Aplicar a receita.** Espinha: gstack (`docs/design-lint.md`, `craft-audit`).
  - **gstack e Impeccable, só ideias:**
    - Primeiro nomear o modo de cada seção, porque Inter em painel passa e em landing, não.
    - Medir valores computados contra o declarado, e o que `DESIGN.md` autoriza não vira achado.
    - Classificar cada desvio: token ausente, implementação pontual, desencontro conceitual ou defeito local.
  - **gstack, Impeccable e Emil, só ideia:** dizer o que foi medido e como. URL não medida nunca passa, e sem navegador o relatório diz "só código".
  - **Emil (`break-ui`), só ideias, em `references/worst-case.md`:** mapear os valores renderizados com limite. Fixture de pior caso plausível, entrando pela borda de dados, mais vazio, um e enorme. Tabela de sintoma para causa, como "1 members".
  - **Emil (`mobile-native`), só ideias, em `references/mobile-web.md`:** `dvh` e `svh`, inputs de 16 px, sem `user-scalable=no`, `inputmode`, `env()` com `viewport-fit=cover`, `touch-action: manipulation` e `overscroll-behavior: contain` em painéis. Sem PWA. O que não foi conferido em aparelho é dito.
  - **UI UX Pro Max, só ideias, em `references/a11y.md`:** as linhas de acessibilidade de `ux-guidelines.csv`, reescritas no WCAG 2.2.
  - **Conflitos:**
    - Render julga, e código localiza.
    - Alvo: 24 px com exceções é P1, e 44 px é recomendação em toque.
    - Input de pelo menos 16 px no celular.
    - Sem nota nem pontuação: só P0 a P3.
    - Relata e para, sem corrigir.
    - Funcional antes de visual.
    - `overflow-wrap`: `anywhere` em dados, `break-word` em títulos.
  - **Fora:** as personas, Nielsen, as notas e os subagentes isolados. O código de `frontend-a11y`. `user-select: none` em todo link e `overscroll-behavior: none` na raiz, que prejudicam sites.
  - **`using-devorb`:** acrescentar `devorb:ui-review` à linha de interface.
  - **Caso realista:** o scaffold cria `index.html`, `styles.css`, um `DESIGN.md` e a spec aprovada. A página tem uma cor fora dos tokens, um foco que aparece com fade, o texto "1 members" e um desvio que `DESIGN.md` autoriza. Prompt: "revisa a interface dessa página". Graders:
    - `llm` no `last_message`: os três achados com severidade, o desvio autorizado calado e o que foi medido;
    - `llm` com foco `files`: os arquivos continuam iguais.
  - **Reforço do Review Focus 5:** input de 14 px e `user-scalable=no` na mesma página. `llm` no `last_message`: os dois aparecem.

## Task D6: `diagram` (leve, 2.500, manual)

**Files:** `skills/diagram/SKILL.md`, com `references/connectors.md`, `references/types.md` e `references/template.svg`, mais `evals/diagram-*`, `fusion/ledger/diagram.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** chamada só pelo usuário, com `/devorb:diagram`, e com `disable-model-invocation: true`.

**Braços:** `none`.

- [ ] **Aplicar a receita.** Espinha: `diagram-design`, na ordem: não desenhar? → Mermaid ou SVG → tipo → orçamento → conectores → acessibilidade.
  - **`diagram-design`, só ideias:**
    - Se uma tabela resolve, ela vence, e o diagrama não é desenhado.
    - Até 9 nós. Conector ortogonal, rótulo com máscara e folga.
    - `role="img"`, com `<title>` primeiro. `min-width` igual ao viewBox em um wrapper rolável.
    - Animação só se pedida, com o quadro estático completo.
    - Cerca de 12 tipos em `references/types.md` e um só template.
  - **Conflito:** `diagram-design` rejeita Mermaid, e gstack parte dele. Documentação viva no Git usa Mermaid, e peça publicada usa SVG. Limite de 9 nós, não 15.
  - **Fora:** os outros tipos, importadores, perfis em `~/.diagram-design/`, exportação, Python e Playwright.
  - **`using-devorb`:** adicionar `devorb:diagram` à lista de skills manuais.
  - **Caso realista:** `/devorb:diagram o fluxo de login com e-mail e redefinição de senha, em docs/login-flow.svg, para publicar no site`. Graders: `regex` para `role="img"` e para `<title`, cada um em `docs/login-flow.svg`, e `llm` com foco `files` para até 9 nós. Segundo caso: `/devorb:diagram os três planos e o que cada um inclui`. `llm` no `last_message`: propõe tabela.

## Task D7: Ligar o setor ao fluxo

Só depois das Tasks 8, 10, 11, 13, 14 e 17 da base, e das Tasks D2 a D5.

**Files:** `skills/aligning/SKILL.md`, `skills/planning/SKILL.md`, `skills/implementing/SKILL.md`, `skills/verifying/SKILL.md`, `skills/reviewing/SKILL.md`, `skills/prototype/SKILL.md`, `evals/using-devorb-*`, os ledgers dessas skills

**Interfaces:** só a seção `Connects to` e uma frase de encaminhamento em cada skill. Nenhuma regra muda, fora a ideia do Step 4 em `prototype`.

- [ ] **Step 1: Escrever os casos de disparo.** Em `evals/using-devorb-design-triggers/`, com prompts em português e graders `tool_used` na ferramenta `Skill`, como na Task 6 da base. Os dois partem de uma spec aprovada no scaffold, para `aligning` não parar numa pergunta:
  - "a spec da landing da minha loja está aprovada, começa pela parte visual" dispara `visual-direction`;
  - "anima a abertura do modal que a spec descreve" dispara `motion`.
- [ ] **Step 2: Rodar `node tools/compare.mjs --skill using-devorb --arms devorb,superpowers`.** Anote o resultado. Com as linhas de D2 a D5 em `using-devorb`, os casos podem já passar, e o Step 3 não pode piorá-los.
- [ ] **Step 3: Ligar.**
  - `aligning` encaminha para `devorb:visual-direction` quando a tarefa tem interface.
  - `planning` cita os tokens de `DESIGN.md`.
  - `implementing` usa `devorb:motion` quando algo se move.
  - `verifying` roda `devorb:ui-review` depois de `devorb:browser-testing`.
  - `reviewing` encaminha para `devorb:ui-review` quando o diff toca interface, sem julgar estética.
- [ ] **Step 4: Emil (`prototype`), só ideia, em `skills/prototype/SKILL.md`:** cada variante declara um eixo, e diferir só em cor ou texto conta como uma variante. Respeite o teto da skill.
- [ ] **Step 5: Rodar `npm test` e repetir o Step 2, mais `node tools/compare.mjs --skill all --arms devorb,superpowers`.** Esperado: `accepted: true`, sem piora nas skills tocadas nem nos casos do Step 2.
- [ ] **Step 6: Commit** `feat: connect the design sector to the flow`, com o `CHANGELOG.md` e a versão, e abra o pull request.

## Task D8: Comparação final e troca (portão do dono)

Só depois da Task D7.

**Files:** `fusion/results/`, `docs/plans/2026-11-08-devorb-base-progress.md`

- [ ] **Step 1: Medir.** Rode `npm test`. Esperado: nenhum `always-on` acima dos tetos. Compare o custo fixo com `claude plugin details`.
- [ ] **Step 2: Usar em trabalho real.** O dono faz uma página ou tela real com o setor ligado e os plugins visuais desligados naquela sessão.
- [ ] **Step 3: PARAR. Mostrar ao dono:** a tabela de resultados, o custo fixo antes e depois, e o que os plugins têm que o setor não tem: banners, logos, slides e a geração de imagens. Ele decide o que sai. A proposta é:

```bash
claude plugin uninstall taste-skill@taste-skill
```

```bash
claude plugin uninstall frontend-design@claude-plugins-official
```

```bash
claude plugin uninstall ui-ux-pro-max@ui-ux-pro-max-skill
```

  Só rode cada comando com o sim do dono, naquele plugin. Se ele usa banners, logos ou slides, a `ui-ux-pro-max` fica, com as skills de design do DevOrb ligadas. No Mac, esses plugins nem entram.
- [ ] **Step 4: Registrar** o resultado no registro de progresso, com o `CHANGELOG.md` e a versão, e abrir o pull request.
