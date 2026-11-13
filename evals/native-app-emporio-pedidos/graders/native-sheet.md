---
type: regex
target: trace
pattern: '"name":"(?:Write|Edit)","input":\{(?:[^"{}]|"(?:[^"\\]|\\.)*")*?"(?:[^"\\]|\\.)*?(?:formSheet|pageSheet|@gorhom/bottom-sheet|true-sheet)'
match: contains
---

O detalhe abre numa sheet da plataforma. Passa se algum Write ou Edit do agente escreve código com uma destas APIs de sheet: `formSheet` (apresentação de rota no Expo Router ou `presentationStyle` do `Modal`), `pageSheet` (`presentationStyle` do `Modal` do React Native), `@gorhom/bottom-sheet` ou `true-sheet`. Ler um arquivo, procurar com Grep ou Bash, ou carregar uma skill que cita essas palavras não conta: o padrão só olha a entrada das ferramentas que escrevem arquivo.
