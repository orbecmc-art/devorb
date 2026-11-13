#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Prumo, a task app for small
# teams, in React with Vite: a command palette (src/CommandPalette.jsx, Ctrl+K),
# a confirm modal (src/ConfirmModal.jsx), a public landing (src/Landing.jsx)
# and all the CSS in src/styles.css. Nothing moves yet: no transition and no
# animation anywhere. Plus the owner's approved spec for motion in
# docs/devorb/specs/. No node_modules: the sandbox has no network, so nothing
# installs and nothing builds; the case judges the files.
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
mkdir -p src docs/devorb/specs

cat > package.json <<'__X__'
{
  "name": "prumo",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.4",
    "vite": "^6.0.7"
  }
}
__X__
cat > .gitignore <<'__X__'
node_modules/
dist/
__X__
cat > README.md <<'__X__'
# Prumo

App de tarefas para equipes pequenas. React com Vite.

- `/` mostra a landing pública (`src/Landing.jsx`).
- `/app` mostra o app: lista de projetos, paleta de comandos (Ctrl+K ou ⌘K) e
  modal de confirmação ao apagar um projeto.

Todo o CSS fica em `src/styles.css`.
__X__
cat > vite.config.js <<'__X__'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
});
__X__
cat > index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Prumo</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
__X__
cat > src/main.jsx <<'__X__'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import './styles.css';

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
__X__
cat > src/App.jsx <<'__X__'
import { useState } from 'react';
import Landing from './Landing.jsx';
import CommandPalette from './CommandPalette.jsx';
import ConfirmModal from './ConfirmModal.jsx';

const INITIAL_PROJECTS = ['Site novo', 'Mudança de escritório', 'Planejamento 2026'];

export default function App() {
  const [projects, setProjects] = useState(INITIAL_PROJECTS);
  const [toDelete, setToDelete] = useState(null);

  if (window.location.pathname !== '/app') return <Landing />;

  return (
    <main className="app">
      <header className="app-header">
        <h1>Projetos</h1>
        <p className="hint">Ctrl+K abre a paleta de comandos</p>
      </header>
      <ul className="project-list">
        {projects.map((p) => (
          <li key={p} className="project">
            <span>{p}</span>
            <button type="button" className="button button-danger" onClick={() => setToDelete(p)}>
              Apagar
            </button>
          </li>
        ))}
      </ul>
      <CommandPalette />
      <ConfirmModal
        open={toDelete !== null}
        title={`Apagar "${toDelete}"?`}
        message="O projeto e todas as tarefas dele somem para toda a equipe."
        onCancel={() => setToDelete(null)}
        onConfirm={() => {
          setProjects((list) => list.filter((p) => p !== toDelete));
          setToDelete(null);
        }}
      />
    </main>
  );
}
__X__
cat > src/CommandPalette.jsx <<'__X__'
import { useEffect, useState } from 'react';

const COMMANDS = [
  'Nova tarefa',
  'Ir para Hoje',
  'Ir para Projetos',
  'Buscar tarefas',
  'Atribuir a mim',
  'Abrir configurações',
];

