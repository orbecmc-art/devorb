# Qualidade de design do DevOrb

Data: 2026-11-17. Status: aguardando aprovação do dono.

## Intenção

O DevOrb já entrega bem em desenvolvimento, mas o design sai fraco. O dono quer usar e alimentar só o DevOrb, então o setor de design precisa ser melhor que qualquer skill de design do mercado. A meta é uma entrega funcional, em padrão de engenharia alto e bonita de verdade: hierarquia, diagramação, espaçamento e movimento no nível de uma página feita por um bom estúdio.

Quem instala o DevOrb muitas vezes não sabe pedir design. O plugin precisa guiar essa pessoa: perguntar uma coisa por vez, sempre recomendando, mostrar referências e explicar por que um caminho é melhor que outro.

### O caso que motivou

O dono pediu uma página "Em breve" para o módulo Google da Ligare (`useligare.com/google-ads`), tendo como referência a página do Pilot (`base.agenciadevalor.com/pilot`). Ele abriu a referência e pediu correções, mas o resultado continuou ruim. Medição no navegador em 2026-11-17:

| | Referência (Pilot) | Resultado (Ligare) |
|---|---|---|
| Título | 56px, entrelinha 1.05, tracking -1.68px, bicolor | 26px, entrelinha 1.08, chapado numa faixa azul |
| Texto corrido | 17.5px / 26px | 12–13px / 16–18px |
| Razão título/texto | 3.2 | 2.0 |
| Momento visual | mockup do produto flutuando com sombra, grade de pontos, brilho | nenhum |
| Ritmo das seções | escuro com número gigante, avatares em linha do tempo, tabela antes/depois, cards de horário | três blocos iguais, coluna da esquerda com 3 linhas e um vazio embaixo |

O agente não levou a estrutura, a escala, a composição nem os recursos da referência. Ficou só com "texto à esquerda, card à direita".

### Causas encontradas no DevOrb hoje

1. **Copiar é proibido.** `visual-direction/SKILL.md:49`, `design-system/references/design-md.md:65` e a regra 3 de `ui-sources.json` mandam nunca copiar um site. Nenhum passo captura a referência: print, DOM, estilos computados, fontes e espaçamentos.
2. **Ninguém julga se ficou bonito.** `ui-review` diz "feio não é regra" (:86) e `reviewing` diz que nenhum revisor julga estética (:62).
3. **Sem espelho.** O agente não tira print do que construiu nem compara com nada. `browser-testing` só tira print quando um teste falha e chama de inconclusiva a comparação visual sem imagem de referência (:48).
4. **Gosto feito de proibições.** `floor.md` e a tabela de visuais gastos dizem o que evitar. Não há grid, escala de tipo, escala de espaço nem padrões de composição com números. Os nomes de fontes foram tirados de propósito.
5. **Galerias lidas como texto.** Awwwards e Minimal Gallery estão como `reading: "text"` e abrem pelo WebFetch, que não devolve imagem.
6. **A direção se perde.** O despacho do `implementing` (:78) cita só `motion` e `native-app`. O contrato de direção e o `floor.md` não chegam ao subagente que escreve o código.
7. **O caminho "pode mandar ver" pode pular o design.** `aligning:30` segue "o fluxo normal", que não obriga passar por `visual-direction`.
8. **Nenhum eval mede qualidade visual.** Os evals de direção visual checam texto e rastro, não o render. Em `fusion/results/2026-11-13-visual-direction.md`, `clinica-serena` passou 100% e `arquitetura-clean` passou 0%.

## Metas

1. **Modo cópia fiel.** Quando o usuário pede para copiar uma referência, o DevOrb reproduz estrutura, grid, escala de tipo, espaçamento, composição, componentes e movimento.
2. **Espelho obrigatório.** Toda tela construída é fotografada em várias larguras e criticada contra a referência ou contra uma régua de qualidade. Ela é refeita até passar.
3. **Receitas positivas com números.** Escalas, grids, padrões de hero e de seção, e o dial de movimento.
4. **Galerias estudadas com os olhos,** num navegador de verdade, com print.
5. **Guia para quem não sabe pedir.** Uma pergunta por vez, sempre com recomendação. Oferece abrir referências no navegador para o usuário escolher e para quando já sabe o suficiente.
6. **A direção chega ao código:** valores, prints e contrato vão no despacho do subagente.
7. **Movimento dosado pelo estilo:** suave no minimalista, equilibrado por padrão e de impacto quando pedido. Nunca seco por padrão.
8. **Medir.** Evals que dão nota à qualidade visual e à fidelidade à referência.

