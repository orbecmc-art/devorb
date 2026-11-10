# DevOrb: plano do setor mobile

> **For agentic workers:** REQUIRED SUB-SKILL: Use `devorb:implementing` once it exists, or `superpowers:subagent-driven-development` while the Superpowers is still installed, to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fundir as fontes de apps de celular em três skills do DevOrb, testadas, para o dono construir apps em Expo e Android nativo com o mesmo fluxo dos sites.

**Architecture:** Mesmo repositório, processo e ferramentas da base e do design. As entradas de `fusion/skills.json` trazem `"sector": "mobile"`, com teto próprio de custo fixo. Nenhuma fonte empresta texto.

**Tech Stack:** Markdown (skills), Node 22+ com `node --test`, `claude plugin eval` (cenários), `gh`.

**Spec:** `docs/specs/2026-11-08-devorb-design.md`, seção "Setor mobile". Leia junto com a Receita de fusão de `docs/plans/2026-11-08-devorb-base.md` e com "Como cada task aplica a receita" de `docs/plans/2026-11-09-devorb-design.md`, que vale aqui também.

## Global Constraints

- Tudo em "Global Constraints" do plano da base e do plano de design vale aqui.
- Começa no Mac, depois do Step 7 da Task 6 da base e da Task D1 do design, que dá a cada setor o seu teto de custo fixo.
- M2 espera a Task 8 da base. M4 espera M1 a M3 e as Tasks D2 a D5.
- Toda task que acrescenta um nome a `skills/using-devorb/SKILL.md` abre espaço tirando linhas que os testes não exigem, como as de "Red Flags". Limite: 3.500 bytes.
- Custo fixo do setor: até 150 tokens, nas duas descrições automáticas.
- Por skill ao ser chamada: 2.500 tokens. `SKILL.md` abaixo de 20.000 bytes.
- Toda fonte do setor tem `textReuse: false`. Credite no ledger.
- Nenhuma skill manda rodar `npx --yes @expo/agent-cli@latest feedback`, `curl | bash`, `npm install -g`, `eas login` ou `eas build`. EAS custa e pede conta: fica com o dono.
- Subir `targetSdk`, SDK do Expo ou AGP é decisão anunciada de `mobile-release`, nunca efeito colateral de outra skill.
- O sandbox não tem aparelho, emulador nem SDK do Android. Os graders leem arquivos e o transcript, e o que só o aparelho confirma a skill diz que ficou sem conferir.

## Review Focus

1. Projeto Expo sem `android/` e `ios/` no git: nada nativo é editado à mão, e o pacote entra com `npx expo install`. Casos de M1 e M3.
2. App Kotlin: edge-to-edge, teclado que não cobre a ação principal, voltar e rotação sem perder o que o usuário digitou. Caso Kotlin de M1.
3. Texto grande e leitor de tela: nada de `allowFontScaling={false}`, e todo controle tem rótulo e papel. Casos de M1 e M2.
4. Tablet e dobrável: navegação por largura, barra abaixo de 600 dp e trilho até 839. Caso Kotlin de M1.
5. Sem aparelho: a skill não declara pronto o que só o aparelho confirma. Caso de M2.

---

## Task M1: `native-app` (completo, 2.500)

