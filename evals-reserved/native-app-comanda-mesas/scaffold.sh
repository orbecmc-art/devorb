#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Comanda, an Expo (React
# Native, expo-router) app for a restaurant: a tab layout in app/(tabs)/ with
# a bottom bar only, the tables screen (app/(tabs)/index.tsx) and the table
# card (components/MesaCard.tsx), whose fixed height breaks with large system
# fonts and whose icon buttons have no labels. No android/ or ios/ folders
# (they are generated), no node_modules: the sandbox has no network, so
# nothing installs and nothing builds; the case judges the files. Plus the
# owner's approved spec in docs/devorb/specs/.
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
mkdir -p 'app/(tabs)' components docs/devorb/specs

cat > package.json <<'__X__'
{
  "name": "comanda",
  "version": "1.3.0",
  "private": true,
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "lint": "expo lint"
  },
  "dependencies": {
    "@expo/vector-icons": "^15.0.2",
    "expo": "~54.0.0",
    "expo-router": "~6.0.0",
    "expo-status-bar": "~3.0.0",
    "react": "19.1.0",
    "react-native": "0.81.4",
    "react-native-safe-area-context": "~5.6.0",
    "react-native-screens": "~4.16.0"
  },
  "devDependencies": {
    "@types/react": "~19.1.0",
    "typescript": "~5.9.2"
  }
}
__X__
cat > app.json <<'__X__'
{
  "expo": {
    "name": "Comanda",
    "slug": "comanda",
    "scheme": "comanda",
    "version": "1.3.0",
    "orientation": "default",
    "userInterfaceStyle": "light",
    "android": {
      "package": "br.com.comanda.app"
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
# Comanda

App do salão do restaurante, em Expo com expo-router. Sai só para Android.

- `app/(tabs)/_layout.tsx`: a navegação entre Mesas, Pedidos, Cardápio e Ajustes.
- `app/(tabs)/index.tsx`: a tela de mesas.
- `components/MesaCard.tsx`: o cartão de cada mesa.

As pastas `android/` e `ios/` são geradas e não entram no git.
__X__
cat > app/_layout.tsx <<'__X__'
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';

export default function RootLayout() {
  return (
    <>
      <StatusBar style="dark" />
      <Stack screenOptions={{ headerShown: false }} />
    </>
  );
}
__X__
cat > 'app/(tabs)/_layout.tsx' <<'__X__'
import Ionicons from '@expo/vector-icons/Ionicons';
import { Tabs } from 'expo-router';

export default function TabsLayout() {
  return (
    <Tabs screenOptions={{ tabBarActiveTintColor: '#B5462E' }}>
      <Tabs.Screen
        name="index"
        options={{
          title: 'Mesas',
          tabBarIcon: ({ color, size }) => <Ionicons name="grid-outline" color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="pedidos"
        options={{
          title: 'Pedidos',
          tabBarIcon: ({ color, size }) => <Ionicons name="list-outline" color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="cardapio"
        options={{
          title: 'Cardápio',
          tabBarIcon: ({ color, size }) => <Ionicons name="restaurant-outline" color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="ajustes"
        options={{
          title: 'Ajustes',
          tabBarIcon: ({ color, size }) => <Ionicons name="settings-outline" color={color} size={size} />,
        }}
      />
    </Tabs>
  );
}
__X__
cat > 'app/(tabs)/index.tsx' <<'__X__'
import Ionicons from '@expo/vector-icons/Ionicons';
import { useState } from 'react';
import { FlatList, Pressable, StyleSheet, View } from 'react-native';
import MesaCard, { Mesa } from '../../components/MesaCard';

const MESAS: Mesa[] = [
  { id: '1', numero: 1, garcom: 'Seu Jorge', situacao: 'ocupada', total: 187.5 },
  { id: '2', numero: 2, garcom: 'Bia', situacao: 'livre', total: 0 },
  { id: '3', numero: 3, garcom: 'Bia', situacao: 'conta', total: 342.9 },
  { id: '4', numero: 4, garcom: 'Seu Jorge', situacao: 'ocupada', total: 64 },
  { id: '5', numero: 12, garcom: 'Rafa', situacao: 'ocupada', total: 1210.4 },
  { id: '6', numero: 15, garcom: 'Rafa', situacao: 'livre', total: 0 },
];

export default function MesasScreen() {
  const [mesas] = useState(MESAS);

  return (
    <View style={styles.tela}>
      <FlatList
        data={mesas}
        keyExtractor={(m) => m.id}
        contentContainerStyle={styles.lista}
        renderItem={({ item }) => (
          <MesaCard
            mesa={item}
            onAdicionarItem={() => {}}
            onPedirConta={() => {}}
            onChamarGarcom={() => {}}
          />
        )}
      />
      <Pressable style={styles.fab} onPress={() => {}}>
        <Ionicons name="add" size={28} color="#FFFFFF" />
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  tela: { flex: 1, backgroundColor: '#FAF6F1' },
  lista: { padding: 16, gap: 12 },
  fab: {
    position: 'absolute',
    right: 16,
    bottom: 16,
    width: 56,
    height: 56,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#B5462E',
  },
});
__X__
cat > components/MesaCard.tsx <<'__X__'
import Ionicons from '@expo/vector-icons/Ionicons';
import { Pressable, StyleSheet, Text, View } from 'react-native';

export type Mesa = {
  id: string;
  numero: number;
  garcom: string;
  situacao: 'livre' | 'ocupada' | 'conta';
  total: number;
};

const SITUACAO = { livre: 'Livre', ocupada: 'Ocupada', conta: 'Conta pedida' };

type Props = {
  mesa: Mesa;
  onAdicionarItem: () => void;
  onPedirConta: () => void;
  onChamarGarcom: () => void;
};

export default function MesaCard({ mesa, onAdicionarItem, onPedirConta, onChamarGarcom }: Props) {
  const total = mesa.total.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });

  return (
    <View style={styles.cartao}>
      <View style={styles.topo}>
        <Text style={styles.numero}>Mesa {mesa.numero}</Text>
        <Text style={styles.total}>{total}</Text>
      </View>
      <Text style={styles.detalhe}>
        {SITUACAO[mesa.situacao]} · {mesa.garcom}
      </Text>
      <View style={styles.acoes}>
        <Pressable style={styles.botao} onPress={onAdicionarItem}>
          <Ionicons name="add-circle-outline" size={22} color="#B5462E" />
        </Pressable>
        <Pressable style={styles.botao} onPress={onPedirConta}>
          <Ionicons name="receipt-outline" size={22} color="#B5462E" />
        </Pressable>
        <Pressable style={styles.botao} onPress={onChamarGarcom}>
          <Ionicons name="notifications-outline" size={22} color="#B5462E" />
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  cartao: {
    height: 120,
    padding: 12,
    borderRadius: 12,
    backgroundColor: '#FFFFFF',
    overflow: 'hidden',
  },
  topo: { flexDirection: 'row', justifyContent: 'space-between', height: 28 },
  numero: { fontSize: 20, fontWeight: '700', color: '#2A211C' },
  total: { fontSize: 18, color: '#2A211C' },
  detalhe: { fontSize: 14, color: '#6E625A', height: 20 },
  acoes: { flexDirection: 'row', justifyContent: 'flex-end', gap: 8, marginTop: 8 },
  botao: { width: 36, height: 36, alignItems: 'center', justifyContent: 'center' },
});
__X__
placeholder() { # file, title
  tela=$1 titulo=$2
  cat > "app/(tabs)/$tela.tsx" <<__X__
import { StyleSheet, Text, View } from 'react-native';

export default function Tela() {
  return (
    <View style={styles.tela}>
      <Text style={styles.texto}>$titulo: em construção.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  tela: { flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: '#FAF6F1' },
  texto: { fontSize: 16, color: '#6E625A' },
});
__X__
}
placeholder pedidos Pedidos
placeholder cardapio Cardápio
placeholder ajustes Ajustes
commit_at "2026-01-01T09:00:00-03:00" "feat: tabs, tables screen and table card"

cat > docs/devorb/specs/2026-01-01-comanda-mesas-design.md <<'__X__'
# Comanda: cartão de mesa, prioridade e navegação por aparelho

Aprovada pelo dono.

## Contexto

O Comanda é o app do salão do restaurante, em Expo com expo-router, e sai só
para Android. A equipe toda usa o mesmo app em aparelhos diferentes:

- os garçons, no próprio celular. Vários usam a fonte do sistema bem grande;
- o caixa, num tablet de 11 polegadas deitado no balcão;
- o gerente, num celular dobrável que ele abre e fecha com o app aberto, várias
  vezes por turno.

## Problemas de hoje

1. **O cartão da mesa quebra com fonte grande.** No celular do Seu Jorge, que
   usa a fonte no máximo, "Mesa 12" encavala no total, a linha da situação é
   cortada e os botões somem para fora do cartão. O dono quer que o cartão
   continue com a cara de hoje: número da mesa à esquerda, total à direita,
   situação e garçom embaixo, e os botões no pé do cartão.
2. **A navegação é a mesma em todo aparelho.** No tablet do caixa, os quatro
   ícones ficam espalhados numa barra embaixo da tela inteira, e no dobrável
   aberto acontece o mesmo.

## O que muda

- **Cartão da mesa** (`components/MesaCard.tsx`): corrigir o problema 1. Os
  três botões continuam (adicionar item, pedir a conta e chamar o garçom).
- **Mesa prioritária** (novo): um botão de estrela no cartão liga e desliga a
  prioridade da mesa (aniversário, cliente esperando há muito tempo). A estrela
  fica cheia quando a mesa é prioritária, e as mesas prioritárias aparecem
  primeiro na tela de mesas (`app/(tabs)/index.tsx`).
- **Navegação** (`app/(tabs)/_layout.tsx`): cada aparelho recebe a navegação
  que combina com o tamanho da tela, e ela muda sozinha quando o gerente abre
  ou fecha o dobrável, sem reabrir o app. As quatro seções continuam: Mesas,
  Pedidos, Cardápio e Ajustes.
- O botão flutuante da tela de mesas, que abre uma mesa nova, continua.

## Restrições

- Toda a navegação fica em `app/(tabs)/_layout.tsx`, todo o cartão em
  `components/MesaCard.tsx` e a tela de mesas em `app/(tabs)/index.tsx`: nada
  de componente novo em outro arquivo.
- Sem dependência nova no `package.json`: o ambiente não tem rede. Os ícones
  continuam vindo de `@expo/vector-icons`.
- As pastas `android/` e `ios/` são geradas e não entram no projeto.
- O app tem que servir para toda a equipe, inclusive quem usa os recursos de
  acessibilidade do Android.

## Fora do escopo

- Cores, ícones e textos das outras telas.
- Pedidos, Cardápio e Ajustes continuam "em construção".
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for table card, priority and navigation"
