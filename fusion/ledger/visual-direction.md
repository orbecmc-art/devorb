# Ledger: `visual-direction`

Skill automática de nível completo, da Task D2 do plano de design, primeira do setor de design (`"sector": "design"`). Espinha: Impeccable (Apache-2.0). Outras fontes: Hallmark, taste-skill, `frontend-design`, Emil (`pick-ui-library`), ECC (`frontend-design-direction`), gstack (`craft`, `proposal-and-preview`, `review-sections`, `craft-audit`), genjutsu (`tells/references/web`) e Monich (`TAG-VOCABULARY`). Todas com `textReuse: false`: só ideias, escritas com palavras próprias e creditadas aqui. Nenhum texto, lista ou abertura delas entrou, e `LICENSES/NOTICE.md` não muda.

Pinos lidos, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos de `fusion/sources.json`, sem rodar nada:

- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430`: `skill/SKILL.src.md`, `skill/reference/new-work.md`, `craft-floor.md`, `mode-persuade.md`, `mode-operate.md`, `mode-read.md`.
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058`: `skills/hallmark/SKILL.md` e `references/gates.md`, `anatomy.md`, `imagery.md`, `craft.md`, `flow.md`.
- `taste-skill@f6b76575f949707b4e3c37cd86cb44b0b98643e8`: `references/copy.md`, `copy-voice.md`.
- `frontend-design@0412be76f50ab4f4f8abff3753efa9269fbbca5b`: `plugins/frontend-design/skills/frontend-design/SKILL.md`.
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9`: `skills/pick-ui-library/SKILL.md`.
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b`: `skills/frontend-design-direction/SKILL.md`.
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`: `design-html/sections/craft.md.tmpl`, `design-consultation/sections/proposal-and-preview.md.tmpl`, `plan-design-review/sections/review-sections.md.tmpl`, `design-review/sections/craft-audit.md.tmpl`.
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389`: `skills/_jutsu/tells/references/web.md`.
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808`: `installable/monich/assets/templates/web-template/design-systems/TAG-VOCABULARY.md`.

A skill foi escrita sem abrir `evals/visual-direction-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task D2 no plano.

`SKILL.md` tem 8.146 bytes (cerca de 2.037 tokens, teto 2.500). A descrição custa cerca de 38 tokens dos 250 do setor.

