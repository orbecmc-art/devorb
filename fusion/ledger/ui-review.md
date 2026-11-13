# Ledger: `ui-review`

Skill automática de nível leve, da Task D5 do plano de design (`"sector": "design"`). Espinha: gstack (`docs/design-lint.md`, `design-review/sections/craft-audit`). Outras fontes: Impeccable (`audit`, `polish`, `harden`), Emil (`break-ui`, `mobile-native`), UI UX Pro Max (`ux-guidelines.csv`), genjutsu (`design-audit`, `desktop-principles`, `desktop-principles/references/keyboard-patterns`) e reanimate (`references/capture`). Todas com `textReuse: false`: entraram só ideias, escritas com voz própria.

Pinos lidos, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos de `fusion/sources.json`, sem rodar nada:

- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`: `docs/design-lint.md`, `design-review/sections/craft-audit.md.tmpl`.
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430`: `skill/reference/audit.md`, `polish.md`, `harden.md`.
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/break-ui/SKILL.md`, `skills/mobile-native/SKILL.md`.
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b`: `src/ui-ux-pro-max/data/ux-guidelines.csv` (as linhas de acessibilidade, toque, formulários e responsivo).
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`: `skills/_jutsu/design-audit/SKILL.md`, `skills/_jutsu/desktop-principles/SKILL.md`, `skills/_jutsu/desktop-principles/references/keyboard-patterns.md`.
- `reanimate@3f7a55a2986a84ca2173e86ee9127eefe31d046d`: `skills/reanimate/references/capture.md`.

A skill foi escrita sem abrir `evals/ui-review-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task D5 no plano. `devorb:design-system` e `devorb:motion` estavam sendo escritas em paralelo: a skill as cita pelo nome e aponta para "as referências" delas, sem nomear arquivo que talvez não exista.

