# Values on an app screen

For an Expo (React Native) or Android screen. The values still come from the direction contract; what changes is that the platform already has a colour and type system, and the theme builds on it instead of replacing it.

## Where the tokens live

The app's own theme is the style layer: `theme.ts`, `src/theme/`, `constants/Colors.ts`, the styling library's config, or the Compose `MaterialTheme`. Write tokens there, in its format, and document them in `DESIGN.md`. The three-uses rule holds here too. Screens import from the theme; a raw hex in a screen is a missing token.

## Colour

- **Surfaces, text and separators use the platform's semantic colours.** They already follow light and dark mode, contrast settings and, on Android, the user's palette. In Expo, `Color` from `expo-router` (or `PlatformColor`), chosen per platform with `Platform.select` inside the theme file, with a plain value for the web build. In Compose, the roles of the `ColorScheme`.
- **Brand colours come in pairs:** one value for light mode and one for dark, each checked against the surface it sits on with `contrast.md`. A brand colour with a single value is half a token.
- **Dynamic colour** (taken from the wallpaper) only on Android 12, API 31, and up, and only when the brand accepts it. Below 31, or when the user turns it off, the theme falls back to the project's own light and dark schemes, so both always exist. Never on iOS.
- **Semantic platform colours are native objects, not strings:** they cannot be interpolated. A colour that animates uses a plain value from the theme.

## Type

- **Text follows the system text size.** Never `allowFontScaling={false}`, on one element or app-wide. Containers around text grow (`minHeight`, padding) and labels wrap. A `maxFontSizeMultiplier` cap is a last resort for tight chrome, after wrapping failed, and is written in `DESIGN.md` with the reason. In Compose, text sizes are in `sp`.
- **System type** (San Francisco on iOS, Roboto on Android) is the default. A brand face is the contract's choice: confirm its weights and check it at the largest text size.
