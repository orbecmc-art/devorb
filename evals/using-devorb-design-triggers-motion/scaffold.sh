#!/usr/bin/env bash
# Builds, in the current directory, a tiny React (Vite) app with a modal
# component (src/Modal.jsx) that appears and disappears with no animation, plus
# the owner's approved spec describing how the modal opens. No node_modules:
# nothing installs and nothing builds.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src docs/devorb/specs

cat > package.json <<'__EOF__'
{
  "name": "agenda",
  "private": true,
  "type": "module",
  "scripts": { "dev": "vite", "build": "vite build" },
  "dependencies": { "react": "^18.3.1", "react-dom": "^18.3.1" },
  "devDependencies": { "@vitejs/plugin-react": "^4.3.4", "vite": "^6.0.7" }
}
__EOF__
cat > .gitignore <<'__EOF__'
node_modules/
dist/
__EOF__
cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Agenda</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
__EOF__
cat > src/main.jsx <<'__EOF__'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import './styles.css';

createRoot(document.getElementById('root')).render(<App />);
__EOF__
cat > src/App.jsx <<'__EOF__'
import { useState } from 'react';
import Modal from './Modal.jsx';

export default function App() {
  const [open, setOpen] = useState(false);
  return (
    <main>
      <h1>Consultas de hoje</h1>
      <button type="button" onClick={() => setOpen(true)}>Nova consulta</button>
      {open && (
        <Modal title="Nova consulta" onClose={() => setOpen(false)}>
          <p>Escolha o horário e o paciente.</p>
        </Modal>
      )}
    </main>
  );
}
__EOF__
cat > src/Modal.jsx <<'__EOF__'
export default function Modal({ title, onClose, children }) {
  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal" role="dialog" aria-modal="true" aria-label={title} onClick={(e) => e.stopPropagation()}>
        <h2>{title}</h2>
        {children}
        <button type="button" onClick={onClose}>Fechar</button>
      </div>
    </div>
  );
}
__EOF__
cat > src/styles.css <<'__EOF__'
.modal-backdrop {
  position: fixed;
  inset: 0;
  display: grid;
  place-items: center;
  background: rgb(0 0 0 / 0.4);
}

.modal {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  width: min(420px, 90vw);
}
__EOF__
cat > docs/devorb/specs/2026-01-01-agenda-modal-design.md <<'__EOF__'
# Abertura do modal de nova consulta

Aprovada pelo dono.

## Comportamento

- O fundo escurece aos poucos, sem piscar.
- A caixa do modal surge de leve, vindo um pouco de baixo, e fica firme no lugar.
- A abertura é rápida: quem marca consulta o dia todo não pode esperar o modal.
- Ao fechar, o modal some mais rápido do que abriu.
- Quem pediu ao sistema menos movimento vê o modal aparecer sem deslocamento.

## Arquivos

O componente fica em `src/Modal.jsx` e o CSS em `src/styles.css`. Nenhuma dependência nova.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "modal without animation and approved spec"
