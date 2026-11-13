#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Feira, a small Android app
# in Kotlin with Jetpack Compose. The profile screen
# (app/src/main/java/com/example/profile/ProfileScreen.kt) shows the name, the
# e-mail and the order count, and has a field to edit the name with a "Salvar"
# button that refuses names shorter than 3 letters. No test exists yet: no
# app/src/test and no app/src/androidTest; app/build.gradle.kts has only
# junit for tests. No Gradle wrapper and no SDK: the sandbox has no network,
# no device, no emulator and no Android SDK, so nothing builds and no test
# runs.
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
mkdir -p app/src/main/java/com/example/profile

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

rootProject.name = "Feira"
include(":app")
__X__
cat > build.gradle.kts <<'__X__'
plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.1.0" apply false
}
__X__
cat > gradle.properties <<'__X__'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
__X__
cat > .gitignore <<'__X__'
.gradle/
build/
local.properties
.idea/
__X__
cat > README.md <<'__X__'
# Feira

App Android de compras da feira, em Kotlin com Jetpack Compose. Uma tela por
enquanto: o perfil, em `app/src/main/java/com/example/profile/ProfileScreen.kt`.

Ainda não tem testes.
__X__
cat > app/build.gradle.kts <<'__X__'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.example.profile"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.profile"
        minSdk = 24
        targetSdk = 35
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
    implementation("androidx.activity:activity-compose:1.9.3")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui")
    debugImplementation("androidx.compose.ui:ui-tooling")

    testImplementation("junit:junit:4.13.2")
}
__X__
cat > app/src/main/AndroidManifest.xml <<'__X__'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:label="Feira"
        android:theme="@android:style/Theme.Material.Light.NoActionBar">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
__X__
cat > app/src/main/java/com/example/profile/MainActivity.kt <<'__X__'
package com.example.profile

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                var savedName by rememberSaveable {
                    mutableStateOf("Maria Aparecida dos Santos Cavalcanti de Albuquerque")
                }
                Scaffold { innerPadding ->
                    ProfileScreen(
                        profile = Profile(
                            name = savedName,
                            email = "maria.albuquerque@example.com",
                            orders = 12,
                        ),
                        onSave = { savedName = it },
                        modifier = Modifier.padding(innerPadding),
                    )
                }
            }
        }
    }
}
__X__
cat > app/src/main/java/com/example/profile/ProfileScreen.kt <<'__X__'
package com.example.profile

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

data class Profile(val name: String, val email: String, val orders: Int)

@Composable
fun ProfileScreen(
    profile: Profile,
    onSave: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    var name by rememberSaveable { mutableStateOf(profile.name) }
    var error by rememberSaveable { mutableStateOf<String?>(null) }

    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .imePadding()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        Text(profile.name, style = MaterialTheme.typography.headlineSmall)
        Text(profile.email, style = MaterialTheme.typography.bodyLarge)
        Text("${profile.orders} pedidos", style = MaterialTheme.typography.bodyLarge)

        OutlinedTextField(
            value = name,
            onValueChange = {
                name = it
                error = null
            },
            label = { Text("Nome") },
            isError = error != null,
            supportingText = error?.let { message -> { Text(message) } },
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
        )

        Button(
            onClick = {
                val trimmed = name.trim()
                if (trimmed.length < 3) {
                    error = "O nome precisa ter pelo menos 3 letras."
                } else {
                    onSave(trimmed)
                }
            },
            modifier = Modifier.fillMaxWidth(),
        ) {
            Text("Salvar")
        }
    }
}
__X__
commit_at "2026-01-01T09:00:00-03:00" "feat: profile screen"