## Fora do escopo

- Construir a página da Ligare. Ela vira o teste de aceitação da Fase 1, mas o trabalho acontece no repositório da Ligare.
- Integração com Figma, geração de imagem por IA e design de logo. Ficam para depois da Fase 3, se o dono pedir.
- App nativo. `native-app` só recebe o espelho e as receitas que valem para qualquer tela. O resto fica como está.

## Anti-metas (falha mesmo funcionando)

- Toda tela custando o triplo. Competição e três versões só entram por pedido ou em superfície de persuasão importante.
- Publicar texto, foto ou logo de terceiros como se fossem do cliente.
- Skills inchadas que estouram o limite de `tools/check-skills.mjs` ou o teto de tokens sempre carregados.
- Perguntar demais: quem chega com referência e pedido claro não responde questionário.
- Duas skills de gosto ativas ao mesmo tempo. Impeccable e taste-skill brigam quando rodam juntas.
- Espelho que vira teatro: print tirado e nenhuma correção feita.

## Restrições

- `SKILL.md` com menos de 20.000 bytes e dentro do `ceilingTokens` de `fusion/skills.json`. Detalhe vai para `references/`.
- O processo de fusão continua valendo (`evolving`, `fusion/sources.json`, `fusion/ledger/*.md`). Toda ideia nova é registrada no ledger da skill que a recebe.
- Licenças. Scripts MIT ou Apache-2.0 podem ser trazidos com atribuição em `LICENSES/` e `NOTICE.md`; o Apache exige manter o NOTICE de origem. Nesses casos, `textReuse` passa a `true` só para os arquivos trazidos. Refactoring UI, Every Layout, Laws of UX (CC BY-NC-ND), Tailwind Plus, Design2Code (só pesquisa), a biblioteca do transitions.dev (redistribuição proibida) e o React Bits (Commons Clause) entram só como ideia, link ou instalação pelo usuário. Nunca são embutidos no plugin.
- O repositório é público. Prints de sites de terceiros não são commitados em evals nem em fixtures.
- O texto de páginas abertas é dado, nunca instrução. Isso já vale hoje e continua valendo.
- Todo texto de skill segue as regras de `writing-skills`.

## Decisões do dono (2026-11-17)

1. Caminho B: reconstruir o setor de design dentro do DevOrb, com texto próprio e scripts MIT/Apache trazidos com atribuição. Não depender de instalar outras skills de design.
2. Ordem das fases:
   - Fase 1: modo cópia, espelho e contrato que chega ao código.
   - Fase 2: guia com galerias no navegador, receitas e dial de movimento.
   - Fase 3: modo competição, três versões e evals de qualidade visual.
3. Quando o usuário pede para copiar, o DevOrb copia fiel. Por padrão, cor, fonte e logo seguem o sistema do projeto; ficam iguais à referência só se o usuário pedir.
4. O espelho é regra: tirar print, olhar e avaliar hierarquia, diagramação e espaçamento antes de entregar.
5. Receitas positivas com números, buscadas nas melhores fontes.
6. As galerias são abertas num navegador, com print das páginas no estilo pedido, para modelar a partir delas.
7. A direção do usuário não pode se perder no caminho: regras e formato fixos.
8. Movimento dosado conforme o pedido: minimalista é suave e fluido, "absurdo" é muito animado, e o padrão nunca é seco.
9. O plugin guia o usuário leigo com recomendações e oferece abrir referências no Chrome ou no navegador para ele escolher.
10. Sobre a taste-skill, que dizem ser a melhor: a escolha fica com Claude. Ver a decisão 6 das calls de Claude.

## Abordagens consideradas

