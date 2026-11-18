# Ledger: `ui-review`

Skill automática, de nível leve na Task D5 e de nível completo desde a Task 5 do plano `docs/plans/2026-11-17-design-quality-fase-1.md`. Nasceu da Task D5 do plano de design (`"sector": "design"`). Espinha: gstack (`docs/design-lint.md`, `design-review/sections/craft-audit`). Outras fontes: Impeccable (`audit`, `polish`, `harden`), Emil (`break-ui`, `mobile-native`), UI UX Pro Max (`ux-guidelines.csv`), genjutsu (`design-audit`, `desktop-principles`, `desktop-principles/references/keyboard-patterns`) e reanimate (`references/capture`). Todas com `textReuse: false`: entraram só ideias, escritas com voz própria.

Pinos lidos, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos de `fusion/sources.json`, sem rodar nada:

- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`: `docs/design-lint.md`, `design-review/sections/craft-audit.md.tmpl`.
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430`: `skill/reference/audit.md`, `polish.md`, `harden.md`.
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/break-ui/SKILL.md`, `skills/mobile-native/SKILL.md`.
- `ui-ux-pro-max@4f2dbb67e64969a9a30ab00742f2d55d66ddec2b`: `src/ui-ux-pro-max/data/ux-guidelines.csv` (as linhas de acessibilidade, toque, formulários e responsivo).
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`: `skills/_jutsu/design-audit/SKILL.md`, `skills/_jutsu/desktop-principles/SKILL.md`, `skills/_jutsu/desktop-principles/references/keyboard-patterns.md`.
- `reanimate@3f7a55a2986a84ca2173e86ee9127eefe31d046d`: `skills/reanimate/references/capture.md`.

