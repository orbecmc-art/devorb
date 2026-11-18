# Ledger: `motion`

Skill automática de nível leve, da Task D4 do plano de design (`"sector": "design"`). Espinha: Emil (`animate`, MIT). Outras fontes: Emil (`choreograph`, `gestures`, `animation-performance`, `remove-animations`, `emil-design-eng`, `apple-design`), gstack (`design-motion`, `docs/design-lint.md`), ECC (`motion-foundations`, `motion-patterns`, `motion-advanced`), `scroll-craft`, `paper-shaders`, `gsap-skills`, Motion AI Kit, transitions.dev, genjutsu (`css-native`, `threejs-r3f`), Monich (`performance`, `animation-discipline`), Impeccable (`audit`) e three.js (`docs/llms.txt`). Todas com `textReuse: false`: só ideias, escritas com palavras próprias e creditadas aqui. Nenhum texto, tabela ou trecho delas entrou, e `LICENSES/NOTICE.md` não muda. Do transitions.dev, cuja licença proíbe redistribuir, não entrou nenhum valor nem snippet.

Pinos lidos, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos de `fusion/sources.json`, sem rodar nada:

- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/animate/SKILL.md`, `animation-performance/SKILL.md`, `choreograph/SKILL.md`, `gestures/SKILL.md`, `remove-animations/SKILL.md`, `emil-design-eng/SKILL.md`, `apple-design/SKILL.md`.
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`: `design-motion/SKILL.md.tmpl`, `design-motion/sections/motion.md.tmpl`, `docs/design-lint.md`.
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b`: `skills/motion-foundations/SKILL.md`, `motion-patterns/SKILL.md`, `motion-advanced/SKILL.md`.
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579`: `plugins/nateherk-design/skills/scroll-craft/references/devices.md`, `feel.md`, `verify.md`.
- `paper-shaders@e7003a2d4e6e932e30b8fa11ec1239e6ea48e16a`: `README.md`, `CHANGELOG.md`.
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760`: `skills/gsap-scrolltrigger/SKILL.md`, `gsap-react/SKILL.md`, `gsap-core/SKILL.md`, `gsap-plugins/SKILL.md`.
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb`: `plugins/motion/skills/motion/best-practices/react.md`, `base-ui.md`, `index.md`.
- `transitions-dev@20d70c1262bf721c0300c2946cbe1fc7605a555c`: `skills/transitions-polish/SKILL.md`, `build/templates/skill.md.tmpl`.
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`: `skills/_jutsu/css-native/SKILL.md`, `skills/_jutsu/threejs-r3f/SKILL.md`.
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808`: `installable/monich/references/performance.md`, `installable/monich/assets/templates/web-template/horizontal-craft/animation-discipline.md`.
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430`: `skill/reference/audit.md` (só a parte de movimento; o arquivo é de `ui-review`).
- three.js, não acompanhado: `docs/llms.txt` no commit `0a980dcf032223a274fcdd60ab56330f1321cca0`, lido com `gh api` (base64), sem clonar.

A skill foi escrita sem abrir `evals/motion-*`, `evals-reserved/` nem `fusion/results/`. O caso só é conhecido pelo texto da Task D4 no plano.

`SKILL.md` tem 8.833 bytes (cerca de 2.209 tokens, teto 2.500). A descrição custa cerca de 42 tokens dos 250 do setor. Nove referências em `references/`, cada uma com até 52 linhas; `shaders.md` e `three.md` com cerca de 40.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (algo na interface vai se mover, com os tipos, ou movimento a auditar ou remover) |
| Abertura: a skill decide se move e como, e é a única que escolhe duração e curva; usa os tokens do projeto | Fronteira da spec ("`motion` é a única que decide...") e Emil (`animate`, estender os tokens do projeto em vez de criar outros) |
| Três modos: construir, auditar, remover | Plano, Task D4 (auditar e remover são modos, não skills) |
| Espinha de sete passos, na ordem | Emil (`animate`, Build Sequence), por decisão da Task D4 |
| 1. Frequência decide: 100+ por dia ou teclado não anima; nenhum código é resultado válido | Emil (`animate` §1, `remove-animations`, The Gate), só ideias |
| Dado funcional só se move para mostrar mudança real de valor | Emil (`animate` §2 e `remove-animations`, Functional data) |
| Página de marketing: um momento autoral; a página fica completa sem JavaScript | gstack (`design-motion`, Motion doctrine), só ideia, por decisão da Task D4 |
| 2. Nomear o propósito; sem propósito, não construir | Emil (`animate` §2), reescrito |
| 3. Escada de ferramenta: `package.json` primeiro, CSS, Motion para saída, layout e gesto em React, GSAP para timeline pinada, texto dividido e morph de SVG; `motion` nunca junto de `framer-motion` | Plano, Task D4 (Motion AI Kit `react.md` e `index.md`, genjutsu `css-native` "When to Use", Emil `animate` §3), só ideias |
| `@starting-style` no lugar de flag `mounted`; keyframes para o que roda durante o carregamento; WAAPI | Emil (`emil-design-eng`, `animate` §3) e genjutsu (`css-native`), só ideias |
| Componente (aviso, gaveta, paleta) usa o especialista do contrato de direção; biblioteca nova nomeada no contrato | Emil (`animate` §3, remete a `pick-ui-library`) e a regra do dono em `visual-direction` |
| 4. `transform` e `opacity` por padrão, `clip-path` e `filter` aceitos, blur até 14 px | Emil (`animate` §4, `animation-performance`), gstack (`design-motion`, blur até 14 px), Motion AI Kit (`index.md`). Conflito resolvido |
| `height` só em disclosure pequeno | Emil (`animate` §4) e Motion AI Kit (`react.md`). Conflito resolvido |
| Sem `scale(0)`; deslocamento curto, mais de uns 40 px só em gaveta | Emil (`animate` §4) e transitions.dev (distância cresce com a cerimônia), só ideias; o limite de 40 px é do plano |
| Popover cresce do gatilho, modal centrado; `:active` com `scale(0.95-0.98)`; hover atrás de media query | Emil (`animate` §4 e §7, `emil-design-eng`), por decisão da Task D4 |
| Variável CSS no pai não move os filhos; `ref.style` em React | Emil (`animation-performance`, `gestures`), só ideia |
| 5. Ease-out forte, `ease-in-out` para atravessar a tela, `linear` só constante; nunca `ease-in` | Emil (`animate` §5), só ideia. O valor de exemplo `cubic-bezier(0.16, 1, 0.3, 1)` é a curva pública easeOutExpo (easings.net), escolha minha; não é tabela do Emil |
| Até 300 ms em modal, menu e aviso; até 500 ms em gaveta, página e momento único; 150 ms ou menos em hover e press | Plano, Task D4 (Emil `animate`, Motion AI Kit `index.md`); o teto de hover vem de Emil (`remove-animations`, Reducing) |
| Fechar mais curto que abrir, sem atraso nem overshoot, salvo pares simétricos | transitions.dev (`transitions-polish`, assimetria), só ideia, sem os valores |
| Mola com `bounce: 0`; bounce só ao soltar depois de arrasto | Emil (`gestures`), conflito resolvido |
| 6. Transição no que dispara rápido; mola com velocidade no gesto; sair por onde entrou; segurar lento e linear, soltar rápido | Emil (`animate` §6, `gestures`), só ideias |
| Laço infinito só com estado real; movimento automático acima de 5 s com pausa; laço pausa fora da tela e em `visibilitychange` | transitions.dev e genjutsu (plano), Monich (`animation-discipline`, WCAG 2.2.2), gstack (`design-lint`, autorotate) e ECC (`motion-advanced`, `visibilitychange`) |
| 7. Reduced motion corta movimento e mantém opacidade e mudança de estado; nada de `0.01ms` global | Emil (`animate` §7), Monich (`animation-discipline`) e Impeccable (`audit`, Motion sensitivity), só ideias |
| Reduced motion corta movimento, nunca alcance (navegação, trilho, rastreio de gesto) | `scroll-craft` (`devices.md`, pan) e Emil (`gestures`, reduced motion). Conflito resolvido |
| Foco na hora: `outline` e `box-shadow` fora da `transition` | gstack (`docs/design-lint.md`, focus-ring-fade), por decisão da Task D4 |
| Pôster estático para WebGL, canvas e vídeo | Plano, Task D4 (three.js, `paper-shaders`, `scroll-craft`) |
| Tabela do que nunca entregar | Emil (`animate`, Never Ship), refeita como tabela própria, com linhas do plano (foco, `0.01ms`, conteúdo oculto, `will-change`, WebGL, rota) |
| Modo auditar: listar, passar pelos passos e pela tabela, relatar sem mudar | Emil (`remove-animations`, Where to Hunt, só a lista de buscas) e o formato de relato da base (pior primeiro). O relato P0 a P3 é de `ui-review` |
| Modo remover: só subtrair; tirar estado inicial oculto, esperas de `transitionend`, `onExitComplete` e foco em callback; propor remover a biblioteca | Emil (`remove-animations`, Removal Hazards e Cleanup), por decisão da Task D4 |
| Saída em poucas linhas: linha do passo 1, ingredientes, o recusado e o que pede teste no celular | Emil (`animate`, Output), reescrito |
| `references/choreography.md` | Emil (`choreograph`): papéis, uma entrada por contêiner, sem stagger em interface frequente, saída simultânea, stagger de 30 a 80 ms não uniforme e total de 300 ms, hero de 100 a 150 ms, sequência só com sentido, interrupção, reduced motion colapsa |
| `references/gestures.md` | Emil (`gestures`, `apple-design` §5, §6, §9 e §10, `emil-design-eng`): rastreio 1:1, offset da pega, captura do ponteiro, histerese de 10 px, borda elástica, mola com velocidade, dispensar por distância ou velocidade, snap pelo ponto projetado. Sem a função de projeção nem os valores da Vaul |
| `references/performance.md` | Emil (`animation-performance`): orçamento de quadro, níveis de custo, trocas, onde roda, variável herdada, blur, `will-change` por último, ordem de diagnóstico. Motion AI Kit (`index.md`): sem alocar memória por quadro, o que perde a aceleração. Monich (`performance.md`): um laço só, sem scroll listener |
| `references/transitions.md` | transitions.dev (`skill.md.tmpl`, Common mistakes; `transitions-polish`, blur e assimetria) e genjutsu (`css-native`): acordeão por grid com padding no filho, chevron gira, indicador sem transição na primeira posição, blur fora do fade, `@starting-style` com `allow-discrete`, View Transitions com reduced motion próprio (também Monich). Nenhum valor ou snippet do transitions.dev; o CSS é meu |
| `references/motion-lib.md` | Motion AI Kit (`react.md`, `base-ui.md`, `index.md`): imports, `MotionConfig`, `AnimatePresence` montado, `popLayout`, `layoutId` com `useId()`, `Reorder` com teclado, saída em Radix e Base UI, motion values. ECC (`motion-patterns`, `motion-foundations`): `key` e `exit`, `"use client"`, `initial` igual ao servidor. Emil (`animation-performance`): aceleração a partir da 14.2 |
| `references/gsap.md` | `gsap-skills` (`gsap-scrolltrigger`, `gsap-react`, `gsap-core`, `gsap-plugins`): ScrollTrigger no topo e em ordem, `refresh()`, `scrub` ou `toggleActions`, filho do pinado, sem `markers`, `useGSAP` com `scope`, `ctx.revert()`, `contextSafe`, `gsap.matchMedia()`, SplitText depois das fontes e com `aria`, plugins gratuitos |
| `references/scroll.md` | `scroll-craft` (`devices.md`, `feel.md`, `verify.md`): clipe pela vida visível do palco, scroll grava o alvo e o rAF persegue, hero visível, trilho mede o overflow e vira scroll nativo, iOS e `play()`, curva de sentimento com um pico no maior span, foco em ato pinado, `100svh`. gstack (`design-motion`): observer a 30%, uma vez. genjutsu (`css-native`): `@supports` e `fill-mode: both`. Emil (`remove-animations`): reveal em toda seção é decoração |
| `references/shaders.md` | `paper-shaders` (`README.md`: textura de fundo, fixar a versão por quebra em `0.0.x`; `CHANGELOG.md`: troca para WebGL2 na 0.0.46, props que mudam de nome). Ignorar reduced motion, erro sem captura sem WebGL2 e `minPixelRatio` vêm do texto da Task D4: não estão no README nem no CHANGELOG lidos. A checagem de `webgl2` antes de montar e o motivo de uma instância por vista (limite de contextos) são meus |
| `references/dial.md` (Fase 2, Task 10) | Tabela dos três níveis e números de referência: Pilar 4 da spec da Fase 1 (`docs/specs/2026-11-17-design-quality-design.md`), cujos números são escritos com palavras próprias a partir das regras públicas do transitions.dev, só a ideia. Faixas por nível: estudo próprio, sem cabeça, de cinco sites de referência (`tools/motion-study.mjs`, sites da Call 2 da spec da Fase 2); entram só números medidos e descrições nossas, sem nome de site. Registry de React Bits e transitions.dev: Pilar 4 da Fase 1 |
| `references/three.md` | three.js (`docs/llms.txt`: `WebGLRenderer` padrão, `WebGPURenderer` com `init()` para TSL), genjutsu (`threejs-r3f`: CSS para inclinar, Canvas 2D, `dpr={[1, 2]}`, `Suspense`, `frameloop="demand"`, sem `setState` em `useFrame`, instâncias, Draco e KTX2, versão de Fiber por React) e Monich (`performance.md`: import dinâmico, `dispose()`). Pôster nos três casos é do plano |

## Conflitos resolvidos

- **Mola:** Emil (`animate`) aceita bounce de 0,1 a 0,3 e o Motion AI Kit dá exemplo com 0,2; Emil (`gestures`) reserva o bounce ao fim do arrasto. Pela Task D4, `bounce: 0` por padrão e bounce só ao soltar depois de arrasto.
- **Rota:** o ECC (`motion-patterns`) manda `mode="wait"` em troca de página; Emil (`remove-animations`) apaga animação de rota dentro do app. Pela Task D4, rota em app não anima, sem `mode="wait"`. `mode="wait"` fica só para duas vistas densas no mesmo contêiner (Emil `choreograph`).
- **Conteúdo oculto:** ECC e Motion AI Kit usam `initial` com opacidade zero; o gstack exige a seção completa sem script. Pela Task D4, markup completo, nunca `initial` condicional.
- **Propriedades:** Emil limita a `transform` e `opacity` (mais `clip-path`); gstack e Motion AI Kit aceitam `filter`. Blur: Emil abaixo de 20 px, gstack até 14 px. Pela Task D4, `transform` e `opacity` por padrão, `clip-path` e `filter` aceitos, blur até 14 px.
- **Reduced motion:** o ECC desliga todo transform; Emil e Monich mantêm opacidade e cor; o `scroll-craft` mostra que zerar o trilho esconde itens. Pela Task D4, corta movimento, nunca alcance.
- **Ferramenta padrão:** o `gsap-skills` recomenda GSAP para toda animação. Vence a escada, que começa no que está instalado e depois no CSS.
- **Altura:** o Motion AI Kit anima `height` até `auto`; Emil tolera só em acordeão. Pela Task D4, só em disclosure pequeno.
- **Cena pinada:** o Monich espera entrada coreografada em toda cena expressiva e o `scroll-craft` monta páginas inteiras de atos; o gstack pede um momento por página. Pela Task D4, vence o momento único; atos pinados só com brief imersivo.
- **Valores fixos de curva:** Emil manda tirar toda curva das tabelas dele. No DevOrb, os tokens do projeto vêm primeiro; sem token, a skill sugere um ease-out público. As tabelas de curva das fontes não entraram.
- **Durações:** Emil (UI abaixo de 300 ms, modal e gaveta até 500 ms), Motion AI Kit (150 a 300 ms, até 500 em superfície grande), gstack (50 a 700 ms em site) e Monich (mais de 500 ms é erro fora de troca de tela). Vale o teto do plano: 300 ms em modal, menu e aviso; 500 ms em gaveta, página e momento único.
- **Stagger:** o transitions.dev usa um passo fixo; Emil proíbe stagger uniforme. Vale Emil (plano): de 30 a 80 ms, variado.
- **Hover de saída:** o transitions.dev dá ao hover-out uma curva com overshoot. Vale a mola sem bounce: a saída pode assentar um pouco mais devagar, sem atraso nem overshoot.
- **Versão do three.js:** o `llms.txt` pede sempre a versão mais nova por import map. Vale a versão exata no `package.json` (plano).
- **Números do transitions.dev:** na Task D4, nenhum valor do transitions.dev entrou (licença sem redistribuição). Na Fase 2, `dial.md` traz os números redondos do Pilar 4 da spec aprovada da Fase 1 (abrir em cerca de 250 ms, fechar em cerca de 150 ms, passo de cerca de 40 ms, cascata abaixo de 300 ms), que o dono aprovou como ideia tirada das regras públicas, com palavras próprias. Não entra token, snippet nem tabela do transitions.dev.
- **Stagger medido contra a regra do passo 5:** o estudo mediu passos de 20 a 100 ms; a tabela do `SKILL.md` pede passos variados de 30 a 80 ms. No Equilibrado vale 40 a 80 ms com cascata abaixo de 300 ms; os passos de até 100 ms ficam no Impacto.

## Regras próprias

Nenhuma. As candidatas da spec ("O foco usa `outline`", e `animation-timeline` e View Transitions como lacuna) não viraram regra: a skill só exige que `outline` e `box-shadow` fiquem fora da `transition` (gstack, pela Task D4), e `animation-timeline` e View Transitions aparecem porque o plano os cita (genjutsu `css-native`, Monich). O valor de curva de exemplo e as checagens de WebGL2 antes de montar são ajustes de redação, não regras.

## Fora

- **Emil:** a resposta inicial fixa, as personas, o formato de revisão, as tabelas de curva e duração com valores, o `RECIPES.md` (não acompanhado), a curva e os tempos da Vaul, a função de projeção e a de rubber band em código, o "Sonner principles", as dicas de tooltip, o vocabulário. De `apple-design`: o easing espelhado, materiais, tipografia, som e háptica, e tudo o que deriva da Apple como citação ou código.
- **gstack:** o pipeline de vitrine do `design-motion` (histórias, ciclo em laço, exportação em MP4 e GIF, câmera), os tipos de carregamento com valores, os tokens de curva dele, os acentos de pulso e marquee, e os ids e números de regra do `design-lint` (são de `ui-review`).
- **ECC:** os presets de `motion-*`, o sistema de tokens e o hook `useSafeMotion`, os padrões prontos (contador, cursor, shimmer) e o limite de 0,2 s para a opacidade em reduced motion.
- **`scroll-craft`:** o motor, os atributos `data-sc-*`, o lerp e a zona morta com valores, o harness de verificação, `serve --lan`, `kie.mjs` e a contabilidade de créditos, a geração de vídeo.
- **`paper-shaders`:** a biblioteca em si (o projeto instala se quiser), os presets e as cores do exemplo, as notas de cada shader.
- **`gsap-skills`:** o texto que empurra GSAP para tudo, o catálogo de plugins fora de ScrollTrigger e SplitText (Physics, Pixi, ScrambleText, CustomWiggle), `ScrollSmoother`, `scrollerProxy`, `batch()` e `GSDevTools`.
- **Motion AI Kit:** MotionScore, o MCP e o gerador, que dependem do plano pago Motion+; os arquivos de Vue e vanilla e `css-or-motion.md`, que não são acompanhados; as instruções de auditar e corrigir sem perguntar.
- **transitions.dev:** os valores de duração, distância, escala, blur e curva, os snippets, o `_root.css`, os comandos `transitions *`, o painel Refine e o instalador que grava em `~/.claude` e roda `curl | bash`. A licença não deixa redistribuir.
- **genjutsu:** posicionamento por âncora, container queries, gradientes de malha, `sibling-index()`, o catálogo do drei, o pós-processamento, `audit.py` e `orchestration`.
- **Monich:** os templates, os modelos GLB de produtos reais, as receitas de estilo, a seção de handoff entre plataformas e a lista de mitos de pesquisa.
- **Impeccable:** o resto de `audit` (notas de 0 a 4, outros eixos), que é de `ui-review`.
- **three.js:** o import map por CDN com "sempre a mais nova", o guia de TSL e de materiais por nós.
- **Plano, Fora:** `will-change` preventivo, animar blur em tela cheia, geração de vídeo.

## Revisões

- 2026-11-13, conferência frase a frase contra cada fonte, depois da primeira escrita, com uma busca de sequências de 5 e 6 palavras iguais às fontes, mais leitura. Reescritas por estarem perto demais:
  - `SKILL.md`: a linha "dezenas de vezes por dia (hover, toggles)" (Emil `remove-animations`); "motion that must stay smooth while the page loads" (Emil `animate`); o título "Pick the properties" (Emil); "a CSS variable on a parent" (Emil `gestures`); "retarget from the current value; keyframes restart from zero" (Emil `animate`); o cabeçalho "Never / Instead" da tabela (Emil); a lista de buscas na ordem do Emil; "focus moved in an animation callback" e "bridges a jarring change" (Emil `remove-animations`).
  - `choreography.md`: "the one thing the user must notice", "a delay that happens to look right", "equal gaps read as mechanical", "direction follows", "`custom` on both", "step between its frames", "record and step through frame by frame; a wave and a queue" (Emil `choreograph`).
  - `gestures.md`: "a spring seeded with the release velocity", "a fast flick over a short distance", "the user is producing the motion" (Emil `gestures`).
  - `motion-lib.md`: a descrição de `reducedMotion="user"`, `popLayout` e `layout` (Motion AI Kit `react.md`); "stable, unique key" (Emil `choreograph`).
  - `performance.md`: o nome da linha "Composite only", o parêntese dos percentuais, "does it get worse as content grows", "costs GPU memory" (Emil `animation-performance`), a ordem das propriedades aceleradas (Motion AI Kit).
  - `scroll.md`: "content visible by default" (genjutsu `css-native`), "the stage's entire visible life" (`scroll-craft`), "hold content back" (Emil `remove-animations`).
  - `transitions.md`: "never on a plain fade" (transitions.dev) e o `scale(0.96)` do exemplo, que é um valor do transitions.dev, trocado por um valor meu.
  - `three.md`: "check the installed React major" (genjutsu `threejs-r3f`).
  - O que ainda casa são nomes de propriedade e de API, listas técnicas (`width`, `height`, `top`, `left`) e a media query de hover.
- 2026-11-13, Task M4 do plano mobile: `references/native.md` novo, só ideias, palavras próprias. Troca de aba não desliza; navegação segue a plataforma; Reanimated, não `Animated`, com valores compartilhados e sem `setState` por quadro; mola quando o dedo está no elemento; háptico no mesmo quadro da animação, nunca como único retorno; em Compose, animar dentro do lambda `graphicsLayer {}`. Fontes: Emil `skills/animate-expo/SKILL.md` (`emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`), genjutsu `skills/_jutsu/compose-motion/references/recomposition-and-anim.md` (`genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`) e `native-slop` (14) da Expo (`expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`), todas MIT, `textReuse: false`. `SKILL.md` ganha uma linha e uma linha da tabela de referências (8.833 para 8.943 bytes).
- 2026-11-18, Fase 2, Task 10: `references/dial.md` novo, com os três níveis (Suave, Equilibrado por padrão, Impacto), os números de referência, as faixas medidas por nível, a regra da referência ("o ritmo dela é o que vale"), `prefers-reduced-motion` obrigatório e React Bits e transitions.dev só por instalação pelo registry, em stack React, respeitando a licença. `SKILL.md` ganha uma linha no §1 e uma linha na tabela de referências (8.943 para 9.104 bytes, cerca de 2.276 tokens, teto 2.500).
  - **Estudo de movimento** (`node tools/motion-study.mjs`, Playwright sem tela com o Chrome do sistema, 1440×900, 40 s, saída fora do repositório). Sites: os cinco da Call 2 (`aave`, `hoy`, `vercel`, `framer`, `raycast-keyboard` em `urls.txt`). Nenhum bloqueou o navegador sem tela; o navegador do dono não foi preciso. Medianas das entradas: 350 a 550 ms no carregamento e 350 a 1000 ms na rolagem; passos de stagger de 20 a 100 ms; hover com mediana de 150 a 160 ms em dois sites e 700 ms em um. Curvas: ease-out forte (`cubic-bezier(0, 0, 0.58, 1)`, `cubic-bezier(0.33, 1, 0.68, 1)`, `cubic-bezier(0.19, 1, 0.22, 1)`), in-out nas cenas (`cubic-bezier(0.65, 0, 0.35, 1)`) e molas compiladas para `linear()` em um site. Nenhum dos cinco é do nível Suave, que fica com os números do Pilar 4.
  - **Limites do estudo:** a detecção de biblioteca só vê globais da janela (`window.gsap`, `window.ScrollTrigger`, `window.lenis`), então GSAP ou Lenis empacotados não aparecem, e "sem biblioteca" nos dois sites de cena presa não quer dizer que não usam uma. Movimento escrito por script quadro a quadro não aparece em `document.getAnimations()`: um site teve 0 amostras na rolagem e 2 no carregamento, e outro faz o hover em JS (0 amostras de hover). Um site recria os objetos de animação a cada evento, o que infla as contagens dele (milhares de amostras); as medianas dele seguem úteis, as contagens não. Os alvos de hover são os 20 primeiros visíveis na ordem das folhas de estilo e puxam para a navegação.

## Resultados

Opus 5.5, nível leve. Braço: sem plugin. `fusion/results/2026-11-13-motion*.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `motion-prumo-paleta-modal` | 4 de 5 (50% na comparação, 3 de 3 numa rodada extra com arquivos guardados) | 0% (0,67) |
| `motion-nivel-suave` (Fase 2, RED) | GREEN pendente | 0% (0,80) |

