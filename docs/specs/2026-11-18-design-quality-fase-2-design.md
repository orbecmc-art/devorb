# Qualidade de design do DevOrb — Fase 2

Data: 2026-11-18. Status: aprovado pelo dono em 2026-11-18 (ordem, abordagem e documento). Continua `docs/specs/2026-11-17-design-quality-design.md`, cujos Pilares 4 e 5 esta fase detalha. Fica fora daqui o Pilar 5 (competição e três versões), que é a Fase 3.

## Intenção

A Fase 1 (versão 1.13.0) já está no ar. O dono testou na página Em breve do Google da Ligare e achou o resultado "1000 vezes melhor". Agora ele quer que o DevOrb saiba entregar o nível de 23 sites que escolheu como referência de qualidade e que enxergue esse nível como algo alcançável.

Quem instala o plugin muitas vezes não sabe pedir design. O plugin precisa guiar essa pessoa, oferecer referências reais e aplicar receitas com números.

## O que o estudo das 23 referências mostrou

O estudo foi feito em 2026-11-18. As abas vieram do Safari do dono e as capturas saíram do `shoot.mjs` da Fase 1, em 1440 e 390.

- **Fonte:** `docs/specs/2026-11-18-referencias/`, com `urls.txt` e os estudos `study-A.md` e `study-B.md`. Os estudos são texto escrito por nós, sem prints de terceiros.
- **Capturados:** 21 dos 23 sites.
- **Números:**
  - título: 46 a 96px em SaaS, mediana entre 64 e 72px, e até 200px em portfólio e editorial;
  - corpo: 13 a 18px, mediana de 14 a 15px;
  - razão título/corpo: 2,9 a 8, normalmente entre 4,2 e 5,5;
  - seções por página: 8 a 11;
  - padding de seção: 96 a 160px;
  - escala de espaço: 64, 80, 128, 160, 200 e 256;
  - raios: 0, 4 a 8, 12 a 16, 24 e pílula;
  - cores de destaque: uma em 9 de cada 10 sites.
- **Padrões:** o título tem peso 400 a 500, com tracking de −0,04 a −0,06em. Cada site usa de 1 a 3 famílias de fonte, e é comum juntar uma grotesca com rótulos em mono. Os acabamentos se repetem: linhas finas no lugar de sombra, escada de opacidade (1 / 0,6 / 0,4 / 0,2) e UI real no lugar de ícone. O conteúdo vaza pela borda, os números são específicos e o mobile é recomposto, não só empilhado.
- **Achados contra o DevOrb 1.13.0:**
  1. **`body-size` ≥ 16 em Persuade está errado.** A regra reprova 15 dos 19 sites medidos, que usam corpo de 13 a 15px.
  2. **As ferramentas falharam em 9 sites reais:**
     - página com mais de 16.000px: o print da seção sai fora da imagem e a execução inteira cai (Shopify, Patensify);
     - `page.screenshot` estoura 30s em site pesado (Audienceful, Melius);
     - seções com revelação ao rolar saem em branco (Monocle, Parloa, Sol, Vercel, Aave, Hoy);
     - nenhuma seção é encontrada (Billow).

## Metas (em ordem de entrega, decisão do dono)

1. **Ferramentas robustas.** `shoot.mjs`, `capture.mjs` e `collect-in-page.js` passam nos 23 sites de referência: capturam, medem e mostram todas as seções preenchidas, sem derrubar a execução por causa de um print.
2. **Receitas calibradas pelas referências:**
   - régua e checagens recalibradas;
   - padrões de abertura e de seção com números;
   - a lista do que denuncia página gerada por IA, que o crítico usa.
3. **Biblioteca de referências.** Os 23 sites entram em `ui-sources.json`, marcados por estilo e uso. O guia oferece esses sites ao usuário.
4. **Guia e dial de movimento**, conforme o Pilar 4 da spec da Fase 1. Para o movimento, primeiro se estudam 4 ou 5 dessas referências num navegador de verdade.

## Fora do escopo

Competição e três versões (Fase 3), Figma, geração de imagem e app nativo.

## Anti-metas

- Uma receita que vira molde e faz toda página sair igual. Os padrões são um cardápio escolhido pelo guia, com sorteio e histórico (ideia da taste-skill).
- Um checador que reprova as próprias referências do dono.
- Prints ou textos de terceiros commitados no repositório público. Só entram URL, números medidos e descrições escritas por nós.

## O design

### Pilar A: ferramentas robustas

