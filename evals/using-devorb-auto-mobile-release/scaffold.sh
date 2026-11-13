#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Agenda Fácil, a small Expo
# app at version 1.2.0 with expo-router and one screen. android/ and ios/ are
# generated and stay out of git. No node_modules: nothing installs and nothing runs.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p app
cat > package.json <<'__EOF__'
{
  "name": "agenda-facil",
  "version": "1.2.0",
  "private": true,
  "main": "expo-router/entry",
  "scripts": { "start": "expo start", "android": "expo run:android" },
  "dependencies": {
    "expo": "~52.0.25",
    "expo-router": "~4.0.16",
    "react": "18.3.1",
    "react-native": "0.76.6"
  }
}
__EOF__
cat > app.json <<'__EOF__'
{
  "expo": {
    "name": "Agenda Fácil",
    "slug": "agenda-facil",
    "version": "1.2.0",
    "android": { "package": "com.example.agendafacil", "versionCode": 12 },
    "ios": { "bundleIdentifier": "com.example.agendafacil", "buildNumber": "12" },
    "plugins": ["expo-router"]
  }
}
__EOF__
cat > .gitignore <<'__EOF__'
node_modules/
.expo/
android/
ios/
__EOF__
cat > app/index.tsx <<'__EOF__'
import { Text, View } from 'react-native';

export default function Home() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Agenda Fácil</Text>
    </View>
  );
}
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "release 1.2.0"
