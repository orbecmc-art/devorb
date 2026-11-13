---
type: regex
target:
  source: file
  path: app/src/test/java/com/example/profile/ProfileScreenTest.kt
pattern: 'createComposeRule\s*\('
match: contains
---

O teste da tela é um teste de UI do Compose. Passa se `app/src/test/java/com/example/profile/ProfileScreenTest.kt` existe e chama `createComposeRule()` (ou `createComposeRule(...)` com argumentos). Falha se o arquivo não existe ou testa a tela sem a regra do Compose.
