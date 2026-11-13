# Mobile web pass

Run at 375 x 812 with touch on (`hasTouch: true`, `isMobile: true`), on the rendered page, then locate in the code. This is the web page on a phone browser; installed web apps (PWA) are out of scope.

## Checks

| Check | Finding when | Measure | Severity |
|---|---|---|---|
| Zoom stays possible | The viewport meta has `user-scalable=no` or `maximum-scale=1` (or less than 2). It fails WCAG 1.4.4; the usual excuse is input zoom, whose real fix is the next row. | Read `meta[name=viewport]`. | P1 |
| Inputs at 16 px or more | An `input`, `textarea` or `select` renders under 16 px at this width. Below it, iOS Safari enlarges the page when the field gets focus and leaves it enlarged. | Computed `font-size` of every field at 375 px. | P2 |
| Keyboard matches the field | A field for numbers, amounts, codes, e-mail, phone or search opens the plain text keyboard: no fitting `type` or `inputmode` (`numeric`, `decimal`, `email`, `tel`, `search`). | Read `type` and `inputmode` against the label. | P2 |
| Screen-tall boxes use small or dynamic units | An app shell, a drawer or anything pinned to the bottom is `100vh` (it overflows under the browser bar); a first screen should be `100svh`, a shell `100dvh`. | Computed height against `innerHeight`; find the `vh` in the code. | P2, P1 if it hides the primary action |
| Safe areas | `env(safe-area-inset-*)` is used without `viewport-fit=cover` in the viewport meta (every inset then reads 0), or `viewport-fit=cover` is set and a fixed header, bottom bar, toast or sheet has no inset padding. | Read the meta and the fixed elements' padding. | P2 |
| Taps answer at once | Controls lack `touch-action: manipulation`, so some browsers still wait for a double tap. | Computed `touch-action` on buttons and links. | P3 |
| Inner scroll stays inside | A scrolling panel (sheet, drawer, chat list, side menu) lets the scroll run on into the page behind it: no `overscroll-behavior: contain` on that panel. | Computed `overscroll-behavior` on scroll containers that are not the page. | P2 |
| No horizontal scroll | `scrollWidth` exceeds `clientWidth`, at 375 and at 320 px. | As in `devorb:browser-testing`. | P1 |

Two declarations are not recommended and never reported as missing: `overscroll-behavior: none` on `html` or `body` (it kills pull-to-refresh on a page that is a document) and `user-select: none` on every link (link text is often something the visitor wants to copy). Seeing either in the code is a P3 note only when it blocks something on this page.

## What emulation cannot show

Touch emulation in a desktop browser leaves out what only the phone does: its keyboard opening over the page, the address bar shrinking, the zoom on a small field, the notch, hover that stays after a tap, the wait before a tap counts, and the bounce at the end of a scroll. Code can show the cause; only a phone shows the effect. The report lists, under not checked, each mobile item that was judged from code or emulation alone and says it needs a phone. Never write that it was checked on a device unless it was.
