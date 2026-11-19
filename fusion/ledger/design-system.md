# Ledger: `design-system`

Skill automática de nível leve, da Task D3 do plano de design, segunda do setor de design (`"sector": "design"`). Espinha: Impeccable (Apache-2.0), `extract` e `document`. Outras fontes: UI UX Pro Max (`colors.csv`, só a ideia do esquema de papéis), ECC (`design-system`), gstack (`docs/design-lint.md`, `design-review/sections/craft-audit`), Impeccable (`audit`), Emil (`apple-design`) e getdesign.md (`VoltAgent/awesome-design-md`, só a estrutura). Todas com `textReuse: false`: só ideias, escritas com palavras próprias e creditadas aqui. Nenhum texto, lista, paleta ou valor delas entrou, e `LICENSES/NOTICE.md` não muda.

Pinos lidos, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos de `fusion/sources.json`, sem rodar nada:

- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430`: `skill/reference/extract.md`, `document.md`, `audit.md`.
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b`: `src/ui-ux-pro-max/data/colors.csv` (só o cabeçalho e a forma das linhas; nenhuma cor).
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b`: `skills/design-system/SKILL.md`.
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`: `docs/design-lint.md`, `design-review/sections/craft-audit.md.tmpl`.
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/apple-design/SKILL.md` (§12 e §15).
- `awesome-design-md@fcc70284932276d085f01ef9f83edde90b1258cb` (getdesign.md; não está em `fusion/sources.json`, então foi lido o `HEAD` do dia): `README.md` e dois arquivos de marca (`design-md/airbnb/DESIGN.md`, `design-md/cal/DESIGN.md`), só para ver a estrutura.

A skill foi escrita sem abrir `evals/design-system-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task D3 no plano.

`SKILL.md` tem cerca de 6.900 bytes (uns 1.720 tokens, teto 2.500). A descrição custa cerca de 43 tokens dos 250 do setor; com os 38 de `visual-direction`, o setor está em 81.

