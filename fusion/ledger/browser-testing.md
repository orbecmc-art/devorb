# Ledger: `browser-testing`

Skill automática de nível leve, da Task 23. Fonte de texto: `webapp-testing` da Anthropic (Apache-2.0). Fontes só de ideias (`textReuse: false`): `browser-qa` do Spartan e `browser-qa` do ECC.

Pinos lidos, buscados rasos em pasta temporária, com hooks desligados e sem rodar nada: `anthropic-skills@2c5958ecac7cee2b583967a2c4981d0f4a75c579` (`SKILL.md`, os três exemplos e `scripts/with_server.py`), `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9` (`SKILL.md` e `playwright-snippets.md`) e `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b` (`SKILL.md`). Spartan e ECC foram lidos uma vez e a escrita foi feita com eles fechados.

**Testada fora do sandbox.** O Chromium não abre dentro do sandbox do `claude plugin eval` (sondagem da Task 23). Por decisão do dono em 2026-11-12, a skill é comparada fora dele, com `tools/eval-outside.mjs`: cada rodada é um `claude -p --restricted` numa pasta temporária, com o login do dono e sem as configurações, hooks, plugins e servidores MCP dele. O caso fica em `evals-outside/`, para a comparação geral não tentar rodá-lo no sandbox. Fora do sandbox nada confina o agente, e ele consegue ler a pasta do braço, onde estão os graders.

## Origem por parte

| Parte | Origem |
|---|---|
| Lei de abertura: tela só funciona depois de um navegador real carregar, agir e ver console e rede limpos | Spartan (navegador real, nada só por HTTP) e Anthropic (testar app local com Playwright), em palavras próprias |
| Passo 1: testes de navegador do projeto primeiro; sem eles, script Playwright headless na linguagem do projeto; sem ferramenta, adicionar é decisão do usuário | Decisão da Task 23. Headless: Anthropic e Spartan |
| Passo 2: subir o servidor em segundo plano, esperar a porta com laço e prazo, encerrar pelo PID | Decisão da Task 23, no lugar do `with_server.py` |
| URL de produção só leitura; fluxo que muda dados só em local, staging ou preview, com permissão explícita e credencial de teste | ECC (raio de impacto, só leitura por padrão), só ideia; conflito resolvido pela Task 23 |
| Passo 3: olhar antes de agir, seletores do estado renderizado, papel e texto visível | Anthropic (reconhecimento antes da ação, seletores descritivos) |
| Esperar um elemento específico; `networkidle` só sem websocket nem polling | Anthropic (`networkidle`) contra Spartan (trava com websocket); conflito resolvido pela Task 23 |
| Passo 4: registrar erro de console, `pageerror`, resposta 400+ e `requestfailed` antes de navegar | Anthropic (exemplo de captura do console) e Spartan (erros de console e de rede), só ideia do Spartan |
| Formulário vazio, inválido e válido; o válido precisa chegar ao servidor | Spartan e ECC, só ideia, com a checagem do status da resposta como acréscimo meu |
| Botões, links, 1280 px e 375 px com toque | Spartan, só ideia |
| Conferir visibilidade antes de clicar; screenshot na falha | Spartan, só ideia |
| Erro de console é bug, aviso não; comparação visual sem imagem de base é inconclusiva | Spartan (erro e aviso) e ECC (sem base, inconclusivo), só ideias |
| Passo 5: relatório por checagem, com passos, esperado, obtido, linha de console ou rede e screenshot; veredito sem "pronto" com falha aberta | Spartan e ECC (modelo de relatório e veredito), só ideia, encurtado |
| Falha vai para `devorb:debugging` quando corrigir faz parte da tarefa; senão, relatar e parar | Interface da Task 23 e Spartan ("não corrigir sem perguntar"), só ideia |
| Stop signs | Próprios, a partir do caso realista |
| `references/playwright.md` | Exemplos da Anthropic (descoberta de elementos, captura do console), reescritos em Node e juntados num script só, com os eventos de rede, os dois viewports e o ciclo do servidor |

## Conflitos resolvidos

- **`networkidle`:** a Anthropic manda esperar `networkidle` sempre; o Spartan avisa que ele nunca termina com websocket ou polling. Vale a decisão da Task 23: esperar um elemento específico, e `networkidle` só em app sem websocket nem polling.
- **Enviar formulário:** o Spartan manda enviar formulários; o ECC limita fluxos que mudam dados. Em produção, só leitura; fluxo que muda dados só em local, staging ou preview, com permissão explícita e credencial de teste.
- **Corrigir ou relatar:** o Spartan manda relatar antes de corrigir; a interface da Task 23 manda a falha para `devorb:debugging`. A skill relata e só passa para `debugging` quando corrigir faz parte da tarefa.

