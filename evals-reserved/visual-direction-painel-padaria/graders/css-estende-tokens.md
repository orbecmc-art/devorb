---
type: llm
focus:
  source: file
  path: painel/pedidos.css
weight: 3
---

Contexto: o projeto é o site estático de uma padaria que já tem identidade visual. O `DESIGN.md` da raiz e o `css/base.css` (que toda página carrega) definem estes tokens como variáveis CSS: cores `--cor-trigo` (#C8892B, ação), `--cor-forno` (#7A2E1D, títulos), `--cor-farinha` (#FBF6EC, fundo), `--cor-miolo` (#F1E4CC, superfícies e linhas alternadas), `--cor-carvao` (#2B2523, texto), `--cor-cinza-forma` (#8A7F76, texto secundário e bordas), `--cor-ok` (#3E7D4F), `--cor-atencao` (#B7791F), `--cor-erro` (#A63A2B); fontes `--fonte-titulo` (Fraunces) e `--fonte-texto` (Inter); tamanhos `--t-1` a `--t-5`; espaços `--e-1` a `--e-7`; raios `--raio-p` e `--raio-m`. Um princípio do `DESIGN.md` diz: superfícies chapadas, sem gradiente e sem sombra pesada. O agente devia construir uma tela interna nova (o painel de pedidos de encomenda das atendentes) estendendo essa identidade. Você vê o `painel/pedidos.css` final.

Passa somente se:

- toda cor do arquivo vem dessas variáveis (`var(--cor-...)`), ou de uma mistura delas (por exemplo `color-mix()` entre essas variáveis ou com `transparent`), ou é `transparent`, `currentColor` ou `inherit`;
- as fontes, quando declaradas, vêm de `var(--fonte-titulo)` ou `var(--fonte-texto)`;
- o arquivo usa de fato os tokens (várias referências a `var(--cor-...)` e aos tokens de espaço, tamanho ou raio). Um valor literal solto para medida de layout (borda de `1px`, largura máxima, coluna de tabela) é aceitável.

Falha se:

- aparece alguma cor literal fora dos tokens: hexadecimal, `rgb()`, `rgba()`, `hsl()`, `oklch()` ou cor por nome (`white`, `black`, `red`, `green`, `gray` e parecidas), mesmo que seja só para um status ou um detalhe;
- o arquivo declara variáveis de cor novas com valores próprios, ou redeclara algum token existente com outro valor (redeclarar com o mesmo valor do `css/base.css` é tolerado);
- usa uma família de fonte que não está nos tokens;
- usa `linear-gradient`, `radial-gradient` ou `conic-gradient`;
- o arquivo quase não usa os tokens e monta um visual próprio, desligado da identidade da padaria.
