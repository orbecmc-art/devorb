# Play policy before a release

Google Play rejects or removes apps over what the manifest asks for and what the app fails to offer. Check the three items below on every release, then the table of sensitive permissions. The Play Console forms stay with the owner: list the ones that apply in the report.

## Package visibility: `<queries>`, not `QUERY_ALL_PACKAGES`

`QUERY_ALL_PACKAGES` shows the app every other app on the phone. Play accepts it only when listing every app is the product itself, as in a security scanner, a file manager or a search tool for the whole device. Any other app declares only the packages or intents it needs, in `<queries>`, and drops the permission.

Find what the code really checks: `getPackageInfo`, `getLaunchIntentForPackage`, `canOpenURL`, `Linking.canOpenURL`, `resolveActivity`, a loop over `getInstalledPackages`. A loop that hunts for competitor or ad apps is a violation on its own; report it.

Kotlin or bare, in `AndroidManifest.xml`:

```xml
<queries>
  <package android:name="com.whatsapp" />
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

Expo with generated native projects: remove the permission from `expo.android.permissions` (add it to `expo.android.blockedPermissions` if a library brings it back) and add the queries with a local config plugin:

```js
// plugins/with-android-queries.js
const { withAndroidManifest } = require('expo/config-plugins');

module.exports = (config, packages = []) =>
  withAndroidManifest(config, (cfg) => {
    const manifest = cfg.modResults.manifest;
    const entry = { package: packages.map((name) => ({ $: { 'android:name': name } })) };
    manifest.queries = [...(manifest.queries ?? []), entry];
    return cfg;
  });
```

```json
"plugins": [["./plugins/with-android-queries", ["com.whatsapp"]]]
```

Then run `npx expo install --fix` and `npx expo-doctor`. If the code gives no clue which packages it checks, propose the plugin with the list left for the user to fill in.

## Foreground services: a type on every one

Every `<service>` started with `startForeground` needs `android:foregroundServiceType` (`dataSync`, `location`, `mediaPlayback` and so on), the matching `FOREGROUND_SERVICE_<TYPE>` permission from API 34, and a visible notification when it starts. The type must fit what the app does. `specialUse` also needs, inside the service:

```xml
<property
  android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE"
  android:value="Live delivery tracking the user started" />
```

with a concrete reason; a vague one ("needs to run in background") gets rejected. Work the user does not watch moves to WorkManager instead. Every type in use needs a declaration in the Play Console, with a short video: owner.

In Expo, services come from libraries; check the merged manifest after a local build, or the library's docs for the SDK in use.

## Account deletion inside the app

An app with accounts (its own, Firebase, Google sign-in) offers a delete-account action within the app, where people look for it: profile or settings. Deletion calls the backend and erases the records. Signing out or clearing local storage is not deletion.

Owner, in the Play Console: a public web link for account deletion, and a reviewer login that does not expire when the app sits behind a login.

## Sensitive permissions

| Asked for | Accepted when | Otherwise |
|---|---|---|
| `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO` | The app is a gallery or backup tool | Photo Picker (`PickVisualMedia`), no permission |
| `MANAGE_EXTERNAL_STORAGE` | File manager, antivirus, backup | Storage Access Framework, or the app's own folder (`getExternalFilesDir`) |
| `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE` (target 30+) | Almost never | Storage Access Framework (`ACTION_OPEN_DOCUMENT`) |
| `ACCESS_FINE_LOCATION` | The feature needs street-level precision | `ACCESS_COARSE_LOCATION` |
| `ACCESS_BACKGROUND_LOCATION` | Safety, navigation or fitness, with an in-app notice that says "location" and "while the app is closed" | Location only while the app is open; never for ads or analytics |
| `READ_CONTACTS` | Contact sync is the product | The system contact picker |
| `USE_EXACT_ALARM` | Alarm clock, timer, calendar | `SCHEDULE_EXACT_ALARM`, inexact alarms or WorkManager |
| SMS or call log | The app is the default SMS or phone handler, with the Console form | SMS Retriever or SMS User Consent for codes; otherwise remove |
| `RECORD_AUDIO` | Recording the user starts and can see | Remove; speech recognizer intent for voice search |
| Accessibility service | The app is a real accessibility tool | Remove; automation belongs in tests |

A permission that no code path uses leaves the manifest. A permission the app needs before the user expects it gets an explanation screen first.
