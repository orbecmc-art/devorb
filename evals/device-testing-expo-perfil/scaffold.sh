#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Feira, a small shopping app
# in Expo with expo-router: two tabs, Início (app/(tabs)/index.tsx) and Perfil
# (app/(tabs)/profile.tsx). The profile screen shows a long name, the e-mail,
# the order count and a field to edit the name with a "Salvar" button that
# refuses names shorter than 3 letters. Planted bug: in profile.tsx the word
# "pedidos" sits loose inside a <View>, outside any <Text>, which crashes the
# screen at runtime ("Text strings must be rendered within a <Text>
# component"); TypeScript does not catch it. android/ and ios/ are generated
# and stay out of git. No node_modules: the sandbox has no network, no device,
# no emulator and no Android SDK, so nothing installs and nothing runs.
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
mkdir -p 'app/(tabs)'

cat > package.json <<'__X__'
{
  "name": "feira",
  "version": "1.0.0",
  "private": true,
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo run:android",
    "ios": "expo run:ios",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "expo": "~52.0.25",
    "expo-router": "~4.0.16",
    "expo-status-bar": "~2.0.1",
    "react": "18.3.1",
    "react-native": "0.76.6",
    "react-native-safe-area-context": "4.12.0",
    "react-native-screens": "~4.4.0"
  },
  "devDependencies": {
    "@types/react": "~18.3.12",
    "typescript": "~5.3.3"
  }
}
__X__
cat > app.json <<'__X__'
{
  "expo": {
    "name": "Feira",
    "slug": "feira",
    "scheme": "feira",
    "version": "1.0.0",
    "orientation": "portrait",
    "userInterfaceStyle": "automatic",
    "android": {
      "package": "com.example.feira",
      "versionCode": 3
    },
    "ios": {
      "bundleIdentifier": "com.example.feira",
      "buildNumber": "3"
    },
    "plugins": ["expo-router"]
  }
}
__X__
cat > tsconfig.json <<'__X__'
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true
  }
}
__X__
cat > .gitignore <<'__X__'
node_modules/
.expo/
android/
ios/
__X__
cat > README.md <<'__X__'
# Feira

App de compras da feira, em Expo com expo-router. Duas abas: Início e Perfil.

- `npx expo start` abre o app no Expo Go ou no emulador.
- `android/` e `ios/` são gerados e não entram no git.
__X__
cat > app/_layout.tsx <<'__X__'
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';

export default function RootLayout() {
  return (
    <>
      <Stack screenOptions={{ headerShown: false }} />
      <StatusBar style="auto" />
    </>
  );
}
__X__
cat > 'app/(tabs)/_layout.tsx' <<'__X__'
import { Tabs } from 'expo-router';

export default function TabsLayout() {
  return (
    <Tabs>
      <Tabs.Screen name="index" options={{ title: 'Início' }} />
      <Tabs.Screen name="profile" options={{ title: 'Perfil' }} />
    </Tabs>
  );
}
__X__
cat > 'app/(tabs)/index.tsx' <<'__X__'
import { ScrollView, StyleSheet, Text } from 'react-native';

export default function HomeScreen() {
  return (
    <ScrollView contentInsetAdjustmentBehavior="automatic" contentContainerStyle={styles.container}>
      <Text style={styles.title}>Feira da semana</Text>
      <Text style={styles.body}>Monte a lista e receba em casa no sábado.</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: 16, gap: 8 },
  title: { fontSize: 22, fontWeight: '600' },
  body: { fontSize: 16 },
});
__X__
cat > 'app/(tabs)/profile.tsx' <<'__X__'
import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';

const PROFILE = {
  name: 'Maria Aparecida dos Santos Cavalcanti de Albuquerque',
  email: 'maria.albuquerque@example.com',
  orders: 12,
};

export default function ProfileScreen() {
  const [saved, setSaved] = useState(PROFILE.name);
  const [name, setName] = useState(PROFILE.name);
  const [error, setError] = useState<string | null>(null);

  function save() {
    const trimmed = name.trim();
    if (trimmed.length < 3) {
      setError('O nome precisa ter pelo menos 3 letras.');
      return;
    }
    setError(null);
    setSaved(trimmed);
  }

  return (
    <ScrollView
      contentInsetAdjustmentBehavior="automatic"
      keyboardShouldPersistTaps="handled"
      contentContainerStyle={styles.container}
    >
      <Text style={styles.name}>{saved}</Text>
      <Text style={styles.email}>{PROFILE.email}</Text>
      <View style={styles.stats}>
        <Text style={styles.statValue}>{PROFILE.orders}</Text> pedidos
      </View>

      <Text style={styles.label}>Nome</Text>
      <TextInput
        style={styles.input}
        value={name}
        onChangeText={setName}
        accessibilityLabel="Nome"
        autoCapitalize="words"
        returnKeyType="done"
        onSubmitEditing={save}
      />
      {error ? <Text style={styles.error}>{error}</Text> : null}

      <Pressable accessibilityRole="button" style={styles.button} onPress={save}>
        <Text style={styles.buttonText}>Salvar</Text>
      </Pressable>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: 16, gap: 12 },
  name: { fontSize: 22, fontWeight: '600' },
  email: { fontSize: 16, color: '#555' },
  stats: { flexDirection: 'row', alignItems: 'baseline', gap: 4 },
  statValue: { fontSize: 18, fontWeight: '600' },
  label: { fontSize: 14, fontWeight: '500' },
  input: { borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 12, fontSize: 16 },
  error: { color: '#b3261e', fontSize: 14 },
  button: { backgroundColor: '#1d6b3a', borderRadius: 8, padding: 14, alignItems: 'center' },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});
__X__
commit_at "2026-01-01T09:00:00-03:00" "feat: home and profile tabs"
