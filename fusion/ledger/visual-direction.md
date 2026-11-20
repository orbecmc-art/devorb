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

1. **Regra do dono: fontes de referência fixas.** Antes de escolher a direção ou fazer um componente do zero, a skill lê `references/ui-sources.json`, consulta as fontes que combinam com as palavras do cliente seguindo as `rules`, abre `reading: "browser"` com ferramenta de navegador (sem ela, uma tentativa de web fetch simples e, se bloquear, a entrada é dada como pulada, ver `sources.md`) e `reading: "account"` só com a conta do dono, e o contrato registra as fontes consultadas, a fundação, os especialistas e o componente de destaque. Está no corpo do `SKILL.md`, não numa referência. Nenhuma fusão a tira. Cenário: o caso das fontes fixas da Task D2 (landing "bem clean" com shadcn/ui e Tailwind).

2. **Cópia fiel na estrutura, honesta no conteúdo.** No Replicate, toda seção da referência fica, na ordem dela, com o mesmo tipo e a mesma forma, e cada tratamento assinatura listado em `secoes.md` (título bicolor, mockup flutuante, número grande em faixa escura, avatares com inicial) fica, salvo se `Changed:` o nomeia. Quando o cliente não tem o fato que a seção pede, a forma recebe o que é verdade (serviços reais no layout de planos, etapas reais no de números) ou uma lacuna visível marcada; nunca se tira, junta ou troca a seção. Essas lacunas não contam no limite de duas por página da §3 e vão todas para a entrega. Está em `references/replicate.md` (passos 2 a 5) e numa frase da §3 do `SKILL.md`. Cenário: o caso reservado `visual-direction-copia-landing-clinica` (2026-11-17, `devorb@d873e93`): sem navegador, o agente montou o pacote, manteve a marca e não copiou texto, mas nas duas rodadas trocou as seções de depoimentos e de planos por outras para não inventar fatos e largou o título bicolor da referência. Falhou em estrutura e escala de tipo.

3. **A composição inclui as contagens.** No Replicate, `secoes.md` registra quantos itens tem cada grupo repetido (cards, pessoas, linhas, logos), e o build mantém essa contagem, remodelando o conteúdo verdadeiro para preenchê-la (mais momentos do dia, mais etapas do fluxo real, papéis ou personas de exemplo marcadas como exemplo). Um item só sai quando nada verdadeiro o preenche, e cada um que sai é nomeado na entrega. A conferência antes da entrega compara as contagens por seção. Está em `references/replicate.md` (passos 2 a 5). Cenário: o GREEN de `visual-direction-copia-referencia` (2026-11-17, `devorb@66e054a`): a rodada com a skill manteve as 6 seções em ordem, o título bicolor e a marca, mas cortou os 6 cards de horário para 3 e trocou a linha do tempo de 4 pessoas por papéis, "porque só há três coisas verdadeiras para mostrar". Falhou só em `structure`.

4. **Regra do dono: par complementar dividido por seção.** Uma página pode usar dois matizes complementares (por exemplo marinho e laranja) quando cada um tem as suas seções: um domina as seções de uma família e o outro as de outra, nunca os dois no mesmo bloco. Dono, 2026-11-18, sobre a página do Pilot: "ficou melhor do que uma cor só, traz vida". Tocou `design-system/references/color-finish.md` e `color-roles.md` e, em `visual-direction`, `floor.md`, `hero-patterns.md`, `persuade.md` e `contract.md`. Cenário: `evals/visual-direction-receitas-landing`, grader `color-pair`. RED em `devorb@8dc3b2f`: `color-pair` falhava 2/2 no braço devorb e 2/2 no `none` (devorb 0,75, none 0,25). GREEN em `devorb@4a966e3`: 100% (1,00), `none` 0,30. Limite conhecido: a faixa vinho (~355°) com o laranja (~25°) conta como três matizes no `accent-count`; sem mudança no código, fica anotado. Em aberto, decisão do dono: o piso "No single word set apart inside a heading" deveria afrouxar para o complemento? Hoje não afrouxa; o complemento só ganha linhas inteiras do título, não uma palavra solta.