- RED da Fase 2 (2026-11-18, `fusion/results/2026-11-18-motion-baseline.md`): braço sem plugin, 2 rodadas por caso. `motion-nivel-suave` 0% (0,80), US$ 0,54; `motion-prumo-paleta-modal` de novo 0% (0,56), US$ 0,45. Custo total US$ 0,98.
- Na comparação, `accepted: false` por 1 de 2 rodadas, abaixo da barra. Uma rodada extra com os arquivos guardados passou em 3 de 3 graders nas três; somando, 4 de 5. Tratado como variação; a skill não mudou.

## Decisões por commit de fonte

- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/animate/SKILL.md` | adotado | espinha de sete passos, porta da frequência, propósito nomeado, escada barata primeiro, propriedades, ease-out e nunca `ease-in`, transição no que dispara rápido, reduced motion junto, tabela do que nunca entregar, saída curta
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/animate/SKILL.md` | recusado | resposta inicial fixa, curvas e durações em tabela, `RECIPES.md`, bounce de 0,1 a 0,3 (conflito)
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/animation-performance/SKILL.md` | adotado | orçamento de quadro, níveis de custo e trocas, onde roda, `ref.style`, variável herdada, blur, `will-change` por último, ordem de diagnóstico
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/animation-performance/SKILL.md` | recusado | as histórias de produção, o formato de relato, o limite de blur de 20 px (conflito)
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/choreograph/SKILL.md` | adotado | papéis, uma entrada por contêiner, sem stagger em interface frequente, junto por padrão, stagger variado, saída simultânea, interrupção, colapso em reduced motion
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/choreograph/SKILL.md` | recusado | a fórmula de duração por distância, os laços de atenção, `useAnimate`, o formato de linha do tempo obrigatório
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/gestures/SKILL.md` | adotado | duas fases do gesto, 1:1 sem mola, mola com velocidade, distância ou velocidade, bounce só ao soltar, valores derivados, segurar linear, reduced motion mantém o rastreio, teste no celular
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/gestures/SKILL.md` | recusado | a curva e os tempos da Vaul, `data-vaul-no-drag`, o exemplo de props do Motion
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/remove-animations/SKILL.md` | adotado | só subtrair, manter o que evita salto, riscos da remoção (estado inicial oculto, esperas, `onExitComplete`, foco), limpeza, propor remover a biblioteca, reveal em toda seção é decoração
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/remove-animations/SKILL.md` | recusado | a tabela de redução com valores, o formato de relato em três partes
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/emil-design-eng/SKILL.md` | adotado | `:active` com escala, popover pela origem, `@starting-style` no lugar de `mounted`, captura do ponteiro, múltiplos toques
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/emil-design-eng/SKILL.md` | recusado | filosofia, formato de revisão, blur para mascarar transição, truques de `clip-path`, princípios do Sonner
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/apple-design/SKILL.md` | adotado | ideia de projetar o repouso pela velocidade, resistência crescente na borda, histerese de uns 10 px
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/apple-design/SKILL.md` | recusado | easing espelhado, código e citações derivados da Apple, materiais, tipografia, som e háptica
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-motion/SKILL.md.tmpl` | adotado | um momento autoral por página, seção completa sem script, blur até 14 px, `filter` e `clip-path` aceitos
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-motion/SKILL.md.tmpl` | recusado | vitrine, exportações, perguntas ao usuário, faixa de 50 a 700 ms
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-motion/sections/motion.md.tmpl` | adotado | intro de seção por `IntersectionObserver` a 30%, uma vez, sem scroll listener; markup como estado final
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-motion/sections/motion.md.tmpl` | recusado | tipos de carregamento com valores, histórias, ciclo de laço, tokens de curva, acentos
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:docs/design-lint.md` | adotado | foco instantâneo fora da `transition`, pausa visível acima de 5 s, `transition: all` e reduced motion ausente como bloqueio
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:docs/design-lint.md` | recusado | ids, níveis e números de regra, o resto do lint (é de `ui-review`)
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/motion-foundations/SKILL.md` | adotado | `"use client"` em todo arquivo com `motion/react`, `initial` igual ao servidor
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/motion-foundations/SKILL.md` | recusado | sistema de tokens e presets de mola, desligar todo transform com opacidade até 0,2 s (conflito)
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/motion-patterns/SKILL.md` | adotado | `AnimatePresence` exige `key` e `exit`
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/motion-patterns/SKILL.md` | recusado | `mode="wait"` em troca de página (conflito), os padrões prontos
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/motion-advanced/SKILL.md` | adotado | laço infinito pausa em `visibilitychange`
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/motion-advanced/SKILL.md` | recusado | os exemplos prontos (cursor, contador, shimmer, arrasto)
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579:plugins/nateherk-design/skills/scroll-craft/references/devices.md` | adotado | clipe pela vida visível do palco, scroll grava o alvo e o rAF persegue, no máximo dois atos de scrub, trilho mede o overflow e vira scroll nativo, contador só com número real, uma vez
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579:plugins/nateherk-design/skills/scroll-craft/references/devices.md` | recusado | o motor, atributos `data-sc-*`, valores de lerp e zona morta, paralaxe em camadas
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579:plugins/nateherk-design/skills/scroll-craft/references/feel.md` | adotado | curva de sentimento antes dos atos, um pico no maior span, final que assenta, partes administrativas curtas
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579:plugins/nateherk-design/skills/scroll-craft/references/feel.md` | recusado | as curvas de exemplo, o teste de contar a alguém, a lista de recursos de imersão
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579:plugins/nateherk-design/skills/scroll-craft/references/verify.md` | adotado | iOS não pinta vídeo mudo nunca tocado (`play()` e `pause()`), testar no iPhone real, reduced motion sem buscar clipes, `100svh`, foco em ato pinado
- `scroll-craft@75d81f74e83692add18cd7a8a8e078b8a887a579:plugins/nateherk-design/skills/scroll-craft/references/verify.md` | recusado | o harness, os relatórios, a contabilidade de `kie.mjs`, o diagnóstico em página
- `paper-shaders@e7003a2d4e6e932e30b8fa11ec1239e6ea48e16a:README.md` | adotado | textura de fundo em sites, fixar a versão por quebra em `0.0.x`
- `paper-shaders@e7003a2d4e6e932e30b8fa11ec1239e6ea48e16a:README.md` | recusado | as cores e props do exemplo, o build e a publicação
- `paper-shaders@e7003a2d4e6e932e30b8fa11ec1239e6ea48e16a:CHANGELOG.md` | adotado | uso de WebGL2 (0.0.46) e props que mudam de nome entre versões (ler os tipos instalados)
- `paper-shaders@e7003a2d4e6e932e30b8fa11ec1239e6ea48e16a:CHANGELOG.md` | recusado | as notas de cada shader
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-scrolltrigger/SKILL.md` | adotado | ScrollTrigger no topo, ordem de criação e `refreshPriority`, `refresh()` depois de fontes e imagens, `scrub` ou `toggleActions`, filho do pinado, `ease: "none"` no horizontal, sem `markers`, matar ao sair
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-scrolltrigger/SKILL.md` | recusado | `batch()`, `scrollerProxy`, a referência de opções
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-react/SKILL.md` | adotado | `useGSAP` com `scope`, `gsap.context` e `ctx.revert()`, `contextSafe`, refs
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-react/SKILL.md` | recusado | instalação e SSR em detalhe
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-core/SKILL.md` | adotado | `gsap.matchMedia()` para reduced motion, reversão automática
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-core/SKILL.md` | recusado | a recomendação de GSAP para tudo (conflito), a referência de easing e tweens
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-plugins/SKILL.md` | adotado | SplitText depois das fontes ou com `autoSplit`, `aria` padrão, dividir só o nível animado, plugins gratuitos no pacote público
- `gsap-skills@aed9cfd3277740755f6bfc1155c7aa645403b760:skills/gsap-plugins/SKILL.md` | recusado | o catálogo dos outros plugins, `ScrollSmoother`, `GSDevTools`
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb:plugins/motion/skills/motion/best-practices/react.md` | adotado | nunca `framer-motion` em código novo, `motion/react-client`, `MotionConfig reducedMotion="user"`, `AnimatePresence` montado, `popLayout`, `layoutId` com `useId()`, altura até `auto` só em conteúdo pequeno, `Reorder` com teclado, Radix com estado içado e `forceMount`, motion values fora do render
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb:plugins/motion/skills/motion/best-practices/react.md` | recusado | a nota sobre v12 e v13, a orientação de ler docs pelo MCP
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb:plugins/motion/skills/motion/best-practices/base-ui.md` | adotado | `render` prop, estado içado, `keepMounted` no `Portal`, saída com propriedade acelerada
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb:plugins/motion/skills/motion/best-practices/base-ui.md` | recusado | os exemplos de código
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb:plugins/motion/skills/motion/best-practices/index.md` | adotado | sem alocar memória por quadro, o que perde a aceleração, sem overshoot em produto sério, animação mostra mudança e não decora
- `motion-ai-kit@1e424943582cbbdb6e3f410687e39f96451447bb:plugins/motion/skills/motion/best-practices/index.md` | recusado | a regra de comentários no código do usuário (sem cenário), links para arquivos não acompanhados
- `transitions-dev@20d70c1262bf721c0300c2946cbe1fc7605a555c:skills/transitions-polish/SKILL.md` | adotado | fechar mais curto que abrir, pares simétricos, sem overshoot no fechar, stagger total de uns 300 ms, nunca atrasar um fechamento, blur fora do fade, distância cresce com a cerimônia (só ideias)
- `transitions-dev@20d70c1262bf721c0300c2946cbe1fc7605a555c:skills/transitions-polish/SKILL.md` | recusado | todos os valores de token, o hover-out com overshoot (conflito), os comandos e o painel
- `transitions-dev@20d70c1262bf721c0300c2946cbe1fc7605a555c:build/templates/skill.md.tmpl` | adotado | acordeão por grid com padding no filho, chevron gira em vez de mudar o path, indicador de abas sem transição na primeira posição, nunca `transition: all` (só ideias)
- `transitions-dev@20d70c1262bf721c0300c2946cbe1fc7605a555c:build/templates/skill.md.tmpl` | recusado | os snippets, as regras de decisão por componente, a instalação e os ganchos `t-*`
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/css-native/SKILL.md` | adotado | CSS quando bastam poucas animações, `animation-timeline` dentro de `@supports` com conteúdo visível, `fill-mode: both`, `@starting-style` com `allow-discrete`, View Transitions
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/css-native/SKILL.md` | recusado | âncora, container queries, `sibling-index()`, malha e cônico, os exemplos com `ease-in`
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/threejs-r3f/SKILL.md` | adotado | CSS para 3D simples em UI, Canvas 2D para partículas, versão de Fiber pela de React, `dpr={[1, 2]}`, `Suspense`, sem `setState` em `useFrame`, render sob demanda, instâncias, Draco e KTX2
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/threejs-r3f/SKILL.md` | recusado | catálogo do drei, pós-processamento, metas de draw calls
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808:installable/monich/references/performance.md` | adotado | um laço rAF, sem scroll listener, Three.js por import dinâmico, `dispose()` e limpeza ao desmontar, sem `backdrop-filter` grande animado
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808:installable/monich/references/performance.md` | recusado | assets e verificação de build (são de `verifying` e `browser-testing`)
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808:installable/monich/assets/templates/web-template/horizontal-craft/animation-discipline.md` | adotado | reduced motion corta eixo e mantém crossfade, View Transitions não respeitam reduced motion sozinhas, pausa acima de 5 s, laços com fim, ferramenta não recebe coreografia de hero
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808:installable/monich/assets/templates/web-template/horizontal-craft/animation-discipline.md` | recusado | cena expressiva sempre animada (conflito), handoff entre plataformas, mitos de pesquisa, o trecho CSS pronto
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/audit.md` | adotado | reduced motion preserva a mudança de estado; `0.01ms` global apaga retorno útil; `will-change` só como dica pontual
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/audit.md` | recusado | o resto da auditoria (é de `ui-review`)
- `three.js@0a980dcf032223a274fcdd60ab56330f1321cca0:docs/llms.txt` | adotado | `WebGLRenderer` padrão, `WebGPURenderer` só para TSL ou compute, com `await renderer.init()`
- `three.js@0a980dcf032223a274fcdd60ab56330f1321cca0:docs/llms.txt` | recusado | import map por CDN com a versão mais nova (conflito), TSL e materiais por nós
