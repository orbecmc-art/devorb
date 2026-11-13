# Expo screens

Read after `SKILL.md` has found `expo` in `package.json`. Check every API here against the docs page for the project's SDK version; names move between SDKs.

## Contents

- Generated or committed native projects
- Packages
- Running the app
- Layout: header, tabs, sheet
- Colour and theme
- The four states
- Keyboard and forms
- Accessibility
- Permissions
- Tells of a screen built with web habits

## Generated or committed native projects

| What git holds | What it means | Native change goes to |
|---|---|---|
| No `android/`, no `ios/` | Generated on build (Continuous Native Generation) | A config plugin in `app.json` / `app.config.*` (a library's own plugin, or a local one in `plugins/`) |
| Both folders committed | Prebuilt or bare: the folders are the source | Edit them in place, and say in the report that the project is bare |

In the generated case, `.gitignore` usually lists both folders. A library that asks you to edit `AndroidManifest.xml` or `Info.plist` by hand almost always ships a plugin: add its name, with options, to `plugins` in the app config. Permission prompts on iOS are plugin options too (the text the user reads when asked).

## Packages

- `npx expo install <pkg>` for every dependency, including dev ones it knows. It picks the release built for this SDK.
- Prefer: `expo-image` over `Image` for remote pictures; `react-native-safe-area-context` for insets; `expo-secure-store` for tokens; `expo-sqlite` (its `localStorage` shim or key-value store) for plain local data; `expo-audio` and `expo-video` instead of `expo-av`; each package's own permission hook instead of the old `expo-permissions`.
- Routes import from `expo-router`. On recent SDKs, React Navigation types come through `expo-router` too; check the SDK's docs before importing `@react-navigation/*` directly.

## Running the app

Expo Go first: `npx expo start`. When a config plugin, a native module or a library missing from Expo Go enters, the app needs a development build made locally (`npx expo run:android` or `npx expo run:ios`), which needs Android Studio or Xcode on the machine. If the sandbox has neither, say which command the owner runs. Cloud builds, store submission and account logins are the owner's.

## Layout: header, tabs, sheet

Expo Router is file-based. A tab screen lives at `app/(tabs)/<name>.tsx`; the tabs come from `app/(tabs)/_layout.tsx`; a detail shown as a sheet is a separate route in the root stack.

```tsx
// app/(tabs)/orders.tsx — the list fills the screen; insets come from the header and tabs
<Stack.Screen options={{ title: 'Pedidos' }} />
<FlatList
  contentInsetAdjustmentBehavior="automatic"
  data={orders}
  keyExtractor={(o) => o.id}
  renderItem={({ item }) => <OrderRow order={item} onPress={() => router.push(`/order/${item.id}`)} />}
  ListEmptyComponent={<EmptyOrders />}
/>
```

```tsx
// app/_layout.tsx — the detail opens as a native sheet
<Stack>
  <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
  <Stack.Screen
    name="order/[id]"
    options={{ presentation: 'formSheet', sheetAllowedDetents: [0.5, 1], sheetGrabberVisible: true }}
  />
</Stack>
```

Hiding the root stack's header over the tab group is fine: the tab group shows its own. What is never fine is hiding a screen's header and drawing a title and back arrow by hand.

- The first child of a stack route that scrolls is the `ScrollView` or list, with `contentInsetAdjustmentBehavior="automatic"`. Padding goes in `contentContainerStyle`, with `gap` between items.
- `useWindowDimensions()` for sizes; flexbox for layout; no `Dimensions.get()` at module scope.
- A `@expo/ui` component (native SwiftUI and Compose views) may fit a picker, switch, menu or grouped settings list: check that the SDK has it before using it.

## Colour and theme

Find the theme first: `theme.ts`, `src/theme/`, `constants/Colors.ts` (the template default), or a styling library's config (NativeWind, Tamagui, Unistyles). Extend that one; never start a second. Screens import colours from it. Platform colours that follow light and dark mode (`Color` from `expo-router`, or `PlatformColor`) live in the theme file, with a fallback for web. A value enters the theme once it is used three times (DevOrb rule); a one-off stays local with a comment.

## The four states

```tsx
const { data, error, isLoading, refetch, isRefetching } = useOrders();
if (isLoading) return <OrdersSkeleton />;          // first load: never the empty state
if (error && !data) return <ErrorState onRetry={refetch} />;
return (
  <FlatList
    data={data}
    refreshControl={<RefreshControl refreshing={isRefetching} onRefresh={refetch} />}
    ListHeaderComponent={error ? <InlineError onRetry={refetch} /> : null}  // stale data stays
    ListEmptyComponent={<EmptyOrders />}           // only after a resolved, empty result
    …
  />
);
```

With TanStack Query, a paused (offline) or disabled query has no data and is not loading: show an offline or "needs X first" state, not the empty one. A root layout that depends on stored state (session, onboarding) keeps the splash up until it has read that state.

## Keyboard and forms

- Forms scroll, with `keyboardShouldPersistTaps="handled"`.
- If `react-native-keyboard-controller` is installed, use its keyboard-aware scroll view and its sticky footer for the primary action. Otherwise wrap the form in `KeyboardAvoidingView` (`behavior="padding"` on iOS) so the action rises with the keyboard. Never move things from `Keyboard` listeners with a timed animation.
- `TextInput`: `keyboardType`, `returnKeyType`, `autoComplete` and `textContentType`, `onSubmitEditing` moving to the next field.
- Saving: the button shows pending and refuses a second tap; on failure the fields keep their values and an inline error offers retry.

## Accessibility

- Leave `allowFontScaling` alone. A row with text uses `minHeight` and padding, so it grows; long labels wrap. A cap (`maxFontSizeMultiplier`) only on tight chrome, after wrapping failed.
- `Pressable` with `accessibilityRole` and `accessibilityLabel` (or `role` and `aria-label` on recent React Native); `accessibilityState` for selected, disabled, busy. Icon-only buttons always get a label. Decorative images: `accessible={false}` or `importantForAccessibility="no"`.
- `hitSlop` brings a small control to 44 pt (iOS) and 48 dp (Android).
- Data the user may copy gets `<Text selectable>`.

## Permissions

Ask when the feature is used, never at launch. Check with the package's hook (`useCameraPermissions`, for example); if the user can still be asked, explain why in the screen and then request; if `canAskAgain` is false, offer a button to `Linking.openSettings()`. Picking photos with `expo-image-picker`'s library picker needs no media permission on recent Android.

## Tells of a screen built with web habits

Fix these when you see them; none is a style choice:

- A centred custom modal for choosing or composing, closed only by an X.
- A header hidden and redrawn, or a tab bar redrawn as a floating pill.
- Content under the notch or the home indicator, or a fixed `marginTop` to dodge it.
- Hex colours in a screen; a dark mode that breaks.
- A spinner covering the whole screen at every step, or an empty message visible before the first response arrives.
- The input or its button hidden by the keyboard; buttons that need two taps with the keyboard open.
- `TouchableOpacity` everywhere instead of `Pressable` with feedback per role.
- Every row a shadowed card; a 1 px grey border on every box.
- Emoji used as icons. Icons come from one family per platform.
- An entrance animation on every list, replayed on every visit.
