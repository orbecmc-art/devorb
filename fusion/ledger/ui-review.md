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
| `references/critique.md`, `## Tells of a generated page`: os 7 sinais, cada um com o que se vê no print e o que entra no lugar; régua de `finish` (10 é nenhum sinal; com um ou mais, 7 ou menos) e de `visual-moment` (ícone no lugar de UI real ou "Feature 1/2/3" como momento, 5 ou menos) | DevOrb: nossos estudos A e B (`docs/specs/2026-11-18-referencias/study-A.md`, "What separates these from AI-generated pages"; `study-B.md`, "Craft vs AI pages"), sínteses e palavras nossas, sem texto de site. O que entra no lugar cita os ids do cardápio da Task 7 e os checks `display-weight` e `accent-count` da Task 5 |
| Autorizado é a exceção que `DESIGN.md` ou o contrato nomeia para esta página; token que só existe na tabela não autoriza, e um token usado como sinal continua sinal | DevOrb, decisão do controlador na Task 8 da Fase 2, para a regra de valores autorizados não anular os sinais |

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

- **Tell 3 aceita o par por seção.** O sinal de página gerada que conta matizes aceita dois matizes complementares quando cada um tem as suas seções (regra do dono, 2026-11-18, ver `design-system` e `visual-direction`). Tocou `references/critique.md`; no `SKILL.md` só entrou a linha `Sources:` do contrato no prompt do crítico (§6). Sem caso RED: ver a lacuna abaixo.
- **O crítico recebe a linha `Sources:` e anota quando o build ignorou as fontes.** Quando o despacho do implementador não trouxe as fontes de `ui-sources.json`, o crítico registra isso nos achados. Sem cenário próprio: `evals/implementing-fontes-ui` testa o implementador, não o crítico (ver `implementing`). Lacuna: nenhum caso mede que o crítico anote o build que ignorou as fontes.
- **Lacuna fechada (2026-11-19):** a regra do crítico (tell 3) agora tem caso RED. O caso `evals/ui-review-par-complementar` passava antes da mudança só por autorização, então o fixture mudou duas vezes na revisão final: (a) `DESIGN.md` e a spec deixam de declarar o par e qual seção é dona de qual cor (antes declaravam, e o caso passava pela autorização e não provava nada); (b) saem as palavras destacadas nos títulos (`.hl`) e os rótulos em maiúsculas espaçadas, porque quebram o piso e o revisor tirava pontos de cor por eles, o que o avaliador lia como acusação ao par (GREEN2 0/2, guardado em `fusion/results/2026-11-19-ui-review-par-green-confundido.md`). Com isso: RED2 (texto antigo do `main` 5534808, só o ajuste a) 0,50, 1 de 2 acusa o par, US$ 1,56; RED3 (texto antigo, ajustes a e b, `devorb@bf75520`) 0,50, 1 de 2 acusa o par, US$ 1,56; GREEN3 (`devorb@8232054`) 1,00 2/2, `none` 0,00, US$ 1,95. O caso deixa de ser só guarda de regressão. Arquivos: `fusion/results/2026-11-19-ui-review-par-red2.md`, `-red3.md` e `2026-11-19-ui-review-par.md`.

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

