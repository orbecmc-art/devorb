# Ledger: `diagram`

Skill manual de nível leve, da Task D6 do plano de design, no setor de design (`"sector": "design"`), chamada só por `/devorb:diagram`. Espinha: `diagram-design` (MIT). Outra fonte: gstack `diagram` (MIT). As duas têm `textReuse: false`: só ideias, escritas com palavras próprias e creditadas aqui. Nenhum texto, lista ou abertura delas entrou, e `LICENSES/NOTICE.md` não muda.

Pinos lidos, iguais aos `lastAbsorbed` de `fusion/sources.json`, buscados rasos (`--depth 1 --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos acompanhados, sem rodar nada:

- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4`: `skills/diagram-design/SKILL.md`, `references/primitives-core.md`, `references/layout-budget.md`, `references/animation.md`.
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4`: `diagram/SKILL.md.tmpl`.

As referências de tipo da `diagram-design` (`type-*.md`), `semantic-patterns.md`, `style-guide.md`, `output-spec.md` e os templates em `assets/` não estão em `fusion/sources.json` e ficaram fechados. `references/types.md` e `references/template.svg` foram escritos do zero, a partir do índice de tipos e dos limites por tipo que estão nos arquivos acompanhados.

A skill foi escrita sem abrir `evals/diagram-*`, `evals-reserved/` nem `fusion/results/`. Os casos só são conhecidos pelo texto da Task D6 no plano.

`SKILL.md` tem cerca de 5,9 mil bytes (cerca de 1,5 mil tokens, teto 2.500). Por ser manual, não custa nada no custo fixo do setor.

## Origem por parte

| Parte | Origem |
|---|---|
| Frontmatter: `disable-model-invocation: true`, `description` de uma linha, `argument-hint` | DevOrb, pela regra das skills manuais (`writing-skills/references/SKILL-MECHANICS.md`) e pela interface da Task D6 |
| Abertura: um diagrama que se entende mais rápido que a prosa, ou nenhum; seis passos em ordem, cada um pode encerrar | `diagram-design` (§1 e §2, a melhor jogada costuma ser apagar; perguntar se o leitor aprende mais que num parágrafo), só ideia. A ordem dos passos é a espinha da Task D6 |
| 1. Desenhar ou não: itens com os mesmos atributos viram tabela; antes e depois só de valores vira tabela; uma caixa ou dois passos viram frase; entregar a tabela, dizer por quê e parar, sem criar arquivo | `diagram-design` (§2 "Don't use for", §3 regra da tabela de três colunas), só ideias, por decisão da Task D6. Os exemplos (planos, recursos por faixa) e o "parar sem criar arquivo" são do DevOrb |
| 2. Mermaid ou SVG pelo lugar onde o diagrama vive; caminho `.md` decide Mermaid, `.svg` ou `.html` decide SVG | Conflito resolvido (ver abaixo), por decisão da Task D6. Mermaid versionável e renderizado no GitHub vem do gstack (`.mmd` como fonte única), só ideia |
| Nunca copiar o layout automático do Mermaid num SVG publicado | `diagram-design` (§4, antipadrão de reproduzir o layout do Mermaid), só ideia |
| 3. Tipo pela pergunta do leitor; dois tipos servem, fica o do eixo dominante; tipo fora da lista é fora de escopo | `diagram-design` (§3, regras práticas), só ideia |
| Anunciar o plano numa linha (tipo, formato, caminho, cortes) e não esperar resposta, salvo assunto incerto; suposições junto do resultado | `diagram-design` (§3 "Confirm before drawing"), só ideia. Não esperar é ajuste do DevOrb: a skill é manual e o usuário já disse o que quer |
| 4. Orçamento: até 9 nós e 12 conectores; o limite do tipo só aperta; um ou dois elementos de destaque | `diagram-design` (§7 e `layout-budget.md`), por decisão da Task D6. O limite de 9, não 15, é conflito resolvido |
| Acima do orçamento: fundir, apagar conector implícito, depois visão geral mais um detalhe; nunca encolher o texto | `diagram-design` (§1, §7, checklist "Remove test"), só ideias. "Nunca encolher o texto" é do DevOrb |
| Teste de remoção antes de terminar | `diagram-design` (§9, "Remove test"), só ideia, numa frase só |
| Cores dos tokens de `DESIGN.md` quando existe; idioma da página no título, na descrição e nos rótulos | DevOrb: fronteira da spec (`design-system` escolhe valores) e Review Focus 1 do plano (português) |
| 5. Conectores: ortogonais, perpendiculares à caixa longe do canto, um ponto por conector, sem traço compartilhado, sem passar atrás de caixa, conectores antes das caixas | `diagram-design` (§6 e `primitives-core.md`, regras obrigatórias 1 a 6), só ideias, por decisão da Task D6 |
| Rótulo com máscara opaca e folga de 6 a 10 px, ao lado do trecho vertical, até 14 caracteres | `diagram-design` (`primitives-core.md`, regra 2 e "Arrow labels"), por decisão da Task D6 |
| No Mermaid, texto curto no nó e detalhe no rótulo da aresta | gstack (`diagram`, Step 1), só ideia |
| 6. Acessibilidade: `role="img"`, `aria-labelledby`, `<title>` primeiro, até 60 caracteres, `<desc>` de uma frase sobre o sentido, ids com o slug | `diagram-design` (§12, contrato do SVG acessível, e `primitives-core.md`), por decisão da Task D6 |
| Sentido nunca só na cor | `diagram-design` (`animation.md`, estado nunca só por cor), só ideia, estendida ao diagrama estático |
| Tudo dentro do `viewBox` | `diagram-design` (§9, conteúdo dentro do viewBox), só ideia |
| `min-width` igual ao viewBox num contêiner com rolagem própria, com o trecho de HTML | `diagram-design` (§9, item em negrito), por decisão da Task D6. O trecho é do DevOrb |
| `accTitle:` e `accDescr:` no Mermaid | DevOrb: sintaxe do próprio Mermaid, para o diagrama em Markdown não perder o que o SVG tem |
| Animação só se pedida; quadro estático completo sem script; `prefers-reduced-motion: reduce` mostra o quadro completo sem reprodução | `diagram-design` (`animation.md`, contrato estático primeiro), só ideia, por decisão da Task D6 |
| Fecho: conferir que o arquivo é XML válido (`xmllint` quando houver) e tem `role="img"` e `<title`; responder com caminho, tipo, cortes e suposições | DevOrb. A conferência substitui os scripts Python da fonte, que ficaram fora |
| `Connects to` | DevOrb: interface da Task D6 e fronteiras da spec (`design-system` dá os tokens, `ui-review` confere a página onde o SVG entra) |
| `references/types.md`: doze tipos com a pergunta do leitor, a palavra do Mermaid e o limite próprio | Tipos e limites de sequência (5 participantes, um bloco), raia (5), quadrante (12), entidades (8), árvore (profundidade 4), camadas (6) e cronograma (12 tarefas): `diagram-design` (§3 e `layout-budget.md`). Limites de fluxograma (3 decisões), estados (8), arquitetura (8 partes, 2 fronteiras) e linha do tempo (8 eventos): meus, dentro do teto de 9. Palavras do Mermaid: sintaxe do Mermaid |
| Escolha entre vizinhos (fluxograma ou estados, fluxograma ou sequência, arquitetura ou fluxo de dados, raia, árvore ou camadas, quadrante ou tabela) e notas por tipo | DevOrb, escritas sem as referências de tipo da fonte, que ficaram fechadas |
| Fora de escopo: gráficos de quantidade, mapas mentais, Venn, jornada, blueprint, Wardley, importação | Task D6 ("Fora") |
| `references/connectors.md`: as cinco regras de traçado, o traço com sentido, os rótulos, a ordem de desenho e a marcação | `diagram-design` (`primitives-core.md`: regras 1 a 6, papéis da seta, rótulo com máscara, largura por caractere de 0,6 em), só ideias. Regra 6 (máscara antes de nó) virou a seção de ordem de desenho. Exemplo de marcação e coordenadas: meus |
| `references/template.svg`: duas caixas, um conector ortogonal com cotovelo e rótulo mascarado ao lado do trecho vertical, `role="img"`, `<title>` e `<desc>` com slug | DevOrb, escrito do zero, sem abrir os templates da fonte. Validado com `xmllint --noout` e conferência por regex; geometria conferida à mão (máscara a 8 px do traço e fora das caixas) |

## Conflitos resolvidos

- **Mermaid:** a `diagram-design` recusa reproduzir o Mermaid e só importa dele; o gstack parte do Mermaid como fonte única e renderiza com binário próprio. Pela Task D6, documentação viva no Git usa Mermaid num bloco cercado, que o GitHub renderiza e o diff mostra como texto; peça publicada usa SVG escrito à mão. O caminho dado pelo usuário decide quando existe.
- **Limite de nós:** o gstack aceita de 5 a 15 nós; a `diagram-design` para em 9. Pela Task D6, vale 9.
- **Saída:** a `diagram-design` entrega sempre um HTML com o SVG dentro, em três variantes; o gstack entrega o trio `.mmd`, `.excalidraw`, SVG e PNG. Vale um arquivo só, no formato que o lugar pede, porque o caso realista pede `docs/login-flow.svg` e a exportação está fora.
- **Confirmar antes de desenhar:** a `diagram-design` para e espera quando o usuário está presente. Numa skill manual o pedido já é a decisão: a skill anuncia o plano numa linha e segue, e só espera se o assunto for incerto. É ajuste de encaixe, não regra própria.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. Nenhuma regra própria entrou: o que não vem das fontes é a resolução de conflito pedida pela Task D6 ou ajuste de encaixe no DevOrb (tokens de `DESIGN.md`, idioma da página, `accTitle` e `accDescr` no Mermaid, a conferência final com `xmllint`), registrado acima.

## Fora

- **`diagram-design`:** os 33 tipos além dos doze, os padrões semânticos, o portão de guia de estilo na primeira vez e os perfis em `~/.diagram-design/`, o onboarding por URL, os importadores de draw.io, Mermaid e Excalidraw com o registro de fidelidade, os quatro controles de saída (formato, tamanho, detalhe, público), a exportação para PNG e SVG, os scripts Python (`verify-geometry.py`, `self_check.py`, `verify-motion.py`, extratores), a grade de 4 px e a tabela de medidas, as famílias tipográficas e a lista de antipadrões estéticos (sombra, brilho, fonte monoespaçada, raio grande), os cartões de resumo, as variantes escura, editorial, esboçada e de terminal, os ícones, as anotações, a legenda em faixa e o controlador de animação com os modos, os tempos e o teclado. Regra estética sustentada só por esta fonte, sem cenário, fica fora pela regra do plano.
- **gstack (`diagram/SKILL.md.tmpl`):** o preâmbulo, o pacote de render e o servidor local, o navegador Aside e o próprio, o `.excalidraw` editável e o PNG, o transporte em base64, a pasta `./diagrams/`, a ida e volta pelo excalidraw.com e o aviso de PDF.

## Resultados

A preencher depois de R6.

## Decisões por commit de fonte

- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/SKILL.md` | adotado | não desenhar quando tabela ou frase resolve, tipo pela pergunta com eixo dominante, anunciar o plano, orçamento de 9 nós e 12 conectores, um ou dois destaques, dividir em visão geral e detalhe, teste de remoção, regras de conector em resumo, contrato do SVG acessível, `min-width` com rolagem própria, nunca copiar o layout do Mermaid
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/SKILL.md` | recusado | portão de guia de estilo, perfis, padrões semânticos, 45 tipos, antipadrões estéticos, sistema de design, cartões, variantes, importação, controles de saída, saída em HTML, exportação, scripts
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/references/primitives-core.md` | adotado | as seis regras de conector, papéis do traço, rótulo com máscara e folga, largura por caractere, ordem de desenho, contrato acessível na forma longa
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/references/primitives-core.md` | recusado | fundo pontilhado, etiqueta de tipo na caixa, legenda em faixa, marcadores com cores da fonte, portão de geometria por script
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/references/layout-budget.md` | adotado | limites por tipo que só apertam o geral (sequência, raia, quadrante, entidades, árvore, camadas, cronograma)
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/references/layout-budget.md` | recusado | grade de 4 px e medidas permitidas, limites dos tipos fora de escopo, layout de página, cartões de resumo
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/references/animation.md` | adotado | animação só quando pedida, quadro estático completo sem script, movimento reduzido mostra o quadro completo, estado nunca só por cor
- `diagram-design@6a7f19fcc132b39b126bea90167679b46b14bcc4:skills/diagram-design/references/animation.md` | recusado | modos, relógio, primitivas animadas, controles e teclado, controlador copiado do template, captura e verificação por script
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:diagram/SKILL.md.tmpl` | adotado | Mermaid como fonte versionável, texto curto no nó e detalhe na aresta, dividir quando passa do legível
- `gstack@1b96d9f8538ae0f3b66dd52b75793a3767e514d4:diagram/SKILL.md.tmpl` | recusado | limite de 15 nós, preâmbulo, render offline com binário e navegador, trio de arquivos, `.excalidraw`, PNG, base64, pasta de saída, aviso de PDF

## Revisões

- 2026-11-13, conferência frase a frase contra cada fonte (sequências de cinco palavras iguais), depois da primeira escrita. Reescritas por estarem perto demais: em `SKILL.md`, "state the plan in one line", "nodes that always travel together", "each get their own point", "sits on an opaque mask", "put detail in edge labels" (gstack), as frases do contrato acessível sobre `role="img"`, `<title>` como primeiro filho e `<desc>` de uma frase, e a do movimento reduzido; em `connectors.md`, "only when both ends share", "the edge it touches", a frase do segmento horizontal que começa na borda de cima ou de baixo, a fórmula de pontos escrita como na fonte, "on top of each other" e "runs through open". Sobram só atributos de marcação SVG (`markerWidth`, `markerHeight`, `refX`, `text-anchor`), que são sintaxe.
