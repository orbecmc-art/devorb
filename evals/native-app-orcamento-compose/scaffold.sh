#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of a native Android app in
# Kotlin with Jetpack Compose for a furniture workshop: one screen, a quote
# request form (name, phone, e-mail, details, a checkbox and a send button) in
# app/src/main/java/com/example/form/MainActivity.kt. Today the screen is not
# edge-to-edge, the fields live in plain remember { } (rotation wipes them)
# and the manifest has no configChanges. targetSdk 34, so edge-to-edge is not
# forced by the system. No Gradle wrapper and no Android SDK: the sandbox has
# no network, so nothing builds; the case judges the files.
# Self-contained, no network. Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
pkg=app/src/main/java/com/example/form
mkdir -p "$pkg/ui/theme" app/src/main/res/values

cat > .gitignore <<'__X__'
.gradle/
build/
local.properties
.idea/
*.iml
__X__
cat > README.md <<'__X__'
# Orçamento

App Android da Marcenaria Aroeira para o cliente pedir orçamento de um móvel.
Kotlin com Jetpack Compose, uma tela só: o formulário em
`app/src/main/java/com/example/form/MainActivity.kt`.
__X__
cat > settings.gradle.kts <<'__X__'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "Orcamento"
include(":app")
__X__
cat > build.gradle.kts <<'__X__'
plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.0.21" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.0.21" apply false
}
__X__
cat > gradle.properties <<'__X__'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
__X__
cat > app/build.gradle.kts <<'__X__'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.example.form"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.form"
        minSdk = 24
        targetSdk = 34
        versionCode = 3
        versionName = "1.0.2"
    }

    buildFeatures {
        compose = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.12.01")
    implementation(composeBom)
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")
    implementation("androidx.activity:activity-compose:1.9.3")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    debugImplementation("androidx.compose.ui:ui-tooling")
}
__X__
cat > app/src/main/AndroidManifest.xml <<'__X__'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:allowBackup="true"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/Theme.Orcamento">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
__X__
cat > app/src/main/res/values/strings.xml <<'__X__'
<resources>
    <string name="app_name">Orçamento Aroeira</string>
</resources>
__X__
cat > app/src/main/res/values/themes.xml <<'__X__'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.Orcamento" parent="android:Theme.Material.Light.NoActionBar" />
</resources>
__X__
cat > "$pkg/ui/theme/Theme.kt" <<'__X__'
package com.example.form.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val Colors = lightColorScheme(
    primary = Color(0xFF6B4E2E),
    onPrimary = Color(0xFFFFFFFF),
    background = Color(0xFFFAF6F0),
    onBackground = Color(0xFF221B14),
    surface = Color(0xFFFAF6F0),
    onSurface = Color(0xFF221B14),
)

@Composable
fun OrcamentoTheme(content: @Composable () -> Unit) {
    MaterialTheme(colorScheme = Colors, content = content)
}
__X__
cat > "$pkg/MainActivity.kt" <<'__X__'
package com.example.form

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.example.form.ui.theme.OrcamentoTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            OrcamentoTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background,
                ) {
                    QuoteForm(onSubmit = { /* o envio entra na próxima versão */ })
                }
            }
        }
    }
}

data class QuoteRequest(
    val name: String,
    val phone: String,
    val email: String,
    val details: String,
    val replyOnWhatsApp: Boolean,
)

@Composable
fun QuoteForm(onSubmit: (QuoteRequest) -> Unit) {
    var name by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var details by remember { mutableStateOf("") }
    var replyOnWhatsApp by remember { mutableStateOf(true) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        Text("Pedido de orçamento", style = MaterialTheme.typography.headlineSmall)
        Text(
            "Conte o móvel que você quer e a gente responde em até dois dias úteis.",
            style = MaterialTheme.typography.bodyMedium,
        )
        OutlinedTextField(
            value = name,
            onValueChange = { name = it },
            label = { Text("Nome") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
        )
        OutlinedTextField(
            value = phone,
            onValueChange = { phone = it },
            label = { Text("Telefone") },
            singleLine = true,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
            modifier = Modifier.fillMaxWidth(),
        )
        OutlinedTextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("E-mail") },
            singleLine = true,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
            modifier = Modifier.fillMaxWidth(),
        )
        OutlinedTextField(
            value = details,
            onValueChange = { details = it },
            label = { Text("Qual móvel, medidas e madeira") },
            minLines = 5,
            modifier = Modifier.fillMaxWidth(),
        )
        Row(verticalAlignment = Alignment.CenterVertically) {
            Checkbox(checked = replyOnWhatsApp, onCheckedChange = { replyOnWhatsApp = it })
            Text("Pode responder pelo WhatsApp")
        }
        Button(
            onClick = { onSubmit(QuoteRequest(name, phone, email, details, replyOnWhatsApp)) },
            enabled = name.isNotBlank() && phone.isNotBlank() && details.isNotBlank(),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Text("Enviar pedido")
        }
    }
}
__X__
commit_at "2026-01-01T09:00:00-03:00" "feat: quote request form"