`fusion/ui-sources.json` foi movido com `git mv` para `skills/visual-direction/references/ui-sources.json`, e `tests/ui-sources.test.mjs` passou a ler o caminho novo. O conteúdo da lista não mudou: ela é do dono.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | DevOrb: só gatilhos (página, tela ou componente a construir, restilizar ou redesenhar, inclusive vindo de spec aprovada) |
| Abertura: página gerada parece gerada porque nada foi decidido; a skill decide palavras, nunca valores | Impeccable (decidir antes de construir) e a fronteira da spec ("Não escolhe valores") |
| 1. O que já é verdade; identidade no código vale sem `DESIGN.md` | Impeccable (`new-work` §1, "Visual authority is evidence") |
| Três níveis de invenção: estender, superfície nova no mesmo mundo, mundo novo | Impeccable (`new-work` §3), por decisão da Task D2. Sem o sorteio de estruturas |
| 2. Modo pelo sucesso do visitante na superfície, não pelo produto; quatro modos | Impeccable (`SKILL.src.md`, Modes). Experience fica no `SKILL.md`, escrita a partir da linha de Experience da espinha e de `mode-persuade` |
| 3. Material antes da forma: dado, a mostrar, faltando; pedir material uma vez; fato ausente vira lacuna visível, até duas por página | Hallmark (`SKILL.md` Shape e Ask once, `craft.md` §8), só ideias. "Se a spec já diz o que existe, isso é o inventário" é ajuste do DevOrb, porque a skill recebe spec aprovada |
| 4. Fontes de referência fixas: ler `references/ui-sources.json`, seguir as `rules`, casar pelas palavras do cliente, `byStyle` primeiro, `browser` só com ferramenta de navegador, `account` só com a conta do dono, dizer o que foi consultado e pulado | **Regra do dono** (spec, "Fontes de referência fixas"; plano, Global Constraints e Task D2) |
| Escolha de biblioteca: partir da tarefa, não da biblioteca citada; `package.json` primeiro, sem trocar dependência sem pedido; uma por tarefa, especialista da lista no lugar da feita à mão; dizer quando sai da lista | Emil (`pick-ui-library`), só ideias. A lista de bibliotecas do Emil não entrou: vale a do dono |
| Biblioteca nova nomeada no contrato antes de instalar; licença do componente antes de copiar | Spec e `rules` de `ui-sources.json` |
| 5. Candidatos do mundo do público; a página que a categoria sempre faz e o oposto previsível são o vício | Impeccable (`new-work` §3, criar o mundo), reescrito; de sete candidatos passou para quatro a seis, para caber |
| Cada candidato diz onde falharia | Monich (`TAG-VOCABULARY`, campo `avoid_for`), só ideia |
| Em Operate e Read, nunca a ferramenta do público como fantasia | Impeccable (`new-work` §3 e `mode-operate`) |
| Teste do espelho: o plano serviria a um concorrente? Mudar uma escolha e dizer qual | `frontend-design` (revisar o plano contra o brief) e Hallmark (Mirror test), só ideia |
| Família tipográfica por papel, conferindo nome, pesos, licença e de onde carrega; sem confirmar, fica pendente | gstack (`proposal-and-preview`, verificação de fonte), só ideia. Tamanhos e pesos ficam com `design-system` (fronteira da spec) |
| O brief vence, mesmo num look gasto | Impeccable ("The brief wins") e `frontend-design`, só ideia |
| 6. Contrato `## Direção visual` na spec recebida | Impeccable (`new-work` §5, Direction contract), adaptado: sem os seis blocos nem a semente, com os campos da Task D2 (fontes consultadas, fundação, especialistas, componente de destaque) |
| Tabela de estados: carregando, vazio, erro, sucesso, parcial e sem permissão, com o que se vê, o gatilho e a próxima ação; estado que não se aplica diz por quê | ECC (`frontend-design-direction`) e gstack (`review-sections`, Pass 2), só ideias |
| 7. Entregar para `devorb:design-system`; ler `floor.md` antes do código quando a mesma tarefa constrói | Interface da Task D2. A leitura do piso antes de editar vem da Impeccable (`SKILL.src.md`, Setup 3) |
| `references/persuade.md`: primeira tela em 1280 x 800 com a ação funcionando; mostrar o real, nunca janela desenhada nem URL de imagem de memória | Impeccable (`mode-persuade`) e Hallmark (Floor 12, `imagery.md` §4), só ideias |
| Seções e fechamento pelo trabalho do visitante, em tabela por tarefa; fechamento por e-mail só em assinatura | Hallmark (`anatomy.md`, gate 85), só ideia, em tabela própria com menos tarefas |
| Cerca de 80 palavras por tela; volume por escala e imagem | Hallmark (Floor 13, gate 58) |
| Uma ação principal com a mesma redação; prova ao lado da afirmação; garantia só se o negócio oferece | taste-skill (`copy.md`, regra 5) e gstack (`craft.md.tmpl`, Conversion rules), só ideias |
| Um candidato no máximo das ferramentas do público; face saturada precisa de motivo; claro ou escuro pela cena; ousadia num lugar só | Impeccable (`new-work` §3 e §4, `craft-floor`) e `frontend-design` (restrição), só ideias. A lista de fontes da Impeccable não entrou: a skill descreve a categoria sem nomes |
| `references/operate.md`: o mundo empresta tipo, paleta, densidade e um detalhe; layout, navegação e controles padrão | Impeccable (`mode-operate`), reescrito com exemplos próprios |
| Sem hero; barra superior; sidebar só acima de uns sete destinos; tabela antes de card; filtros na URL; modal por último; destrutiva com desfazer ou confirmação; movimento é estado | Hallmark (`flow.md`, App screens), só ideias, por decisão da Task D2 |
| Sem componente de destaque em Operate | `rules` de `ui-sources.json` e Monich (onde não serve), por decisão da Task D2 |
| Cor em Operate: contenção | Conflito resolvido (ver abaixo) |
| Dados de amostra variados com nomes de exemplo | Conflito resolvido (ver abaixo) |
| `references/read.md`: moldura e coluna; orientação; monoespaçada só para código; candidatos das publicações do público | Impeccable (`mode-read`), reescrito |
| `references/copy.md`: folha de fatos antes do texto | taste-skill (`copy-voice.md` §1), só ideia, com campos próprios e menos linhas |
| Nada inventado; lacuna visível até duas; sem lorem, sem `href="#"`; formulário sem endpoint não mostra sucesso | Hallmark (`craft.md` §8, gates 46a e 70), gstack (`craft.md.tmpl`, Ship floor) e taste-skill (`copy.md`), só ideias |
| Orçamento por página: um título em dois fragmentos, dois contrastes "X, não Y", nenhuma palavra de virtude própria | taste-skill (`copy-voice.md` §5), só ideia, por decisão da Task D2. Os exemplos são próprios |
| Ação com verbo e objeto, mesma redação; títulos que dizem o que se encontra | taste-skill (`copy.md`) e `frontend-design` (escrita), só ideias |
| Rótulo acima de título só com fato, destino ou identificador | Conflito resolvido (ver abaixo) |
| Teste da troca (concorrente no título), a boca do dono, segunda passada | taste-skill (`copy-voice.md` §6) e Hallmark (`craft.md` §6), só ideias |
| `references/floor.md`: dois níveis, piso nunca dispensado e reflexo só com motivo desta página registrado | Hallmark (`gates.md` §1, Floor e Reflex), por decisão da Task D2 |
| Piso: só tokens, `overflow-x: clip`, `minmax(0, 1fr)`, contêiner limitado em 1920, primeira tela completa em 1280 x 800, sem ponto médio, palavra destacada ou rótulo em caixa alta espaçada | Hallmark (Floor 1, 4, 5, 9, 10, 12 e 14), por decisão da Task D2 |
| Piso: `lang`, `<title>`, descrição, skip link, foco instantâneo, reduced motion, conteúdo sem script, imagem do LCP sem lazy | gstack (`craft-audit` e Ship floor) e Hallmark (Floor 6 e 7, gate 28a), por decisão da Task D2 |
| Piso: status sem dado (selo "operacional", ponto ao vivo, versão, "sincronizado há") | genjutsu (`tells/references/web.md`), só ideia, por decisão da Task D2 |
| Reflexos: faixa de cidade, relógio ou clima; código de seção vazio; três cards iguais; brilho, blob, texto em gradiente, vidro; fechamento por e-mail; um layout repetido; monoespaçada como fantasia | genjutsu (`tells`), Impeccable (`craft-floor`, Refuse) e Hallmark (gates 3, 29, 64, 66, 85), só ideias |
| Looks gastos descritos em números, em tabela própria | `frontend-design` (calibração) e Hallmark (gate 65), só ideia, por decisão da Task D2. Os limites numéricos são do Hallmark (gate 65) ou meus, onde a fonte não dava número |

