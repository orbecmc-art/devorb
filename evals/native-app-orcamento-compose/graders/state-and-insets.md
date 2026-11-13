---
type: llm
focus:
  source: file
  path: app/src/main/java/com/example/form/MainActivity.kt
weight: 3
---

Contexto: app Android em Kotlin com Jetpack Compose, `targetSdk` 34. Antes da rodada, este arquivo tinha a `MainActivity` (um `ComponentActivity` com `setContent` e um `Surface` de tela cheia) e o composable `QuoteForm`: um `Column` rolável com `padding(16.dp)` e os campos Nome, Telefone, E-mail e "Qual móvel, medidas e madeira" (`OutlinedTextField`), uma `Checkbox` "Pode responder pelo WhatsApp" e o botão "Enviar pedido". Cada valor estava em `var x by remember { mutableStateOf(...) }`, então girar o aparelho apagava o que a pessoa digitou. O pedido foi a tela ocupar a tela toda (edge-to-edge) e não perder o que foi digitado ao girar. O projeto não tem `lifecycle-viewmodel-compose` nas dependências.

Julgue só este arquivo. Passa somente se as três condições valem:

1. **O que foi digitado sobrevive.** Os quatro campos de texto (nome, telefone, e-mail e detalhes) guardam o valor em `rememberSaveable` (com ou sem `Saver`), em `rememberTextFieldState`, ou num `ViewModel` que lê e grava pelo `SavedStateHandle`. Falha se algum dos quatro segue em `remember { mutableStateOf(...) }` simples, ou se o estado fica num `ViewModel` sem `SavedStateHandle`: ele aguenta a rotação, mas perde tudo quando o sistema mata o processo em segundo plano. A `Checkbox` também em estado salvo é melhor, mas não é exigida.
2. **Nada fica sob as barras do sistema.** Com o edge-to-edge, o conteúdo recebe os insets: `Scaffold` com o `innerPadding` (ou `contentPadding`) aplicado ao conteúdo, ou um modificador como `safeDrawingPadding()`, `systemBarsPadding()`, `statusBarsPadding()` junto com `navigationBarsPadding()`, `windowInsetsPadding(WindowInsets.safeDrawing)` (ou `systemBars`, `safeContent`), ou `consumeWindowInsets` com um desses. Falha se a tela só tem o `padding(16.dp)` fixo de antes, se o `innerPadding` do `Scaffold` é ignorado (por exemplo `{ _ -> ... }`), ou se só o topo é tratado e o botão do fim pode ficar sob a barra de navegação.
3. **A tela continua aqui e inteira.** O formulário segue neste arquivo, com os quatro campos, a `Checkbox` e o botão "Enviar pedido", e o arquivo não usa `configChanges` nem trava a orientação (`requestedOrientation`) para escapar da rotação.

Não julgue cores, espaçamento, textos nem gosto. Tratar o teclado (`imePadding()` ou insets `safeDrawing`, que incluem o teclado) é bom, mas não é exigido aqui.
