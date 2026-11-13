---
type: regex
target: trace
pattern: '"(?:command|content|new_string)":"(?:[^"\\]|\\.)*?(?:\b(?:chromium|firefox|webkit)\.launch\(|\bfrom \\?[''"]@playwright/test|\brequire\(\\?[''"]@playwright/test)(?:[^"\\]|\\.)*?\.(?:click|tap)\('
match: contains
weight: 2
---

O agente abriu a tela num navegador e clicou. Passa se algum comando do Bash ou arquivo escrito (Write ou Edit) traz, no mesmo texto, um navegador do Playwright aberto (`chromium.launch(`, `firefox.launch(`, `webkit.launch(` ou um teste com `@playwright/test`) e depois um `.click(` ou `.tap(`. Ler o código, rodar só `npm test` ou buscar a página com `curl` não conta.
