---
type: regex
target: trace
pattern: '"name":"Write","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"file_path":"[^"]*",\s*(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"content":"(?:[^"\\]|\\.)*?(?:[Dd]escart[áa]ve(?:l|is)|DESCART[ÁA]VE|[Tt]hrowaway|THROWAWAY|[Jj]ogar fora|JOGAR FORA|[Nn][ãa]o [ée] c[óo]digo de produ[çc][ãa]o|[Nn]ot production code|[Aa]pague (?:este|esse) arquivo|[Dd]elete this file)|"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:>|\btee\b)(?:[^"\\]|\\.)*?(?:[Dd]escart[áa]ve(?:l|is)|DESCART[ÁA]VE|[Tt]hrowaway|THROWAWAY|[Jj]ogar fora|JOGAR FORA|[Nn][ãa]o [ée] c[óo]digo de produ[çc][ãa]o|[Nn]ot production code|[Aa]pague (?:este|esse) arquivo|[Dd]elete this file)'
match: contains
---

O próprio arquivo avisa que é descartável. Passa se o agente escreveu um arquivo (com Write, ou com `cat >`, `>>` ou `tee` no Bash) cujo conteúdo traz um aviso como "descartável", "throwaway", "jogar fora", "não é código de produção" ou "apague este arquivo".
