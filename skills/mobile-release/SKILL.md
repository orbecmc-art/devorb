---
name: mobile-release
description: Prepare an Expo or Kotlin Android app for a store release: version bump, announced SDK or build upgrades, Play policy check
argument-hint: "Which version are you releasing? (e.g. 1.2.0)"
disable-model-invocation: true
---

# Mobile release

The branch is done and merged; now the app has to get into the store. This skill changes only what the release needs: the version, the upgrades the store or a library forces, and what Play policy rejects. Shipping the build to the store stays with the owner.

If the user passed a version, that is the release. Without one, ask; if nobody answers, stop and say which version the project has now.

## 1. Know the project

- **Expo:** `expo` in `package.json`. Read the SDK major from that dependency.
- **Kotlin:** an `AndroidManifest.xml` and a Gradle build (`build.gradle` or `build.gradle.kts`). Read `targetSdk`, `compileSdk` and the Android Gradle Plugin (AGP) version, from the module build file or `gradle/libs.versions.toml`.
- **Neither:** stop and say this skill handles only those two.

In an Expo project, check whether `android/` and `ios/` are tracked by git (`git ls-files android ios`). Not tracked means the native projects are generated at build time: every native change goes through `app.json` (or `app.config.*`) and config plugins, and hand edits to `android/` are lost on the next build. Tracked means a bare project: edit the native files, as in Kotlin.

Look things up in the documentation of the version the project uses, never the latest: `https://docs.expo.dev/versions/v<SDK>.0.0/` for Expo, and the release notes of the project's own AGP for Gradle. An API from a newer SDK breaks the build.

## 2. Bump the version

| Project | Version the user sees | Build number, +1 from the current value |
|---|---|---|
| Expo | `expo.version` in `app.json` | `expo.android.versionCode`, and `expo.ios.buildNumber` when present |
| Kotlin | `versionName` in the app module's `defaultConfig` | `versionCode` in the same block |

The build number is an integer the store has never seen: raise it by one, never reuse or lower it. If `eas.json` sets `"appVersionSource": "remote"`, EAS owns the build numbers: set the version, leave the number, and say so. Change only these fields.

## 3. Upgrades are announced decisions

Raising `targetSdk`, the Expo SDK or AGP happens here and nowhere else, and never as a side effect. Before changing any of them, tell the user what goes from which version to which, and why now: a Play target-API deadline, a library that requires it, a security fix. "A newer one exists" is not a reason. If the user is away, make the change only when the release is blocked without it, and put the announcement at the top of the report.

**Expo SDK.** Read the changelog of every SDK you cross. Then:

```bash
npx expo install expo@^<target>.0.0
npx expo install --fix
npx expo-doctor
```

Run `npx expo install --fix` and `npx expo-doctor` again after every later change to dependencies or config, and fix what they report before moving on. New packages also enter with `npx expo install <package>`, never plain `npm install`, so the versions match the SDK.

**AGP.** Project on AGP 8 or older and the release needs 9? Stop there. The first jump belongs to Android Studio's AGP Upgrade Assistant, run by the owner, who tells you when it is done; raise it by hand only if the owner says to. Once on 9:

- remove the `kotlin-android` plugin (`org.jetbrains.kotlin.android`): AGP 9 compiles Kotlin itself;
- move annotation processors from kapt to KSP; a processor without KSP support stays on the legacy kapt AGP offers;
- check the result with `./gradlew help` and `./gradlew build --dry-run`.

Kotlin Multiplatform projects are out of scope: say so and stop.

## 4. Pass the Play policy

Read `references/play-policy.md` and check the permissions, services and account flow it lists. Where the permissions live:

- **Expo, generated:** `expo.android.permissions`, `expo.android.blockedPermissions` and the `plugins` in `app.json`. Manifest entries such as `<queries>` go in through a config plugin, never into `android/`.
- **Kotlin or bare:** `app/src/main/AndroidManifest.xml`, plus what libraries merge in.

Fix what the code shows clearly. When the right fix depends on what the app is for (which packages it really checks, whether a service must stay in the foreground), propose it with the exact change and leave the decision to the user.

## 5. Build locally, leave EAS to the owner

Local builds cost nothing: `npx expo run:android --variant release` for Expo, `./gradlew bundleRelease` for Kotlin. EAS builds cost money and need the owner's Expo account: never run `eas login`, `eas build` or `eas submit`. In the report, name the EAS step as the owner's next move.

Signing keys and their passwords stay out of git and out of the report: name where they live, never the value.

This sandbox has no Android SDK, emulator or device. Say plainly what stays unchecked: that the release build compiles and starts, that it runs on a real device, and anything you could not run (`expo-doctor` without network, for one).

## 6. Report

1. Version: from and to, and the build number, with the file and field.
2. Upgrades: each one with versions and reason, or "none".
3. Commands run and their result (`npx expo install --fix`, `npx expo-doctor`, Gradle).
4. Policy findings: file, line or key, the change made or proposed.
5. Left to the owner: EAS build and upload, Play Console forms (foreground service declaration, reviewer login, account deletion link, data safety), and what only a device confirms.

Never call the release ready while a policy finding is open.

## Connects to

- **Receives:** the user's `/devorb:mobile-release <version>`, after `devorb:finishing` has merged or closed the branch.
- **Uses:** `references/play-policy.md`; the versioned Expo or AGP documentation; `devorb:verifying` for the project's tests after any upgrade; `devorb:device-testing` for what a device must confirm.
- **Hands off to:** the owner, with the EAS command, the Play Console forms and the device checks; the changes stay uncommitted unless the user asks, and then go through `devorb:finishing`.