## Conflitos resolvidos

- **Eyebrow:** a Impeccable e o Hallmark proíbem sem exceção; o taste-skill aceita um ou dois por página. Pela Task D2, o rótulo acima de um título fica só quando traz fato, destino ou identificador que faria falta. Entrou como reflexo em `floor.md`, com a regra em `copy.md`.
- **Dados de amostra:** a Impeccable pede valores plausíveis com unidade; o gstack proíbe números redondos e nomes de placeholder; o Hallmark pede valores que se leiam como amostra, com valores redondos. Pela Task D2, em mock os valores são variados e os nomes são de exemplo (`exemplo.com`, "Cliente Exemplo"), nunca um número que o visitante tome como afirmação.
- **Cor em Operate:** a Impeccable diz que tela cinza com um acento é o padrão da categoria e pede paleta comprometida no shell; o Hallmark contém a cor (acento só para ação, seleção e estado, e um segundo neutro no shell). Pela Task D2, vence a contenção. Da Impeccable ficou só o aviso de que cinza com um acento ainda é o padrão, se o tipo, a densidade e o detalhe não fizerem a tela ser deste produto.
- **Sorteio ou plano livre:** a Impeccable exige `concept-seed` com binário próprio antes de qualquer código. Vale o estrutural da spec: plano livre com o teste do espelho, sem script.
- **Uma estética para tudo:** o taste-skill impõe uma. Vale o modo da superfície (spec).
- **Fato e envio falso:** o taste-skill aceita preço e horário plausíveis marcados (`data-assumed`) e o gstack simula estados de formulário sem backend. Vale o Hallmark (spec): fato ausente vira lacuna visível, e formulário sem endpoint não mostra sucesso.
- **Listas de fontes:** a Impeccable lista faces saturadas; o gstack as recebe da Impeccable. Nenhuma lista vira lei (spec): a skill descreve a categoria sem nomes, pede motivo registrado em Persuade, e o brief vence.
- **Perguntar ou seguir:** a Impeccable e o Hallmark perguntam antes de construir (duas a quatro perguntas). No DevOrb a skill recebe spec aprovada de `devorb:aligning`, então pede só material, uma vez, e só se houver alguém na conversa e a spec não disser o que existe. É ajuste de encaixe no fluxo, não regra própria.

