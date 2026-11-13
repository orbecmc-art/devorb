# Ledger: `native-app`

Skill automática de nível completo, da Task M1 do plano mobile, primeira do setor mobile (`"sector": "mobile"`). Espinha: Expo (`expo-native-ui` e `expo-web-to-native/references/false-friends`, MIT). Outras fontes: Expo (`expo-data-fetching`, `expo-overview`, `expo-design-system`, `expo-design-system/references/native-slop`), Android (`system/edge-to-edge`, `jetpack-compose/adaptive`, `security/android-permissions-security`, `security/android-intent-security`, Apache-2.0), Material 3 (`references/navigation-patterns`, `references/theming-and-dynamic-color`, MIT), genjutsu (`mobile-principles`, `compose-motion/references/recomposition-and-anim`, `compose-multiplatform/references/cmp-platform-quirks`, MIT) e Emil (`animate-expo`, MIT). Todas com `textReuse: false`: só ideias, escritas com palavras próprias e creditadas aqui. Nenhum texto, tabela ou exemplo de código delas entrou, e `LICENSES/NOTICE.md` não muda.

Pinos lidos, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos que o Mapa de skills do mobile dá a esta skill, sem rodar nada:

- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`: `plugins/expo/skills/expo-native-ui/SKILL.md`, `expo-web-to-native/references/false-friends.md`, `expo-design-system/SKILL.md`, `expo-design-system/references/native-slop.md`, `expo-data-fetching/SKILL.md`, `expo-overview/SKILL.md`.
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d`: `system/edge-to-edge/SKILL.md`, `jetpack-compose/adaptive/SKILL.md`, `security/android-permissions-security/SKILL.md`, `security/android-intent-security/SKILL.md`.
- `material-3-skill@14385f2bf3804d8779f8b4db2604211f1e70b4c1`: `skills/material-3/references/navigation-patterns.md`, `theming-and-dynamic-color.md`.
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`: `skills/_jutsu/mobile-principles/SKILL.md`, `compose-motion/references/recomposition-and-anim.md`, `compose-multiplatform/references/cmp-platform-quirks.md`. `mobile-principles/references/accessibility-mobile.md` é de `device-testing` (fragmento mais longo) e não foi lido aqui.
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/animate-expo/SKILL.md`.

