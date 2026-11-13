# Reviewing an app screen

For an Expo (React Native) or Android screen. There is no browser render: the screen comes from `devorb:device-testing` (its screenshots and its report). Without a device or emulator, every check that needs the render ends as not checked, as in `SKILL.md`.

## Native slop: habits from the web

Generated apps repeat the same web habits, and each leaves a trace you can search for. Use them as searches, not as a score: a hit is a place to look, never a finding by itself. Check each hit against the contract and `DESIGN.md`. What they authorize is clear. A confirmed habit is a finding with its own severity, from P0 to P3, like any other. No count of habits and no grade.

Set `SRC` to the app's source folder and `THEME` to its theme folder, then run from the project root:

```bash
# press feedback from old touchables; Pressable, with feedback per role, replaces them
grep -rnE 'Touchable(Opacity|Highlight|WithoutFeedback)' "$SRC" --include='*.tsx'
# a centred dialog used to pick or compose, where a native sheet or menu belongs
grep -rn '<Modal' "$SRC" --include='*.tsx'
# an alert for a routine, undoable action, for a success, or for a field error
grep -rn 'Alert\.alert' "$SRC" --include='*.tsx'
# a header rebuilt by hand: back swipe and large title lost
grep -rnE 'headerShown:[[:space:]]*false' "$SRC" --include='*.tsx'
# a floating, custom-styled tab bar instead of the platform's
grep -rn 'tabBarStyle' "$SRC" --include='*.tsx'
# a decorative gradient pushing the task below the fold
grep -rnE 'LinearGradient|experimental_backgroundImage' "$SRC" --include='*.tsx'
# a typeface set outside the theme
grep -rn 'fontFamily:' "$SRC" --include='*.tsx' | grep -v "^$THEME/"
# hex colours outside the theme: dark mode breaks
grep -rnE "['\"]#[0-9a-fA-F]{3,8}['\"]" "$SRC" --include='*.tsx' | grep -v "^$THEME/"
# emoji used as icons (text content may hold emoji; an emoji in place of an icon is the habit)
rg -n '[\p{Emoji_Presentation}\x{FE0F}]' "$SRC" -g '*.tsx'
```

Only the render shows the rest. Look at the screenshots for: a sheet that closes only with an "X" (no handle, no drag down); every row or section boxed as its own shadowed card; a grey border around every container; heavy shadows doing the job of hierarchy; the same padding at every level; an onboarding carousel before anything useful; one platform dressed in the other's controls (check both platforms); content under the notch or the home indicator, or a hand-set top margin. Three need the app running: an entrance animation replayed on every visit (leave and re-enter), a full-screen spinner or "nothing here" flashing during the first load, and a field or submit button hidden by the keyboard.

## Touch targets

The minimum is 44 x 44 pt on iOS and 48 x 48 dp on Android. Measure the touchable area, not the icon: `hitSlop` or padding may extend it beyond what is drawn. A target under the minimum, `hitSlop` included, is a P2 finding; when it is the screen's primary action, P1.