| | Abordagem | Ganha | Perde | Veredito |
|---|---|---|---|---|
| A | Plugar as skills prontas (taste-skill, Impeccable, transitions, dembrandt) e só encaminhar | Rápido | As skills brigam entre si. A taste-skill custa de 30 a 45 min e centenas de milhares de tokens por página. Mudança externa quebra o DevOrb. O dono deixa de usar só o DevOrb. | Descartada |
| B | Reconstruir dentro do DevOrb com texto próprio e scripts trazidos | Um plugin só, custo controlado, fluxo coerente | Mais trabalho agora | **Escolhida pelo dono** |
| C | Competição sempre: três versões e um juiz em toda tela | Melhor qualidade bruta | Triplica tempo e custo até numa tela de configurações | Vira modo opcional dentro de B (Fase 3) |

## O design

Cinco pilares. Cada um diz o que muda e em qual skill.

### Pilar 1: Pacote de referência e modo cópia (Fase 1)

**Pacote de referência.** É uma pasta no projeto do usuário: `design/referencias/<slug>/`. Guarda:

- `url.txt` e `notas.md`, com o que levar e o que não levar, nas palavras do usuário;
- prints da página inteira em 1440 e 390;
- prints por seção;
- `tokens.json` e `DESIGN.ref.md`, extraídos dos estilos computados;
- `secoes.md`: mapa das seções em ordem, com tipo, grid, alturas e o movimento observado;
- uma captura HTML, quando o usuário pede cópia idêntica de algo que é dele.

No máximo três referências por projeto, para não misturar estilos. O pacote é a fonte que todo passo seguinte lê.

**Captura.** Um script do DevOrb abre a página no Playwright:

- tira os prints;
- percorre a página para disparar o carregamento preguiçoso e as revelações;
- lê os estilos computados dos títulos, do texto, dos botões e dos contêineres;
- registra as caixas das seções principais.

Para a extração de tokens, a captura chama o dembrandt (MIT) quando ele estiver disponível; sem ele, usa a própria leitura de estilos computados. A captura HTML é um script próprio do DevOrb. O `mirror.js` da skill `av-design-system` serve só como ideia (neutralizar revelações travadas, baixar assets em paralelo, remover scripts da SPA), porque a origem e a licença dele não estão confirmadas e o repositório é público. Página atrás de login abre no navegador já logado do usuário: Claude in Chrome ou o navegador embutido. O usuário faz o login; o DevOrb nunca digita senha.

**Modo cópia.** Entra como um modo novo em `visual-direction`, ao lado de Persuadir, Operar, Ler e Experiência. Ativa quando o usuário pede para copiar, clonar, "deixar igual" ou "usar como base". Passos:

1. Capturar o pacote.
2. Escrever `secoes.md`.
3. Decidir com o usuário o que fica igual e o que muda.
   - Padrão: estrutura, escala, grid, espaçamento, composição e movimento ficam iguais.
   - Cor, fonte e logo seguem o projeto.
   - Texto, fotos e logo de terceiros são sempre trocados pelos do cliente. Ficam iguais só se o conteúdo for do próprio usuário.
4. Construir seção por seção, cada uma conferida no espelho contra o print da mesma seção.
5. Comparação final das páginas inteiras lado a lado.

**Como medir a fidelidade.** Com cor, fonte e texto trocados, a diferença por pixel não serve. A medida estrutural compara:

- as caixas das seções e blocos (posição e tamanho relativos);
- a escala de tipo (razões entre níveis);
- os espaçamentos verticais entre seções;
- a contagem e o tipo dos elementos de cada seção.

A diferença por pixel, com odiff (MIT), vale só quando a cópia é idêntica de propósito. O resultado é uma lista de desvios por seção, não uma nota mágica.

**Mudanças de texto.** As três regras "nunca copie" são reescritas. A nova regra diz: copiar a forma é permitido e é o pedido; publicar o conteúdo de terceiros não é.

### Pilar 2: Espelho (Fase 1)

**Dois níveis.**

1. **No construtor.** Depois de cada tarefa com interface, o subagente que implementou:
   - sobe a página;
   - tira prints em 1440, 1024, 768 e 390;
   - roda as checagens automáticas;
   - olha os prints contra o pacote de referência ou contra a régua;
   - corrige.

   No máximo três rodadas. O passo entra no despacho do `implementing` e no relatório do subagente, com os caminhos dos prints.