O trecho de contraste de `references/contrast.md` foi escrito aqui e rodado antes de entrar: `#000/#fff` deu 21,00:1, `#767676/#fff` deu 4,54:1 e `#777/#fff` deu 4,48:1 (reprova texto, passa texto grande), que são os valores conhecidos. Lê `#rgb`, `#rrggbb` e `oklch()`, porque o Tailwind v4 usa `oklch`; `oklch(1 0 0)` contra `oklch(0 0 0)` também deu 21,00:1.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (sistema de design ou tokens, spec com `## Direção visual` sem valores, tema de shadcn/ui ou Tailwind) |
| Abertura: a única skill que escolhe valores; acessibilidade decidida aqui como tokens | Fronteira da spec ("`design-system` é a única que escolhe valores") |
| 1. Ler antes de escrever: contrato, `DESIGN.md`, onde o projeto declara valores, componentes, `package.json` e lockfile | Impeccable (`extract` passo 1, `document` Scan passo 1), só ideias, por decisão da Task D3 |
| Projeto com valores: manter nomes e formato, sem renomear nem mudar de arquivo | Impeccable (`document`, nomes abertos; `extract`, convenções existentes) e o fluxo da spec ("em superfície que já existe, `design-system` só lê") |
| `DESIGN.md` existente não é editado nem sobrescrito sem pedido; a mensagem final diz o que falta nele | Impeccable (`document`, "do not silently overwrite"), endurecido pela spec ("nunca é sobrescrito sem pedido") e pelo segundo caso da Task D3 |
| Cores rastreadas até o mundo do contrato; nada de paleta de framework, de gerador ou de hábito | Fora da Task D3 ("a skill não sugere cores de fábrica") e a análise das 192 paletas na spec; gstack (`design-lint`, `framework-palette`), só ideia |
| 2. Primitivo e semântico; componentes só usam semântico | Impeccable (`extract` passo 4, "primitive vs semantic"), por decisão da Task D3 |
| Token novo só com três lugares fazendo o mesmo trabalho; parecidos com trabalhos diferentes ficam separados | Impeccable (`extract` passo 2 e Avoid), por decisão da Task D3 |
| Tamanho do corpo pelo modo, sem piso único | Conflito resolvido (ver abaixo) |
| Título grande com tracking negativo; leading cai com o tamanho; cada passo fixa tamanho, peso, leading e tracking | Emil (`apple-design` §15), só ideias, por decisão da Task D3 |
| Em Operate: 8 px até a borda da linha, 16 px entre textos de linhas, 12 px sob lista | gstack (`design-lint`, `row-crowding` e `copy-flush-under-list`), só ideia, por decisão da Task D3 |
| Borda de largura constante entre estados; foco fora da borda | gstack (`design-lint`, `input-state-shift`), só ideia |
| Desabilitado por pelo menos três sinais, nunca só opacidade ou cor | gstack (`design-lint`, `input-state-shift`) e Impeccable (`audit`), só ideias |
| Estados com tokens próprios | getdesign.md (variantes como chaves irmãs) e Impeccable (`document`, variantes por convenção de nome) |
| Superfície translúcida com alternativa opaca em `prefers-reduced-transparency` e `prefers-contrast` | Emil (`apple-design` §12), só ideia, por decisão da Task D3 |
| Valores de movimento são de `motion` | Fronteira da spec |
| 3. Pares a 4,5:1, e 3:1 para texto grande, ícone, borda de controle e foco | Impeccable (`audit`, contraste), gstack (`design-lint`, `low-contrast`) e a Task D3 ("acessibilidade como tokens") |
| Calcular todo par, nos dois temas, com o script; nunca estimar; par reprovado muda luminosidade, não matiz | Regra própria da Task D3 (o trecho em Node) e o caso realista (contraste calculado em todos os pares, nos dois temas) |
| Token de foco usado por todo elemento interativo em `:focus-visible` | Task D3 ("o token de foco") e gstack (`design-lint`, `missing-focus-visible`), só ideia |
| 4. No escuro a marca fica e o resto é rederivado; inverter não é tema escuro | UI UX Pro Max, só ideia, por decisão da Task D3 |
| 5. Tailwind v4 em `@theme`, sem `tailwind.config` novo; v3 em `theme.extend`; sem Tailwind, `:root` | gstack (`craft-audit` §4), só ideia, por decisão da Task D3 |
| shadcn/ui: o tema padrão nunca vai ao ar; trocar os valores das variáveis, manter os nomes | **Regra do dono** (spec, "Fontes de referência fixas"; plano, Task D3) |
| Um valor num lugar só; componentes leem tokens, nunca literais | Impeccable (`document`, "don't split the source of truth") e gstack (`design-lint`, `literal-outside-tokens`), só ideias |
| 6. `DESIGN.md` só quando não existe, no formato aberto, com tabela de contraste, estados e lacunas | Spec (formato de `google-labs-code/design.md`) e Impeccable (`document`) |
| 7. Espécime com todo papel, par, razão, os dois temas, escala e cada componente em cada estado, só com `var()` | ECC (`design-system`, prévia HTML autônoma), só ideia, por decisão da Task D3. "Servir como o projeto serve páginas" é ajuste do DevOrb: um HTML solto não lê o `@theme` do Tailwind v4 sem build |
| 8. Mensagem final: onde estão os tokens, `DESIGN.md` escrito ou intocado, resultados de contraste, valor sem origem | DevOrb |
| `planning` e `implementing` citam tokens; `ui-review` mede contra eles | Interface da Task D3 |
| `references/color-roles.md`: 16 papéis em pares (sete superfícies com tinta, mais borda e anel) | UI UX Pro Max (`colors.csv`, as colunas de papéis), só a estrutura, por decisão da Task D3. Nenhuma das 192 paletas |
| Mínimo por papel; `muted-foreground` também sobre `background` e `card`; `primary` como link | DevOrb, a partir dos limiares acima |
| Nomes do projeto primeiro; com shadcn/ui, `*-foreground` e as variáveis extras dele recebem valor | DevOrb, pela regra do dono |
| Papéis de status e gráfico só quando usados, com a regra dos três usos | Impeccable (`document`, "omit rather than inventing") e a regra dos três usos |
| Valores a partir do mundo do contrato, com o motivo escrito; nunca de escala de framework, paleta pronta ou arquivo de marca | Fora da Task D3 e getdesign.md (só estrutura) |
| `references/contrast.md`: fórmula, limiares, script em Node sem dependências, respostas conhecidas, como rodar | Regra própria da Task D3 ("Própria"), escrita aqui. Os limiares são do WCAG 2 |
| `references/design-md.md`: frontmatter YAML, referências `{grupo.chave}` só em componentes, estado como chave irmã, notação de cor do projeto | Impeccable (`document`, esquema do frontmatter), só ideias, com exemplo próprio e sem valores |
| Seções do corpo em ordem, com a tabela de contraste em `## Colors` | Impeccable (`document`, oito seções) |
| Nota de fonte livre que substitui uma proprietária; seção `## Known gaps` | getdesign.md (`cal/DESIGN.md`, "Note on Font Substitutes" e "Known Gaps"), só ideias, por decisão da Task D3 |
| Arquivos de marcas reais só para ver a estrutura | Task D3 e spec (getdesign.md, "só a estrutura") |

