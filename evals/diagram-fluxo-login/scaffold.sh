#!/usr/bin/env bash
# Builds, in the current directory, the site of a language school in Node with
# e-mail login and password reset. src/auth.js describes every step of both
# flows in comments, with more steps than fit in 9 nodes, so the diagram has to
# group them. No docs/ folder yet.
# Self-contained, no network, no dependencies.
# Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
mkdir -p src

cat > package.json <<'__EOF__'
{ "name": "escola-falar-site", "private": true, "type": "module", "scripts": { "start": "node src/server.js" } }
__EOF__
cat > .gitignore <<'__EOF__'
node_modules/
__EOF__
cat > README.md <<'__EOF__'
# Escola Falar: site

Site da Escola Falar, escola de idiomas. O aluno entra com e-mail e senha para
ver turmas, notas e boletos. Quem esqueceu a senha pede um link de
redefinição, que chega por e-mail.

O passo a passo do login e da redefinição de senha está em `src/auth.js`.

    npm start
__EOF__
commit_at "2026-01-05T09:00:00-03:00" "chore: start the site"

cat > src/auth.js <<'__EOF__'
// Login and password reset for students.
//
// Login (POST /entrar):
//   1. The student types e-mail and password on /entrar.
//   2. Look up the account by e-mail. No account: show "e-mail ou senha
//      inválidos" (same message as a wrong password, on purpose).
//   3. After 5 wrong passwords in 15 minutes, lock the account for 15 minutes
//      and show "tente de novo em 15 minutos".
//   4. Compare the password with the stored hash. Wrong: show "e-mail ou senha
//      inválidos" and count the failure.
//   5. Right: create a session (cookie, 7 days) and go to /painel.
//
// Password reset:
//   1. On /entrar the student clicks "Esqueci minha senha" and types the e-mail
//      on /esqueci.
//   2. Always show "se o e-mail existir, enviamos um link": the page never says
//      whether the account exists.
//   3. If the account exists, create a single-use token valid for 1 hour and
//      send the link /redefinir?token=... by e-mail.
//   4. The student opens the link. Expired or already used token: show "link
//      expirado" and offer to send a new one.
//   5. Valid token: the student types the new password twice (at least 8
//      characters).
//   6. Save the new hash, mark the token as used and go back to /entrar with
//      "senha alterada".
import { createHash, randomBytes } from 'node:crypto';

export const ACCOUNTS = new Map(); // email -> { hash, failures: [], lockedUntil }
export const TOKENS = new Map(); // token -> { email, expires, used }

const hash = (password) => createHash('sha256').update(password).digest('hex');

export function login(email, password, now = Date.now()) {
  const account = ACCOUNTS.get(email);
  if (!account) return { ok: false, message: 'e-mail ou senha inválidos' };
  if (account.lockedUntil > now) return { ok: false, message: 'tente de novo em 15 minutos' };
  if (account.hash !== hash(password)) {
    account.failures = account.failures.filter((t) => now - t < 15 * 60e3).concat(now);
    if (account.failures.length >= 5) account.lockedUntil = now + 15 * 60e3;
    return { ok: false, message: 'e-mail ou senha inválidos' };
  }
  account.failures = [];
  return { ok: true, redirect: '/painel' };
}

export function requestReset(email, sendMail, now = Date.now()) {
  if (ACCOUNTS.has(email)) {
    const token = randomBytes(16).toString('hex');
    TOKENS.set(token, { email, expires: now + 60 * 60e3, used: false });
    sendMail(email, `/redefinir?token=${token}`);
  }
  return { message: 'se o e-mail existir, enviamos um link' };
}

export function resetPassword(token, password, now = Date.now()) {
  const entry = TOKENS.get(token);
  if (!entry || entry.used || entry.expires < now) return { ok: false, message: 'link expirado' };
  if (password.length < 8) return { ok: false, message: 'a senha precisa de 8 caracteres' };
  ACCOUNTS.get(entry.email).hash = hash(password);
  entry.used = true;
  return { ok: true, redirect: '/entrar', message: 'senha alterada' };
}
__EOF__
commit_at "2026-01-12T10:00:00-03:00" "feat: e-mail login and password reset"