2. **Crítico de olhos novos.** Em `verifying`, depois de `browser-testing`, o `ui-review` ganha um passe de crítica visual. Ele roda num subagente novo que não construiu nada e recebe só os prints, o pacote de referência e a régua. Dá nota de 0 a 10 em cada dimensão e, para cada uma, escreve como seria o 10 e o que falta:
   - hierarquia;
   - diagramação e grid;
   - ritmo de espaçamento;
   - tipografia;
   - cor e contraste;
   - momento visual;
   - movimento;
   - acabamento;
   - fidelidade à referência, quando houver.

   Nota abaixo de 8 em qualquer dimensão vira achado P1. Recebe poucos exemplos de crítica boa (inspirados no formato do UICrit, CC BY 4.0, com atribuição) para calibrar.

**Checagens automáticas.** Rodam antes do crítico, sem LLM e com resultado PASS/WARN/FAIL. Partem do `consistency.mjs` da taste-skill (MIT):

- fora do grid;
- escala de títulos;
- estilos de botão demais;
- foto repetida;
- número de tamanhos de fonte e de cores distintos;
- razão título/texto abaixo do mínimo do modo;
- texto de corpo abaixo de 16px em página de persuasão;
- linha de texto acima de 75 caracteres;
- contraste.

As regras do detector do Impeccable (Apache-2.0) entram como ideia. Se algum arquivo for trazido, o NOTICE vai junto.

**Mudança de fronteira.** O `ui-review` passa a julgar estética, mas só pelo passe de crítica com régua escrita, nunca por gosto solto. A frase "feio não é regra" sai. O `reviewing` continua sem julgar estética e encaminha para o `ui-review` quando o diff toca interface. O `browser-testing` deixa de tratar como inconclusiva a comparação visual quando existe pacote de referência.

### Pilar 3: Contrato que chega ao código (Fase 1)

- O `## Direção visual` da spec ganha campos fixos:
  - modo e nível de movimento;
  - caminhos do pacote de referência;
  - o que fica igual e o que muda;
  - seções em ordem, cada uma com padrão, texto final ou fonte do texto e movimento;
  - lista do que não fazer.

  Os campos sem uso são cortados, para o contrato ficar mais curto que o atual.
- O `planning` coloca em cada passo de interface os caminhos do contrato, do `DESIGN.md` e dos prints da seção, além do critério de pronto do espelho.
- O despacho do `implementing` leva esses caminhos, o `floor.md` e a ordem de rodar o espelho. O subagente devolve os prints.
- O caminho "pode mandar ver" do `aligning` continua passando por `visual-direction` quando a tarefa tem interface. Ele pula as perguntas, não a direção.

### Pilar 4: Guia, galerias e receitas (Fase 2)

**Guia.** É o começo de `visual-direction`.

1. Primeiro, medir o que já se sabe pelo pedido, pelo projeto, pela marca e pela referência.
2. Perguntar só o que falta, uma pergunta por vez, sempre com recomendação e o porquê, na língua do usuário.

O que pode faltar:

- o que o visitante precisa fazer ou acreditar no fim;
- o clima;
- o nível de movimento;
- onde a página é calma, onde é intensa e qual é o pico;
- o movimento-assinatura ligado ao negócio;
- os materiais reais: fotos, números e logo.

Quem já chegou com referência e pedido claro vai direto ao contrato.

**Galerias com os olhos.**

1. O DevOrb pergunta se pode abrir referências no navegador.
2. Escolhe de 4 a 6 páginas nas galerias da `ui-sources.json` que combinam com o estilo descrito (campo `byStyle`).
3. Abre cada uma num navegador de verdade e tira print.
4. Mostra um quadro com os prints e a recomendação.
5. O usuário escolhe uma ou manda o próprio link.
6. A escolhida vira pacote de referência, capturada do site original, não da galeria.

Galerias:

- `reading` passa a `browser` em todas as galerias.
- A Land-book vem primeiro, porque aceita navegação automatizada.
- Godly e Recent só para ver: nada é salvo a partir delas.
- Dribbble fica de fora, porque os termos proíbem robôs.
- Mobbin e Refero entram como opcionais pelo MCP oficial, quando o usuário tem plano.
- Os links que o dono mandar entram na lista por pull request, como já é a regra.

**Receitas.** Ficam em `references/` de `design-system` e `visual-direction`, com números:

- **Escala de tipo e de espaço fluidas,** no método do Utopia, com valores gerados e não texto copiado. Larguras mínima e máxima 360 e 1440. Razões por modo:
  - Persuadir: 1.25 a 1.333;
  - Ler: 1.2;
  - Operar: 1.125 a 1.2.

  Um script gera os tokens `clamp()`.
