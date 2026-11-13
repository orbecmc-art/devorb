# Web habits that do not port to React Native

Read when a screen or a component is being written by someone used to the web, or code is moved from a web app. Each row: the habit, what replaces it, and why the habit fails.

## Contents

- Elements and text
- Events
- Layout and style
- Navigation
- Data, storage and secrets
- Browser APIs
- Network
- Scroll, keyboard and safe area
- Services with their own native SDK

## Elements and text

| Web habit | In the app | Why |
|---|---|---|
| `div`, `section`, `span` | `View` | One generic container; there are no semantic variants. |
| `p`, `h1`, loose text | `Text` | A string outside `Text` throws at run time. Headings are `Text` with a style and `accessibilityRole="header"`. |
| `img` | `expo-image` (or `Image`) | Remote images need a size or a flex parent, or they render at zero. |
| `button`, `a` | `Pressable` | Unstyled, with no hover; the label is a `Text` inside. |
| `input`, `textarea` | `TextInput` (`multiline` for long text) | Value comes from `onChangeText`, as a string. |
| `ul`/`li` built with `.map()` | `FlatList` / `FlashList` | `.map()` renders all rows up front; long lists stutter. |
| `svg` inline | `react-native-svg` | No built-in SVG element. |

## Events

| Web habit | In the app | Why |
|---|---|---|
| `onClick` | `onPress` (`onLongPress`, `onPressIn`) | There is no click event. |
| `onChange` reading `e.target.value` | `onChangeText`, which receives the string | No event object to unpack. |
| `form` and `onSubmit` | the button's `onPress` and the field's `onSubmitEditing` | There is no form tag to submit. |
| `:hover`, `:focus` styles | `Pressable`'s `pressed` state, focus handled in code | Fingers do not hover; a hover-only affordance is invisible. |
| `e.preventDefault()` | nothing | No default action to cancel. |

## Layout and style

| Web habit | In the app | Why |
|---|---|---|
| `className`, CSS files, Tailwind classes | style objects, or NativeWind if the project already has it | Plain React Native reads no CSS. |
| Inherited styles | style each `Text` | Only nested `Text` inherits a few text properties. |
| `flex-direction: row` default | `column` default | Flexbox is always on, and items stack top to bottom. |
| `px`, `rem`, `vh`, `em` | plain numbers (density-independent) | No units; some props accept `%`. |
| `@media` queries | `useWindowDimensions()`, `Platform` | Decide at run time from size or platform. |
| `position: fixed` | `position: 'absolute'` plus safe-area insets, or the navigator's bars | `fixed` does not exist. |
| CSS transitions, `@keyframes` | Reanimated, through `devorb:motion` | No CSS animation engine. |

## Navigation

| Web habit | In the app | Why |
|---|---|---|
| Routes from React Router or Next.js | Expo Router files under `app/` | Similar file-based idea, different API. |
| `<a href>` | `Link` from `expo-router` | |
| `useNavigate`, `router.push` from Next | `useRouter()` / `router` from `expo-router` | |
| `useParams`, `useSearchParams` | `useLocalSearchParams()` | |
| `window.location` | `usePathname()` | There is no location object. |
| `notFound()`, `redirect()` | a `+not-found` route, `router.replace` | |

## Data, storage and secrets

| Web habit | In the app | Why |
|---|---|---|
| Server components, server actions | a client screen calling an HTTP endpoint | The phone runs no server code; it fetches. |
| Database client in a page | stays on the server, behind an API | The app never holds database credentials. |
| `localStorage` | `expo-sqlite`'s `localStorage` shim or key-value store | Old `AsyncStorage` from core is gone. There is no `sessionStorage`. |
| Cookies, session cookie auth | a bearer token in `expo-secure-store`, sent as a header | Nothing stores cookies for you. |
| `process.env.SECRET` | stays on the server | Only `EXPO_PUBLIC_` variables reach the app, and they ship inside it in plain text. Never a secret there. |

## Browser APIs

| Web habit | In the app | Why |
|---|---|---|
| `window`, `document` | none | They do not exist; guard web-only libraries. |
| `matchMedia('(prefers-color-scheme: dark)')` | `useColorScheme()` | |
| `window.innerWidth` | `useWindowDimensions()` | Updates on rotation. |
| `navigator.geolocation`, camera, clipboard | `expo-location`, `expo-camera`, `expo-clipboard` | Each needs its package and, usually, a permission. |
| `confirm()`, `prompt()` | `Alert.alert` with buttons, or an inline control | Only `alert()` exists. Routine undoable actions get undo, not a confirm. |
| `dangerouslySetInnerHTML` | render the data | No DOM. |

## Network

| Web habit | In the app | Why |
|---|---|---|
| `fetch('/api/x')` | `fetch(API_URL + '/x')`, with `API_URL` read from `EXPO_PUBLIC_API_URL` | No origin, so relative URLs fail. |
| Worrying about CORS | not needed | No browser; the host must still be reachable from the phone (not `localhost` on a device). |
| Streaming with the built-in `fetch` | `expo/fetch` | The core `fetch` cannot read a streamed body. |

## Scroll, keyboard and safe area

| Web habit | In the app | Why |
|---|---|---|
| The page scrolls by itself | `ScrollView` or a list | Content past the screen edge is simply cut off. |
| Nested scrolling | never a `ScrollView` inside a same-direction list | It breaks virtualization and gestures. |
| The keyboard is the browser's problem | keyboard-aware layout (see `references/expo.md`) | The keyboard covers fields and buttons by default. |
| Notch handled by the browser | header, tabs, `contentInsetAdjustmentBehavior`, or insets | Content runs under the notch and the home indicator. |
| Tab order and focus rings | `ref.focus()`, `returnKeyType`, `onSubmitEditing` | No automatic focus order. |

## Services with their own native SDK

| Web service | In the app | Watch out |
|---|---|---|
| Stripe for digital goods or subscriptions | in-app purchase through the stores | Store rules require it; this changes pricing. Decide with the owner. |
| Stripe for physical goods or services | Stripe's React Native SDK | Allowed. |
| Google Maps for the web | `react-native-maps` | |
| Web push | `expo-notifications` | Different permission and delivery. |
| OAuth redirect | `expo-auth-session` or the provider's native SDK | Completes through a deep link. |
| File input, `getUserMedia` | `expo-image-picker`, `expo-document-picker`, `expo-camera` | |
| Analytics snippet | the provider's React Native SDK | The JS snippet does not load. |