A skill foi escrita sem abrir `evals/native-app-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task M1 no plano. Ela foi escrita na pasta de preparo e o coordenador a move para `skills/native-app/`.

`SKILL.md` tem cerca de 2.039 tokens (teto 2.500). A descrição custa cerca de 37 tokens (nome mais descrição) dos 150 do setor, que divide com `device-testing`. As referências: `expo.md` cerca de 1.918, `android.md` cerca de 1.906, `false-friends.md` cerca de 1.610.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (tela, formulário, navegação ou ajuste nativo em app Expo ou Android em Kotlin) |
| Abertura: hábito web compila e quebra no aparelho; a skill decide como a tela é construída, não valores nem movimento | Fronteira da spec ("Setor mobile", `native-app`) e `false-friends` (a ideia de falso amigo), reescrita |
| 1. Primeiro passo: Expo, Kotlin ou nenhum; nenhum faz parar e dizer | **Decisão da Task M1**. O sinal `expo` no `package.json` vem de `expo-overview` (Start Here 1); ler a versão do SDK e a documentação versionada, de `expo-overview` (Shared setup rules) e da spec ("atualizar com a documentação da versão do SDK") |
| As regras do Android só em app Kotlin | Conflito da spec (ver abaixo) |
| 2. Projeto sem `android/` e `ios/` é gerado: nativo por config plugin; `npx expo install` | `expo-overview` (Managed vs. bare, Install packages) e decisão da Task M1, reescritos |
| Expo Go até entrar plugin ou módulo nativo, depois build local | `expo-native-ui` (Running the App) e conflito da spec |
| EAS, logins e instalação global ficam com o dono | Global Constraints do plano mobile e spec |
| SDK, AGP e `targetSdk` sobem só em `mobile-release` | Global Constraints e conflito da spec |
| 3. Idioma web não porta: primitivas, `onPress`, lista virtualizada, sem `position: fixed`, CSS ou hover | `false-friends` e `expo-native-ui` (Behavior), por decisão da Task M1 |
| `EXPO_PUBLIC_` não guarda segredo; token em `expo-secure-store` | `expo-data-fetching` (Environment Variables, Authentication) e `false-friends`, por decisão da Task M1 |
| Módulos removidos do React Native não entram | `expo-native-ui` (Library Preferences), por decisão da Task M1 |
| 4. Área segura do header, das abas ou de `contentInsetAdjustmentBehavior`; sem `SafeAreaView` de nenhum pacote em tela com header ou abas; `useSafeAreaInsets` em tela cheia | `expo-native-ui` (Responsiveness, General Styling) e `native-slop` (17), por decisão da Task M1. "De nenhum pacote" é ajuste meu: `react-native-safe-area-context` também exporta um `SafeAreaView` |
| Título e voltar pelo navegador, nunca header refeito | `expo-native-ui` (stack title) e `native-slop` (11) |
| Sheet nativa com detents e arrastar; abas da plataforma | `native-slop` (1, 2, 5) e Emil (`animate-expo`, tabela de ferramentas) |
| Cada plataforma no seu idioma; Material 3 nunca no iOS; tratamento neutro só registrado na spec | `expo-native-ui` (Styling), `native-slop` (16), genjutsu (`cmp-platform-quirks`, Material 3 components) e conflito da spec. O registro na spec vem da linha nova do contrato de `visual-direction` (spec, Fronteiras) |
| Cores, tipo e espaço do tema; nada de hex na tela; papel novo entra no tema por `design-system` | `expo-design-system` (Adopt Before You Build, The Theme), com a regra de três usos do DevOrb (conflito) |
| 5. Quatro estados; vazio nunca na primeira carga; erro de atualização mantém o conteúdo; salvar preserva o rascunho | `expo-data-fetching` (Every Screen Has Four States, Saves preserve work) e `expo-native-ui` (Behavior), por decisão da Task M1 |
| 6. Ação principal fora do teclado; tipo de teclado, tecla de retorno, autofill; `keyboardShouldPersistTaps` | `expo-native-ui` (Behavior), `native-slop` (20) e `false-friends` (foco), por decisão da Task M1 |
| Voltar não descarta o digitado sem perguntar | `expo-native-ui` (verificação de voltar e fechar) e decisão da Task M1 (Review Focus 2) |
| 7. Nunca `allowFontScaling={false}`; linhas crescem | `expo-design-system` (Dynamic Type), por Review Focus 3 |
| Todo controle com rótulo e papel; estado exposto; ícone sozinho sempre rotulado | `expo-design-system` (component contract, Accessibility), genjutsu (`mobile-principles`, `contentDescription`) e Review Focus 3 |
| Alvo de toque 44 pt e 48 dp, com `hitSlop` | genjutsu (`mobile-principles`, Touch Targets) e Emil (`animate-expo`, Press) |
| 8. Resumo do Android | Ver `android.md` abaixo |
| 9. Transições, sheets e abas da plataforma; o resto vai para `motion` | Emil (`animate-expo`, ferramenta mais barata, navegação nativa) e fronteira da spec ("Não escolhe valores nem movimento") |
| 10. Percorrer a tarefa no código; entregar a `device-testing`; listar o que só o aparelho confirma | `expo-native-ui` (Before calling a screen complete), Emil (`animate-expo`, sensação só em build de release) e spec (Limites e testes, Aparelho) |
| Stop signs | DevOrb, no formato de `browser-testing` |
| `references/expo.md`: tabela gerado ou commitado | `expo-overview` (Managed vs. bare), reescrito em tabela própria |
| Pacotes preferidos (`expo-image`, safe-area-context, secure-store, sqlite, audio e video, hook de permissão do pacote) | `expo-native-ui` (Library Preferences) e `false-friends` (Storage) |
| Rotas do Expo Router: tela em `(tabs)`, sheet como rota da pilha raiz com `formSheet` e detents | `native-slop` (1, 2) e Emil (`animate-expo`, sheet como `formSheet`). Os exemplos de código são meus |
| `@expo/ui` só se o SDK tiver | `expo-native-ui` e `expo-overview` (Component selection rule), reduzido: a fonte manda consultar primeiro sempre; aqui é opção conferida pela versão |
| Achar o tema antes de criar outro; cor de plataforma no arquivo do tema | `expo-design-system` (Adopt Before You Build, Colors) e `expo-native-ui` (Colors) |
| Quatro estados em código; consulta pausada ou desligada não é vazio; splash até ler o estado salvo | `expo-data-fetching` (Four States, Gate on hydration). O exemplo é meu |
| Teclado: `react-native-keyboard-controller` se instalado, senão `KeyboardAvoidingView`; nunca ouvinte de `Keyboard` com animação temporizada | `expo-native-ui` (Behavior) e Emil (`animate-expo`, ferramenta para teclado). O caminho sem a biblioteca é meu, para não instalar dependência sem pedido |
| Acessibilidade no RN: escala, `minHeight`, papel, rótulo, estado, decorativo escondido, `selectable` | `expo-design-system` (Dynamic Type, Accessibility) e `expo-native-ui` (Text Styling) |
| Permissão no Expo: pedir no uso, explicar, `canAskAgain` falso leva às configurações | Ideia de `android-permissions-security` (fluxo de três estados) levada ao Expo; `expo-image-picker` sem permissão é ajuste meu, conferível na documentação da versão |
| Sinais de tela feita com hábito web | `native-slop` (1, 5, 11, 13, 17, 18, 19, 20, 7, 9, 3, 14), só ideias, em lista própria e menor |
| `references/android.md`: `enableEdgeToEdge()` antes de `setContent`; ícones automáticos no `ComponentActivity`; contraste da barra | `edge-to-edge` (Step 2, Navigation Bar Contrast), por decisão da Task M1 |
| Insets: um só caminho; `innerPadding` no `contentPadding`; barras do M3 se ajustam sozinhas; `safeDrawingPadding` fora do `Scaffold` | `edge-to-edge` (Step 3, Lists), por decisão da Task M1 |
| Teclado: `adjustResize`, `imePadding` antes do `verticalScroll` ou `contentWindowInsets` com `safeDrawing`, nunca os dois; botão principal sobe com o teclado | `edge-to-edge` (IME), por decisão da Task M1. O lugar do botão é meu, pelo Review Focus 2 |
| `NavigationSuiteScaffold` não repassa padding | `edge-to-edge` (Adaptive Scaffolds) |
| Nunca `configChanges` nem orientação fixa; `rememberSaveable`; `Saver`; auditar todo `remember`; estados de rolagem salváveis; `ViewModel` com `SavedStateHandle` | `adaptive` (Step 6), por decisão da Task M1. O `ViewModel` e o `TextFieldValue.Saver` são acréscimos meus |
| Voltar com alterações pergunta; predictive back | genjutsu (`mobile-principles`, Mobile Gestures) e Review Focus 2 |
| Navegação por largura: barra abaixo de 600 dp, trilho de 600 a 839, trilho ou gaveta a partir de 840 | Material 3 (`navigation-patterns`, Decision Tree) e `adaptive` (Step 2), por decisão da Task M1 |
| Esconder a navegação pelo estado, não removendo; lista e detalhe lado a lado sem seta de voltar | `adaptive` (Step 2.1, Step 3), só ideias |
| Rótulos visíveis; até cinco destinos na barra | Material 3 (`navigation-patterns`, Guidelines) |
| Tema M3 dos tokens; cor dinâmica com reserva; claro e escuro | Material 3 (`theming-and-dynamic-color`, Jetpack Compose Theming) e spec ("cor dinâmica com reserva") |
| Material 3 só no Android, inclusive em Compose Multiplatform | genjutsu (`cmp-platform-quirks`) e conflito da spec |
| Permissões: checar, explicar, pedir, configurações na negativa permanente; sem cache; `SecurityException`; localização em segundo plano depois | `android-permissions-security` (§6, §7, §8), por decisão da Task M1 |
| `PickVisualMedia` sem permissão de mídia | `android-permissions-security` (§7), por decisão da Task M1 |
| `PendingIntent` imutável; `exported="false"`; extras não confiáveis; `onNewIntent` com as mesmas checagens | `android-intent-security` (§2, §4, checklist), por decisão da Task M1 |
| Acessibilidade e toque no Compose: `sp`, `heightIn`, `contentDescription`, papel no `clickable`, 48 dp com 8 dp, rótulo visível | genjutsu (`mobile-principles`, Touch Targets) e Review Focus 3. O rótulo visível no campo é meu |
| Notas de desempenho no Compose: leitura em lambda, `derivedStateOf`, `key` estável | genjutsu (`recomposition-and-anim`), só ideias, sem o exemplo de `remember` sem chave |
| `references/false-friends.md` | `false-friends` da Expo, só ideias, em tabelas próprias. Cabeçalho levou `accessibilityRole="header"`, e a linha do `localhost` no aparelho é minha |

## Conflitos resolvidos

- **Expo ou Android nativo:** as fontes do Android pressupõem projeto nativo; a Expo gera o nativo. Pela spec, as regras do Android valem só em app Kotlin, e no Expo o nativo muda por config plugin.
- **Projeto Expo com `android/` e `ios/` commitados:** a Expo trata como prebuild ou bare. A skill edita essas pastas no lugar e diz no relatório que o projeto é bare. Não é regra Kotlin: as regras do `android.md` não entram por isso.
- **Expo Go ou dev client:** a Expo diz "sempre Expo Go primeiro"; a spec decide Expo Go até entrar config plugin ou módulo nativo, depois build local. Build na nuvem fica com o dono.
- **Material 3 no iOS:** o Material 3 se apresenta como padrão geral; a spec proíbe no iOS. Diretrizes da Apple no iOS e Material 3 no Android, ou neutro registrado na spec.
- **Tokens:** a Expo transforma em token todo valor usado duas vezes; vence a regra do DevOrb, três usos.
- **`targetSdk`:** `edge-to-edge` sobe para 35 sem perguntar. No DevOrb, subir é decisão anunciada de `mobile-release`; a skill diz quando uma API precisa de SDK maior e para aí.
- **`@expo/ui` primeiro:** a Expo manda consultar sempre antes de qualquer componente. Ficou como opção, conferida pela versão do SDK, porque o caso realista pode estar num SDK sem ela e o DevOrb não troca dependência sem pedido.
- **Teclado:** a Expo manda usar `react-native-keyboard-controller`. Sem a biblioteca instalada, vale `KeyboardAvoidingView`, para não adicionar dependência que ninguém pediu.
- **Lista e detalhe no Android:** `adaptive` exige Navigation 3 e `SceneStrategy`, e o Material 3 cita `NavigableListDetailPaneScaffold`. A skill fica na ideia (lado a lado quando largo, sem seta de voltar) e não escolhe a API, que depende da versão do projeto.
- **Duração:** a navegação segue a plataforma; o resto fica com `motion` (spec).
- **EAS:** a Expo manda `eas login` e `eas build` quando preciso; no DevOrb ficam com o dono (spec e Global Constraints).

## Regras próprias

Nenhuma regra do dono nova nesta skill. As decisões acima vêm da spec e da Task M1.

## Fora

- **Expo:** o pedido de feedback com `npx --yes @expo/agent-cli@latest` (presente em `expo-native-ui`, `expo-data-fetching` e `expo-overview`), o MCP, as skills `eas-*`, o `npm install -g` e o `expo-overview` como roteador (com as perguntas de confirmação de intenção). Também: estilo de código (kebab-case, aliases), sombras com `boxShadow`, `borderCurve`, SF Symbols, háptico, gradientes, efeitos de vidro, a paleta `Color` completa e as escalas de espaço, tipo, raio, sombra e movimento de `expo-design-system` (valores são de `design-system` e `motion`), as regras de extração de componente, o roteiro de auditoria com `grep`, as receitas de React Query (retry, refresh de token, cliente de API) e os carregadores de rota web.
- **Android:** a exigência de subir `targetSdk` para 35, os testes de screenshot por formato, a migração para Navigation 3, `Grid` experimental, barras que somem ao rolar, desktop, dobráveis em detalhe, mídia com ExoPlayer, permissões customizadas, provedores de conteúdo, verificação de assinatura de chamador, serviços vinculados e broadcasts.
- **Material 3:** a frase em que ele se declara acima de outras skills, Material 3 no iOS, todo o caminho web (`@material/web`, CSS, geração de tema por semente em JS) e as medidas de componente (altura, largura, elevação).
- **genjutsu:** `remember {}` sem chave (o exemplo de movimento reduzido), zonas do polegar, orçamentos de desempenho, os exemplos SwiftUI e web, Layout Inspector, Macrobenchmark e Baseline Profiles.
- **Emil:** o bloco que fixa a primeira resposta do agente, as curvas, molas e durações (são de `motion`) e as receitas de Reanimated.

## Revisões

- 2026-11-13, conferência frase a frase com um script de n-gramas (6 e depois 5 palavras) contra todas as fontes lidas, seguida de leitura. Reescritas por estarem perto demais:
  - `SKILL.md`: "headerShown false plus a Text title" (`native-slop` 11) e "packages with `npx expo install`" (`expo-overview`).
  - `expo.md`: "it resolves the version that matches the SDK" (Emil) e a frase do spinner entre todos os estados (`expo-design-system` e `native-slop` 19); "renders the splash until that state" (`expo-data-fetching`).
  - `android.md`: "user input and interactive UI state" e "never add `android:configChanges`" (`adaptive`); "never launch a nested Intent" (`android-intent-security`).
  - `false-friends.md`: as linhas de `onChange`, do formulário sem evento de envio, das rotas, de rolagem, do mapa, da lista com `.map()`, do eixo principal, do cookie e do `Pressable`.
  - Os n-gramas que sobraram são nomes de API (`override fun onCreate`, `windowSoftInputMode`, `react-native-safe-area-context`, `presentation: 'formSheet'`).
- 2026-11-13: o agente que escreveu o reservado `native-app-comanda-mesas` viu sem querer as linhas 45 a 51 do plano mobile (as ideias da Expo da Task M1), por um `grep -A`. Nada sobre os itens 3 e 4 do Review Focus, que o caso testa, estava nelas.

## Linhas por fonte

- `expo-skills@a9e5bd3:plugins/expo/skills/expo-native-ui/SKILL.md` | adotado | espinha: idioma da plataforma, área segura, header, módulos removidos, quatro estados, teclado, verificação final
- `expo-skills@a9e5bd3:plugins/expo/skills/expo-web-to-native/references/false-friends.md` | adotado | espinha: tabela de falsos amigos, reescrita em `references/false-friends.md`
- `expo-skills@a9e5bd3:plugins/expo/skills/expo-data-fetching/SKILL.md` | adotado | quatro estados, salvar sem perder rascunho, `EXPO_PUBLIC_` sem segredo
- `expo-skills@a9e5bd3:plugins/expo/skills/expo-overview/SKILL.md` | adotado em parte | sinal de Expo, versão do SDK, gerado ou bare, `npx expo install`; recusado como roteador e no feedback
- `expo-skills@a9e5bd3:plugins/expo/skills/expo-design-system/SKILL.md` | adotado em parte | adotar o tema existente, Dynamic Type, acessibilidade do componente; recusado nas escalas e nos dois usos
- `expo-skills@a9e5bd3:plugins/expo/skills/expo-design-system/references/native-slop.md` | adotado | sinais de tela feita com hábito web, em lista própria
- `android-skills@5815d27:system/edge-to-edge/SKILL.md` | adotado | edge-to-edge, insets, teclado; recusado em subir `targetSdk`
- `android-skills@5815d27:jetpack-compose/adaptive/SKILL.md` | adotado em parte | navegação por largura, estado entre mudanças de configuração, nunca `configChanges`; recusado em Navigation 3, Grid, desktop e mídia
- `android-skills@5815d27:security/android-permissions-security/SKILL.md` | adotado em parte | fluxo de permissão, seletor de fotos, sem cache; recusado em permissões customizadas e IPC
- `android-skills@5815d27:security/android-intent-security/SKILL.md` | adotado em parte | `PendingIntent` imutável, `exported`, extras não confiáveis; recusado em provedores e serviços
- `material-3-skill@14385f2:skills/material-3/references/navigation-patterns.md` | adotado em parte | larguras 600 e 840, rótulos visíveis; recusado no caminho web
- `material-3-skill@14385f2:skills/material-3/references/theming-and-dynamic-color.md` | adotado em parte | cor dinâmica com reserva; recusado na geração por semente e no web
- `genjutsu@5e00595:skills/_jutsu/mobile-principles/SKILL.md` | adotado em parte | alvos de toque, sem hover, voltar preditivo; recusado em zonas do polegar, orçamentos e `remember` sem chave
- `genjutsu@5e00595:skills/_jutsu/compose-motion/references/recomposition-and-anim.md` | adotado em parte | três notas de desempenho; o resto é de `motion`
- `genjutsu@5e00595:skills/_jutsu/compose-multiplatform/references/cmp-platform-quirks.md` | adotado em parte | Material 3 estranho no iOS; recusado no resto
- `emil-skills@715c180:skills/animate-expo/SKILL.md` | adotado em parte | transições, sheets e abas nativas, `npx expo install`, sensação só em build de release; recusado no bloco de resposta fixa e nos valores

## Resultados

Opus 5.5, nível completo, 3 rodadas. Braço: sem plugin. `fusion/results/2026-11-13-native-app*.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `native-app-emporio-pedidos` (Expo) | 100% | 67% (0,95) |
| `native-app-orcamento-compose` (Kotlin) | 100% | 100% |
| Reservado `native-app-comanda-mesas` | 67% (0,92) | 100% |

- `accepted: true` nos dois. No reservado o DevOrb fica uma rodada atrás do braço sem plugin, dentro da tolerância de uma rodada. O caso Kotlin passa nos dois braços e fica como guarda contra piora.