## Conflitos resolvidos

- **Tamanho do corpo:** o gstack (`design-lint`, `tiny-text`) sugere corpo de 16 px; a Impeccable e o Emil tratam o tamanho como parte da hierarquia de cada produto. Pela Task D3, o tamanho do corpo depende do modo (denso em Operate, generoso em Read e Persuade), e não há piso único.
- **`DESIGN.md` existente:** a Impeccable mostra o arquivo e pergunta se atualiza, sobrescreve ou mescla. No DevOrb não há pergunta no meio do fluxo: o arquivo fica intocado sem pedido, os tokens novos seguem o que ele diz, e a mensagem final lista o que falta nele. Vale a spec ("nunca é sobrescrito sem pedido").
- **Projeto sem sistema:** a Impeccable não cria sistema sem perguntar onde e entra em modo semente sem valores. Aqui a skill recebe o contrato aprovado e é a dona dos valores (spec), então cria o sistema a partir dele, e marca em `## Known gaps` o que não pôde rastrear.
- **Cores de partida:** o ECC pesquisa três concorrentes e aceita `--palette`; a UI UX Pro Max traz 192 paletas. Vale a Task D3: as cores saem do contrato de direção, e nenhuma paleta pronta entra.
- **Primitivo dentro de `colors`:** o formato aberto não deixa uma cor apontar para outra. `colors` guarda os papéis semânticos com valor, e a seção `## Colors` diz de qual primitivo cada um vem. O código continua com as duas camadas.
- **Foco com `outline`:** o gstack conserta o anel de foco feito com borda usando `outline`. A regra "foco com `outline`, por `forced-colors`" é candidata da spec e ainda não tem cenário; a skill só exige o anel fora da borda e com token.

## Regras próprias

1. **Regra do dono: tema padrão do shadcn/ui.** Quando a fundação é o shadcn/ui, os valores das variáveis do tema padrão são trocados pelos tokens do projeto, nos dois temas, mantendo os nomes. Está no corpo do `SKILL.md`. Nenhuma fusão a tira. Cenário: o terceiro caso da Task D3 (projeto com shadcn/ui no tema padrão e spec com direção própria).
2. **Contraste calculado por script.** Todo par, nos dois temas, passa pelo trecho de `references/contrast.md`, e o resultado vai para `DESIGN.md` e para a mensagem final. Cenário: o caso realista da Task D3 (contraste calculado em todos os pares, nos dois temas).
3. **Regra do dono: par complementar dividido por seção.** Uma página pode usar dois matizes complementares (por exemplo vinho e laranja) quando cada um tem as suas seções: um domina as seções de uma família e o outro as de outra, nunca os dois no mesmo bloco. Dono, 2026-11-18, sobre a página do Pilot: "ficou melhor do que uma cor só, traz vida". Tocou `design-system/references/color-finish.md` e `color-roles.md` e, em `visual-direction`, `floor.md`, `hero-patterns.md`, `persuade.md` e `contract.md`. Cenário: `evals/visual-direction-receitas-landing`, grader `color-pair`. RED em `devorb@8dc3b2f`: `color-pair` falhava 2/2 no braço devorb e 2/2 no `none` (devorb 0,75, none 0,25). GREEN em `devorb@4a966e3`: 100% (1,00), `none` 0,30. Limite conhecido: a faixa vinho (~355°) com o laranja (~25°) conta como três matizes no `accent-count`; sem mudança no código, fica anotado. Decisão aberta do dono: o piso "No single word set apart inside a heading" continua; o complemento ganha linhas inteiras do título, não uma palavra solta.