- 2026-11-18, Task 5 do plano `docs/plans/2026-11-18-design-quality-fase-2.md`: régua recalibrada contra as 23 referências (Call 7 e Pilar B da spec `docs/specs/2026-11-18-design-quality-fase-2-design.md`).
  - **Problema.** Na última rodada do `refs-check` (`fusion/results/2026-11-18-refs-check.md`), 19 das 23 referências davam FAIL, todas por `body-size` (corpo abaixo de 16px) ou `heading-ratio` (razão abaixo de 3,0). Os sites bons usam corpo de 13 a 15px, e a régua reprovava o que a gente quer copiar.
  - **`heading-ratio`.** FAIL abaixo do mínimo do modo e, em Persuade, WARN abaixo do alvo (`MODE_TARGET_RATIO = { persuade: 4.0 }`). O mínimo de Persuade cai de 3,0 para 2,5: a referência da agência do dono mede 2,9 no computador, e a Ligare, a página ruim, mede 2,0 e continua reprovada. O alvo de 4,0 vem da faixa típica das referências, de 4,2 a 5,5. Operate, Read e Experience não mudam (1,6, 2,0 e 2,0).
  - **`body-size`.** FAIL só com mediana abaixo de 13px, em Persuade e Read; sem amostra de corpo, continua FAIL. Em Read, de 13 até menos de 14px dá WARN. O estudo mediu corpo de 13 a 18px, com mediana de 14 a 15px.
  - **`font-sizes`.** WARN acima de 12 tamanhos distintos (antes 8): as referências usam de 6 a 26.
  - **`display-weight`, nova.** WARN quando uma amostra `h1` ou `h2` tem 48px ou mais, peso 700 ou mais e tracking de 0 ou mais. As referências usam título de peso 400 a 500 com tracking negativo, e título em negrito com tracking normal é um dos sinais de página feita por IA da spec.
  - **`accent-count`, nova.** WARN com mais de 2 matizes saturadas somando as cores de texto, os fundos de botão (`fills`, novo em `metrics.json`) e os fundos das seções. 9 de cada 10 referências usam uma cor de destaque. `accentHues` lê `rgb()`, `rgba()` (alfa até 0,1 fica de fora) e `oklch()` (com `%` e `/ alfa`); conta como saturada a cor `rgb` com saturação HSL de 0,35 ou mais e luminosidade de 0,15 a 0,9, e a `oklch` com croma de 0,08 ou mais; junta matizes a menos de 30° em grupos, também através do 0°; formato desconhecido é ignorado, sem `NaN`. Atalho registrado no código: a matiz HSL e a OKLCH ficam alguns graus fora uma da outra.
  - **Textos.** `references/critique.md`, dimensão `typography`: o corpo confortável passa de "cerca de 16px ou mais" para 14 a 16px, com lead de 18 a 22px. `skills/visual-direction/references/floor.md` ganha `## Measured`, com os limites que o `shoot.mjs` confere.
  - **Graders.** `grep -rnE '16 ?px|body-size' evals-outside/*/graders evals/*/graders` não acha grader que dependa do FAIL de corpo de 16px. `ui-review-critica-em-breve` continua com sentido: a página mede 26/13 = 2,0, FAIL em `heading-ratio`.
  - **Razão por largura.** A primeira rodada deu 17/23: os 6 FAIL eram `heading-ratio` em 768 ou 390 (orior, hoy, monocle, mobbin, parloa e agenciadevalor, razões de 2,0 a 2,46), com título e corpo conferidos como os de verdade. No celular e no tablet esses sites reduzem o título e mantêm o corpo, e a regra de mobile da própria spec (h1 de 32 a 64px sobre corpo de 16px) já dá 2,0. Decisão do controlador: `checkFloor` lê `m.width`, e abaixo de 1024px (`DESKTOP_MIN_WIDTH`) Persuade dá FAIL abaixo de 2,0 e WARN abaixo de 2,5; os outros modos dão FAIL abaixo de 0,8 vez o mínimo (`NARROW_RATIO_FACTOR`). Métrica sem `width` conta como computador. `MODE_MIN_RATIO` continua sendo a tabela do computador.
  - **Prova contra as referências.** Segunda rodada do `refs-check` em `fusion/results/2026-11-18-refs-check.md`: 23/23 PASS, zero FAIL; os seis sites acima ficam com WARN nas larguras estreitas.