1. **Revelação ao rolar.** Antes do `goto`, um shim de `IntersectionObserver` faz todo elemento observado ser reportado como visível. Depois da rolagem, `document.getAnimations()` termina as animações de entrada. Elementos com `opacity` abaixo de 0,1 ou `visibility: hidden`, e que têm texto ou imagem, são forçados a aparecer só na captura. A ideia vem do `mirror.js` da skill `av-design-system` do dono, sem copiar texto. A medição registra quantas revelações foram forçadas.
2. **Página longa.** O clip de cada seção é limitado à imagem de página inteira. Uma seção abaixo de 16.000px é fotografada sozinha, com `fullPage: false` e rolagem até ela. Uma seção vazia é pulada e anotada. Nenhum print derruba a execução: o erro vai para `metrics.json` como `shotErrors` e a execução segue.
3. **Site pesado.** `animations: 'disabled'` e `timeout` de 60s no screenshot, com uma nova tentativa com `caret: 'hide'`. Na falha, `shotErrors` e a execução segue. O `goto` usa `waitUntil: 'domcontentloaded'` mais a espera de rede ociosa que já existe.
4. **Seções não encontradas.** Quando `sectionNodes` dá 0 ou 1, um segundo critério roda: blocos de largura total, irmãos, com altura de 120px ou mais, em qualquer profundidade abaixo de `main`/`body`, escolhendo o nível com mais desses blocos. Billow é o caso de teste.
5. **Prova:** um teste de aceitação local (`tools/refs-check.mjs`, fora do `npm test`) roda `shoot.mjs` nos 23 URLs. Pronto quando:
   - pelo menos 21 dos 23 capturam sem erro de execução;
   - nenhum site tem seção em branco onde havia conteúdo;
   - o relatório lista o que falhou.

   A rede e o Playwright são do dono, e o teste roda sob demanda.

### Pilar B: receitas calibradas

Arquivos novos em `skills/visual-direction/references/` e `skills/design-system/references/`, com números e escritos com palavras nossas:

- **Régua recalibrada** (`rules.mjs` e `floor.md`):
  - `body-size` deixa de reprovar entre 13 e 16px. FAIL só abaixo de 13px; WARN entre 13 e 14px em Read.
  - A razão título/corpo em Persuade dá FAIL abaixo de 2,5 e WARN entre 2,5 e 4,0, com **alvo de 4,0** (ver Call 7).
  - Checagem nova `display-weight`: WARN quando o título de 48px ou mais tem peso 700 ou mais e tracking igual ou maior que zero.
  - Checagem nova `accent-count`: WARN com mais de 2 matizes saturadas fora dos neutros.
  - `font-sizes` vai para 12 ou mais. Os sites usam de 6 a 26 tamanhos, então a checagem só avisa.
- **Tipografia:**
  - título de 56 a 96px em Persuade, com peso 400 a 500 e tracking entre −0,02 e −0,05em, que aumenta junto com o tamanho;
  - corpo de 14 a 16px e lead de 18 a 22px;
  - 1 a 3 famílias, com a combinação grotesca + mono para rótulos e números;
  - título em dois tons, cinza e preto, com o mesmo tamanho nas duas cores.
- **Cor e acabamento:**
  - uma cor de destaque;
  - escada de opacidade para texto;
  - linhas finas de 1px a 6–10% no lugar de sombra;
  - sombra só em UI flutuante;
  - halo desfocado acima de 100px, sempre atrás de objeto e nunca atrás de texto;
  - grade ou trilho visível como recurso opcional.
- **Espaço e raio:** escala de 64, 80, 128, 160, 200 e 256px. Padding de seção de 96 a 160px. Raio de 4 a 8px em produto e dev, 12 a 16px em consumo, 24px nas folhas de seção e pílula só em botão e chip.
- **Padrões de abertura** (cerca de 10, unindo os 7 e 8 dos dois estudos): nome, quando usar, esboço em texto e medidas. Exemplos: centralizado com o produto embaixo e halo; cabeçalho dividido com a UI vazando; texto à esquerda e UI à direita com halo; um objeto cortado pela dobra; foto cheia com tipografia display; tipografia que encena o produto; parede de conteúdo inclinada.
- **Padrões de seção** (cerca de 12): bento de UI viva; grade de prova; cartões de número com rótulo mono; linhas alternadas com UI esmaecendo; passos numerados; declaração em dois tons; tabela de especificação em mono; configurador no lugar da tabela de preço; FAQ com linhas finas; faixa escura de contraste; CTA final que repete o par da abertura; rodapé com a marca gigante cortada.
- **Sinais de página feita por IA:** a lista dos dois estudos entra em `references/critique.md` como régua da dimensão `finish` e de `visual-moment`. Os sinais são:
  - ícone onde devia haver UI real;
  - tudo centralizado;
  - destaque demais;
  - números genéricos;
  - título em negrito com tracking normal;
  - mobile só empilhado;
  - "Feature 1/2/3".
- **Mobile recomposto:** a abertura alinha à esquerda, o CTA ocupa a largura toda, o visual secundário cai ou vira carrossel, e o h1 fica entre 32 e 64px.

### Pilar C: biblioteca de referências

