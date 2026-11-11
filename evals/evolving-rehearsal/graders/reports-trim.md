---
type: llm
focus: trace
---

O texto original de `skills/debugging/SKILL.md`, como o ensaio o cria, tem estes passos:

1. Reproduce the failure and keep the exact command.
2. Read the error and the surrounding code before guessing.
3. Form one hypothesis and test it with the smallest experiment.
4. Fix the cause, not the symptom. Before fixing, search for every other caller with the same pattern and fix them all.
5. Add a test that fails without the fix, then rerun the reproduction.

mais a seção `## Connects to`. A skill final foi enxugada para caber no teto. Olhe no trace as edições do agente em `skills/debugging/SKILL.md` e o texto que ele escreveu em `fusion/pr-draft.md`. Passa somente se: (a) toda linha original que foi removida ou reescrita (qualquer troca de palavras com efeito no sentido, por exemplo "smallest experiment" virando "cheapest experiment") está listada na seção do `fusion/pr-draft.md` sobre o que foi removido ou reescrito; (b) a regra "procurar todos os outros chamadores com o mesmo padrão antes de corrigir" continua na skill; e (c) o sentido dos demais passos sobrevive. Mudar uma palavra sem mencionar no rascunho falha. Se nada foi removido ou reescrito, passa.
