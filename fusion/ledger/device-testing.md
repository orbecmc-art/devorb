# Ledger: `device-testing`

Skill automática de nível leve, da Task M2 do plano mobile, segunda skill automática do setor mobile (`"sector": "mobile"`). Espinha: Android (`testing/testing-setup`, Apache-2.0). Outras fontes: genjutsu (`mobile-principles/references/accessibility-mobile`), Expo (`expo-native-ui` e `expo-web-to-native`, este lido uma vez e não acompanhado) e Emil (`animate-expo`). Todas com `textReuse: false`: só ideias, escritas com palavras próprias e creditadas aqui. Nenhum texto, lista, tabela ou exemplo de código delas entrou, e `LICENSES/NOTICE.md` não muda.

Pinos lidos, buscados rasos (`--depth 1 --no-tags --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, sem rodar nada:

- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d`: `testing/testing-setup/SKILL.md`.
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`: `skills/_jutsu/mobile-principles/references/accessibility-mobile.md`. O `SKILL.md` de `mobile-principles` veio junto no checkout, mas é de `native-app` e não foi lido.
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`: `plugins/expo/skills/expo-native-ui/SKILL.md` (só o parágrafo de conferir antes de dar a tela por pronta; o resto é de `native-app`) e `plugins/expo/skills/expo-web-to-native/SKILL.md`. Este segundo caminho não está em `fusion/sources.json`: entrou porque a Task M2 o cita pelo nome.
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/animate-expo/SKILL.md`.

A skill foi escrita sem abrir `evals/device-testing-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task M2 no plano.

`SKILL.md` tem cerca de 6.370 bytes (uns 1.590 tokens, teto 2.500). A descrição custa cerca de 34 tokens dos 150 do setor, que divide com `native-app`. `references/android-tests.md` tem cerca de 5.880 bytes e só carrega em app Kotlin.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (tela de app Expo ou Android mudou, precisa de teste de UI, ou precisa ser conferida antes de publicar) |
| Abertura: build e checagem de tipo provam que compila, não que desenha; a tela só funciona depois de aberta num aparelho, com a tarefa principal feita e o log limpo | Expo (`expo-web-to-native`, verificar rodando e não compilando), só ideia. O exemplo do texto solto é do caso da Task M2 |
| Lei: sem "pronto" para tela que nenhum aparelho abriu | Review Focus 5 do plano mobile e "Aparelho" da spec |
| 1. Expo, Kotlin ou web; web vai para `devorb:browser-testing` | Fronteiras da spec ("par de `browser-testing` para apps") e detecção de `native-app` (Task M1) |
| Procurar aparelho com `adb devices` e `xcrun simctl`; instalar SDK, emulador ou Xcode é decisão do usuário; EAS e instalação global são do dono | Global Constraints do plano mobile e conflito "EAS" da spec |
| 2. Checagens estáticas sempre; comando que não sobe é "não rodou", nunca "passou" | DevOrb (`devorb:verifying`, "missing pieces block") |
| O que só quebra no aparelho, no Expo: texto fora de `<Text>`, `{list.length && ...}` que vira `0`, elementos e props da web, `allowFontScaling={false}`, altura fixa em volta de texto, `SafeAreaView` do `react-native` | Caso da Task M2 (texto solto) e Review Focus 3. `{list.length && ...}` e a altura fixa são acréscimos meus. Elementos web e `SafeAreaView` vêm de Expo (`expo-native-ui`), só ideia, e já estão em `native-app`; aqui são só o que conferir |
| No Compose: `clickable` sem `role`, botão só de ícone com `contentDescription = null`, título com `maxLines = 1` sem overflow, entrada em `remember` | genjutsu (rótulo e papel no TalkBack) e Task M1 (`rememberSaveable`), só ideias. `maxLines` é acréscimo meu |
| Todo controle com rótulo e papel; `Pressable` e `TouchableOpacity` não têm papel por padrão | genjutsu (checklist de leitor de tela), só ideia, e Review Focus 3. A observação sobre `Pressable` é minha |
| 3. Achar pelo que o leitor de tela lê; `testID` ou `testTag` só quando três matchers não bastam | Android (matchers semânticos primeiro, tag acima de três matchers), só ideia |
| Fake antes de mock | Android (Step 4), só ideia |
| Expo: `@testing-library/react-native` por papel e nome; sem a biblioteca, adicionar é decisão do usuário | DevOrb, no molde de `browser-testing` (Playwright ausente é decisão do usuário) |
| Android: teste de UI em `src/test` com Robolectric; `androidTest` só a pedido | Android (Step 6), só ideia, por decisão da Task M2 |
| Teste que não rodou aqui é escrito, com o comando, e relatado como não rodado | DevOrb (`devorb:verifying`) |
| 4. Rodar no aparelho: Expo Go, `npx expo run:android` depois de config plugin ou módulo nativo, `./gradlew installDebug`; log com `adb logcat` | Conflito "Expo Go ou dev client" da spec; Expo (`expo-native-ui`, Expo Go primeiro), só ideia |
| O roteiro: tarefa principal, uma falha e a volta, teclado, voltar e rotação, título longo, lista vazia e imagem faltando, texto grande, leitor de tela, larguras | Expo (`expo-native-ui`, parágrafo final de Behavior), só ideia, por decisão da Task M2. Rotação vem da Task M1; leitor de tela e larguras, do genjutsu e do Android |
| Fonte em 1,5x no Android; maior tamanho de acessibilidade no iOS | Android (Step 8), só ideia. Conflito com o genjutsu (ver abaixo) |
| Larguras 400, 610 e 900 dp | Android (Step 8), só ideia, por decisão da Task M2 |
| Configuração do aparelho alterada volta ao valor de antes | Acréscimo meu (o `font_scale` por `adb` fica gravado no aparelho do usuário) |
| Fluidez só em build de release, no aparelho mais fraco que o app atende; sem essa rodada, fica sem conferir | Emil (`animate-expo`, regra 5) e Expo (`expo-web-to-native`), só ideias, por decisão da Task M2 |
| 5. Relatório por checagem; sem aparelho, termina sempre com "Not checked on a device", escrito para a tela; veredito nunca "pronto"; publicar é decisão do usuário | Expo (relatar o que rodou e o que não rodou), só ideia; Review Focus 5; formato do relatório de `browser-testing` |
| Falha vai para `devorb:debugging` quando corrigir faz parte da tarefa; senão relatar e parar | Interface da Task M2, no molde de `browser-testing` |
| Stop signs | Próprios, a partir dos dois casos da Task M2 |
| `references/android-tests.md` §1: ler o catálogo e o Gradle, manter a pilha, nunca subir AGP, `compileSdk` ou `targetSdk` para caber um teste | Android (Steps 1 e 3, respeitar a pilha e não subir AGP), só ideia, e Global Constraints (`targetSdk` é de `mobile-release`) |
| §2: tabela de onde mora cada teste; `androidTest` só para o que só o aparelho mostra (barras do sistema, notificação, SQLite real, Dropshots) e a pedido | Android (Steps 6, 7, 12 e 13), só ideias, em tabela própria |
| Sem teste da fiação da Activity nem do grafo de DI | Android (Step 5), só ideia |
| §3: só dependências de teste, com a BOM do app; versão do catálogo ou a mais nova confirmável, dita como não confirmada | DevOrb. O pedido do caso Kotlin manda escrever o teste, então adicionar dependência de teste faz parte dele |
| §4: exemplo de teste com fake, `StateRestorationTester`, `DeviceConfigurationOverride` (fonte 1,5x e 400 x 500) e checagem de rótulo e papel em todo nó clicável | Próprio, escrito do zero. Ideias do Android (restauração de estado sempre, simular tamanho e fonte) e do genjutsu (rótulo e papel) |
| `@Config(sdk = [N])` quando o Robolectric recusa o `targetSdk` | Acréscimo meu |
| Espresso: `withText` e `withContentDescription` antes de `withId` | Android (Espresso para Views) com a regra de semântica da Task M2 |
| Contar os testes que rodaram: zero é falha | `devorb:verifying` |
| §5: capturas em 400, 610 e 900 dp, 400 x 500 com fonte 1,5 e cada tema; estados injetados; captura não testa comportamento; sem ferramenta, adicionar é decisão do usuário | Android (Step 8), só ideia. Alturas reduzidas para 500 e 1000 por decisão minha, para caber |

## Conflitos resolvidos

- **Ferramenta de verificação:** o `expo-web-to-native` manda instalar `agent-browser` e `argent` e não aceita captura manual. No DevOrb, instalar ferramenta é decisão do usuário, e sem aparelho a skill lista o que ficou sem conferir.
- **Expo Go, dev client e EAS:** o `expo-native-ui` cita `eas build` entre os caminhos de build. Vale a spec: Expo Go até entrar config plugin ou módulo nativo, depois build local; `eas build` fica com o dono.
- **Instalar frameworks:** o Android instala Hilt ou Koin, JaCoCo, ferramenta de captura e Dropshots quando faltam. Na skill, a pilha do projeto fica como está; entram só as dependências de teste quando o usuário pediu o teste, e ferramenta de captura é decisão dele.
- **Tamanho do texto:** o genjutsu pede conferir com fonte em 200%; o Android, em 1,5x. Vale a Task M2: 1,5x no Android, e o maior tamanho de acessibilidade no iOS, onde não há escala numérica comparável.
- **Matriz de tamanhos:** o Android pede nove combinações (três larguras e três alturas). A Task M2 fixa as três larguras; a skill pede duas alturas, para o custo da captura não pesar em tarefa leve.

## Regras próprias

Regras próprias só saem com decisão explícita do dono.

Nenhuma. As regras de sem aparelho não declarar pronto e de listar o que ficou sem conferir vêm do plano (Review Focus 5) e da spec. Os acréscimos marcados como meus na tabela acima são checagens, não regras novas.

## Fora

- O pedido de feedback à Expo com `npx --yes @expo/agent-cli@latest feedback`: proibido pelo plano.
- `agent-browser`, `argent`, o laço `run-as-goal` e o roteiro de migração da web do `expo-web-to-native`: são de migrar app, não de conferir tela.
- Do Android: instalar DI, JaCoCo, testes de ponta a ponta com UI Automator, a montagem do Dropshots, a configuração do Compose Preview Screenshot Testing por versão do AGP e a criação de `AGENTS.md` e `docs/testing.md`.
- Do genjutsu: os exemplos em SwiftUI e web, a tabela de contraste (fica com `ui-review`), a redução de movimento (fica com `motion`) e acomodações motoras.
- Do Emil: todo o ofício de animação (fica com `motion` e `native-app`) e o bloco que fixa a primeira resposta do agente.

## Revisões

- 2026-11-13, revisão frase por frase contra as fontes, com uma busca de sequências de cinco palavras: quatro frases ficaram perto demais (build que compila e não desenha, fluidez em build de release, captura que não testa comportamento, sem teste de Activity e DI) e foram reescritas antes da entrega. Sobraram só "a release build on the", ideia da Task M2, e o nome do artefato `ui-test`.
- 2026-11-13: a checagem de rótulo e papel no exemplo filtrava todo nó clicável e pegaria os campos de texto, que também aceitam clique e não têm papel. Passou a excluir nós com `hasSetTextAction()`.
- O exemplo de teste de `references/android-tests.md` não foi compilado: o sandbox não tem SDK do Android nem Gradle.

## Resultados

A preencher depois de R6.

## Decisões por commit de fonte

- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:testing/testing-setup/SKILL.md` | adotado | só ideias: ler a pilha antes, respeitar a pilha, não subir AGP para teste, fake antes de mock, teste de UI em `src/test` com Robolectric e `androidTest` a pedido, matcher semântico e tag acima de três, restauração de estado, simular tamanho e fonte, larguras 400, 610 e 900 dp e fonte 1,5, estados injetados nas capturas, o que só o aparelho mostra
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:testing/testing-setup/SKILL.md` | recusado | instalar DI, JaCoCo, Dropshots e UI Automator por padrão, nove tamanhos por tela, testes de navegação como suíte própria, relatório em Markdown da análise, `AGENTS.md` e `docs/testing.md`
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/mobile-principles/references/accessibility-mobile.md` | adotado | só ideias: todo controle com rótulo e papel para TalkBack e VoiceOver, botão de ícone sem rótulo, texto grande sem corte
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/mobile-principles/references/accessibility-mobile.md` | recusado | fonte em 200% (conflito), tabela de contraste, redução de movimento, acomodações motoras, exemplos em SwiftUI e web
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-native-ui/SKILL.md` | adotado | só ideias: antes de dar a tela por pronta, a tarefa principal, uma falha e a volta, teclado, voltar, título longo, imagem faltando, texto grande, e dizer o que não rodou; Expo Go primeiro
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-native-ui/SKILL.md` | recusado | o resto da skill (é de `native-app`), `eas build` como caminho, o pedido de feedback à Expo
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-web-to-native/SKILL.md` | adotado | só ideia, lido uma vez: build verde prova que empacota, não que renderiza
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-web-to-native/SKILL.md` | recusado | a migração da web, `agent-browser` e `argent` obrigatórios, comparação com o original web, o laço `run-as-goal`, `eas-app-stores`, o pedido de feedback à Expo
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/animate-expo/SKILL.md` | adotado | só ideia: fluidez só se julga em build de release, no aparelho mais lento atendido
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/animate-expo/SKILL.md` | recusado | todo o ofício de animação (fica com `motion` e `native-app`), a resposta inicial fixa