## Regras próprias

Regras próprias só saem com decisão explícita do dono.

1. **Sem ferramenta de navegador, a tela é declarada não verificada.** Quando o usuário está fora e não há Playwright, a skill diz que a tela não foi conferida e por quê, em vez de chamar de conferida com os testes unitários. Caso: o realista da Task 23, grader `reports-failure`.
2. **O envio válido precisa chegar ao servidor.** O formulário só passa se a resposta do servidor também passa, não só a página. Caso: o realista, em que a tela não mostra nada e o 404 só aparece na rede.

## Fora

- `with_server.py`: usa `shell=True` e exige Python (decisão da Task 23).
- Varredura automática de todas as páginas, do Spartan e do ECC: pesaria em tarefa pequena (decisão da Task 23).
- Core Web Vitals, axe-core e modo escuro do ECC: fora do escopo de conferir uma tela; a acessibilidade fica para o setor de design.
- Tamanhos de 768 px e 1440 px do ECC: a Task 23 pede 1280 px e 375 px.
- Uso de MCP de navegador (ECC): a skill usa o que o projeto já tem ou Playwright.

## Revisões

- 2026-11-12: o exemplo de formulário em `references/playwright.md` foi rodado contra o app do caso realista. Preenchia só o nome, a validação barrava o envio e o `waitForResponse` estourava o prazo sem registrar nada. Agora preenche os dois campos e registra "nenhum pedido enviado" como problema. Rodado de novo, acha o 404, os dois erros de console e a falta de mensagem de sucesso nos dois viewports.
- 2026-11-12, revisão frase por frase contra Spartan e ECC: três frases ficaram perto demais do texto deles (clique em elemento invisível, erro contra aviso de console, comparação sem imagem de base) e foram reescritas. Só a redação mudou, depois de preparado o braço da rodada R6.

## Resultados

Opus 5.5, nível leve, 2 rodadas, fora do sandbox com `tools/eval-outside.mjs`, comparado com o braço sem plugin (a Anthropic traz 19 skills juntas, então não há braço de fonte). `fusion/results/2026-11-12-browser-testing-outside*.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `browser-testing-cadastro-cliente` | 100% (1,00) | 0% (0,60) |

- `accepted: true`. Sem plugin, o agente acha o 404 nas quatro rodadas (duas da linha de base e duas da comparação), lendo o código e testando com `curl`, mas só abre o navegador em uma delas. Com o DevOrb, as duas rodadas abriram a tela no Chromium e clicaram em Salvar.
- Numa rodada o DevOrb chamou `devorb:reviewing` e não `devorb:browser-testing`, e mesmo assim testou no navegador. O pedido "confere antes de eu avisar o cliente" fica entre revisar e testar a tela.

## Decisões por commit de fonte

- `anthropic-skills@2c5958ecac7cee2b583967a2c4981d0f4a75c579:skills/webapp-testing/SKILL.md` | adotado | Playwright headless, reconhecimento antes da ação, seletores descritivos, fechar o navegador, esperar por elemento
- `anthropic-skills@2c5958ecac7cee2b583967a2c4981d0f4a75c579:skills/webapp-testing/SKILL.md` | recusado | árvore de decisão em Python, `wait_for_timeout` como espera, uso de scripts como caixa-preta
- `anthropic-skills@2c5958ecac7cee2b583967a2c4981d0f4a75c579:skills/webapp-testing/examples/` | adotado | captura do console e descoberta de elementos, reescritas em Node em `references/playwright.md`
- `anthropic-skills@2c5958ecac7cee2b583967a2c4981d0f4a75c579:skills/webapp-testing/scripts/with_server.py` | recusado | `shell=True` e Python obrigatório
- `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9:toolkit/skills/browser-qa/SKILL.md` | adotado | só ideias: navegador real, erros de console e de rede, botões, links e formulários, 1280 px e 375 px com toque, visibilidade antes do clique, screenshot na falha, erro de console é bug e aviso não, relatar antes de corrigir
- `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9:toolkit/skills/browser-qa/SKILL.md` | recusado | varrer todas as páginas, limite de 3 segundos, navegação, breadcrumbs e fluxo de login
- `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9:toolkit/skills/browser-qa/playwright-snippets.md` | adotado | só ideias: rolagem horizontal no celular, captura de `requestfailed`
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/browser-qa/SKILL.md` | adotado | só ideias: só leitura em produção, fluxo que muda dados só em staging com permissão e credencial de teste, sem imagem de base é inconclusivo
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/browser-qa/SKILL.md` | recusado | MCP de navegador, Core Web Vitals, axe-core, três breakpoints, modo escuro, veredito SHIP