**Files:** `skills/native-app/SKILL.md`, com `references/expo.md`, `references/android.md` e `references/false-friends.md`, mais `evals/native-app-*`, `evals-reserved/native-app-*`, `fusion/ledger/native-app.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** usada por `devorb:implementing` quando o projeto tem `expo` no `package.json` ou um `AndroidManifest.xml`. Lê os tokens de `devorb:design-system` e chama `devorb:motion` quando algo se move.

**Braços:** `none`.

- [ ] **Aplicar a receita.** Espinha: Expo (`expo-native-ui`, `false-friends`).
  - **Decisões:** o primeiro passo é ver se o projeto é Expo, Kotlin ou nenhum dos dois. Sem `expo` no `package.json` e sem `AndroidManifest.xml`, a skill para e diz isso.
  - **Expo, só ideias:**
    - Sem `android/` e `ios/` versionados, o projeto é gerado: o nativo muda por config plugin, e pacote entra com `npx expo install`.
    - O idioma web não porta: `View`, `Text`, `onPress`, lista virtualizada, nada de `position: fixed`. Variável `EXPO_PUBLIC_` não guarda segredo.
    - A área segura vem do header, das abas ou de `contentInsetAdjustmentBehavior`. O header nunca é refeito à mão, e módulos removidos do React Native, como `SafeAreaView` e `AsyncStorage`, não entram.
    - Tela com dados tem quatro estados, sem tela vazia na primeira carga. A ação principal fica fora do teclado.
  - **Android, só ideias, em `references/android.md`:** `enableEdgeToEdge()` antes de `setContent`, `adjustResize` e `innerPadding` no `contentPadding`. Nunca `configChanges` para fugir de rotação; entrada do usuário em `rememberSaveable`. Permissão: checar, explicar, pedir e levar às configurações na negativa permanente. `PickVisualMedia` no lugar de permissão de mídia, e `PendingIntent` imutável.
  - **Material 3 e Android, só ideia:** barra de navegação abaixo de 600 dp e trilho até 839, por `NavigationSuiteScaffold`.
  - **Conflitos:** os da spec, em "Setor mobile". Em especial: as regras do Android valem só em app Kotlin, e Material 3 nunca no iOS.
  - **Fora:** o roteador `expo-overview`, o MCP da Expo, as skills `eas-*` e o pedido de feedback à Expo.
  - **`using-devorb`:** adicionar a linha `| Building a mobile app screen | devorb:native-app |`. Respeite o limite de 3.500 bytes.
  - **Caso realista:** o scaffold cria um app Expo sem `android/`, com a tela de pedidos em `app/(tabs)/orders.tsx` e a spec aprovada de uma lista de pedidos com detalhe em sheet. Prompt: "segue a spec aprovada e faz a tela de pedidos". Graders:
    - `regex` `not_contains` para `<div`, `onClick` e `SafeAreaView`, cada um em `app/(tabs)/orders.tsx`;
    - `llm` com foco `files`: quatro estados, sheet nativa e nenhuma cor fora do tema.
  - **Caso Kotlin:** o scaffold cria um app Compose com `app/src/main/java/com/example/form/MainActivity.kt`, `app/src/main/AndroidManifest.xml` e um formulário. Prompt: "ajusta a tela em app/src/main/java/com/example/form/MainActivity.kt para ocupar a tela toda e não perder o que foi digitado ao girar". Graders: `regex` para `enableEdgeToEdge` em `app/src/main/java/com/example/form/MainActivity.kt`, `regex` `not_contains` para `configChanges` em `app/src/main/AndroidManifest.xml`, e `llm` com foco `files` para `rememberSaveable`.
  - **Reservado (R1):** um subagente novo escreve um caso a partir dos itens 3 e 4 do Review Focus.

## Task M2: `device-testing` (leve, 2.500)

Só depois da Task 8 da base.

**Files:** `skills/device-testing/SKILL.md`, com `references/android-tests.md`, mais `evals/device-testing-*`, `fusion/ledger/device-testing.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** roda em `devorb:verifying`, antes de `devorb:ui-review`, quando o projeto é um app. É o par de `devorb:browser-testing`. Falha encontrada vai para `devorb:debugging`.

**Braços:** `none`.

- [ ] **Aplicar a receita.** Espinha: Android (`testing/testing-setup`).
  - **Expo (`expo-native-ui`), só ideias:** antes de dizer pronto, conferir a tarefa principal, uma falha, o teclado, o voltar, um título longo e texto grande, e dizer o que não rodou.
  - **Expo (`expo-web-to-native/SKILL.md`, lido uma vez, não acompanhado) e Emil (`animate-expo`), só ideia:** build verde não prova que a tela renderiza. Fluidez só se julga em build de release, no aparelho mais lento.
  - **Android, só ideias, em `references/android-tests.md`:** teste de UI em `src/test` com Robolectric, e `androidTest` só a pedido. Fake antes de mock, e busca por semântica, não por id.
  - **Android e genjutsu, só ideia:** captura de tela em 400, 610 e 900 dp e com fonte em 1,5x. Todo controle tem rótulo e papel para o leitor de tela.
  - **`using-devorb`:** acrescentar `devorb:device-testing` à linha de app.
  - **Caso Expo:** o scaffold cria um app Expo com um texto solto fora de `<Text>` em `app/(tabs)/profile.tsx`. Prompt: "confere se a tela de perfil funciona antes de eu publicar". Grader `llm` no `last_message`: acha o texto solto, diz que não havia aparelho, lista o que conferir nele e não declara pronto.
  - **Caso Kotlin:** outro scaffold, um app Compose com `app/src/main/java/com/example/profile/ProfileScreen.kt` e nenhum teste. Prompt: "escreve o teste da tela em app/src/test/java/com/example/profile/ProfileScreenTest.kt e confere antes de eu publicar". Graders: `regex` para `createComposeRule` em `app/src/test/java/com/example/profile/ProfileScreenTest.kt`, e `llm` no `last_message` para o que só o aparelho confirma.

## Task M3: `mobile-release` (leve, 2.500, manual)

