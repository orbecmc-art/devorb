---
name: native-app
description: Use when building or changing a screen, form, navigation or native setting in a mobile app, an Expo project or an Android app in Kotlin
---

# Native app

A phone screen written with web habits compiles, then fails on the device: text under the notch, a button behind the keyboard, a list that mounts every row, typing lost on rotation. This skill decides how the screen is built on its platform: primitives, bars and navigation, safe areas, keyboard, back and data states. Values (colour, size, spacing) come from `devorb:design-system`; movement from `devorb:motion`.

## 1. Which project is this?

Look before writing any code, and say which one you found:

- **Expo:** `expo` is a dependency in `package.json`. Read its version: advice and docs follow that SDK (the versioned docs page, never `latest`). Then check whether `android/` and `ios/` are committed. Read `references/expo.md`.
- **Android in Kotlin:** an `AndroidManifest.xml` (usually `app/src/main/`) with Kotlin sources. Read `references/android.md` before editing.
- **Neither:** no `expo` dependency and no `AndroidManifest.xml`. Stop and say this is not an Expo or Android project, so this skill does not apply. Do not scaffold one unasked.

The Android rules in this skill apply only to a Kotlin app. In Expo, the native projects are generated.

## 2. Expo: the native side is generated

- **No `android/` or `ios/` in git:** never create or hand-edit them, and never commit a prebuild. A native change (permission text, URL scheme, a library's setup) goes in `app.json` or `app.config.*` as a config plugin.
- **Every package enters through `npx expo install <pkg>`**, never `npm install` or `yarn add`, so its version is the one built for this SDK.
- Expo Go runs the app until a config plugin or native module enters; from then on it needs a local development build. Builds on EAS, `eas` logins and global installs are the owner's: say what to run, do not run it.
- Raising the Expo SDK, AGP or `targetSdk` is an announced decision of `devorb:mobile-release`, never a side effect here.

## 3. Web idioms do not port

`references/false-friends.md` has the full table. The ones that break most:

- `View`, `Text`, `Pressable`, `TextInput`, `expo-image`. No HTML elements; every string sits inside `Text`. `onPress`, never `onClick`.
- Long or unknown-length lists use `FlatList` or `FlashList`, never `.map()` in a `ScrollView`.
- No `position: fixed`, no CSS files or `className` (unless NativeWind is already set up), no hover.
- `EXPO_PUBLIC_` variables are compiled into the app and readable by anyone: they hold URLs and public keys, never a secret. Tokens go in `expo-secure-store`.
- Modules removed from React Native core never enter: `SafeAreaView`, `AsyncStorage`, `Picker`, `WebView` from `react-native`.

## 4. Platform chrome, not hand-made chrome

- **Safe area** comes from the stack header, the tab bar, or `contentInsetAdjustmentBehavior="automatic"` on the screen's root `ScrollView` or `FlatList`. A screen with a header or tabs wraps nothing in a `SafeAreaView` (from any package) and has no `marginTop` guessed for the notch. A full-bleed screen (camera, map) reads `useSafeAreaInsets()`.
- **Title and back** come from the navigator's options (`<Stack.Screen options={{ title }} />`). Never hide the header (`headerShown: false`) to draw a title in `Text` and a back button by hand.
- **Sheets** are routes presented as a native sheet (`presentation: 'formSheet'` with detents and drag to dismiss), not a centred `Modal` closed by an X. **Tabs** are the platform tab bar.
- **Each platform keeps its own idiom:** Apple's guidelines on iOS, Material 3 on Android. Material 3 is never applied on iOS (no FAB, no ripple there), and no iOS chrome is drawn on Android. A deliberate neutral look is allowed only when the spec records it.
- **Colours, type and spacing** come from the project's theme or tokens. A screen has no raw hex. If the theme lacks a role, add it there (through `devorb:design-system`), not in the screen.

## 5. A screen with data has four states

Loading, error (with retry), empty (says why and offers the next action: `ListEmptyComponent`), content. The empty state never shows while the first load runs. A failed refresh keeps the content on screen with a small error. A save disables repeat taps while pending, keeps the draft on failure, and closes the form only after success.

## 6. Forms and the keyboard

- The primary action is never under the keyboard. Expo: see `references/expo.md`; Kotlin: `adjustResize` plus IME insets, in `references/android.md`.
- Each field gets its keyboard type, return key and autofill hint. Taps on buttons work while the keyboard is open (`keyboardShouldPersistTaps="handled"`).
- Back or dismiss never drops what the user typed without asking. In Kotlin, typed input also survives rotation.

## 7. Text size and screen readers

- Text follows the system size. Never `allowFontScaling={false}`; in Compose, text sizes in `sp` and containers that grow (`minHeight`, `heightIn(min = …)`), never a fixed height around text.
- Every control has a label and a role: `accessibilityRole` and `accessibilityLabel` (or `role` and `aria-label`) in React Native; `contentDescription` and `semantics { role = … }` or a `Button`/`clickable(role = …)` in Compose. Icon-only controls always carry a label; decorative images are hidden from the reader. Selected, disabled and busy states are exposed.
- Touch targets: 44 pt on iOS, 48 dp on Android, using `hitSlop` or padding rather than a bigger icon.

## 8. Android in Kotlin

Only in a Kotlin app, after reading `references/android.md`:

- `enableEdgeToEdge()` before `setContent` in each Activity; `android:windowSoftInputMode="adjustResize"` where there is a keyboard; the `Scaffold`'s `innerPadding` goes to the list's `contentPadding`.
- Never `android:configChanges` or a locked `screenOrientation` to dodge rotation. User input lives in `rememberSaveable` (or a `ViewModel` with `SavedStateHandle`).
- Permissions: check, explain, request, and send to the app's settings after a permanent denial. Images come from `PickVisualMedia`, with no media permission. Every `PendingIntent` is immutable.
- Navigation by window width, through `NavigationSuiteScaffold`: a bar below 600 dp, a rail from 600 to 839 dp. New screens in Compose; a screen in Views migrates only on request.

## 9. When something moves

Screen transitions, sheets and tabs use what the platform gives. Anything else that animates goes to `devorb:motion` before code.

## 10. Before saying it is done

Walk the main task through the code: each data state, one failure and retry, long text, the largest font, keyboard open, back, and rotation in Kotlin. Then hand off to `devorb:device-testing`. Without a device or emulator, list what stays unconfirmed (feel on a release build, the real keyboard frame, the notch) and never call it working on a phone.

## Stop signs

| Thought | Reality |
|---|---|
| "I'll add the native permission in `android/` directly" | In a generated Expo project that folder is rebuilt; the change is lost. Config plugin. |
| "`npm install` is the same thing" | It ignores the SDK's version map. `npx expo install`. |
| "A `SafeAreaView` is the quick fix" | The header, tabs or scroll inset already own it. |
| "`configChanges` stops the reset on rotation" | It hides the state loss and breaks resizing. `rememberSaveable`. |
| "Bigger text breaks my layout, I'll lock it" | The layout is wrong. Let rows grow. |
| "It looks right in the code, so it works" | Only a device confirms feel and keyboard; say so. |

## Connects to

- **Receives:** `devorb:implementing`, when the project has `expo` in `package.json` or an `AndroidManifest.xml`, or a request to build or fix a mobile screen.
- **Uses:** the tokens from `devorb:design-system`; `devorb:motion` when something moves; `references/expo.md`, `references/android.md`, `references/false-friends.md`.
- **Hands off to:** `devorb:device-testing`, which decides what runs without a device and what only the device confirms; back to `devorb:implementing` for the next task.