A skill foi escrita sem abrir `evals/ui-review-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task D5 no plano. `devorb:design-system` e `devorb:motion` estavam sendo escritas em paralelo: a skill as cita pelo nome e aponta para "as referências" delas, sem nomear arquivo que talvez não exista.

`SKILL.md` tinha 6.767 bytes na Task D5 e tem hoje 9.893 (ver Revisões, Task 5 de 2026-11-17; teto de 2.500 tokens). A descrição custa cerca de 44 tokens com o nome, dos 250 do setor.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (tela construída a conferir contra contrato, `DESIGN.md`, acessibilidade ou web no celular; pedido de revisar interface) |
| Abertura: `browser-testing` responde se funciona, esta skill se ficou como combinado; não decide gosto nem valor, não corrige | Fronteiras da spec ("Setor de design") e interface da Task D5. Desde 2026-11-17: gosto só pela régua escrita (ver Revisões) |
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
- **Notas:** a Impeccable dá de 0 a 4 por dimensão e um total de 20; o gstack dá de 0 a 10 em `plan-design-review` (ledger de `visual-direction`). Só P0 a P3. Revisto em 2026-11-17: notas de 0 a 10 só no bloco Critique, e cada nota abaixo de 8 vira P1.
- **Corrigir ou relatar:** a Impeccable (`polish`, `harden`) e o Emil (`mobile-native`) corrigem; `break-ui` corrige sob pedido. A skill relata e para.
- **Ordem:** a Impeccable põe o funcional antes do cosmético; o gstack ordena por ganho visual. Funcional antes de visual.
- **`overflow-wrap`:** o Emil pede `anywhere` para não quebrar palavra de título; o gstack proíbe `anywhere` em título. `anywhere` em dados, `break-word` em títulos.

## Regras próprias

- **Bloco Critique copiado ao pé da letra, e cada nota abaixo de 8 com sua linha `[P1]`.** O revisor copia o bloco do crítico no formato fixo: a linha `Critique (…):` e, depois, uma linha `<dimension>: <0-10> — a 10 here: … — gap: …` por dimensão, na ordem da régua. Nunca tabela, nunca resumo, porque `devorb:verifying` lê esse bloco. Toda nota abaixo de 8 ganha sua própria linha `[P1]` nos achados, mesmo quando um achado medido já cobre o mesmo problema: nesse caso a linha cita o número do achado (`[P1] hierarchy 3/10 — see finding 3`) em vez de sumir. A exceção é a nota cuja lacuna mira só o que o `DESIGN.md` ou o contrato autoriza, ou um valor que ninguém declarou: a linha fica no bloco como veio e não ganha P1. Se o crítico não consegue ler `critique.md` no caminho do plugin, o revisor copia o arquivo para uma pasta temporária e passa o caminho da cópia, sem colar o texto. Está no passo 5 da §6 do `SKILL.md` e em `references/critique.md`.

  Cenário: o GREEN fora do sandbox de 2026-11-17 (`devorb@cbba161`, `fusion/results/2026-11-17-ui-review-outside.md`). O crítico acertou o conteúdo: hierarchy 3, visual-moment 1, reference-fidelity 1, e a razão medida de 2,0 contra 3,29. Mesmo assim, nas duas rodadas o revisor transformou o bloco numa tabela em markdown e não listou as notas baixas como P1, dizendo que "repetiam os achados medidos". O crítico também não conseguiu ler `critique.md` no caminho do plugin; o revisor copiou o arquivo para uma pasta temporária e rodou de novo.

## Fora

- **Pela Task D5:** as personas (a usuária chata do `break-ui`, o engenheiro sênior do `mobile-native`), Nielsen, as notas e os subagentes isolados (os dois voltaram na Task 5 de 2026-11-17, só no bloco Critique), o código de `frontend-a11y` (ECC), `user-select: none` em todo link e `overscroll-behavior: none` na raiz.
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
- 2026-11-13, Task M4 do plano mobile: `references/native.md` novo, só ideias, palavras próprias. Os vícios de "native slop" da Expo (`plugins/expo/skills/expo-design-system/references/native-slop.md`, `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`, MIT, `textReuse: false`) viram buscas próprias e uma lista do que só a tela mostra, sem nota nem contagem; alvo mínimo de 44 pt ou 48 dp, medido com `hitSlop` (genjutsu `mobile-principles/SKILL.md`, `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`). Severidade do alvo abaixo do mínimo, P2 e P1 na ação principal: decisão minha. Duas buscas são minhas: hex fora do tema e o filtro de tema em `fontFamily`. `SKILL.md` aponta para a referência e recebe de `devorb:device-testing` em app (6.767 para 6.879 bytes).

- 2026-11-17, Task 5 do plano `docs/plans/2026-11-17-design-quality-fase-1.md`: crítico de olhos novos.
  - **Fronteira mudou.** Antes a skill não julgava gosto ("Ugly is not a rule"). Agora julga a estética, mas só pela régua escrita em `references/critique.md` e por um revisor que não vê o código. Valor que ninguém declarou continua sem ser achado de token. Três frases mudaram: a abertura ("taste is judged only through the written rubric"), a §7 ("no grade outside the Critique block") e o sinal de parada ("Ugly is judged by the rubric, with a fresh reviewer"). A §6 nova, "Visual critique", fica depois das checagens, e Severidade e Relatório viraram §7 e §8.
  - **§6 em cinco passos:**
    1. `shoot.mjs` pelo caminho absoluto, no modo do contrato, com `--pw` quando o projeto não tem Playwright;
    2. FAIL do `checks.json` vira P1, WARN vira P2;
    3. com pacote de referência, `compareStructure` (o motivo de `grossFail` é P1 Conceptual mismatch, o desvio é P2); sem as métricas no pacote, fotografar o `source.html` ou a URL dele;
    4. despachar um subagente novo cujo prompt cita pelo caminho `references/critique.md`, os prints, o pacote e o contrato, sem código e sem dizer quem construiu; a régua nunca é colada no prompt;
    5. copiar o bloco `Critique` no relatório; nota abaixo de 8 vira `[P1]`, com classe Conceptual mismatch ou Local defect.

    Sem ferramenta de subagente, o próprio revisor critica só pelos prints e diz isso no título do bloco. Sem navegador, o bloco sai do código, a primeira linha diz "only code" e as notas de render levam "(from code)".
  - **`references/critique.md`:** a régua tem 9 dimensões nesta ordem: hierarchy, layout-grid, spacing-rhythm, typography, color-contrast, visual-moment, motion, finish e reference-fidelity (`n/a` sem pacote). Cada uma diz o que olha e como é o 10. O arquivo traz âncoras de 10, 8, 5 e 2, o formato `Critique (fresh reviewer):` com uma linha `<dimension>: <0-10> — a 10 here: … — gap: …` por dimensão, e três exemplos próprios (padaria, academia, página de preços). Os exemplos não repetem o cenário do caso de avaliação.
  - **Origem das ideias.** Só ideias, com texto próprio, e `textReuse: false` em todas:
    - gstack (MIT): nota de 0 a 10 com "como seria o 10" por dimensão. A ideia já estava registrada no ledger de `visual-direction` (`plan-design-review`, mesmo pino `1b96d9f8538ae0f3b66dd52b75793a3767e514d4`). Não reabri o arquivo nesta task.
    - Hallmark (MIT, `407fa689f4a276f2fd389208d271d0fef08f5058`): o revisor de contexto limpo, que nunca viu o código nem quem fez.
    - UICrit (Duan et al., UIST 2024, conjunto de dados de críticas de UI, CC BY 4.0): a forma de cada exemplo (problema, onde, por que importa, correção). Nenhum texto do conjunto foi copiado, e os três exemplos são meus. Não está em `fusion/sources.json`, porque é artigo e conjunto de dados, não repositório com pino.
    - taste-skill (MIT, `f6b76575f949707b4e3c37cd86cb44b0b98643e8`): conferir a consistência do build pelos prints (escala, ritmo, acabamento). Essa parte já entrou como `checks.json` na Task 2. Aqui virou as dimensões spacing-rhythm e finish.
  - **Caso novo** `evals-outside/ui-review-critica-em-breve`, fora do sandbox porque precisa de navegador. É uma página "Em breve" do Prumo que usa só tokens do `DESIGN.md` e é feia do jeito da Ligare: faixa chapada com título de 26px, corpo de 13px, coluna esquerda com três linhas e um vazio, nenhum momento visual e quatro seções contra seis da referência. Traz um pacote pronto em `design/referencias/ref-agenda/`. Os graders são:
    - `critique` (bloco com as 9 dimensões, notas abaixo de 8 em hierarchy e reference-fidelity, e P1 para as duas);
    - `fresh` (um `Agent` cujo input cita `critique.md`);
    - `no-edits-index`, `no-edits-styles` e `design-unchanged`;
    - `token-pass` (não acusar token errado onde os tokens estão certos).

    Há também um caso reservado no sandbox, escrito por um subagente novo, que não abri.
  - `fusion/skills.json`: `ui-review.level` foi de `light` para `full`. `SKILL.md` foi de 6.879 para 9.893 bytes (cerca de 2.474 tokens, teto 2.500).
  - **Rodada de correção da revisão:**
    - o 10 de typography passou a 60 a 75 caracteres por linha, como o piso;
    - a lacuna do crítico que mira o que o `DESIGN.md` ou o contrato autoriza, ou que só pede um valor que ninguém declarou, é descartada e não vira P1, e o crítico recebe o `DESIGN.md` para não mirar nas exceções;
    - instalar o Playwright ou baixar navegador segue `devorb:browser-testing`: decide o usuário, só o sim explícito dele conta, e sem o sim a revisão é só de código;
    - a ordem dos fallbacks ficou explícita: `Critique (self):` com prints e sem subagente, e `Critique (self, from code):` sem navegador;
    - o caso ganhou o grader `design-unchanged`, e `token-pass` libera `320px`, `640px` e bordas de 1px.
  - **Segunda rodada:**
    - sem navegador e com ferramenta de subagente, o crítico novo é despachado mesmo assim, pelo caminho de `critique.md`, com os caminhos do `DESIGN.md`, do contrato, do pacote e do HTML e CSS da página. Só nesse caminho ele lê código, porque não há prints, e não afirma nenhuma medida visual. O bloco sai como `Critique (fresh reviewer, from code):`.
    - Sem navegador e sem subagente, o bloco continua `Critique (self, from code):`.
    - A ordem dos quatro fallbacks foi para o fim de `critique.md`, e o `SKILL.md` aponta para ela.
    - O prompt do caso ganhou um sim explícito para instalar: "Pode instalar o que precisar para renderizar a página."

- 2026-11-18, Task 1 do plano `docs/plans/2026-11-18-design-quality-fase-2.md`: revelação forçada.
  - **Problema.** Em 6 dos 23 sites de referência (monocle, parloa, sol, vercel, aave, hoy), seções inteiras saíam em branco no print, porque o conteúdo só aparece quando entra na tela ou depois de uma animação.
  - **`scripts/reveal-init.js`**, novo, entra com `addInitScript` antes do `goto`: troca o `IntersectionObserver` por uma subclasse que entrega toda entrada como visível (`isIntersecting: true`, `intersectionRatio: 1`). Sem `IntersectionObserver`, não faz nada.
  - **`window.__devorbReveal()`** em `collect-in-page.js`, depois da rolagem e antes de `__devorbExpand()`: termina cada animação com `finish()` (a infinita lança e fica como está), marca com `data-devorb-reveal` o conteúdo com opacidade abaixo de 0,1 ou `visibility: hidden` e injeta uma folha que o mostra com `!important`. Menus, diálogos, tooltips, listas e camadas `position: fixed` ficam de fora, para nada fechado ser pintado por cima das seções. Depois da folha, termina de novo as animações novas: a folha dispara transições de opacidade, e uma transição vence o `!important` (achado no monocle, onde 92 itens ainda saíam em opacidade 0).
  - **`metrics.json`** ganha `revealed` (quantos elementos a revelação marcou) e `hiddenContent` por seção (conteúdo com opacidade própria abaixo de 0,1, ou escondido, depois da revelação). `__devorbMetrics()` refaz a revelação no mesmo tick antes de medir, e o `shoot` a refaz antes de cada print.
  - **Barra de zero `hiddenContent`** certifica que a revelação funciona no momento da medida e do print. Print em branco de cena de rolagem fixada é limite conhecido e registrado, não item da barra. `replicate.md` lê `revealed` acima de 0 como movimento ao rolar, e o caminho com ferramenta de navegador de `critique.md` roda `__devorbReveal()`.
  - **Origem da ideia.** Trocar o `IntersectionObserver` e terminar as animações antes do print vem do `mirror.js` da skill `av-design-system` do dono. Só a ideia: o código e o texto são do DevOrb, sem trecho copiado.

- 2026-11-18, Task 2 do plano `docs/plans/2026-11-18-design-quality-fase-2.md`: página longa e site pesado.
  - **Problema.** Quatro sites de referência derrubavam o `shoot.mjs` inteiro por um print só. Shopify Editions e Patensify, com páginas acima de 16.000px, paravam em "Clipped area is either empty or outside the resulting image"; Audienceful e Melius, em "Timeout 30000ms exceeded".
  - **`planShots(pageHeight, sections, viewportHeight = 900)`** devolve `fullClip`, `perSection` e `skipped`. A seção que cabe na imagem de página inteira (16.000px) sai recortada dela; a que passa disso sai sozinha, com `fullPage: false`, depois de rolar a janela até o topo dela. O recorte fica só na parte da seção que está dentro da página: uma seção fixada ou deslocada que começa acima do topo perde o trecho de fora. Seção escondida, com largura abaixo de 1px ou sem nenhum trecho dentro da página é pulada, com o motivo.
  - **Rolagem no fim da página.** A janela para antes do topo de uma seção curta no fim da página (o rodapé). `shootPage` desloca o recorte pelo que a janela não conseguiu rolar, para o print não pegar a seção de cima.
  - **Print que falha.** Todo `page.screenshot` usa `animations: 'disabled'` e `timeout: 60000`. A rolagem até a seção faz parte de cada tentativa. Na falha, tenta mais uma vez com `caret: 'hide'`; na segunda falha, a primeira linha da mensagem entra em `shotErrors` e a execução segue. As seções puladas também entram, como `skipped: hidden` ou `skipped: empty`.
  - **`metrics.json`** ganha `shotErrors: { shot, error }[]`, com `shot` igual a `full` ou `section-<i>`.
  - **`goto`** espera `domcontentloaded` em vez de `load`, seguido da espera de rede ociosa de 5s que já existia: sites que nunca terminam de carregar deixam de travar a captura.

- 2026-11-18, Task 3 do plano `docs/plans/2026-11-18-design-quality-fase-2.md`: segundo critério de seções.
  - **Problema.** A Billow dava 0 seções. Sem `main`, o primeiro critério desce por `body` e dois `div` de página inteira até o rodapé, porque os blocos de conteúdo ficam atrás de um wrapper sem caixa (0×0, `display: contents`) e o cabeçalho tem 79px.
  - **`findSections(tree)`** devolve `{ root, nodes }`. Usa o primeiro critério quando ele dá 2 seções ou mais. Senão, a partir de `main` (ou da árvore), escolhe o nó com mais filhos de largura de pelo menos 90% da largura de partida e altura de 120px ou mais, o primeiro em pré-ordem no empate; com 2 ou mais, esse nó e esses filhos são as seções. `findSectionsRoot`, `sectionNodes` e `findScroller` não mudam.
  - **Coletor.** `__devorbMetrics` usa a cópia `__devorbFindSections`, e `root` passa a ser a tag do nó escolhido. `__devorbTree()` devolve a árvore medida, para depurar.
  - **Billow medida.** 5 seções a 1440 e a 390. O estudo A contou cerca de 13: os três blocos que têm cada um o seu próprio wrapper sem caixa e o rodapé ficam de fora, porque o critério só conta filhos diretos.

## Resultados

Opus 5.5, nível leve, 2 rodadas. Braço: sem plugin. `fusion/results/2026-11-13-ui-review*.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `ui-review-equipes` | 100% | 0% (0,38) |

