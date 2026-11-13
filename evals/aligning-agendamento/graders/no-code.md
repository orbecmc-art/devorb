---
type: regex
target: last_message
pattern: '(?:```|~~~)[ \t]*(?:jsx?|tsx?|javascript|typescript|html|xml|css|scss|python|py|sql|bash|sh|shell|zsh|json|ya?ml|java|kotlin|swift|dart|go|rust|php|ruby|rb|cpp|csharp|vue|svelte|prisma|graphql|dockerfile)\b|^[ \t>]*(?:import |export |function |const |let |var |class |def |from \S+ import |<!doctype|<html|<head|<body|<div|<script|create table |select .+ from )|`(?:function|const|let|import|class|def) '
flags: mi
match: not_contains
---

A primeira resposta não traz código: nenhum bloco cercado com linguagem de programação ou de dados, nenhuma linha que comece com palavra-chave de código ou tag HTML, nenhum trecho inline como `function x`. Lista em markdown, texto e bloco cercado sem linguagem (por exemplo um rascunho de tela em texto) passam.