5. **Regra do dono: fontes do dono antes de qualquer design.** O portão em §4 e no `guide.md` vale também quando não há pessoa para perguntar: antes de qualquer design a skill lê `references/ui-sources.json` e `sources.md`. Entrada com `reading: "browser"` sem ferramenta de navegador ganha uma tentativa de web fetch antes de ser dada como pulada, regra única em `sources.md` e no JSON (custa uma chamada de rede que deve bater num bloqueio de robô). Tocou `SKILL.md`, `guide.md`, `sources.md` e `ui-sources.json`. Cenário: `visual-direction-arquitetura-clean`. Depois da Fase 2 o caso caiu para 0,36. GREEN em `devorb@4a966e3`: 0,64 em 2 rodadas (`none` 0,18). Diagnóstico de 1 rodada só com devorb: 0,73, com os graders 1 a 3 (`sources-before-code`, `clean-gallery-before-code`, `names-sources`) e 5 (`one-standout`) passando e 4 e 6 falhando: o Sonner não entrou no `package.json` e o aviso foi feito à mão. O caso continua sem aprovação: 0% de aprovação, listado em "Lacunas (nenhum braço passa)", e o diagnóstico de 1 rodada ficou abaixo da barra de 2/3. Este GREEN não está aprovado. Lacuna anotada em 2026-11-19 como "nenhuma regra faz o Sonner entrar sem rede". Os traces de 2026-11-20 mostram outra coisa: o agente nunca chegou a escolher o Sonner, porque decidiu que o aviso da newsletter ficava dentro do formulário (regra 6). O `README.md` da fixture já diz que dependência nova entra no `package.json` e no código, e nas rodadas em que o Sonner foi escolhido ele entrou no `package.json` sem rede.

6. **Regra do dono: aviso de resultado de ação é trabalho de toast.** Decisão do dono em 2026-11-20. Em `sources.md`, o trabalho é nomeado pelo que acontece na tela, não pela palavra da spec: o aviso que informa o resultado de uma ação (salvou, inscreveu, enviou, falhou no servidor) é o trabalho de toast, usa o especialista da lista e nunca é uma linha de status montada no formulário ou na página; o erro de validação de um campo continua junto do campo. Cenário: `visual-direction-arquitetura-clean`, graders `4-sonner-dependency` e `6-newsletter-toast`, que falharam em todas as rodadas gravadas até `devorb@d7dc0a1`. A spec da fixture diz "a página confirma com um aviso na tela", e na sessão inteira o agente escolhia, por gosto, uma mensagem no formulário, com o que a regra do especialista deixava de se aplicar. RED no caso cortado em 20 turnos (logo depois do contrato), 3 de 3 sem especialista: "Especialista: nenhum; o aviso da newsletter fica junto do formulário, em texto com `aria-live`, porque um toast some antes de ser lido e o Sonner não está instalado"; "o aviso da newsletter é uma mensagem na própria linha do formulário (aria-live), não um toast, então Sonner fica de fora"; "O aviso da newsletter fica junto do campo e não vira toast, então o Sonner fica de fora". A alternativa recusada pelo dono era reescrever a spec da fixture para dizer "toast": o caso passaria e as specs reais, que dizem "aviso", continuariam com o aviso feito à mão. Limite conhecido: seis subagentes novos, só com a spec e os arquivos da skill, já escolhiam o Sonner em 6 de 6 antes da regra; a falha só aparece na sessão inteira, então teste com subagente não serve de RED para esta regra. A oração "nunca é uma linha de status" entrou na segunda rodada, depois de uma rodada inteira em que o agente leu a regra e escreveu "o aviso da newsletter é inline". Resultado e o que ficou aberto: "Resultados", 2026-11-20.

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
  - **Espaço:** a §4 (tipos de `reading` e escolha de biblioteca) foi para `references/sources.md` e a lista de campos da §6 para `references/contract.md`, sem mudança de comportamento. `SKILL.md` foi de 8.544 para 6.479 bytes e, com o modo cópia, ficou em 7.128 bytes (cerca de 1.782 tokens, teto 2.500).
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
- **2026-11-18, decisão do dono: o modo cópia pede antes de instalar.** `references/replicate.md` segue a regra de pedir antes: instalar Playwright ou um navegador, em qualquer lugar, e rodar `npx -y dembrandt@…` exigem o sim explícito do usuário ("decide sozinho" ou "não consigo responder" não é sim). Sem o sim, nada se instala: usa-se uma instalação que já existe por `--pw`, ou uma ferramenta de navegador (Claude in Chrome ou o navegador embutido) com `collect-in-page.js` pela ferramenta de JavaScript e prints do navegador, ou, sem navegador nenhum, `--dry-run` e a leitura do código da referência à mão. Sai a frase que mandava instalar numa pasta temporária sem o sim. Os graders `login-fallback` e `pack` de `evals-outside/visual-direction-copia-referencia` foram conferidos com as mesmas checagens sintéticas: `login-fallback` passa na leitura do `replicate.md`; `pack` falha nessa leitura sozinha e passa num comando com `capture.mjs` e num caminho real de `secoes.md`.

