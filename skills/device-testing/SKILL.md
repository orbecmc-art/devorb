---
name: device-testing
description: Use when an Expo or Android app screen changed, needs a UI test, or must be checked before release, before saying it works
---

# Device testing

A passing build or type check means the code compiles. Drawing is a separate event: a screen with loose text compiles and then crashes on open. An app screen works only when a phone or emulator showed it, someone did the main task on it, and the log stayed clean.

```
NO "READY" FOR AN APP SCREEN THAT NO DEVICE OPENED.
```

## 1. Which app, which device

- `expo` in `package.json`: Expo. Without `android/` and `ios/` in git, the native folders are generated: nothing native to test by hand.
- `AndroidManifest.xml` with Kotlin: native Android. Tests follow `references/android-tests.md`.
- Neither: a web screen. Use `devorb:browser-testing` instead.

Look for a device: `adb devices` lists one, or `xcrun simctl list devices booted` shows a booted simulator. A missing command means no device. Installing the Android SDK, an emulator or Xcode is the user's call; `eas login`, `eas build` and global installs are the owner's. Never run them to get a device.

## 2. Static checks: always

They run anywhere and catch what crashes first.

1. The project's own checks: type check (`npx tsc --noEmit`), lint, test script, `./gradlew testDebugUnitTest`. A command that cannot start here (no `node_modules`, no Gradle, no SDK) is reported as not run, with the reason, never as passed.
2. Read the changed screen for what only blows up on the phone:
   - **Expo:** a string or number placed straight inside `View`, `Pressable` or a fragment, including `{count}` and `{list.length && ...}` that can render `0` (crash: text outside `<Text>`); web elements and props (`div`, `img`, `onClick`, `position: 'fixed'`); `allowFontScaling={false}` or a low `maxFontSizeMultiplier`; a fixed `height` around text; `SafeAreaView` from `react-native`.
   - **Compose:** a `clickable` with no `role`; an icon-only button with `contentDescription = null`; a title with `maxLines = 1` and no overflow; typed input kept in `remember` instead of `rememberSaveable`.
   - **Both, for the screen reader:** every control has a label (visible text, `accessibilityLabel`, `contentDescription`) and a role (`accessibilityRole`, `Role.Button`). A `Pressable` or `TouchableOpacity` has no role until you give it one.

Each finding gets `file:line`.

## 3. Tests

Write or extend a UI test when the user asks, or when changed logic has none.

- **Find nodes as the screen reader would:** role, visible text, label. A `testID` or `testTag` only when three matchers cannot single the node out.
- **Fake before mock:** pass an in-memory version of the repository or API the screen uses. Mock a module only when no seam exists.
- **Expo:** with `jest-expo` and `@testing-library/react-native` installed, use `render`, `screen.getByRole('button', { name: 'Salvar' })`, `fireEvent.press`, and assert what the user then sees. Not installed: adding them is the user's call; ask, and if they are away, list it under not checked.
- **Android:** read `references/android-tests.md` before writing. UI tests go in `src/test` with Robolectric; `androidTest` only when the user asks.

A test that could not run here is written, named with its command, and reported as not run.

## 4. On the device, when one exists

Run the app (`npx expo start` with Expo Go; `npx expo run:android` once a config plugin or native module is in; `./gradlew installDebug` for Kotlin). Watch `adb logcat '*:E'` or the Metro log while you go. A red screen or crash is a failure.

Walk this, and screenshot each failure (`adb exec-out screencap -p > shot.png`):

1. The main task, start to finish.
2. One failure and the way back: no network, server error, bad input. What was typed survives.
3. Keyboard open: the main action stays visible and tappable.
4. Back (system button, gesture, sheet swipe): goes one step back and keeps the input. On Android, rotate too.
5. A long title or name, an empty list, a missing image.
6. Large text: font 1.5x on Android, the largest accessibility size on iOS. Nothing cut, every action reachable.
7. TalkBack or VoiceOver: each control says what it is and what it does.
8. Widths 400, 610 and 900 dp (phone, foldable, tablet), by screenshot test or emulator.

A system setting you change (`adb shell settings put system font_scale 1.5`), you restore and say so.

Smoothness needs its own run: a release build, on the weakest phone the app targets. Debug builds, simulators and fast phones mislead in both directions; without that run, smoothness stays unchecked.

## 5. Report

One line per check: how it ran (static, test, device), what happened, pass or fail. Each failure: steps, expected, actual, the log line, `file:line` or screenshot.

Reading code finds defects but never clears a device check: a keyboard, back, font or long-title check that looks fine in the code still goes on the list. Without a device, the report always ends with **Not checked on a device**: every item of the walk in step 4, written for this screen ("the profile header with a 40-character name at font 1.5x"), plus every test that did not run. The verdict is then "static checks pass, not checked on a device", or "does not work" with the failure. Never "ready", "pronto" or "can publish": publishing is the user's decision, made with that list.

A failure goes to `devorb:debugging` when fixing is part of the task. Otherwise report it and stop.

## Stop signs

| Thought | Reality |
|---|---|
| "It builds, so the screen renders" | Compiling is not drawing. Loose text compiles and crashes. |
| "No emulator here, so I'll call it done on the tests" | Say what the device must still confirm. That list is the deliverable. |
| "It felt smooth in the simulator" | That needs a release build on the weakest supported phone. |
| "I'll add a testTag to find it" | If TalkBack cannot find it either, that is the bug. |
| "I'll install the SDK or run eas build" | The user's call, and EAS costs the owner money. |

## Connects to

- **Receives:** an app project from `devorb:verifying`, before `devorb:ui-review`; a screen built with `devorb:native-app`; a request to check or test an app screen.
- **Uses:** the project's tests and tools, a device or emulator when present; `references/android-tests.md`.
- **Hands off to:** `devorb:ui-review` to measure the screen against its contract; `devorb:debugging` for a failure the task must fix; `devorb:verifying`, which takes this report as the app evidence.