As candidatas da spec **não entraram**: foco com `outline` por `forced-colors`, e texto grande como 24 px ou 18,66 px em negrito. A skill e `contrast.md` dizem "texto grande como o WCAG define", sem o número. Ficam em aberto até um cenário as justificar.

## Fora

- **Impeccable:** a pergunta de onde guardar o sistema antes de criar, as rodadas de perguntas qualitativas (estrela-guia, nomes descritivos de cor), as Named Rules, o arquivo lateral `.impeccable/design.json` com rampas tonais e trechos de componente, o painel ao vivo, o linter do Stitch, o modo semente e o `PRODUCT.md`, a migração de componentes (é de `implementing`) e as notas de 0 a 4 do `audit` (o resto de `audit` é de `ui-review`).
- **UI UX Pro Max:** as 192 paletas, a busca BM25 em Python, as notas por tipo de produto e qualquer dial de estilo.
- **ECC:** a pesquisa de concorrentes por MCP de navegador, `design-tokens.json`, as flags `--style` e `--palette`, a auditoria em dez dimensões com notas (é de `ui-review`) e a lista de vícios de IA (está em `visual-direction`).
- **gstack:** o binário `gstack-design-lint`, a ordem de correção, as regras de cópia, movimento e página, os números de cada regra que não estão acima, e o resto de `craft-audit` (é de `ui-review`).
- **Emil:** gestos, springs, molas e o resto de `apple-design` (é de `motion`), o CSS de vidro de exemplo, a fonte do sistema por padrão (a família vem do contrato), e tudo o que deriva da Apple como citação ou código.
- **getdesign.md:** as cores, fontes e assinaturas das marcas, as seções de comportamento responsivo e o guia de iteração, e o índice de marcas.

## Revisões

- 2026-11-13, conferência frase a frase contra cada fonte, depois da primeira escrita. Reescritas por estarem perto demais:
  - `SKILL.md`: "three or more uses with the same intent" e "look alike but do different jobs" (Impeccable `extract`); "build each step as size, weight, leading and tracking together" (Emil, hierarquia como conjunto); "focus is drawn with `outline`" virou "anel fora da borda", para não antecipar a regra candidata.
  - `design-md.md`: o exemplo de frontmatter fazia uma cor apontar para outra, o que o formato proíbe; refeito com papéis semânticos e o primitivo na prosa.
- 2026-11-13, Task M4 do plano mobile: `references/native.md` novo, só ideias, palavras próprias. Cor semântica da plataforma em superfície, texto e separador; marca em pares claro e escuro; cor dinâmica só a partir da API 31, com os esquemas do projeto como reserva, nunca no iOS; cor de plataforma não se interpola; nunca `allowFontScaling={false}`, com `maxFontSizeMultiplier` só como último recurso registrado. Fontes: Expo `expo-native-ui/SKILL.md` e `expo-design-system/SKILL.md` (`expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`), Material 3 `skills/material-3/references/theming-and-dynamic-color.md` (`material-3-skill@14385f2bf3804d8779f8b4db2604211f1e70b4c1`), as duas MIT, `textReuse: false`. `SKILL.md` ganha uma linha que aponta para a referência (6.872 para 6.958 bytes).