- 2026-11-18, Task 5 do plano `docs/plans/2026-11-18-design-quality-fase-2.md`: `references/floor.md` ganha `## Measured`, com os números que `shoot.mjs` confere e o que é FAIL e o que é WARN, medidos nas 23 referências (Call 7 da spec `docs/specs/2026-11-18-design-quality-fase-2-design.md`). A razão mínima de Persuade cai de 3,0 para 2,5, com alvo de 4,0 (WARN entre os dois), e abaixo de 1024px de largura passa a 2,0, com WARN abaixo de 2,5; o corpo só reprova abaixo de 13px; entram `display-weight` e `accent-count` como WARN. O porquê de cada número está no ledger de `ui-review`, na mesma data.

- 2026-11-18, Task 7 da Fase 2 de qualidade de design (`docs/plans/2026-11-18-design-quality-fase-2.md`), parte 1 do cardápio:
  - `references/hero-patterns.md` (10 aberturas) e `references/section-patterns.md` (12 seções, mais `## Mobile recomposition`) são novos. Cada padrão tem `When:`, `Sketch:`, `Measures:` e `Mobile:`, sob o cabeçalho `` ### `<kind>:<id>` — <nome> ``. Os padrões e as faixas vêm das sínteses de `docs/specs/2026-11-18-referencias/study-A.md` e `study-B.md`, medições e descrições nossas, escritas com palavras nossas e sem nomear site. Nenhum texto, print ou cópia das páginas entrou.
  - O topo de cada arquivo diz que é um cardápio, não um molde; que `Measures` são as faixas em que `devorb:design-system` escolhe os valores (com `typography.md`, `color-finish.md` e `space-radius.md` da Task 6) e que o contrato cita o id, nunca o número; que o padrão respeita `floor.md`; e que halo, rótulo em mono e número de seção só entram com a razão da página na linha `Floor:`.
  - Onde a referência faz o que o Floor proíbe, o padrão traz a versão que respeita o Floor: script sobre caixa-alta vira uma face só em linhas inteiras (`hero:full-photo-display-type`); gradiente em meio título e peso 900 viram uma cor e peso moderado (`hero:copy-and-form-card`); palavra-chave em chip vira tom por frase inteira (`section:two-tone-statement`); chave em caixa-alta espaçada vira caixa normal (`section:mono-spec-table`); ponto colorido só com estado real (`section:stat-cards-mono`).
  - `contract.md`: `First screen:` cita um id `hero:` e cada item de `Sections:` cita um id `section:` ou `custom`. `SKILL.md`: uma frase no §5 passo 3 aponta para os dois arquivos e uma no §6 diz que o contrato cita o id, nunca a medida. O arquivo foi de 7.128 para 7.321 bytes, cerca de 1.831 tokens, com teto de 2.500.
  - A ideia de um cardápio de onde o guia escolhe, com sorteio, vem da taste-skill, **só como ideia**: nenhum texto, lista ou padrão dela entrou. O sorteio com histórico fica para a Task 11; aqui a escolha vem do material e da direção.
  - O caso novo é `evals/visual-direction-receitas-landing`: a landing do Lote com a spec sem `## Direção visual`, três números do dono e a lista do que o produto faz, sem `DESIGN.md`. Graders: `patterns` (regex na spec: um `hero:` e três `section:`), `type-recipe`, `finish` e `mobile` (llm em `styles.css`) e `no-tells` (llm em `index.html`). O grader `mobile` julga a largura de 390px (regras de base mais as media queries que valem ali), e não só uma media query de até 640px, para não reprovar CSS que começa pelo celular ou só usa `clamp()`. Decisão do controlador: fica assim.
  - `tests/design-patterns.test.mjs` confere os 22 ids, os quatro rótulos de cada bloco e o `## Mobile recomposition`.

