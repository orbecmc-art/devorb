# Motion on an app screen

For an Expo (React Native) or Android screen. Walk the same steps as `SKILL.md`; these rules change the answers.

## Should it move

- **Switching tabs never slides.** Tabs sit side by side, not one inside another, and a slide suggests depth that is not there, paid for every time the user switches. Use no animation (`animation: 'none'`) or the native tab bar's own behaviour.
- **Navigation follows the platform.** Pushing a screen, opening a sheet and going back use the navigator's own transitions and timing. The rest is decided here.
- **Routine screens just appear.** A staggered entrance on every list, replayed on every visit, is a rare-moment effect used on a daily screen.

## Tool

- **Reanimated, never the core `Animated`.** The core library cannot follow a finger without going through the JavaScript thread, and its native driver handles only transform and opacity. Reanimated runs on the UI thread and keeps going while JavaScript is busy.
- **State lives in shared values** read by `useAnimatedStyle`. No `setState` from a gesture or scroll handler, which renders React every frame. Calls back to JavaScript happen once, at the end of a gesture or when a value crosses a threshold, never on every update.
- **Never animate to a fixed height.** Text grows with the system size; measure the content (`onLayout`) or animate a transform.

## Spring or timing

**When the finger is on the element** (drag, swipe, a sheet being pulled, press and hold), use a spring, started from the release velocity, so a grab in mid-flight continues from where the element is. Overshoot only when the gesture carried momentum. With no finger involved, use the timing curves of `SKILL.md`.

## Haptics

- **Same frame as the visual:** fire at the moment the change happens (a detent catches, a drag commits, a value steps), not when the animation finishes. A late haptic feels like a glitch.
- **Never the only feedback.** Many people turn haptics off, and many Android phones barely produce them. The visual change must work alone.
- From a worklet, schedule the haptic call back on the JavaScript runtime.

## Reduced motion

Reanimated reads the system setting (`useReducedMotion`, or `ReduceMotion.System` on an animation). The rule of `SKILL.md` holds: cut the movement, keep the state change.

## Compose

Animate translation, scale, rotation and alpha inside the lambda `Modifier.graphicsLayer { }` (and `Modifier.offset { }` for position). The lambda reads the animated value in the draw phase, so nothing recomposes each frame; the non-lambda forms read it during composition and recompose the node on every frame.