`SKILL.md` tem 6.767 bytes (cerca de 1.692 tokens, teto 2.500). A descrição custa cerca de 44 tokens com o nome, dos 250 do setor.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (tela construída a conferir contra contrato, `DESIGN.md`, acessibilidade ou web no celular; pedido de revisar interface) |
| Abertura: `browser-testing` responde se funciona, esta skill se ficou como combinado; não decide gosto nem valor, não corrige | Fronteiras da spec ("Setor de design") e interface da Task D5 |
| Linha em destaque: o render julga, o código localiza; não medido não passa | Conflito da Task D5 (render julga) e gstack (`design-lint.md`, URL sem navegador sai com código próprio e nunca passa), só ideia |
| 1. Ler `DESIGN.md`, o contrato, o piso de `visual-direction` e as referências de `design-system` e `motion`; só essas, WCAG 2.2 e o piso de web no celular são regras; valor não declarado não é achado | Interface da Task D5 ("Não cria regra de valor") |
| O que `DESIGN.md` ou o contrato autoriza não é achado: a checagem fica limpa, sem achado nem recomendação | Impeccable (`polish`, estabelecer o sistema antes) e gstack (`design-lint.md`, dispensas registradas e casa em `DESIGN.md`), só ideias, por decisão da Task D5 |
| 2. Nomear o modo de cada seção antes de checar; Inter passa em painel e não em landing que não a escolheu; menu escondido em tela larga num sistema é achado | gstack (`craft-audit`, classificador de Persuade), genjutsu (`desktop-principles`, hambúrguer em desktop), só ideias, por decisão da Task D5. Os modos são os de `visual-direction` |
| 3. Funcional antes de visual; usar a execução e o script de `browser-testing`; viewports 1280 x 800, 375 com toque e 1920 | Impeccable (`polish`, triagem: tarefa quebrada antes de cosmético) e interface da Task D5. Viewports de `browser-testing` e do piso de `visual-direction` |
| Sem navegador: primeira linha "only code", checagens de render não conferidas, achados de código marcados como inferidos | gstack (`design-lint.md`, render pulado e dito), Emil (`break-ui`, dizer o que foi visto e o que foi inferido) e Impeccable (`audit`, dizer o que produziu a evidência), só ideias |
| 4. Medir computado contra declarado com `getComputedStyle`; cor fora dos tokens é desvio | gstack (`design-lint.md`, camada de render e tokens), por decisão da Task D5 |
| Movimento lido com `document.getAnimations()` depois de disparar o estado; de novo com `reducedMotion: 'reduce'` | reanimate (`capture.md`, despejo das animações pelo navegador), só ideia |
| Foco: Tab pela página, ler contorno e `transition-property`; anel que transiciona é fade | gstack (`design-lint.md`, `focus-ring-fade` e a caminhada de foco), só ideia |
| Contraste calculado das cores pintadas, com o par e a razão | genjutsu (`design-audit`, contraste não está no script: calcular e escrever o par) e gstack (contraste contra os pixels pintados), só ideias |
| Texto exibido (texto, `alt`, `aria-label`, `title`, `placeholder`), nunca classes; vícios de IA e plural quebrado; vício só passa com frase citada do contrato; palavra de clima não autoriza | genjutsu (`design-audit`, grupo `tells`), só ideia, por decisão da Task D5. Os vícios são os reflexos e looks gastos do piso de `visual-direction` |
| Localizar cada desvio com `arquivo:linha`; rodar `worst-case.md` quando a tela mostra dados | Conflito da Task D5 (código localiza) e Emil (`break-ui`) |
| Quatro classes de desvio: token ausente, pontual, desencontro conceitual, defeito local | Impeccable (`polish` §1), só ideia, reescrita |
| 5. Checagens: cada linha do contrato, cada item do piso, tokens, movimento, a11y, celular; atalhos | Interface da Task D5. Atalho de uma letra e atalhos do navegador: genjutsu (`keyboard-patterns`, conflitos), só ideia |
| Cada checagem termina em achado, limpa ou não aplicável; não aplicável é não conferido | genjutsu (`design-audit`, os três estados do script), só ideia |
| 6. P0 a P3 com definições próprias; sem nota nem total | Impeccable (`audit`, severidades P0 a P3), só ideia. As notas de 0 a 4 e o total de 20 ficaram fora (conflito da Task D5) |
| Alvo abaixo de 24 px sem exceção é P1; abaixo de 44 px no toque é recomendação P3; input de 16 px no celular | Conflitos da Task D5. Impeccable (`audit`, SC 2.5.8 com exceções) e UI UX Pro Max (linhas 22 e 104) |
| 7. Formato do relatório: o que foi medido e como, modos, achados com declarado, medido, classe e regra, checagens, inventário, não conferido | gstack (`design-lint.md`, linha por achado com arquivo, linha e evidência), Impeccable (`audit`, local, categoria, padrão violado) e genjutsu (`design-audit`, inventário com até cinco `arquivo:linha`, sem veredito), só ideias, em formato próprio |
| Relatar e parar, sem mudar arquivo; achados para `devorb:debugging` quando a tarefa inclui corrigir | Impeccable (`audit`, documentar sem corrigir), Emil (`break-ui`, relatar antes de corrigir) e interface da Task D5. O encaminhamento repete o de `browser-testing` |
| Tabela de sinais de parada | DevOrb, no formato das outras skills |
| `references/a11y.md`: critérios do WCAG 2.2 por princípio, com o que olhar e como medir no navegador; A e AA são P1, P0 quando fecham a tarefa; AAA é recomendação P3 | UI UX Pro Max (`ux-guidelines.csv`, linhas 9, 22, 28, 36 a 45, 55, 63, 99 a 109, 112, 117, 118), reescritas e organizadas pelos critérios do WCAG 2.2. AAA nunca apresentado como AA: linhas 101 e 102 |
| a11y: 2.1.4, atalho de uma tecla só com foco ou desligável | genjutsu (`keyboard-patterns`, atalho de uma letra mata a digitação), ligado ao critério do WCAG |
| a11y: tomar atalhos do navegador globalmente é P2 | genjutsu (`keyboard-patterns`, conflitos com o navegador), só ideia |
| a11y: texto grande pelo limiar que `DESIGN.md` declara, ou a definição do WCAG (18 pt, ou 14 pt em negrito) | Fronteira da spec (o limiar nasce em `design-system`) e a definição do próprio WCAG |
| `references/mobile-web.md`: zoom liberado, input de 16 px, `type` e `inputmode`, `dvh` e `svh`, `env()` com `viewport-fit=cover`, `touch-action: manipulation`, `overscroll-behavior: contain` em painéis, sem rolagem horizontal; sem PWA | Emil (`mobile-native`), só ideias, por decisão da Task D5. A severidade de cada linha é minha |
| O que a emulação não mostra é listado como não conferido e precisa de aparelho | Emil (`mobile-native`, testar em aparelho real) e Impeccable (`audit`, dizer o que produziu a evidência), por decisão da Task D5 |
| `references/worst-case.md`: mapear os valores renderizados com fonte e limite; "sem limite" é achado | Emil (`break-ui`, fase 1), só ideia, reescrita |
| Pior caso plausível ou o limite do esquema; vazio, um e enorme; acentos do português | Emil (`break-ui`, fase 2) e Impeccable (`harden`, entradas extremas), só ideias. Acentos e cedilha: ajuste ao público do dono |
| Entrar pela borda de dados, só na sessão do navegador (`page.route`, cópia fora do projeto, texto trocado na sessão) | Emil (`break-ui`, regra 2), adaptado: sem alternador nem fixture no repositório, porque a skill relata e para |
| Tabela de sintoma para causa, com "1 members" | Emil (`break-ui`, fase 4), só ideia, com linhas reescritas e menos colunas |
| `overflow-wrap`: `anywhere` em dados, `break-word` em títulos | Conflito da Task D5 (Emil pede `anywhere`; gstack e o piso pedem `break-word` em títulos) |

