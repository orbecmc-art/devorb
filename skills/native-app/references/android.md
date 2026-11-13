# Android in Kotlin

Read before editing a Kotlin app (an `AndroidManifest.xml` with Kotlin sources). None of this applies to an Expo project, whose native side is generated. Raising `targetSdk`, `compileSdk` or AGP is not part of this skill: if an API below needs a newer SDK than the project has, say so and leave the bump to `devorb:mobile-release`.

## Contents

- Edge to edge
- Insets and the keyboard
- Rotation, resizing and saved state
- Back
- Navigation by window width
- Material 3 theme
- Permissions and media
- Intents
- Accessibility and touch
- Compose performance notes

## Edge to edge

In every Activity, call `enableEdgeToEdge()` (from `androidx.activity`) before `setContent`:

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    enableEdgeToEdge()
    super.onCreate(savedInstanceState)
    setContent { AppTheme { FormScreen() } }
}
```

Calling it before or after `super.onCreate` both work, as long as it comes before `setContent`. The `ComponentActivity` version picks light or dark status and navigation icons by itself; only the `WindowCompat` route needs `isAppearanceLightStatusBars` set by hand. A screen with a bottom bar may set `window.isNavigationBarContrastEnforced = false` so the bar colour reaches the bottom edge.

## Insets and the keyboard

Pick one way per screen; two ways pad twice.

1. **`Scaffold`:** use the `innerPadding` it hands to the content. For a list, pass it as `contentPadding` (the first and last items clear the bars and the list still scrolls behind them), and add `Modifier.consumeWindowInsets(innerPadding)`.
2. **Material 3 bars** (`TopAppBar`, `NavigationBar`, `NavigationRail`, `ModalBottomSheet`) pad themselves.
3. **Outside a `Scaffold`:** `Modifier.safeDrawingPadding()` or `windowInsetsPadding(WindowInsets.safeDrawing)` on the container.

Keyboard:

- Each Activity with text input has `android:windowSoftInputMode="adjustResize"` in the manifest.
- The scrolled form gets `Modifier.imePadding()` placed **before** `verticalScroll(...)`, or the `Scaffold` uses `contentWindowInsets = WindowInsets.safeDrawing` (which already includes the keyboard). Never both.
- The primary button stays reachable: at the end of that padded, scrolling column, or in a bottom area with `imePadding()`, so it rises with the keyboard.
- `KeyboardOptions` sets the keyboard type and IME action; `keyboardActions` moves focus to the next field.

`NavigationSuiteScaffold` and the adaptive list-detail scaffolds do not pass padding down: apply insets on each screen inside them, never on the scaffold itself.

## Rotation, resizing and saved state

Keeping an Activity from being recreated with `android:configChanges` or a fixed `android:screenOrientation` is never the fix. Recreation happens on rotation, fold, window resize, theme and language change; blocking it hides state loss and breaks resources that differ by size.

- What the user typed, picked or toggled goes in `rememberSaveable`:

  ```kotlin
  var name by rememberSaveable { mutableStateOf("") }
  ```

  `TextFieldValue` needs `rememberSaveable(stateSaver = TextFieldValue.Saver)`; the newer `rememberTextFieldState()` saves itself. A custom class needs a `Saver`, or `@Serializable` with `rememberSerializable`. Key the state on its subject when it has one (`rememberSaveable(orderId) { … }`).
- Plain `remember { … }` is lost on recreation. Check every `remember` on the screen, not only the text fields.
- Scroll positions: `rememberLazyListState()`, `rememberScrollState()`, never `remember { LazyListState() }`.
- State that must also survive the process being killed, or that belongs to the screen rather than one composable, lives in a `ViewModel` with `SavedStateHandle`.

## Back

Back never silently discards typed input: with unsaved changes, intercept it (`BackHandler(enabled = hasChanges)`) and ask. Predictive back is on by default for apps targeting Android 16: use the back callbacks, not `onBackPressed`.

## Navigation by window width

Decide by the window's width class, never by device type or orientation:

| Window width | Navigation |
|---|---|
| Below 600 dp (compact) | Bottom navigation bar |
| 600 to 839 dp (medium) | Navigation rail |
| 840 dp and wider (expanded) | Rail, or a permanent drawer when there are many destinations |

`NavigationSuiteScaffold` (Material 3 adaptive navigation suite) switches between bar and rail for you: give it the destinations and it reads the window size. If it must hide (full-screen photo, camera), drive its state rather than removing it. Lists may become grids with adaptive columns on wide windows. A list with a detail may show both side by side when wide; there, the detail has no back arrow.

Five destinations or fewer fit a bar; more need a rail with overflow or a drawer. Labels stay visible under icons.

## Material 3 theme

`MaterialTheme` with a `ColorScheme` built from the project's tokens (`devorb:design-system`). Dynamic colour (from the wallpaper, Android 12 and up) is allowed when the brand accepts it, always with the token scheme as fallback on older versions and when it is off. Light and dark schemes both exist. Components take colours from the scheme roles, never hex in a screen. Material 3 is the Android idiom only: in Compose Multiplatform, the iOS side gets native-feeling controls or a recorded neutral look, not Material bars.

## Permissions and media

Ask when the feature is used, never at launch, and never cache the result.

1. `ContextCompat.checkSelfPermission` — granted? Go ahead.
2. `shouldShowRequestPermissionRationale` true? Explain in the UI first; request from that explanation's button.
3. Request with `rememberLauncherForActivityResult(ActivityResultContracts.RequestPermission())`.
4. Denied and no rationale to show: the denial is permanent. Offer a button that opens `Settings.ACTION_APPLICATION_DETAILS_SETTINGS` for the app's package. Never loop requests.

Catch `SecurityException` around protected calls: a one-time grant can expire mid-session. Background location is a separate, later request after foreground location is granted.

Photos and videos come from the system photo picker, `ActivityResultContracts.PickVisualMedia`, which needs no `READ_MEDIA_*` or storage permission.

## Intents

- Every `PendingIntent` uses `PendingIntent.FLAG_IMMUTABLE`. A mutable one (inline reply) is rare and must name an explicit component.
- Components not meant for other apps declare `android:exported="false"`.
- Extras from an incoming intent are untrusted: validate them, and a nested `Intent` taken from extras runs only after its target passes an allowlist. `onNewIntent` gets the same checks as `onCreate`.

## Accessibility and touch

- Text in `sp`; containers with text use `heightIn(min = …)` and wrap, never a fixed height.
- `Icon(contentDescription = "…")` for meaningful icons, `null` for decorative ones. A custom clickable sets its role and click label (`Modifier.clickable(role = Role.Button, onClickLabel = "…")`) or `semantics { … }`; a toggle exposes its state.
- Touch targets reach 48 dp, with 8 dp between them. Material 3 controls enforce the minimum; custom `Box` or `Row` targets do not.
- Every field has a visible label (`label = { Text("…") }`), not only a placeholder.

## Compose performance notes

- Animated values read in a lambda modifier (`Modifier.offset { … }`, `graphicsLayer { … }`) recompose nothing per frame.
- Values derived from fast-changing state (scroll offset) go through `derivedStateOf`.
- Lazy lists give items a stable `key`.

Timing, curves and what should move at all belong to `devorb:motion`.
