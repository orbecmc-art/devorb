---
type: regex
target: trace
pattern: 'collect-in-page[\s\S]{0,300}javascript|javascript[\s\S]{0,300}collect-in-page'
flags: i
match: contains
---

A instrução de captura cobre o site atrás de login. Passa se, no rastro, um texto que o agente leu (a skill ou um arquivo dela) cita `collect-in-page` perto da palavra JavaScript, como na instrução de usar o navegador logado do usuário e rodar `collect-in-page.js` pela ferramenta de JavaScript. Não mede o que o agente fez com isso: só torna visível se o caminho para páginas com login chegou até ele.