- **Razão título/texto mínima por modo:** 3.0 em Persuadir e 1.6 em Operar. Esses números são calls de Claude, calibrados pelo caso Pilot (3.2).
- **Base de espaço 4/8.** Medida do texto entre 60 e 75 caracteres.
- **Padrões de hero,** de 6 a 8, cada um com esboço em texto, quando usar e as medidas. Exemplos: texto e mockup flutuante, título gigante centralizado, imagem cheia com texto por cima, split com prova social.
- **Padrões de seção,** de 12 a 16, mesma estrutura. Exemplos: faixa escura com número grande, linha do tempo de pessoas, tabela antes e depois, cards de horário, bento, prova social, CTA repetido com texto diferente em cada seção.
- **Pares de fontes gratuitas por categoria,** uma lista curta. Os nomes voltam a ser permitidos nas receitas.
- **Sorteio com histórico,** ideia da taste-skill, para dois projetos seguidos não saírem iguais. Fica registrado no projeto.

**Dial de movimento.** Fica em `motion`:

| Nível | Quando | O que entra |
|---|---|---|
| Suave | minimalista, editorial, sistema | fade e deslocamento de 4 a 12px |
| Equilibrado (padrão) | maioria das páginas | entradas em cascata, hover vivo, números contando, mockup com leve movimento |
| Impacto | quando pedido ou quando o guia recomenda e o usuário aceita | cenas no scroll, elemento fixo enquanto rola, texto cinético, luz, 3D |

Números de referência, escritos com palavras próprias a partir das regras públicas do transitions.dev:

- abrir em cerca de 250ms e fechar em cerca de 150ms;
- cascata de cerca de 40ms, com total abaixo de 300ms;
- nunca quicar ao fechar;
- nunca atrasar um fechamento.

Com referência, o movimento dela é observado na captura e o ritmo é copiado. `prefers-reduced-motion` continua obrigatório. O dial também decide de onde vêm os componentes: React Bits e transitions.dev entram como instalação pelo registry no projeto do usuário, só em stack React e respeitando a licença.

### Pilar 5: Competição, três versões e evals (Fase 3)

**Três versões.** Modo opcional. Três subagentes constroem a mesma seção ou página, cada um a partir de uma referência ou direção diferente. O usuário escolhe uma, saem mais três a partir dela, e depois vem o refino. Só por pedido, ou por oferta do guia em página de persuasão importante.

**Competição.** Modo opcional, inspirado no Gauntlet Loop. Os construtores trabalham em paralelo. O crítico de olhos novos compara cada versão com o pacote de referência sem saber de quem é cada uma, devolve até alguma passar e escolhe a vencedora.

**Evals.**

- Um eval de cópia com uma página de referência escrita pelo próprio DevOrb (MIT), que imita as qualidades do caso Pilot. Ele mede:
  - razão título/texto;
  - fidelidade estrutural por seção;
  - checagens automáticas;
  - nota do crítico.
- Um eval de guia: o usuário leigo diz "quero um site bonito para minha clínica", e o eval verifica uma pergunta por vez, com recomendação e oferta de abrir referências.
- Os evals de design atuais são revistos para medir resultado, não só se a skill disparou.

## Calls de Claude (o dono pode rever)

