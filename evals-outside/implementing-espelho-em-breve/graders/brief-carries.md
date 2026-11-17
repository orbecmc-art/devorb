---
type: regex
target: trace
pattern: '"name":"(?:Agent|Task)","input":\{(?=(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"\w+":"(?:[^"\\]|\\.)*?design/referencias/)(?=(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"\w+":"(?:[^"\\]|\\.)*?floor\.md)'
match: contains
---

O despacho leva ao construtor o que ele precisa para se comparar. Passa se uma mesma chamada `Agent` (ou `Task`) traz, em algum campo do seu `input`, o caminho do pacote de referência (`design/referencias/`) e o `floor.md` de `devorb:visual-direction`. Falha se nenhum subagente foi despachado, ou se nenhum despacho cita os dois.