- 2026-11-18, Task 11 da Fase 2 de qualidade de design (`docs/plans/2026-11-18-design-quality-fase-2.md`), o guia e o sorteio com histórico:
  - `references/guide.md` é novo e vira o passo `## 0. Guide` do `SKILL.md`, com três linhas que apontam para ele. A ordem vem do Pilar D da spec da Fase 2 e do guia do Pilar 4 da spec da Fase 1: começar pelo que já se sabe; perguntar só o que falta, uma pergunta por mensagem, sempre com recomendação e o porquê em palavras simples; sem pessoa na conversa, decidir pela recomendação e registrar no contrato, sem navegador, quadro nem captura.
  - Referências com os olhos: de 4 a 6 entradas `kind: "reference"` de `ui-sources.json`, filtradas pelo estilo e desempatadas pelo setor, oferecidas pelo nome com a recomendação, e o pedido para abrir o navegador na mesma pergunta. Com o sim, `shoot.mjs --widths 1440,390` numa pasta temporária (instalar Playwright pede outro sim, como em `replicate.md`; sem ele, o Chrome do usuário ou o navegador embutido), um `board.html` local e nunca commitado, e a escolhida (ou o link do usuário) vira pacote com `capture.mjs`. Nenhuma serve: as páginas `byStyle` das galerias; Godly e Recent só para ver.
  - O nível de movimento é perguntado como recomendação pelo `dial.md` de `devorb:motion` (Task 10).
  - `scripts/draw.mjs` é novo: `patternIds`, `usedIds` e `draw` (Fisher-Yates nos não usados, depois os usados do mais antigo para o mais recente) e a CLI `--fits <ids> --count <n> [--specs <dir>]`, que lê as specs de `docs/devorb/specs` como histórico, sem arquivo de memória novo (decisão do planejador). Id fora dos arquivos de padrões sai com 1 e `UNKNOWN: <id>`. Testes em `tests/design-draw.test.mjs`.
  - O sorteio com histórico vem da taste-skill, **só como ideia**: nenhum texto, código ou lista dela entrou.
  - `SKILL.md` foi de 7.321 para 7.841 bytes.
  - O caso novo é `evals/visual-direction-guia-leigo`: a spec aprovada da landing da Movimenta Fisioterapia, sem `## Direção visual`, sem `DESIGN.md` e sem material, e a usuária diz que não entende nada de design. Graders: `one-question` (llm na última mensagem, peso 2), `offers-refs` (llm na última mensagem, peso 3) e `no-build` (regex no rastro: nenhum `Write` em `.html` ou `.css`).

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
| GREEN (`--arms devorb,none`, `devorb@66e054a`) | 0% (0,67), US$ 2,06 | 0% (0,56), US$ 1,29 |
| Reservado `visual-direction-copia-landing-clinica` (`devorb@d873e93`, sem navegador) | 0% (0,71), US$ 1,76 | 0% (0,74), US$ 0,63 |

- `fusion/results/2026-11-17-visual-direction-outside-baseline.md` e `fusion/results/2026-11-17-visual-direction-reserved.md`. No reservado, o DevOrb falhou em estrutura e escala de tipo: trocou seções sem fato do cliente (depoimentos, planos) por outras e largou o título bicolor. Daí a regra própria 2. Na mesma rodada, o reservado `visual-direction-painel-padaria` deu 50% (0,86) com o DevOrb contra 100% (1,00) sem plugin. A causa não foi conferida nesta tarefa. No GREEN de fora do sandbox (`fusion/results/2026-11-17-visual-direction-outside.md`), `accepted: true`, mas o caso é lacuna (nenhum braço passa): com a skill, tudo passou menos `structure`, porque o build cortou os 6 cards para 3 e as 4 pessoas para papéis. Daí a regra própria 3.

### Fase 2, Task 7 (cardápio de padrões)

RED em 2026-11-18, só a linha de base. Opus 5.5, 2 rodadas por caso, braço sem plugin. O resultado está em `fusion/results/2026-11-18-visual-direction-baseline.md`.

| Caso | Sem plugin | Custo |
|---|---|---|
| `visual-direction-receitas-landing` | 0% (0,25) | US$ 0,88 |
| `visual-direction-arquitetura-clean` | 0% (0,18) | US$ 0,96 |
| `visual-direction-clinica-serena` | 0% (0,75) | US$ 0,67 |

- A rodada custou US$ 2,48 no total. O caso novo falha sem o plugin, então o RED está confirmado. `patterns` falha em todo braço de base por construção e não conta como RED.
- GREEN (`--arms devorb,none`) fica com o controlador e ainda não rodou.