- 2026-11-18, Task 6 da Fase 2 de qualidade de design (`docs/specs/2026-11-18-design-quality-fase-2-design.md`, Pilar B e Call 6):
  - `scripts/fluid-scale.mjs` é novo: a função pura `fluidScale` e uma CLI que imprime um `clamp()` por passo, entre 360 e 1440px. O método da escala fluida (tamanho mínimo e máximo por passo, interpolados pela largura e presos por `clamp()`) é do **Utopia** (utopia.fyi), **só a ideia**. Nenhum código, texto ou tabela do Utopia foi lido para escrever o script. As fórmulas vêm da brief da Task 6 e os testes estão em `tests/design-fluid.test.mjs`.
  - `references/typography.md`, `color-finish.md` e `space-radius.md` são novos. Os números vêm de `docs/specs/2026-11-18-referencias/study-A.md` e `study-B.md`, medições nossas de 21 sites, escritas com palavras nossas. Nenhum texto dos sites entrou. As razões por modo vêm do Pilar 4 da spec da Fase 1. Cada arquivo diz que a direção fixa o que a spec fixa, e cada um traz um exemplo gerado: a escala e o padding de seção pela CLI, e a escada de opacidade pelo script de `contrast.md`. Onde uma receita toca um reflexo de `floor.md` (mono em rótulo, halo), ela pede a razão da página na linha `Floor:` do contrato.
  - Pares de fontes: são 6, por categoria. Cada face foi conferida em 2026-11-18 por três checagens. A página `https://fonts.google.com/specimen/<Nome>` responde 200 (um nome falso dá 404). O `METADATA.pb` em `google/fonts/ofl/<nome>` diz `license: "OFL"`. A API `fonts.googleapis.com/css2` carrega os pesos 400 e 500 (um nome falso dá 400). As faces conferidas: Geist, Geist Mono, Inter, JetBrains Mono, Newsreader, Bricolage Grotesque, DM Sans, Cormorant Garamond, Manrope, IBM Plex Sans e IBM Plex Mono.
  - `SKILL.md` ganhou uma frase em **Type**, uma em **Spacing and radius** e os arquivos novos em `Uses`. O arquivo foi de 6.958 para 7.355 bytes, cerca de 1.840 tokens, com teto de 2.500.
  - O caso novo é `evals/design-system-escala-fluida`: a landing do Lote (devtools, Persuade, Geist e Geist Mono), com `:root {}` vazio e sem `DESIGN.md`. Os graders são `fluid`, `type-recipe` e `finish-recipe`. Depois do RED, os dois graders `llm` ganharam uma frase que só endurece: o valor precisa estar ligado ao seu papel ou uso, e um número solto numa escala não conta.

## Resultados

Opus 5.5, nível leve, 2 rodadas. Braços: sem plugin e UI UX Pro Max (`4f2dbb6`). `fusion/results/2026-11-13-design-system*.md`.

| Caso | DevOrb | Sem plugin | UI UX Pro Max |
|---|---|---|---|
| `design-system-cafe-moenda` | 100% | 0% (0,57) | 0% (0,71) |
| `design-system-padaria-pedidos` | 100% | 0% (0,60) | 0% (0,60) |
| `design-system-shadcn-padrao` | 100% | 100% | 100% |

- `accepted: true`. O caso do tema padrão do shadcn passa em todos os braços e fica como guarda contra piora.
- O grader de `DESIGN.md` intacto não carregava: o padrão começava com a linha `---` do próprio arquivo, que o leitor de cabeçalho tomou como fim do cabeçalho. Trocado por `-{3}`.

### Fase 2, Task 6 (escala fluida e receitas)

RED em 2026-11-18, só a linha de base. Opus 5.5, 2 rodadas por caso, braço sem plugin. O resultado está em `fusion/results/2026-11-18-design-system-baseline.md`.

| Caso | Sem plugin | Custo |
|---|---|---|
| `design-system-escala-fluida` | 0% (0,20) | US$ 0,73 |
| `design-system-cafe-moenda` | 0% (0,57) | US$ 1,31 |
| `design-system-padaria-pedidos` | 0% (0,60) | US$ 0,64 |
| `design-system-shadcn-padrao` | 100% | US$ 1,51 |

- A rodada custou US$ 4,17 no total. O caso novo falha sem o plugin, então o RED está confirmado. Os três casos antigos repetem as notas de 2026-11-13.
- GREEN (`--arms devorb,none`) fica com o controlador e ainda não rodou.

### Plano de regras de cor e referências (2026-11-19)

RED em 2026-11-18, GREEN em 2026-11-19, Opus 5.5, 2 rodadas, `--arms devorb,none`. `fusion/results/2026-11-18-visual-direction-receitas.md` (RED) e `fusion/results/2026-11-19-visual-direction-receitas.md` (GREEN).