- Os 23 sites entram em `ui-sources.json` como `kind: "reference"`. Cada entrada leva `styles` (por exemplo `saas-dark`, `saas-light`, `editorial`, `restaurante`, `fintech`, `portfolio`, `devtools`, `agencia`), `uses` (landing, página de produto, em breve, institucional) e `reading: "browser"`, com uma linha sobre o que estudar ali, escrita por nós.
- O teste `tests/ui-sources.test.mjs` passa a exigir que as 23 entradas existam.
- O dono acrescenta e remove referências por pull request, como já é a regra.

### Pilar D: guia e dial de movimento (do Pilar 4 da spec da Fase 1)

- **Guia:** começa pelo que já se sabe. Pergunta só o que falta, uma coisa por vez, sempre com recomendação. Oferece abrir de 4 a 6 referências da biblioteca filtradas pelo estilo, mostra os prints e o usuário escolhe. A escolhida vira pacote de referência.
- **Dial de movimento:** os níveis são Suave, Equilibrado (padrão) e Impacto. Os números vêm da spec da Fase 1. Esta fase acrescenta o que os sites com animação mostrarem.
- **Estudo de movimento:** antes de escrever o dial, 5 referências são abertas no navegador do dono. Gravo rolagem e hover, e meço com `document.getAnimations()` a duração, a curva e o stagger de cada uma. Escolha de Claude, que o dono pode trocar: Aave e Hoy (scroll preso), Vercel, Framer e Raycast. Os números entram em `skills/motion/references/`.

## Calls de Claude (o dono pode rever)

1. Os limiares novos: corpo abaixo de 13px dá FAIL; razão com alvo de 4,0; peso de display com tracking; contagem de destaques.
2. O estudo de movimento usa 5 sites escolhidos por mim: Aave, Hoy, Vercel, Framer e Raycast.
3. O teste das 23 referências roda sob demanda (`tools/refs-check.mjs`), fora do `npm test`, porque depende de rede e do Playwright.
4. Ciclo de testes: completo em `visual-direction` (biblioteca e receitas) e `ui-review` (crítico com sinais de IA). Leve em `design-system` e `motion`. O mesmo critério de orçamento da Fase 1 vale, e cada rodada paga é confirmada antes.
5. Os padrões são um cardápio, e o guia escolhe com histórico para não repetir. A ideia do sorteio vem da taste-skill.
6. **Itens do Pilar 4 da Fase 1 que entram aqui:** o script de escalas fluidas no estilo Utopia, uma função pura que gera os tokens `clamp()` a partir de largura mínima, largura máxima e razão, com testes; a lista curta de pares de fontes gratuitas por categoria; e `reading: "browser"` em todas as galerias. O teste "a clean brief has a gallery it can read without a browser" muda junto. Mobbin e Refero pelo MCP, e Land-book primeiro, ficam para quando houver plano pago. O guia oferece primeiro as 23 referências e depois as páginas `byStyle` das galerias.
7. **Régua contra as referências:** `heading-ratio` dá FAIL abaixo de 2,5 e WARN entre 2,5 e 4,0, com alvo de 4,0. O mínimo duro cai de 3,0 para 2,5 porque a referência da agência do dono mede 2,9; a página ruim da Ligare media 2,0 e continua reprovada. O `refs-check` exige zero FAIL nas 23 referências, só lista os WARN e trata a saída 2 do `shoot` como resultado, não como erro. Cada referência tem o seu modo em `urls.txt`; persuade é o padrão.
8. **Etiquetas:** as referências usam as `styles` que já existem (clean, bold, animated, playful, ai, product), e o teste continua valendo. Um campo novo, `sectors` (saas, devtools, fintech, restaurante, agencia, portfolio, editorial, ecommerce), é o segundo eixo. O guia filtra primeiro pelo estilo e desempata pelo setor. `kind: "reference"` entra na lista de tipos permitidos. O Mobbin continua como entrada de telas e não é duplicado.
9. **Estudo de movimento:** roda no Playwright sem tela, rolando a página e passando o mouse pelos elementos que têm `:hover`, e lê `document.getAnimations()` e as transições computadas. Usa o navegador do dono só se algum site bloquear. Assim roda sozinho.
10. **Barra do `refs-check`:** os 23 sites capturam sem derrubar a execução, Melius e Audienceful incluídos. "Seção em branco" é medido na página: depois da revelação forçada, refeita no momento da medida e antes de cada print, o coletor conta, por seção, os elementos com texto ou imagem que ainda têm opacidade própria abaixo de 0,1 ou `visibility: hidden` (`hiddenContent`). O `refs-check` exige zero em todos.

## Suposições a confirmar

1. Decisão do dono (2026-11-18): os 23 sites ficam na biblioteca sem checar os termos de uso de cada um. Só entram URL, números medidos e descrições nossas; nada é salvo deles no repositório.
2. O orçamento das rodadas pagas da Fase 2 ainda não foi definido. Antes da primeira rodada paga, peço o teto.

## Para o construtor decidir

Nomes de arquivos de referência, a divisão entre `SKILL.md` e `references/`, como guardar o histórico do sorteio e o formato do relatório do `refs-check`.