### Fase 2, Task 11 (guia e sorteio com histórico)

RED em 2026-11-18, só a linha de base, Opus 5.5, 2 rodadas, braço sem plugin. O resultado está em `fusion/results/2026-11-18-visual-direction-baseline.md`.

| Caso | Sem plugin | Custo |
|---|---|---|
| `visual-direction-guia-leigo` | 0% (0,00) | US$ 3,65 |

- O caso novo falha sem o plugin, então o RED está confirmado.
- GREEN (`--arms devorb,none`), o caso de cópia e o reservado ficam com o controlador e ainda não rodaram.

### Plano de regras de cor e referências (2026-11-19)

GREEN em 2026-11-19, `devorb@4a966e3`, Opus 5.5, 2 rodadas, `--arms devorb,none`. Arquivos: `fusion/results/2026-11-19-visual-direction-receitas.md`, `fusion/results/2026-11-19-visual-direction-arquitetura.md`, `fusion/results/2026-11-19-visual-direction-arquitetura-1rodada.md`. RED: `fusion/results/2026-11-18-visual-direction-receitas.md`.

| Caso | RED | GREEN devorb | GREEN none | Custo GREEN |
|---|---|---|---|---|
| `visual-direction-receitas-landing` | devorb 0,75 / none 0,25 (`color-pair` falha 2/2 nos dois), US$ 3,83 | 100% (1,00) | 0,30 | US$ 6,39 |
| `visual-direction-arquitetura-clean` | 0,36 (Fase 2) | 0,64, 0% de aprovação (não aprovado) | 0,18 | US$ 7,79 |

- Diagnóstico de `arquitetura-clean`, 1 rodada só devorb: 0,73, abaixo da barra de 2/3, US$ 1,89. Passam 1, 2, 3 e 5; falham `4-sonner-dependency` e `6-newsletter-toast`. A pasta `.arms` é recriada a cada rodada, então o detalhe da rodada dupla se perdeu.
- Custo total do plano: US$ 43,09 dos US$ 50 aprovados (RED 3,83 + 2,09 + 7,66 + RED2 1,56 + RED3 1,56; GREEN 6,39 + 7,79 + 2,06 + 4,25 + GREEN2 2,06 + GREEN3 1,95; diagnóstico 1,89).

### Aviso de resultado de ação (2026-11-20)

Plano `docs/plans/2026-11-20-aviso-de-acao-toast.md`, regra 6. Opus 5.5 (`claude-opus-5-5`), caso `visual-direction-arquitetura-clean`. Arquivos: `fusion/results/2026-11-20-visual-direction-arquitetura-1rodada.md` (diagnóstico), `fusion/results/2026-11-20-visual-direction-arquitetura-primeira-rodada.md` (primeira rodada inteira) e `fusion/results/2026-11-20-visual-direction-arquitetura.md` (segunda).

| Rodada | Braço | Resultado | Custo |
|---|---|---|---|
| Diagnóstico, 1 rodada inteira, trace guardado | `devorb@d7dc0a1` | 0,73, 0% de aprovação; falham 4 e 6 | US$ 6,20 |
| RED, caso cortado em 20 turnos, 3 rodadas | `devorb@d7dc0a1` | contrato sem especialista em 3 de 3 | US$ 3,28 |
| GREEN, caso cortado em 20 turnos, 3 rodadas | `devorb@31f827d` | contrato com Sonner em 3 de 3; erro 400 junto do campo em 3 de 3 | US$ 3,40 |
| GREEN 1, 3 rodadas inteiras | `devorb@31f827d` | 33% de aprovação (1 de 3), 0,73 | US$ 7,29 |
| GREEN 1, 3 rodadas inteiras | `none` | 0%, 0,18 | US$ 1,37 |

Primeira rodada inteira: `accepted: false`, abaixo da barra de 2/3.

O que a regra mudou na primeira rodada: o grader `4-sonner-dependency` passou em 2 de 3 rodadas inteiras (antes, 0 em 9 rodadas inteiras com detalhe por grader, mesmo texto do grader), e uma rodada passou nos seis graders, a primeira aprovação do caso. Somando o caso cortado e as rodadas inteiras, o contrato nomeou o Sonner em 5 de 6.

Rodada por rodada, `devorb@31f827d`:

