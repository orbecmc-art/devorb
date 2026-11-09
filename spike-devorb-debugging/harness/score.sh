#!/usr/bin/env bash
# Scores one arm independently of what the agent reported.
# Usage: score.sh <compare dir> <arm dir> <base commit>
C="$1"; A="$2"; BASE="$3"
cd "$A" || exit 1
RUNS=15; ok=0
for i in $(seq $RUNS); do node --test >/dev/null 2>&1 && ok=$((ok+1)); done
echo "suite visivel: $ok/$RUNS"
echo "--- teste oculto"
ARM_DIR="$A" node --test --test-reporter=tap "$C/hidden/hidden.test.mjs" 2>&1 | grep -E 'ok [0-9]+ - H[0-9]' | sed 's/^ *//'
echo "--- sobras"
echo "sleep/espera em test/, payments, refunds: $(grep -nE 'sleep\(|setTimeout' test/*.js src/payments.js src/refunds.js | grep -v 'const sleep' | wc -l)"
echo "logs de depuracao: $(grep -nE 'console\.(log|error|debug)|DEBUG' src/*.js test/*.js | wc -l)"
echo "--- testes vao ao vermelho com o codigo original?"
T="$(mktemp -d)"; cp -r "$A/." "$T/"; cd "$T"
git checkout -q "$BASE" -- src 2>/dev/null; f=0
for i in 1 2 3 4 5; do node --test >/dev/null 2>&1 || f=$((f+1)); done
echo "falhas com src original: $f/5"
cd "$A"; rm -rf "$T"
echo "--- mudancas"
git status --short; git diff "$BASE" --stat | tail -8