## Regras próprias

1. **Regra do dono: fontes de referência fixas.** Antes de escolher a direção ou fazer um componente do zero, a skill lê `references/ui-sources.json`, consulta as fontes que combinam com as palavras do cliente seguindo as `rules`, abre `reading: "browser"` só com ferramenta de navegador e `reading: "account"` só com a conta do dono, e o contrato registra as fontes consultadas, a fundação, os especialistas e o componente de destaque. Está no corpo do `SKILL.md`, não numa referência. Nenhuma fusão a tira. Cenário: o caso das fontes fixas da Task D2 (landing "bem clean" com shadcn/ui e Tailwind).

A candidata da spec (a fonte escolhida tem os acentos do português) **não entrou**: a Task D2 manda esperar um cenário que a justifique, e nenhum caso conhecido mede os glifos da fonte. Fica em aberto para a revisão do dono.

## Fora

- **Impeccable:** o motor e o lançador (`impeccable context`, `concept-seed`, `serve-question`, `build-phase`, `comp-spec`, `font-match`, `detect`), o sorteio de direção, as cartas, a escolha do dono e o re-roll, as imagens de comp e o caminho comp-led inteiro, a busca no catálogo externo, os subagentes de revisão e de documentação, o `surface brief`, a linha FINISH, os comandos (`polish`, `bolder` etc.), os hooks e a telemetria. Também a lista de faces saturadas pelo nome, o bloco `<claude>` sobre o viés de creme e as regras sobre símbolos carregados (sem cenário).
- **Hallmark:** `sloplint`, `theme.mjs` (sorteio, temas, scaffold, log), `capture.mjs`, a biblioteca de fotos, o carimbo no CSS, o bloco Picks, a crítica pré-emissão de seis eixos, os gêneros, as macroestruturas, o `install-hook` e as revisões em contexto novo. Os números de cada gate (tamanhos, durações, OKLCH) são de `design-system` e `motion`, não desta skill.
- **taste-skill:** `copy-lint`, a estética única, os registros de voz, a busca de nome inventado, as regras de endereço e telefone, os créditos de foto e a proibição de legenda.
- **`frontend-design`:** a persona de estúdio e o plano com hex e ASCII, que são valores.
- **Emil:** a resposta inicial fixa, a lista de bibliotecas (vale a do dono) e `disable-model-invocation`.
- **ECC:** o registro JSON de evidência e o `check-evidence.js`, a pesquisa no UIZZE (MCP pago), e o portão de render, que é de `ui-review` e `browser-testing`.
- **gstack:** `gstack-design-lint`, os arquétipos de `design-shotgun`, as perguntas uma a uma do `plan-design-review`, as notas de 0 a 10, o modelo de `DESIGN.md` (fica para `design-system`), a lista de estéticas prontas, os mockups pagos e o JSON-LD.
- **genjutsu:** o formato de três campos e as entradas que já estão no piso por outra fonte.
- **Monich:** o vocabulário controlado em chinês e o índice de marcas.

## Revisões