| Rodada | 1 | 2 | 3 | 4 | 5 | 6 | O que aconteceu |
|---|---|---|---|---|---|---|---|
| 1 | passa | passa | passa | passa | passa | passa | `sonner` no `package.json`, `toast.success` depois da resposta, `<Toaster />` no `app/layout.tsx`, erro 400 junto do campo |
| 2 | passa | passa | falha | passa | passa | falha | build igual ao da rodada 1, mas o `fetch` está em `lib/newsletter.ts`, e a mensagem final não nomeia as fontes |
| 3 | passa | passa | falha | falha | passa | falha | o contrato voltou a dizer "o aviso da newsletter é inline"; a mensagem final não nomeia as fontes |

Três lacunas saíram dessa rodada, e o dono aprovou um ajuste para cada uma (2026-11-20, `devorb@2502b5c`):

- **O grader 6 reprovava um build correto.** Na rodada 2 o formulário chama `toast.success` do Sonner depois de `subscribe()` responder ok, e `subscribe()` faz o `POST /api/newsletter` em `lib/newsletter.ts`, separado para ser testado sem navegador, como a `devorb:tdd` pede. O grader lê só `components/newsletter-form.tsx` e a condição 2 exigia o `fetch` no formulário. O juiz guarda só os votos; o motivo é dedução a partir da condição e do arquivo. Ajuste: a condição 2 aceita o envio por uma função importada chamada com `await`. É um grader afrouxado: um grader `llm` lê um arquivo só, então o juiz confia na função sem vê-la, e deixa de pegar uma função que não faça o `POST` (rota errada, `GET` ou um stub). A condição 1 não mudou. Conferência antes de pagar, com o texto novo e os arquivos guardados: `fetch` no formulário passa, `await subscribe(email)` passa, aviso feito à mão com `role="status"` falha.
- **A mensagem final sem as fontes (grader 3)** em 2 de 3. A regra está na `visual-direction` §4, mas no fluxo inteiro a mensagem final sai muitos turnos depois, por caminhos diferentes: uma rodada terminou pelo `implementing`, a outra só pelo `verifying`. Não é efeito da regra 6: o grader já tinha falhado em `devorb@1126ff4`. Ajuste: a frase que manda nomear as fontes entrou no `implementing/SKILL.md` e no `verifying/SKILL.md` (ledgers dessas skills).
- **A regra 6 vazou em 1 de 6.** Ajuste: a oração "nunca é uma linha de status montada no formulário ou na página".

Segunda rodada inteira, com os três ajustes:

| Rodada | Braço | Resultado | Custo |
|---|---|---|---|
| GREEN 2, 3 rodadas inteiras | `devorb@2502b5c` | 67% de aprovação (2 de 3), 0,94 | US$ 15,03 |
| GREEN 2, 3 rodadas inteiras | `none` | 0%, 0,18 | US$ 1,11 |

| Rodada | 1 | 2 | 3 | 4 | 5 | 6 | O que aconteceu |
|---|---|---|---|---|---|---|---|
| 1 | passa | passa | falha | passa | passa | passa | estourou o tempo do caso (1200 s) no meio da onda de correção da revisão final; sem mensagem final, o grader 3 falha |
| 2 | passa | passa | passa | passa | passa | passa | 1177 s, a 23 s do limite |
| 3 | passa | passa | passa | passa | passa | passa | 659 s |