**Files:** `skills/mobile-release/SKILL.md`, com `references/play-policy.md`, mais `evals/mobile-release-*`, `fusion/ledger/mobile-release.md`, `skills/using-devorb/SKILL.md`

**Interfaces:** chamada só pelo usuário, com `/devorb:mobile-release` e `disable-model-invocation: true`. Roda depois de `devorb:finishing`.

**Braços:** `none`.

- [ ] **Aplicar a receita.** Espinha: Expo (`expo-upgrade`, `expo-dev-client`) e Android (`agp-9-upgrade`, `play-policy-insights`).
  - **Expo, só ideias:** usar a documentação da versão do SDK do projeto, nunca a mais recente. Rodar `npx expo install --fix` e `expo-doctor` a cada mudança. Build local é grátis; EAS custa e pede conta, e fica com o dono.
  - **Android, só ideias:** AGP abaixo de 9: parar e perguntar. Depois, tirar `kotlin-android` e trocar kapt por KSP.
  - **Android, só ideias, em `references/play-policy.md`:** `foregroundServiceType` em todo serviço, `<queries>` no lugar de `QUERY_ALL_PACKAGES`, e exclusão de conta dentro do app.
  - **Decisão própria:** subir `targetSdk`, SDK do Expo ou AGP é anunciado antes, com o motivo.
  - **`using-devorb`:** adicionar `devorb:mobile-release` à lista de skills manuais.
  - **Caso realista:** um app Expo gerado, sem `android/`, com `app.json` em `expo.android.versionCode` 7 e `QUERY_ALL_PACKAGES` em `expo.android.permissions`. Prompt: `/devorb:mobile-release prepara a 1.2.0`. Graders:
    - `regex` para `"versionCode":\s*8` em `app.json`;
    - `llm` no `trace`: nenhum `eas login` nem `eas build`;
    - `llm` no `last_message`: aponta a permissão em `app.json` e propõe declarar os pacotes com `<queries>` por config plugin.

## Task M4: Ligar o setor ao fluxo e ao design

Só depois de M1 a M3 e das Tasks D2 a D5.

**Files:** `skills/design-system/references/native.md`, `skills/motion/references/native.md`, `skills/ui-review/references/native.md`, `skills/visual-direction/SKILL.md`, `skills/verifying/SKILL.md`, `skills/implementing/SKILL.md`, os ledgers dessas skills, `evals/using-devorb-mobile-triggers/`

- [ ] **Step 1: Escrever os casos de disparo.** Com prompts em português, graders `tool_used` na ferramenta `Skill` e uma spec aprovada no scaffold: "faz a tela de login do app" num projeto Expo dispara `native-app`, e "confere o app antes de publicar" dispara `device-testing`.
- [ ] **Step 2: Rodar `node tools/compare.mjs --skill using-devorb --arms devorb,superpowers`.** Anote o resultado.
- [ ] **Step 3: Escrever as referências nativas, só ideias.**
  - **`design-system`:** cor semântica da plataforma em superfície e texto, marca em pares claro e escuro, cor dinâmica só a partir da API 31 com esquema de reserva, e nunca `allowFontScaling={false}`.
  - **`motion`:** troca de aba não desliza. Reanimated, não `Animated`. Mola quando o dedo está no elemento. Háptico no mesmo quadro da animação, nunca como único retorno. Em Compose, animar dentro de `graphicsLayer{}`.
  - **`ui-review`:** os vícios de "native slop" da Expo, com as buscas e sem nota. Alvo mínimo de 44 pt ou 48 dp, com `hitSlop`.
  - **`visual-direction`:** o contrato ganha uma linha com o idioma de cada plataforma, ou com um tratamento neutro registrado.
  - **`verifying`:** roda `devorb:device-testing` antes de `devorb:ui-review` quando o projeto é um app.
  - **`implementing`:** usa `devorb:native-app` quando o projeto é um app.
- [ ] **Step 4: Rodar `npm test`, repetir o Step 2 e rodar `node tools/compare.mjs --skill all --arms devorb,superpowers`.** Esperado: `accepted: true`, sem piora nas skills tocadas.
- [ ] **Step 5: Commit** `feat: connect the mobile sector`, com o `CHANGELOG.md` e a versão, e abra o pull request.

## Task M5: Uso real (portão do dono)

- [ ] **Step 1: Medir.** `npm test`. Esperado: o custo fixo do setor em até 150 tokens.
- [ ] **Step 2: PARAR. O dono usa o setor num app real** e diz se fica. Registre o resultado no registro de progresso, com o `CHANGELOG.md`, suba a versão em uma unidade menor e abra o pull request.
