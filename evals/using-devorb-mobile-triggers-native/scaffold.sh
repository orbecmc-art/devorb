#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Clube, a small Expo app with
# expo-router and one home screen (app/index.tsx), plus the owner's approved
# spec for a login screen that does not exist yet. android/ and ios/ are
# generated and stay out of git. No node_modules: nothing installs and nothing
# runs.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p app docs/devorb/specs

cat > package.json <<'__EOF__'
{
  "name": "clube",
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
    "name": "Clube",
    "slug": "clube",
    "scheme": "clube",
    "version": "1.0.0",
    "orientation": "portrait",
    "userInterfaceStyle": "automatic",
    "android": { "package": "com.example.clube", "versionCode": 1 },
    "ios": { "bundleIdentifier": "com.example.clube", "buildNumber": "1" },
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
  return <Stack />;
}
__EOF__
cat > app/index.tsx <<'__EOF__'
import { Text, View } from 'react-native';

export default function Home() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Bem-vindo ao Clube</Text>
    </View>
  );
}
__EOF__
cat > docs/devorb/specs/2026-01-01-clube-login-design.md <<'__EOF__'
# Tela de login do Clube

Aprovada pelo dono.

## Objetivo

O sócio entra no app com e-mail e senha antes de ver a tela inicial.

## Tela

- Campo de e-mail e campo de senha, com o botão "Entrar".
- Link "Esqueci a senha" abaixo do botão (por enquanto só mostra um aviso).
- E-mail inválido ou senha vazia: mensagem embaixo do campo, sem fechar o teclado.
- Enquanto entra, o botão mostra que está carregando e não aceita outro toque.
- A tela fica em `app/login.tsx`. O login real ainda não existe: use uma função falsa que aceita qualquer e-mail válido com senha de 6 caracteres ou mais.

## Fora do escopo

Cadastro, login social e recuperação de senha de verdade.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "home screen and approved login spec"