export default function CommandPalette() {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [active, setActive] = useState(0);

  useEffect(() => {
    function onKey(event) {
      if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k') {
        event.preventDefault();
        setOpen((value) => !value);
        setQuery('');
        setActive(0);
      } else if (event.key === 'Escape') {
        setOpen(false);
      }
    }
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, []);

  if (!open) return null;

  const items = COMMANDS.filter((c) => c.toLowerCase().includes(query.toLowerCase()));

  function onInputKey(event) {
    if (event.key === 'ArrowDown') setActive((i) => Math.min(i + 1, items.length - 1));
    if (event.key === 'ArrowUp') setActive((i) => Math.max(i - 1, 0));
    if (event.key === 'Enter') setOpen(false);
  }

  return (
    <div className="palette-overlay" onClick={() => setOpen(false)}>
      <div
        className="palette"
        role="dialog"
        aria-modal="true"
        aria-label="Paleta de comandos"
        onClick={(event) => event.stopPropagation()}
      >
        <input
          className="palette-input"
          autoFocus
          value={query}
          placeholder="Digite um comando"
          onChange={(event) => {
            setQuery(event.target.value);
            setActive(0);
          }}
          onKeyDown={onInputKey}
        />
        <ul className="palette-list" role="listbox">
          {items.map((c, i) => (
            <li key={c} role="option" aria-selected={i === active} className="palette-item">
              {c}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
__X__
cat > src/ConfirmModal.jsx <<'__X__'
export default function ConfirmModal({ open, title, message, onCancel, onConfirm }) {
  if (!open) return null;

  return (
    <div className="modal-backdrop" onClick={onCancel}>
      <div
        className="modal"
        role="alertdialog"
        aria-modal="true"
        aria-labelledby="confirm-title"
        onClick={(event) => event.stopPropagation()}
      >
        <h2 id="confirm-title">{title}</h2>
        <p>{message}</p>
        <div className="modal-actions">
          <button type="button" className="button" onClick={onCancel} autoFocus>
            Cancelar
          </button>
          <button type="button" className="button button-danger" onClick={onConfirm}>
            Apagar
          </button>
        </div>
      </div>
    </div>
  );
}
__X__
cat > src/Landing.jsx <<'__X__'
export default function Landing() {
  return (
    <main className="landing">
      <section className="landing-hero">
        <h1>Tarefas da equipe num lugar só</h1>
        <p>O Prumo junta projetos, prazos e responsáveis sem reunião para saber quem faz o quê.</p>
        <a className="button button-primary" href="/app">
          Criar conta grátis
        </a>
      </section>
    </main>
  );
}
__X__
cat > src/styles.css <<'__X__'
:root {
  --bg: #f7f7f5;
  --surface: #ffffff;
  --text: #1d1d1b;
  --muted: #6b6b66;
  --line: #e2e2dd;
  --accent: #2f5bd3;
  --danger: #c23a2b;
  --radius: 10px;
  font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
  color: var(--text);
  background: var(--bg);
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
}

:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 2px;
}

.button {
  display: inline-block;
  padding: 0.6rem 1rem;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: var(--surface);
  color: var(--text);
  font: inherit;
  text-decoration: none;
  cursor: pointer;
}

.button-primary {
  border-color: var(--accent);
  background: var(--accent);
  color: #ffffff;
}

.button-danger {
  border-color: var(--danger);
  color: var(--danger);
}

/* App */

.app {
  max-width: 720px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.hint {
  color: var(--muted);
}

.project-list {
  margin: 0;
  padding: 0;
  list-style: none;
}

.project {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem 0;
  border-bottom: 1px solid var(--line);
}

/* Paleta de comandos */

.palette-overlay {
  position: fixed;
  inset: 0;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding-top: 15vh;
  background: rgb(0 0 0 / 0.25);
}

.palette {
  width: min(560px, calc(100% - 2rem));
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: var(--surface);
  box-shadow: 0 12px 32px rgb(0 0 0 / 0.18);
}

.palette-input {
  width: 100%;
  padding: 0.9rem 1rem;
  border: 0;
  border-bottom: 1px solid var(--line);
  border-radius: var(--radius) var(--radius) 0 0;
  font: inherit;
}

.palette-list {
  margin: 0;
  padding: 0.25rem;
  list-style: none;
}

.palette-item {
  padding: 0.6rem 0.75rem;
  border-radius: 6px;
}

.palette-item[aria-selected='true'] {
  background: #eef2fc;
}

/* Modal de confirmação */

.modal-backdrop {
  position: fixed;
  inset: 0;
  display: grid;
  place-items: center;
  padding: 1rem;
  background: rgb(0 0 0 / 0.4);
}

.modal {
  width: min(420px, 100%);
  padding: 1.5rem;
  border-radius: var(--radius);
  background: var(--surface);
  box-shadow: 0 16px 40px rgb(0 0 0 / 0.2);
}

.modal h2 {
  margin-top: 0;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 0.5rem;
}

/* Landing */

.landing {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 2rem 1rem;
  background: var(--bg);
}

.landing-hero {
  max-width: 640px;
  text-align: center;
}

.landing-hero h1 {
  font-size: clamp(2rem, 6vw, 3.5rem);
  line-height: 1.1;
}

.landing-hero p {
  color: var(--muted);
  font-size: 1.125rem;
}
__X__
commit_at "2026-01-01T09:00:00-03:00" "feat: landing, project list, command palette and confirm modal"

cat > docs/devorb/specs/2026-01-01-prumo-movimento-design.md <<'__X__'
# Movimento no Prumo

Aprovada pelo dono.

## Contexto

O Prumo é um app de tarefas para equipes pequenas, em React com Vite. Hoje
nada se move: a paleta, o modal e a landing aparecem e somem de uma vez. O
dono quer movimento nas três partes abaixo.

## O que muda

- **Paleta de comandos** (`src/CommandPalette.jsx`): abre com Ctrl+K (ou ⌘K)
  e é o jeito principal de navegar e de criar tarefas no Prumo. Cada pessoa da
  equipe abre e fecha a paleta mais de cem vezes por dia.
- **Modal de confirmação** (`src/ConfirmModal.jsx`): aparece antes de apagar
  um projeto, poucas vezes por semana. Ganha uma entrada animada.
- **Landing** (`src/Landing.jsx`): a página pública de apresentação ganha um
  fundo animado e discreto atrás do título e do botão de cadastro.

## Restrições

- Todo o CSS fica em `src/styles.css`: nada de CSS em outro arquivo nem
  CSS-in-JS.
- Cada tela continua num arquivo só: o fundo da landing fica em
  `src/Landing.jsx` e em `src/styles.css`.
- Sem dependência nova no `package.json`. O ambiente não tem rede.
- O Prumo é usado no celular e no computador.

## Fora do escopo

- Mudar layout, cores ou textos.
- Outras telas.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for motion"