- 2026-11-18, Task 8 do plano `docs/plans/2026-11-18-design-quality-fase-2.md`: sinais de página gerada no crítico.
  - **Problema.** A régua dava 10 em `finish` a uma página sem nada quebrado, mesmo com todos os vícios de página feita no automático: ícone no lugar do produto, tudo no centro, três cores de destaque, números genéricos, título pesado, mobile só empilhado e "Feature 1/2/3".
  - **`references/critique.md`** ganha `## Tells of a generated page`, depois da régua: os 7 sinais da spec (Pilar B), cada um com o que se vê no print e o que entra no lugar, com os ids `hero:` e `section:` do cardápio da Task 7 para a linha de correção do revisor. Dois sinais apontam para os checks que os medem: destaque demais para `accent-count`, título em negrito com tracking normal para `display-weight`. Sinal passa só com frase do contrato que o crítico possa citar, como no §4 do `SKILL.md`.
  - **Régua.** `finish`: o 10 é nenhum sinal visível; cada sinal visto vai no gap, e com um ou mais a nota fica em 7 ou menos. `visual-moment`: ícone no lugar de UI real ou "Feature 1/2/3" como momento da página dá 5 ou menos.
  - **Autorizado.** Uma linha ao lado da regra "o que `DESIGN.md` ou o contrato autoriza nunca é gap": autorizado é a exceção nomeada para esta página, e um token declarado usado como sinal continua sinal. Decisão do controlador, porque o caso declara de propósito todos os valores no `DESIGN.md` (peso 800, roxo, rosa e verde-água) e a regra antiga deixava o crítico desculpar dois sinais.
  - **`SKILL.md`** não muda: está em 9.982 bytes, perto do teto de tokens, e o texto todo fica em `critique.md`.
  - **Caso novo** `evals-outside/ui-review-sinais-de-ia`: a landing do Lote com `DESIGN.md` que declara todos os valores usados e os sinais plantados. Graders: `tells` (llm na resposta, peso 3: `finish` abaixo de 8 e três dos sete sinais nomeados), `new-checks` (regex: `display-weight` e `accent-count` na resposta), `fresh` (cópia do de `ui-review-critica-em-breve`) e `no-edits-index`. Medido no `shoot.mjs`: só `display-weight` e `accent-count` dão WARN, nas quatro larguras, sem FAIL. Limite do coletor: `accent-count` só lê cor de h1 a h3, `p`, `li`, botões e fundos de seção; destaque só em `strong`, `span` ou ícone não conta. Por isso os títulos dos cartões levam as três cores.

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

### Fase 2, Task 8 (sinais de página gerada)

RED em 2026-11-18, só a linha de base, fora do sandbox. Opus 5.5, 2 rodadas por caso, braço sem plugin. `fusion/results/2026-11-18-ui-review-outside-baseline.md`.

| Caso | Sem plugin | Custo |
|---|---|---|
| `ui-review-sinais-de-ia` | 0% (0,17) | US$ 0,55 |
| `ui-review-critica-em-breve` | 0% (0,56) | US$ 0,76 |

- A rodada custou US$ 1,31 no total. O caso novo falha sem o plugin, então o RED está confirmado.
- GREEN (`--arms devorb,none`) e o caso reservado ficam com o controlador e ainda não rodaram.

Plano de regras de cor e referências, 2026-11-19, Opus 5.5, 2 rodadas, `--arms devorb,none`. Arquivos: `fusion/results/2026-11-19-ui-review-par-red.md` e `fusion/results/2026-11-19-ui-review-par.md`.

| Caso | Etapa | devorb | none | Custo |
|---|---|---|---|---|
| `ui-review-par-complementar` | RED (`devorb@9b96a34`) | 1,00 (2/2, já passava) | 0,00 | US$ 2,09 |
| `ui-review-par-complementar` | GREEN (`devorb@4a966e3`) | 100% (1,00) | 0,00 | US$ 2,06 |
| `ui-review-par-complementar` | RED2 (texto antigo, fixture a) | 0,50 (1 de 2 acusa o par) | n/d | US$ 1,56 |
| `ui-review-par-complementar` | RED3 (texto antigo, fixture a+b, `devorb@bf75520`) | 0,50 (1 de 2 acusa o par) | n/d | US$ 1,56 |
| `ui-review-par-complementar` | GREEN3 (`devorb@8232054`) | 1,00 (2/2) | 0,00 | US$ 1,95 |

- Custo total do plano: US$ 43,09 dos US$ 50 aprovados (RED 3,83 + 2,09 + 7,66 + RED2 1,56 + RED3 1,56; GREEN 6,39 + 7,79 + 2,06 + 4,25 + GREEN2 2,06 + GREEN3 1,95; diagnóstico 1,89).

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