| Caso | Etapa | devorb | none | Custo |
|---|---|---|---|---|
| `visual-direction-receitas-landing` | RED (`devorb@8dc3b2f`) | 0,75, `color-pair` falha 2/2 | 0,25, `color-pair` falha 2/2 | US$ 3,83 |
| `visual-direction-receitas-landing` | GREEN (`devorb@4a966e3`) | 100% (1,00) | 0,30 | US$ 6,39 |

- Custo total do plano: US$ 35,96 dos US$ 50 aprovados (RED 3,83 + 2,09 + 7,66; GREEN 6,39 + 7,79 + 2,06 + 4,25; diagnóstico 1,89).

## Decisões por commit de fonte

- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/extract.md` | adotado | ler o que existe primeiro, três usos com a mesma intenção, primitivo e semântico, parecidos com intenções diferentes ficam separados, seguir as convenções do projeto
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/extract.md` | recusado | perguntar onde criar o sistema, extrair componentes e migrar (é de `implementing`), Storybook
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/document.md` | adotado | `DESIGN.md` na raiz no formato aberto, tokens no frontmatter YAML, referências `{grupo.chave}`, variantes como chaves irmãs, nomes do projeto, uma notação, ordem das seções, omitir em vez de inventar, nunca sobrescrever calado, onde procurar os valores
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/document.md` | recusado | arquivo lateral `.impeccable/design.json`, painel ao vivo, Stitch, perguntas qualitativas, Named Rules, modo semente, `PRODUCT.md`
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/audit.md` | adotado | limiares de contraste, cor fora de token, tema escuro com contraste próprio
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/audit.md` | recusado | notas de 0 a 4 e o relatório (são de `ui-review`)
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b:src/ui-ux-pro-max/data/colors.csv` | adotado | 16 papéis de cor em pares, cada superfície com sua tinta; no escuro a marca fica e as superfícies são rederivadas
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b:src/ui-ux-pro-max/data/colors.csv` | recusado | as 192 paletas, as notas por tipo de produto
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/design-system/SKILL.md` | adotado | espécime autônomo para aprovação, ler o código antes de propor
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/design-system/SKILL.md` | recusado | pesquisa de concorrentes, `design-tokens.json`, flags de estilo e paleta, auditoria com notas, lista de vícios
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-review/sections/craft-audit.md.tmpl` | adotado | tokens no Tailwind instalado: `tailwind.config` na v3, `@theme` na v4; trabalhar dentro da pilha existente
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-review/sections/craft-audit.md.tmpl` | recusado | rodar o lint, ordem de correção, checagens de Persuade (são de `ui-review`)
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:docs/design-lint.md` | adotado | borda constante entre estados, desabilitado por três sinais, foco visível e não feito de borda, contraste por tipo de elemento, espaçamento de linhas em listas (8, 16 e 12 px), literal fora do bloco de tokens, paleta padrão de framework como alerta
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:docs/design-lint.md` | recusado | o binário, níveis e dispensas, as regras de cópia, movimento e página, os demais números
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/apple-design/SKILL.md` | adotado | tracking negativo em título grande, leading inverso ao tamanho, passo da escala como conjunto, alternativa opaca para `prefers-reduced-transparency` e `prefers-contrast`
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/apple-design/SKILL.md` | recusado | gestos, springs e materiais animados (são de `motion`), CSS de exemplo, fonte do sistema por padrão, qualquer citação derivada da Apple
- `awesome-design-md@fcc70284932276d085f01ef9f83edde90b1258cb:design-md/cal/DESIGN.md` | adotado | seção de lacunas conhecidas, nota de fonte livre no lugar da proprietária, estados como chaves próprias
- `awesome-design-md@fcc70284932276d085f01ef9f83edde90b1258cb:design-md/cal/DESIGN.md` | recusado | cores, fontes e assinatura da marca, seções de comportamento responsivo e guia de iteração
- `awesome-design-md@fcc70284932276d085f01ef9f83edde90b1258cb:design-md/airbnb/DESIGN.md` | adotado | só a confirmação da estrutura (frontmatter e seções)
- `awesome-design-md@fcc70284932276d085f01ef9f83edde90b1258cb:README.md` | recusado | o índice de marcas e o pedido de novos arquivos