- 2026-11-13, conferência frase a frase contra cada fonte, depois da primeira escrita. Reescritas por estarem perto demais:
  - `SKILL.md`: "the old look is evidence of what the subject is" (Impeccable); as descrições dos modos ("decides and acts", "understands something", Impeccable); "the page this category always ships and its predictable opposite; both are the rut" (Impeccable); "knows by heart" (Impeccable); o teste do espelho com "neighbouring prompt... change one decision and say which" (Hallmark); "The brief wins" com a lista de fixações (Impeccable); "identify the task, not the library" (Emil); "the category-default arrangement it refuses" (Impeccable); os rótulos real, pictures, absent do inventário (Hallmark), trocados por given, to show, missing.
  - `persuade.md`: a ação "in its working form" com o exemplo da clínica (Impeccable); "how software pages look and almost nothing else" (Hallmark); "About 80 words on any one screen" (Hallmark); "Proof sits beside the claim it supports" (gstack); o exemplo dos livros e da serifa (Impeccable); claro ou escuro pela cena (Impeccable); "spend your boldness in one place" (`frontend-design`).
  - `operate.md`: "know where everything is before they notice the world", "never supplies the layout, the navigation model or the controls", os exemplos de mapa de transporte e de quadro de horários, a descrição do shell e "costume" (Impeccable); sidebar "earned by more than seven", card "independently interactive or of a different kind", modal "the last answer", "figures are the product's own", estados e "drawn a quarter of the screen", acento e segundo neutro (Hallmark).
  - `read.md`: a lista de tradições editoriais, a moldura, a coluna, o shell, "pull it back to the frame" e o material real (Impeccable).
  - `copy.md`: "with no facts, a model fills a template... the fix is facts and decisions" (taste-skill); os campos da folha de fatos; "an empty field stays empty"; a tabela de orçamento e seus exemplos; "a verb plus what the visitor gets"; o teste do rival, ler em voz alta como o cliente e a tique que substitui a removida (taste-skill); o teste de apagar o eyebrow, o link sem URL e o formulário sem endpoint (Hallmark). Um exemplo da folha de fatos citava uma clínica em Goiânia, perto demais do caso realista, e virou uma padaria.
  - `floor.md`: tokens, contêiner em 1920, foco, rótulos, ponto médio e seta (Hallmark); a ordem de mudança dos looks (Hallmark gate 65); a lista dos looks gastos (`frontend-design`), refeita como tabela própria.
- 2026-11-13, Task M4 do plano mobile: o contrato do passo 6 ganha a linha **Platform**, só em tela de app: o idioma de cada plataforma (diretrizes da Apple no iOS, Material 3 no Android) ou o tratamento neutro escolhido, com o motivo. Vem da Fronteira de design da seção "Setor mobile" da spec e de `native-slop` (16) da Expo (`expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`, MIT, só ideia). `SKILL.md` foi de 8.390 para 8.544 bytes.
- 2026-11-17, Task 4 do plano `docs/plans/2026-11-17-design-quality-fase-1.md` (modo cópia):
  - **Espaço:** a §4 (tipos de `reading` e escolha de biblioteca) foi para `references/sources.md` e a lista de campos da §6 para `references/contract.md`, sem mudança de comportamento. `SKILL.md` foi de 8.544 para 6.479 bytes e, com o modo cópia, ficou em 7.011 bytes (cerca de 1.753 tokens, teto 2.500).
  - **Replicate,** quarto nível de invenção na §1, entra quando o usuário pede para copiar, clonar, "deixar igual" ou usar como base, e aponta para `references/replicate.md`: capturar o pacote com `capture.mjs`; atrás de login, o navegador já logado do usuário com `collect-in-page.js` pela ferramenta de JavaScript; sem navegador nenhum, ler o HTML e o CSS da referência, escrever `secoes.md` e `notas.md` à mão e dizer que a captura e o espelho não rodaram; perguntar antes de commitar o pacote e sugerir `design/referencias/` no `.gitignore` quando o conteúdo é de terceiros; o padrão do que fica igual e do que muda, perguntado uma vez quando há pessoa na conversa; construir seção por seção com espelho contra `section-<i>.png`; `compareStructure` e depois `devorb:ui-review`. A §5 (direção) não roda no Replicate: a referência é a direção.
  - **Scripts pelo caminho absoluto** da pasta da skill, com `--pw <dir>` quando o projeto não tem Playwright. Instalar Playwright no projeto do usuário só com o sim dele; sem isso, numa pasta temporária.
  - **Origem das ideias,** todas com as fontes fechadas e texto próprio:
    - ai-website-cloner-template (MIT): as fases (capturar, mapear as seções, construir seção por seção, comparar no fim). Só ideia.
    - taste-skill (MIT, `textReuse: false`): fotografar o build e conferir a consistência contra a referência. Só ideia; os scripts do DevOrb (`shoot.mjs`, `rules.mjs`) são próprios.
    - `mirror.js` da skill `av-design-system` do dono: neutralizar revelações travadas por scroll. Só ideia, porque a origem e a licença não estão confirmadas: aqui virou a seção `hidden` lida da fonte e registrada como movimento.
    - dembrandt (MIT, `0.39.2` no npm): conferido com `npx -y dembrandt --help` em 2026-11-17, que funcionou. O comando gravado é `npx -y dembrandt@0.39.2 <url> --design-md`, opcional e só em página pública. Não rodei contra uma página, então o caminho exato do `DESIGN.md` que ele escreve (sob `output/`) não foi conferido.
  - **Regras "nunca copie" reescritas:** §4 do `SKILL.md` (copiar a forma quando pedido; nunca publicar texto, fotos ou logo de terceiros como do cliente), regra 3 de `ui-sources.json` e `skills/design-system/references/design-md.md` (estrutura e escala quando pedido; cores, fontes e assinatura de outra marca só quando o usuário é dono dela). `tests/ui-sources.test.mjs` não cita a frase antiga e não mudou.
  - **Outras skills de gosto:** uma linha na §4 manda não carregar frontend-design, taste-skill, Impeccable nem ui-ux-pro-max com o fluxo de design do DevOrb ativo, e recomendar desinstalá-las uma vez (decisão 8 da spec).
  - **Contrato:** `contract.md` ganhou os rótulos fixos que as Tasks 5 a 8 leem: `Mode`, `Invention level`, `Motion level: Suave | Equilibrado | Impacto`, `Reference pack: design/referencias/<slug>/ (até 3)`, `Same as reference:`, `Changed:`, `Sections:` (padrão, fonte do texto e movimento por seção) e `Do not:`. Os rótulos ficam como escritos, em qualquer língua da spec.
  - **Razão título/texto 2.0 em Read e Experience:** a spec fixa só 3.0 em Persuade e 1.6 em Operate. Para Read e Experience, o construtor escolheu 2.0 (Task 1, `MODE_MIN_RATIO` em `skills/ui-review/scripts/rules.mjs`): leitura e vitrine precisam de hierarquia clara, mas não do título de vitrine de venda, e 2.0 é a razão medida na Ligare, uma tela real de app (`progress.md` da Task 1). Fica para o dono confirmar.