- A barra de 2/3 foi atingida: 67% (2 de 3 rodadas aprovadas).
- O grader 4 (`sonner` no `package.json`), cujo texto não mudou, passou em 3 de 3. Antes da regra, falhou nas 9 rodadas inteiras que têm detalhe por grader (`devorb@af8adfb` 3 rodadas, `devorb@35cdc27` 2, `devorb@1126ff4` 2, `devorb@4a966e3` 1, `devorb@d7dc0a1` 1). O GREEN de 2 rodadas de `devorb@4a966e3` não tem detalhe por grader.
- O grader 6 passou em 3 de 3, mas **com a condição 2 afrouxada**: os três builds enviam por uma função importada chamada com `await` (`lib/newsletter.ts`), então com o texto antigo os três falhariam. A comparação antes e depois do grader 6 cruza dois textos de grader e não mede igual com igual. Toda linha de resultado anterior a `2502b5c` usou o grader 6 antigo.
- O que o controlador leu nos três builds guardados: `sonner` no `package.json`; `toast.success` depois do `await` da função de envio; `<Toaster />` montado (`app/layout.tsx` em dois, `app/page.tsx` em um); e cada `lib/newsletter.ts` faz `POST /api/newsletter` e só devolve sucesso quando a resposta é ok. Essa última leitura é a única conferência do `POST` na segunda rodada: nenhum grader o vê.
- Erro de campo: em 2 dos 3 builds o 400 "E-mail inválido." aparece só junto do campo (`aria-describedby`). Na rodada 3, aprovada, o formulário chama `toast.error(result.message)` em toda falha e também marca o erro do campo quando o motivo é `invalid`: o e-mail inválido aparece junto do campo **e** num toast. É o antiobjetivo da spec ("toast empilhado em cima de uma mensagem que já está no formulário"), em 1 dos 3 builds, e nenhum grader o pega.
- **A `compare.mjs` imprimiu `accepted: false`**, com o motivo "rodadas com erro da ferramenta": a rodada que estourou os 1200 s conta como erro da ferramenta e bloqueia o `accepted`. Pela regra da casa (GREEN é `accepted: true`), **este GREEN não está aprovado**, embora a barra de aprovação tenha sido atingida. A decisão é do dono.
- O limite de tempo virou a lacuna do caso: o fluxo inteiro do `implementing` (subagente por task, revisão do branch, onda de correção) leva de 11 a 20 minutos aqui, e duas das três rodadas ficaram em cima dos 1200 s. As rodadas correram 3 de cada vez (`--concurrency 3`) na mesma credencial, com outra sessão rodando evals; isso pode ter alongado o tempo. A rodada de diagnóstico, sozinha, levou 973 s.
- O grader 3 passou nas duas rodadas que chegaram à mensagem final. São duas rodadas: não dá para dizer que a frase nova foi a causa.

Custo total: US$ 37,67 dos US$ 50 do teto da frente (6,20 + 3,28 + 3,40 + 8,66 + 16,13), contando o custo do juiz. As duas linhas da segunda rodada somam 16,14 porque cada uma foi arredondada; o valor antes de arredondar é 16,13. A linha "Custo total desta execução" que a `compare.mjs` imprime (US$ 8,63 e US$ 16,10) deixa o custo do juiz de fora. O saldo não paga outra rodada cheia de 3.

**Decisão do dono (2026-11-20): o item 1 fica aceito como está.** O grader 6 continua com a condição 2 afrouxada, e a segunda rodada vale com `accepted: false` (2 de 3 aprovadas; a que não passou estourou os 1200 s do caso). Isto é uma aceitação do dono, não um GREEN pela regra da casa: a `compare.mjs` não imprimiu `accepted: true` em nenhuma rodada deste plano. No mesmo dia o dono confirmou que a frase das fontes fica também no `verifying`. A lista abaixo continua em aberto.

Em aberto:

- A regra 6 se lê de dois jeitos para um erro que o servidor devolve sobre um campo: "falhou no servidor" (toast) e "erro de validação de um campo" (campo). Visto na execução 3 da segunda rodada inteira (acima). A hipótese da spec ("a falha que vem do servidor depois do envio" é resultado da ação) diz uma coisa e o Review Focus do plano diz outra. Uma redação que resolveria: o erro do campo fica junto do campo também quando o servidor o devolve. Não aplicado: qualquer mudança na regra pede nova rodada paga.
- A regra 6 diz "usa o especialista da lista", e o bullet seguinte de `sources.md` diz que o que já está instalado e faz o trabalho fica. Com outra biblioteca de toast já no `package.json`, os dois podem ser lidos um contra o outro. Nenhuma rodada exercitou isso.
- A frase que manda nomear as fontes mora em duas skills (`implementing/SKILL.md` e `verifying/SKILL.md`), ao lado da original em `visual-direction/SKILL.md` §4: três lugares que podem divergir. Ela também supõe que a spec tem uma linha `Sources:`; um ajuste de interface sem contrato não tem. A evidência é 2 de 2 rodadas, e o grader 3 já tinha passado sem ela (1 de 1 em `devorb@d7dc0a1`, 1 de 3 em `devorb@31f827d`).
- Grader 6, condição 2, afrouxada (dono aprovou, 2026-11-20): nenhum grader vê mais o `POST`. Se ficar assim, falta uma conferência que veja a requisição fora do formulário.
- A conferência do juiz do grader 6 novo antes de pagar (passa, passa, falha) foi feita com três subagentes juízes avulsos na sessão, não com o juiz da harness, e a saída não está guardada.
- Nenhuma rodada `--reserved` correu, e nenhum caso `implementing-*` ou `verifying-*` correu, embora três skills tenham mudado. `skills/writing-skills/references/devorb.md` pede os dois.
- A segunda rodada custou o dobro da primeira no braço `devorb`, e duas das três rodadas ficaram nos 1200 s do limite: as três passaram pelo fluxo inteiro do `implementing`, enquanto as da primeira rodada tomaram caminhos mais curtos. Não se investigou se as frases novas têm parte nisso.
- O laço com teto (o caso real parado em 20 turnos) é um script fora do repositório; os resultados dele existem só neste ledger.

