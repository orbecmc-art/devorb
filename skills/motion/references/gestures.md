# Gestures

Read for drag, swipe, sheets, carousels and anything that follows the pointer. For a bottom sheet or drawer, use the specialist library from the direction contract before building one: momentum, dismissal, focus trap and Escape take weeks to get right.

## While the finger is down: track

- Position follows the pointer 1:1. No easing, no duration, no spring: a spring here makes the element lag behind the finger.
- Keep the offset where the user grabbed it, so the element does not jump to centre under the pointer.
- Capture the pointer once the drag starts (`setPointerCapture`), so it keeps tracking outside the element. Ignore extra touches after the first.
- Wait for about 10px of movement before committing to a drag direction, so a tap or a scroll is not taken as a drag.
- Write `transform` directly or use a motion value. No React state per `pointermove`, no CSS variable on a parent.
- Past a boundary, resist more the further it goes (rubber band), instead of stopping dead. In Motion, `dragElastic`.
- Set `touch-action` for the drag axis so native scrolling does not fight the gesture.

## When the finger lifts: release

- Finish with a spring that starts at the finger's release velocity, so the motion continues at the speed the finger had.
- Dismiss on distance **or** velocity: past roughly half the travel, or a quick flick that covered little ground.
- Snap to the point nearest where the motion was heading, not where it was let go: project the resting position from the velocity, then pick the closest snap point.
- Bounce only here, small. The same sheet closed by a button gets no bounce.
- If the gesture does not pass the threshold, return quickly.
- Values that depend on the drag (overlay opacity, page scale behind) derive from the same motion value, so they never drift apart when the user reverses.

## Interruptible

The user can catch a closing sheet and drag it back. Springs retarget mid-flight with their current velocity; keyframes cannot. Enter and dismiss along the same axis, so the gesture is discoverable.

## Hold

Press-and-hold shows time passing: linear, slow (a second or two). Letting go early snaps back fast with an ease-out.

## Reduced motion

Tracking stays: the motion comes from the user's own hand. Drop the fling momentum and the bounce; release settles with a short fade or a direct position change.

## Check

Test on a real phone over the local network. A trackpad hides touch problems, and a 60Hz monitor hides what a 120Hz phone shows. Hit targets at least 44 by 44px. A spring that feels wrong usually needs more damping.
