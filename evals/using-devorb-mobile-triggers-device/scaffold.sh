#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Horta, a small Expo app with
# expo-router and one finished screen, the harvest list (app/index.tsx), plus
# the owner's approved spec for that screen. The owner is about to publish.
# android/ and ios/ are generated and stay out of git. No node_modules: the
# sandbox has no network, no device and no emulator, so nothing runs.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p app docs/devorb/specs

cat > package.json <<'__EOF__'
{
  "name": "horta",
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
__EOF__
cat > app.json <<'__EOF__'
{
  "expo": {
    "name": "Horta",
    "slug": "horta",
    "scheme": "horta",
    "version": "1.0.0",
    "orientation": "portrait",
    "userInterfaceStyle": "automatic",
    "android": { "package": "com.example.horta", "versionCode": 1 },
    "ios": { "bundleIdentifier": "com.example.horta", "buildNumber": "1" },
    "plugins": ["expo-router"]
  }
}
__EOF__
cat > tsconfig.json <<'__EOF__'
{ "extends": "expo/tsconfig.base", "compilerOptions": { "strict": true } }
__EOF__
cat > .gitignore <<'__EOF__'
node_modules/
.expo/
android/
ios/
__EOF__
cat > app/_layout.tsx <<'__EOF__'
import { Stack } from 'expo-router';

export default function RootLayout() {
  return <Stack screenOptions={{ title: 'Colheitas' }} />;
}
__EOF__
cat > app/index.tsx <<'__EOF__'
import { useState } from 'react';
import { FlatList, Pressable, Text, View } from 'react-native';

const INITIAL = [
  { id: '1', name: 'Alface', ready: true },
  { id: '2', name: 'Tomate-cereja', ready: false },
  { id: '3', name: 'Manjericão', ready: true },
];

export default function Harvest() {
  const [items, setItems] = useState(INITIAL);
  const toggle = (id: string) =>
    setItems((list) => list.map((i) => (i.id === id ? { ...i, ready: !i.ready } : i)));

  return (
    <FlatList
      data={items}
      keyExtractor={(i) => i.id}
      renderItem={({ item }) => (
        <Pressable onPress={() => toggle(item.id)} accessibilityRole="checkbox" accessibilityState={{ checked: item.ready }}>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', padding: 16 }}>
            <Text>{item.name}</Text>
            <Text>{item.ready ? 'Pronto para colher' : 'Crescendo'}</Text>
          </View>
        </Pressable>
      )}
    />
  );
}
__EOF__
cat > docs/devorb/specs/2026-01-01-horta-colheitas-design.md <<'__EOF__'
# Lista de colheitas da Horta

Aprovada pelo dono.

## Tela

- Lista dos canteiros com o nome da planta e o estado: "Pronto para colher" ou "Crescendo".
- Um toque na linha troca o estado.
- A tela fica em `app/index.tsx` e funciona no Android e no iPhone.

## Publicação

Primeira versão nas lojas depois desta tela.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "harvest list and approved spec"