1. **O espelho mora em dois lugares:** no `implementing`, como passo do construtor, e no `ui-review`, como crítico de olhos novos. Não criar skill nova, porque menos skills custam menos tokens sempre carregados.
2. **Corte de reprovação:** nota abaixo de 8 em qualquer dimensão, com no máximo 3 rodadas. Se ainda não passar, entrega com os achados explícitos ao usuário, nunca em silêncio.
3. **Fidelidade medida por estrutura,** não por pixel, exceto na cópia idêntica.
4. **Larguras do espelho:** 1440, 1024, 768 e 390. A cópia compara 1440 e 390.
5. **Razões de escala e razão título/texto:** os números do Pilar 4. Ajustáveis pelos evals.
6. **taste-skill:** trazer as peças fortes dela, com atribuição MIT: os scripts de print e consistência, a ideia do gate com no máximo 3 rodadas e a do sorteio com histórico. Não instalar a skill inteira nem mandar o usuário instalá-la, porque ela custa centenas de milhares de tokens por página e briga com outras skills de gosto.
7. **Pasta do pacote:** `design/referencias/` no projeto do usuário. Entra no `.gitignore` do projeto quando o conteúdo for de terceiros. O DevOrb pergunta antes de commitar.
8. **Skills de gosto instaladas fora do DevOrb** (frontend-design, taste-skill, Impeccable, ui-ux-pro-max): uma linha em `visual-direction` manda não carregá-las enquanto o fluxo de design do DevOrb roda, e o guia recomenda desinstalá-las uma vez, como o D8 já previa. Sem hook novo: um plugin não descarrega skills de outro, e o custo de um hook com testes não se paga aqui.
9. **Ferramentas de captura** rodam sob demanda com `npx` (Playwright, dembrandt, odiff). Sem rede ou sem Node, o espelho cai para os prints do navegador do usuário, e as checagens automáticas rodam só pelo script local.
10. **Escopo do plano:** o `planning` detalha só a Fase 1. As Fases 2 e 3 ficam como esboço neste documento e ganham plano próprio depois que a Fase 1 passar no teste de aceitação.
11. **Régua mínima já na Fase 1,** para telas sem referência: o `floor.md` atual, a razão título/texto por modo, o corpo de 16px ou mais em Persuadir, a medida de 60 a 75 caracteres e a base 4/8. Os padrões de hero e de seção e as escalas fluidas ficam na Fase 2.
12. **Saída do laço na cópia:** quem encerra o laço é a nota de fidelidade do crítico (8 ou mais). A lista de desvios do script é entrada do crítico, não portão. O script só reprova sozinho em desvio grosseiro: número de seções diferente da referência, ou razão título/texto mais de 20% abaixo da referência.

## Suposições a confirmar

1. O teste de aceitação da Fase 1 é refazer a página "Em breve" do Google na Ligare com o Pilot como referência, no repositório da Ligare, guiado pelo dono. O resultado não é commitado no DevOrb.
2. A Ligare usa React/Next (a fonte Geist sugere Next). Isso decide se React Bits entra no teste.
3. A Site Architect que está no Drive do dono é a mesma instalada localmente. Dela, o DevOrb leva a descoberta uma pergunta por vez com recomendação e a extração de paleta a partir da marca, só como ideia.

## Para o construtor decidir

- Nomes de arquivos e scripts dentro de cada skill, desde que sigam o padrão do repositório.
- A divisão exata entre `SKILL.md` e `references/` para caber nos limites.
- O formato do quadro de prints mostrado ao usuário: Artifact, arquivo local ou aba do navegador.
- A forma dos exemplos de crítica, desde que a atribuição fique registrada.
- Quais evals atuais reescrever e quais aposentar, registrando o motivo em `fusion/results/`.

## Fontes desta decisão

- Mapa interno (2026-11-17): skills `visual-direction`, `design-system`, `motion`, `ui-review`, `browser-testing`, `implementing`, `planning`, `reviewing` e `aligning`; spec `docs/specs/2026-11-08-devorb-design.md` §Setor de design.
- Pesquisa externa (2026-11-17):
  - Anthropic frontend-design (Apache-2.0);
  - Impeccable (Apache-2.0);
  - Hallmark (MIT);
  - taste-skill (MIT, v2.5);
  - gstack (MIT);
  - ui-ux-pro-max (MIT);
  - dembrandt (MIT);
  - ai-website-cloner-template (MIT);
  - odiff (MIT);
  - Design2Code (só ideia);
  - UICrit (CC BY 4.0);
  - Utopia;
  - transitions.dev (licença própria);
  - React Bits (MIT com Commons Clause);
  - termos de Land-book, Godly, Mobbin, Refero e Dribbble.
- Material do dono: 12 vídeos do YouTube, tasteskill.dev, transitions.dev, reactbits.dev, a skill `site-architect` e a skill `av-design-system`. Ideias tiradas dos vídeos:
  - Gauntlet Loop;
  - pacote de referência com no máximo 3 referências;
  - três versões com escolha do usuário;
  - entrevista de composição com mapa de calma e pico;
  - prompt de handoff com campos fixos;
  - aviso de mesma stack da fonte;
  - não ativar duas skills de gosto juntas.

