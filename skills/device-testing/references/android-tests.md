# Android UI tests

For `devorb:device-testing` in a Kotlin app. Read it before writing a test.

## 1. Read the setup first

Open `gradle/libs.versions.toml` and the module's `build.gradle(.kts)`. Note: JUnit 4 or 5, Robolectric, `androidx.compose.ui:ui-test-junit4` or Espresso, Mockk or Mockito, Hilt or Koin, and any screenshot tool (Roborazzi, Paparazzi, Compose Preview Screenshot Testing, Dropshots). Keep what is there. Never swap a framework, and never raise AGP, `compileSdk` or `targetSdk` to make a test fit: that is `devorb:mobile-release`.

## 2. Where tests live

| Test | Folder | Runs on |
|---|---|---|
| Compose or Espresso behavior | `src/test` | the JVM, through Robolectric |
| Screenshot with Roborazzi or Paparazzi | `src/test` | the JVM |
| Anything only a phone shows: system bars and edge-to-edge, notifications, real SQLite, Dropshots | `src/androidTest` | a device, and only when the user asks |

Skip tests whose subject is an Activity's wiring or the DI graph; put logic tests on the ViewModel and repository.

## 3. Test-only dependencies, when missing

The user asked for the test, so add only test scopes, using the Compose BOM the app already has:

```kotlin
android {
    testOptions { unitTests.isIncludeAndroidResources = true }
}
dependencies {
    testImplementation("junit:junit:4.13.2")
    testImplementation("org.robolectric:robolectric:<version>")
    testImplementation(platform(libs.androidx.compose.bom)) // the BOM line the app already uses
    testImplementation("androidx.compose.ui:ui-test-junit4")
    debugImplementation("androidx.compose.ui:ui-test-manifest")
}
```

Use a version already in the catalog. Otherwise write the newest you can confirm and say it was not confirmed. Without network or the SDK, nothing here resolves: write the files and report the test as not run.

## 4. A behavior test

```kotlin
package com.example.profile

import androidx.compose.ui.semantics.SemanticsProperties
import androidx.compose.ui.semantics.getOrNull
import androidx.compose.ui.test.*
import androidx.compose.ui.test.junit4.StateRestorationTester
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import org.junit.Assert.*
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

@RunWith(RobolectricTestRunner::class)
class ProfileScreenTest {
    @get:Rule val compose = createComposeRule()

    // Fake first: a small in-memory class behind the screen's own interface.
    private class FakeProfiles(var name: String) : ProfileRepository {
        override fun load() = Profile(name)
        override fun save(p: Profile) { name = p.name }
    }

    @Test fun savingANewNameShowsIt() {
        val repo = FakeProfiles("Ana")
        compose.setContent { ProfileScreen(repo) }
        compose.onNode(hasSetTextAction()).performTextReplacement("Ana Souza")
        compose.onNode(hasText("Salvar") and hasClickAction()).performClick()
        assertEquals("Ana Souza", repo.name)
        compose.onNodeWithText("Ana Souza").assertIsDisplayed()
    }

    @Test fun typedTextSurvivesRecreation() {
        val tester = StateRestorationTester(compose)
        tester.setContent { ProfileScreen(FakeProfiles("Ana")) }
        compose.onNode(hasSetTextAction()).performTextReplacement("rascunho")
        tester.emulateSavedInstanceStateRestore()
        compose.onNode(hasSetTextAction()).assert(hasText("rascunho"))
    }

    @Test fun longNameAtLargeTextOnSmallScreen() {
        compose.setContent {
            DeviceConfigurationOverride(
                DeviceConfigurationOverride.FontScale(1.5f) then
                    DeviceConfigurationOverride.ForcedSize(DpSize(400.dp, 500.dp))
            ) { ProfileScreen(FakeProfiles("Maria Aparecida dos Santos Albuquerque")) }
        }
        compose.onNode(hasText("Salvar") and hasClickAction()).performScrollTo().assertIsDisplayed()
    }

    @Test fun everyControlHasLabelAndRole() {
        compose.setContent { ProfileScreen(FakeProfiles("Ana")) }
        compose.onAllNodes(hasClickAction() and !hasSetTextAction()).fetchSemanticsNodes().forEach { node ->
            val c = node.config
            val label = c.getOrNull(SemanticsProperties.ContentDescription)?.joinToString()
                ?: c.getOrNull(SemanticsProperties.Text)?.joinToString()
            assertFalse("control without label: $c", label.isNullOrBlank())
            assertNotNull("control without role: $label", c.getOrNull(SemanticsProperties.Role))
        }
    }
}
```

Adapt names to the real screen: read its parameters and strings first. A screen that takes state and callbacks needs no fake: pass values and record the calls. `performScrollTo` needs a scrollable parent; when the screen has none, assert the node is displayed instead.

- **Matchers:** text, content description, role, `hasSetTextAction`, `hasClickAction`. Use `testTag` only when three combined matchers still match more than one node. Espresso screens: `withText` and `withContentDescription` before `withId`.
- **Robolectric and SDK:** if it rejects the app's `targetSdk`, add `@Config(sdk = [N])` with the highest level it supports. Do not lower the app's SDK.
- **Run:** `./gradlew :app:testDebugUnitTest --tests com.example.profile.ProfileScreenTest`. Read the count of tests run: zero is a failure.

## 5. Screenshots

With a screenshot tool already in the project, add the screen at widths 400, 610 and 900 dp (heights 500 and 1000 are enough), plus a 400 x 500 at font 1.5, and each theme the app ships. Feed loading, error and empty in directly rather than waiting for them. Screenshots show layout; taps and state changes belong to the behavior tests. Without a tool, adding one is the user's call; the forced-size test above shows nothing crashes, not how it looks.