## Conflitos resolvidos

Todos pela Task D5:

- **Render ou código:** o gstack mede o render e também lê o código; o genjutsu audita só o código. O render julga se há desvio, e o código localiza. Sem navegador, o relatório diz "só código".
- **Alvo de toque:** a Impeccable e o genjutsu dão 24 px do WCAG com exceções; a UI UX Pro Max e o Emil falam em 44. Abaixo de 24 px sem exceção é P1; 44 px no toque é recomendação.
- **Input no celular:** a Impeccable aceita 14 px para texto secundário. Input fica em 16 px ou mais no celular.
- **Notas:** a Impeccable dá de 0 a 4 por dimensão e um total de 20; o gstack dá de 0 a 10 em `plan-design-review` (ledger de `visual-direction`). Só P0 a P3.
- **Corrigir ou relatar:** a Impeccable (`polish`, `harden`) e o Emil (`mobile-native`) corrigem; `break-ui` corrige sob pedido. A skill relata e para.
- **Ordem:** a Impeccable põe o funcional antes do cosmético; o gstack ordena por ganho visual. Funcional antes de visual.
- **`overflow-wrap`:** o Emil pede `anywhere` para não quebrar palavra de título; o gstack proíbe `anywhere` em título. `anywhere` em dados, `break-word` em títulos.

## Fora

- **Pela Task D5:** as personas (a usuária chata do `break-ui`, o engenheiro sênior do `mobile-native`), Nielsen, as notas, os subagentes isolados, o código de `frontend-a11y` (ECC), `user-select: none` em todo link e `overscroll-behavior: none` na raiz.
- **gstack:** o binário `gstack-design-lint`, o daemon de navegador, as regras de valor da tabela (px, OKLCH, durações), que são de `design-system` e `motion`, os comentários de dispensa, os códigos de saída, o perfil `--scope app` e a ordem de correção do `craft-audit`.
- **Impeccable:** o detector, `critique-storage`, os comandos sugeridos, os achados positivos obrigatórios, a parte de apps desktop com CDP e as seções de i18n árabe e persa (sem cenário).
- **Emil:** a resposta inicial fixa, o alternador "Demo data / Worst case" e a fixture deixada no projeto, as correções aplicadas, o realce de toque, `theme-color`, `user-select` em controles, hover só com `(hover: hover)` (sem cenário) e tudo de PWA.
- **genjutsu:** `audit.py`, as partes de SwiftUI e Compose, os atalhos canônicos por plataforma, janelas múltiplas, densidade e a doutrina de animação (é de `motion`).
- **UI UX Pro Max:** a busca em Python, as linhas fora de acessibilidade, toque, formulários e responsivo, os exemplos de código com classes do Tailwind.
- **reanimate:** a clonagem, `capture.ts`, `frames.ts` e os scripts com Playwright e ffmpeg; só a leitura de `getAnimations()` entrou.

## Revisões

- 2026-11-13, conferência frase a frase contra cada fonte, depois da primeira escrita. Reescritas por estarem perto demais:
  - `SKILL.md`: a linha em destaque "a page nobody measured never passes" (gstack); "a mood word ... authorizes nothing" com "editorial" e "agency" (genjutsu); as definições das quatro classes de desvio (Impeccable); "never as passed" (genjutsu); "Keep them few" (Impeccable).
  - `worst-case.md`: a abertura sobre dado gentil (Emil); "include what is easy to forget" e sua lista (Emil); "unbounded" como achado em si (Emil); "real person could produce, or the exact limit" e "prove nothing" (Emil); espalhar as falhas nas primeiras linhas (Emil); oito linhas da tabela de sintomas (Emil); "never truncate numbers, amounts, dates" (Emil).
  - `mobile-web.md`: a explicação do zoom do iOS, os `env()` que valem 0, "people copy addresses and order numbers" e a lista do que a emulação não mostra (Emil).