- `accepted: true`. Sem navegador no sandbox, a revisão diz "só código" e acha os três problemas plantados, o campo de 14 px e o `user-scalable=no`, cala o desvio autorizado e não muda os arquivos.

RED da Task 5, 2026-11-17: Opus 5.5, braço sem plugin, fora do sandbox. `fusion/results/2026-11-17-ui-review-outside-baseline.md`.

| Caso | Sem plugin |
|---|---|
| `ui-review-critica-em-breve` | 0% (0,50), US$ 0,90 |

- O braço com a skill antiga não rodou neste RED. Ela proibia nota ("No grade, score or total anywhere") e dizia "Ugly is not a rule", então não podia produzir o bloco Critique. O GREEN (`--arms devorb,none --outside-sandbox` e `--reserved`) fica para o controlador.

GREEN da Task 5, 2026-11-17: Opus 5.5, 2 rodadas, fora do sandbox, com a skill em `devorb@cbba161` (antes da regra própria acima). Arquivo: `fusion/results/2026-11-17-ui-review-outside.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `ui-review-critica-em-breve` | 0% (0,67), US$ 2,59 | 0% (0,56), US$ 0,72 |

- `accepted: true`, e o caso ficou como lacuna (nenhum braço passa). As duas rodadas do DevOrb passaram em `fresh`, `no-edits-*`, `design-unchanged` e `token-pass`, e falharam em `critique`: o bloco virou tabela e as notas abaixo de 8 não viraram P1. Isso deu origem à regra própria acima, que foi escrita depois desta rodada e ainda não foi medida.

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