## Resultados

Opus 5.5, nível completo, 3 rodadas, `--ablation none`. Braços: sem plugin e UI UX Pro Max (`4f2dbb6`). `fusion/results/2026-11-13-visual-direction*.md`.

| Caso | DevOrb | Sem plugin | UI UX Pro Max |
|---|---|---|---|
| `visual-direction-clinica-serena` | 100% (1,00) | 0% (0,67) | 0% (0,75) |
| `visual-direction-arquitetura-clean` | 0% (0,55) | 0% (0,18) | 0% (0,18) |
| Reservado `visual-direction-painel-padaria` | 100% (1,00) | 33% (0,82) | 33% (0,82) |

- `accepted: true` nos dois. O caso das fontes fixas é lacuna em todos os braços, mas o DevOrb tem a maior nota.
- Depois de R6, a skill passou a mandar usar o especialista escolhido mesmo sem rede (vai no manifesto, com o aviso de que falta instalar) e a nomear as fontes na mensagem final (`af8adfb`). Rodado de novo, o caso das fontes fixas ficou em 0% (0,48), contra 0,18 nos dois outros braços: o agente lê a lista e abre as galerias antes do código, mas ainda não põe o `sonner` em nenhuma das rodadas. Causa não conferida no trace. Fica como lacuna.
- Portão do dono: as duas páginas da Clínica Serena (com a skill e sem plugin) e a spec com a direção estão em `fusion/results/d2-portao/`. Por decisão do dono (seguir o recomendado), o setor segue; a avaliação de gosto fica com ele quando abrir as páginas.
- Custo: US$ 8,82 nas linhas de base e US$ 24,33 na comparação. O caso das fontes fixas custa uns US$ 4 por rodada com a skill, porque o agente consulta as fontes na web.

Modo cópia, 2026-11-17, `evals-outside/visual-direction-copia-referencia` (`--outside-sandbox`), Opus 5.5, 2 rodadas:

| Etapa | DevOrb | Sem plugin |
|---|---|---|
| RED (`--baseline-only`) | não roda | 0% (0,63), US$ 1,36 |

- `fusion/results/2026-11-17-visual-direction-outside-baseline.md`. GREEN (`--arms devorb,none` e `--reserved`) fica com o controlador.

## Decisões por commit de fonte

- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/SKILL.src.md` | adotado | modos pelo sucesso do visitante na superfície, Experience no `SKILL.md`, o brief vence, identidade no código vale sem `DESIGN.md`, ler o piso antes de editar
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/SKILL.src.md` | recusado | lançador e binário, comandos, hooks, doctor, pin, a persona de diretor premiado
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/new-work.md` | adotado | três níveis de invenção, candidatos do mundo do público, o vício da página da categoria e do oposto, ferramenta do público como fantasia, contrato de direção antes do código, faces com motivo, claro ou escuro pela cena
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/new-work.md` | recusado | `concept-seed` e o sorteio, cartas, re-roll, comps, caminho comp-led, revisores e documentador, `surface brief`, a lista de faces pelo nome, o bloco `<claude>`
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/craft-floor.md` | adotado | piso separado da direção, o que se recusa por padrão (cards iguais, eyebrow, números de seção, gradiente no texto, vidro, monoespaçada como fantasia), claro ou escuro pela cena
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/craft-floor.md` | recusado | valores de contraste, tipo, sombra e movimento (são de `design-system`, `motion` e `ui-review`), o bloco `<codex>`
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/mode-persuade.md` | adotado | a primeira tela com a ação funcionando, a direção carrega a página sem engolir as partes
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/mode-persuade.md` | recusado | regras de comps e de objeto visto uma vez
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/mode-operate.md` | adotado | o mundo empresta tipo, paleta, densidade e um detalhe; controles padrão; shell primeiro
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/mode-operate.md` | recusado | paleta comprometida no shell (conflito: vence a contenção), regras de comps
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/mode-read.md` | adotado | moldura e coluna, orientação, monoespaçada só para código, candidatos editoriais
- `impeccable@cf7ea4a8fe56f3e186e9ffaca3124937e36e6430:skill/reference/mode-read.md` | recusado | regras de comps, números de medida (são de `design-system`)
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/SKILL.md` | adotado | inventário antes da forma, pedir material, teste do espelho, o piso checável, 80 palavras por tela, primeira tela em 1280 x 800, contêiner em 1920
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/SKILL.md` | recusado | sorteio de tema, scripts, carimbo, bloco Picks, gêneros, comp com chave de API
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/gates.md` | adotado | piso e reflexo em dois níveis, reflexo só com motivo registrado, eyebrow com fato, fechamento pelo trabalho, envio falso, look gasto com números
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/gates.md` | recusado | numeração dos gates, notas de crítica, `sloplint`, ledger de repetição, valores de cada gate
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/anatomy.md` | adotado | seções, ação e fechamento pelo trabalho do visitante, em tabela própria
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/anatomy.md` | recusado | amostras de seção que o usuário troca depois, tarefas `try`, `join` e `listen`
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/imagery.md` | adotado | mostrar o produto real, capturado ou construído com controles de verdade; nunca janela desenhada nem URL de imagem de memória; imagem do LCP sem lazy
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/imagery.md` | recusado | biblioteca de fotos, slots, tratamentos, `capture.mjs`, regras de proporção
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/craft.md` | adotado | fato ausente como lacuna visível até duas, link sem URL para a seção mais próxima, formulário sem endpoint, teste da troca na cópia, rótulos em caixa normal
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/craft.md` | recusado | valores de tipo, cor, espaço e movimento (são de `design-system` e `motion`), as doze aberturas de seção
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/flow.md` | adotado | tela de sistema: sem hero, barra superior, sidebar acima de uns sete destinos, tabela antes de card, filtros na URL, quatro estados, destrutiva com desfazer, movimento como estado, contenção da cor
- `hallmark@407fa689f4a276f2fd389208d271d0fef08f5058:skills/hallmark/references/flow.md` | recusado | escopo de componente com prévia de oito estados, sinal 8 (Inspo), modo rápido, hook, harnesses, carimbo
- `taste-skill@f6b76575f949707b4e3c37cd86cb44b0b98643e8:skills/taste-skill/references/copy.md` | adotado | nada inventado, sem placeholder nem `href="#"`, ação principal com a mesma redação, botão com verbo e objeto, títulos que nomeiam a coisa
- `taste-skill@f6b76575f949707b4e3c37cd86cb44b0b98643e8:skills/taste-skill/references/copy.md` | recusado | `copy-lint`, preços e horários assumidos, regras de endereço, telefone e mapa, nome inventado, créditos, proibição de legenda
- `taste-skill@f6b76575f949707b4e3c37cd86cb44b0b98643e8:skills/taste-skill/references/copy-voice.md` | adotado | folha de fatos antes do texto, orçamento de dispositivos (dois fragmentos, contrastes, virtudes), teste do rival, ler como o cliente, a tique que volta
- `taste-skill@f6b76575f949707b4e3c37cd86cb44b0b98643e8:skills/taste-skill/references/copy-voice.md` | recusado | cartão de voz e registros, perguntas de cópia, leitor novo em subagente
- `frontend-design@0412be76f50ab4f4f8abff3753efa9269fbbca5b:plugins/frontend-design/skills/frontend-design/SKILL.md` | adotado | revisar o plano contra o brief (teste do espelho), looks gastos para calibrar, o brief vence, ousadia num lugar só, ação com o mesmo nome no fluxo
- `frontend-design@0412be76f50ab4f4f8abff3753efa9269fbbca5b:plugins/frontend-design/skills/frontend-design/SKILL.md` | recusado | persona de estúdio, plano com hex e ASCII, conselho de seletores CSS
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/pick-ui-library/SKILL.md` | adotado | tarefa antes da biblioteca citada, `package.json` primeiro sem trocar dependência, uma recomendação, avisar quando sai da lista
- `emil-skills@715c1807e08c497cfd1dc4feb450a2a3300ef2a9:skills/pick-ui-library/SKILL.md` | recusado | a lista de bibliotecas, a resposta inicial fixa, a invocação manual
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/frontend-design-direction/SKILL.md` | adotado | tabela de estados com gatilho, o que se vê e a próxima ação; estado que não se aplica diz por quê; sem paisagem de landing em ferramenta
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/frontend-design-direction/SKILL.md` | recusado | registro JSON e `check-evidence.js`, UIZZE, portão de render
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:plan-design-review/sections/review-sections.md.tmpl` | adotado | tabela de funcionalidade por estado
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:plan-design-review/sections/review-sections.md.tmpl` | recusado | sete passes com nota, uma pergunta por problema, mockups, log de revisão
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-consultation/sections/proposal-and-preview.md.tmpl` | adotado | conferir nome, pesos, licença e URL da fonte antes de usá-la; sem confirmar, fica pendente
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-consultation/sections/proposal-and-preview.md.tmpl` | recusado | estéticas prontas, proposta SAFE/RISK, mockups pagos, prévia HTML, modelo de `DESIGN.md` (fica para `design-system`)
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-review/sections/craft-audit.md.tmpl` | adotado | prova que só o usuário tem fica como faltando, skip link, imagem do LCP sem lazy
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-review/sections/craft-audit.md.tmpl` | recusado | `gstack-design-lint`, ordem de correção, Tailwind por versão
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-html/sections/craft.md.tmpl` | adotado | prova ao lado da afirmação, garantia só se oferecida, ship floor (título, descrição, `href` real)
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:design-html/sections/craft.md.tmpl` | recusado | simular estados do formulário sem backend (conflito), arquétipos, lint, JSON-LD, valores de movimento
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/tells/references/web.md` | adotado | status inventado, faixa de relógio ou clima, código de seção vazio, três cards iguais, brilho e blob de enfeite
- `genjutsu@5e00595ab7495d6bb966639f2f5ff1dbee364389:skills/_jutsu/tells/references/web.md` | recusado | o formato de três campos e as entradas já cobertas por outra fonte
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808:installable/monich/assets/templates/web-template/design-systems/TAG-VOCABULARY.md` | adotado | cada candidato diz onde não serve (`avoid_for`)
- `monich@ae98c316fed8f9ba7d17e8bd3e99f6a5d473f808:installable/monich/assets/templates/web-template/design-systems/TAG-VOCABULARY.md` | recusado | o vocabulário controlado e o índice de marcas
- `ai-website-cloner-template` (MIT) | adotado | só a ideia das fases do clone (capturar, mapear, construir por seção, comparar); sem texto
- `taste-skill@f6b76575f949707b4e3c37cd86cb44b0b98643e8` (scripts de print e consistência) | adotado | só a ideia de fotografar o build e conferir contra a referência; scripts próprios
- `av-design-system:mirror.js` (do dono, origem e licença não confirmadas) | adotado | só a ideia de neutralizar revelações; sem texto nem código
- `dembrandt@0.39.2` (MIT, npm) | adotado | comando opcional de tokens em página pública, conferido com `--help`