## Resultados

Opus 5.5, nível leve, 2 rodadas. Braço: sem plugin. `fusion/results/2026-11-13-ui-review*.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `ui-review-equipes` | 100% | 0% (0,38) |

- `accepted: true`. Sem navegador no sandbox, a revisão diz "só código" e acha os três problemas plantados, o campo de 14 px e o `user-scalable=no`, cala o desvio autorizado e não muda os arquivos.

## Decisões por commit de fonte

- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:docs/design-lint.md` | adotado | medir no render contra os tokens, URL não medida nunca passa, render pulado é dito, caminhada de foco, anel com fade, contraste pelos pixels pintados, uma linha por achado com arquivo e linha
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:docs/design-lint.md` | recusado | o binário, as regras com valores próprios, dispensas em comentário, códigos de saída, perfil de app, catálogo de faces
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-review/sections/craft-audit.md.tmpl` | adotado | classificar a página pelo modo antes de auditar
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-review/sections/craft-audit.md.tmpl` | recusado | rodar o lint, salvar o DOM, ordem de correção, Tailwind por versão
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/audit.md` | adotado | documentar sem corrigir, severidades P0 a P3, local e padrão violado por achado, alvo de 24 px com exceções, dizer o que produziu a evidência
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/audit.md` | recusado | notas de 0 a 4, total de 20, faixas, detector, comandos sugeridos, achados positivos obrigatórios
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/polish.md` | adotado | ler o sistema antes, quatro classes de desvio, funcional antes de cosmético
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/polish.md` | recusado | as correções, `critique-storage`, o diff final
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/harden.md` | adotado | entradas extremas (longo, curto, vazio, muitos itens, acentos e emoji), zoom de 200 %
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/harden.md` | recusado | os trechos de código, i18n árabe e persa, validação no servidor, desempenho, 14 px para texto secundário (conflito)
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/break-ui/SKILL.md` | adotado | mapa de valores com limite, pior caso plausível, vazio, um e enorme, entrar pela borda de dados, sintoma para causa, relatar antes de corrigir, dizer o que foi visto e o que foi inferido
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/break-ui/SKILL.md` | recusado | persona, resposta inicial, alternador e fixture no projeto, correção sob pedido, as severidades Broken, Ugly e Fragile (valem P0 a P3)
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/mobile-native/SKILL.md` | adotado | `dvh` e `svh`, input de 16 px, zoom nunca bloqueado, `inputmode`, `env()` com `viewport-fit=cover`, `touch-action: manipulation`, `overscroll-behavior: contain` em painéis, o que só o aparelho mostra
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/mobile-native/SKILL.md` | recusado | persona, resposta inicial, aplicar as correções, `overscroll-behavior: none` na raiz, `user-select: none` em links, realce de toque, `theme-color`, PWA
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b:src/ui-ux-pro-max/data/ux-guidelines.csv` | adotado | linhas de acessibilidade, toque, formulários e responsivo, reescritas pelos critérios do WCAG 2.2; AAA nunca como AA
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b:src/ui-ux-pro-max/data/ux-guidelines.csv` | recusado | as demais categorias, os exemplos de código, vibração, `fastclick`
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/design-audit/SKILL.md` | adotado | achado, limpa ou não aplicável, não aplicável como não conferido, vícios lidos no texto exibido, vício só com frase da tese, palavra de clima não autoriza, inventário com `arquivo:linha` sem veredito, contraste calculado com o par
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/design-audit/SKILL.md` | recusado | `audit.py`, listas por pilha, severidades Critical, Important e Nice-to-have
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/desktop-principles/SKILL.md` | adotado | menu hambúrguer em tela larga é defeito num sistema
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/desktop-principles/SKILL.md` | recusado | hover obrigatório, densidade, janelas, doutrina de animação, código de SwiftUI e Compose
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/desktop-principles/references/keyboard-patterns.md` | adotado | atalho de uma letra sem modificador não dispara digitando, atalhos do navegador não sequestrados
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/desktop-principles/references/keyboard-patterns.md` | recusado | tabelas de atalhos canônicos, acordes, descoberta
- `reanimate@3f7a55a2986a84ca2173e86ee9127eefe31d046d:skills/reanimate/references/capture.md` | adotado | ler duração, atraso e curva reais com `document.getAnimations()`
- `reanimate@3f7a55a2986a84ca2173e86ee9127eefe31d046d:skills/reanimate/references/capture.md` | recusado | captura de quadros, clonagem, scripts e WebGL