Pendências menores das revisões (2026-11-20). O dono pediu para resolvê-las e deixar o branch pronto. As três que pediam mexer em texto de skill foram fechadas sem mudança, por decisão do agente, com o motivo de cada uma; o dono pode mandar editar:

- "the list's specialist" sem antecedente dentro da frase da regra 6: fica como está. `sources.md` já chama `ui-sources.json` de "the list" no bullet seguinte ("the list's specialist over a hand-built version", "When the list has nothing for the job"), e o revisor da task recomendou não mexer.
- Confirmação de ação destrutiva não citada na regra 6: não entra. Nenhuma rodada mostrou um agente tratando "confirma apagar?" como aviso de resultado, e a `writing-skills` só aceita texto com uma falha gravada por trás.
- No `implementing/SKILL.md`, a frase das fontes vem depois de "three lists, each exhaustive" e não é uma lista: fica como está. O revisor julgou aceitável; mover a frase é editar um `SKILL.md` depois da rodada paga, e só uma rodada cheia mede a mensagem final.
- Corrigidas nos registros: os valores sem o custo do juiz que restavam na spec e no plano (6,19, 8,63, 9,47 e 21,51 viraram 6,20, 8,66, 9,48 e 21,54), a frase "rodada 2, rodada 3", e o nome do relatório da primeira rodada inteira, que passou de `-rodada-1.md` para `-primeira-rodada.md` para não se confundir com o `-1rodada.md` do diagnóstico.

Não conferido: os outros casos da `visual-direction`, do `implementing` e do `verifying` e o reservado `visual-direction-guia-restaurante` não rodaram com estas mudanças; nenhuma rodada mede a regra 6 numa tela de operação.

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
- `ai-website-cloner-template@sem-pin:fases do clone (capturar, mapear, construir por seção, comparar)` | adotado | só a ideia das fases, MIT; sem texto
- `taste-skill@sem-pin:scripts de print e consistência (commit visto f6b76575f949707b4e3c37cd86cb44b0b98643e8, caminho fora dos rastreados)` | adotado | só a ideia de fotografar o build e conferir contra a referência; scripts próprios
- `av-design-system@sem-pin:mirror.js` | adotado | só a ideia de neutralizar revelações, do dono, origem e licença não confirmadas; sem texto nem código
- `dembrandt@sem-pin:pacote npm 0.39.2, saída de --help` | adotado | comando opcional de tokens em página pública, MIT
- registro em fusion/sources.json: decisão do dono
- `taste-skill@sem-pin:ideia do cardápio de padrões com sorteio (citada na spec da Fase 2)` | adotado (só ideia) | um cardápio de padrões de onde o guia escolhe; texto, lista e padrões próprios, a partir dos estudos A e B; o sorteio com histórico fica para a Task 11
- `docs/specs/2026-11-18-referencias/study-A.md` e `study-B.md` (nossos) | adotado | os 10 padrões de abertura, os 12 de seção, as faixas de `Measures` e a recomposição no celular
- `docs/specs/2026-11-18-referencias/urls.txt` (lista do dono, 23 sites, termos não conferidos por decisão do dono, Suposição 1) | adotado | 22 entradas `reference` na biblioteca (a Mobbin segue como `screens`), só URL, etiquetas e descrição nossa; Melius e Audienceful etiquetados pelos prints do `refs-check`
- `taste-skill@sem-pin:ideia do sorteio com histórico (citada na spec da Fase 2, Call 5)` | adotado (só ideia) | o guia sorteia os padrões que cabem e deixa por último os usados nas specs recentes; `draw.mjs` e o texto do guia são próprios
- Pilar D da spec da Fase 2 e Pilar 4 da spec da Fase 1 (nossos) | adotado | a ordem do guia: o que já se sabe, uma pergunta por vez com recomendação, referências com os olhos, o pacote, o nível de movimento
