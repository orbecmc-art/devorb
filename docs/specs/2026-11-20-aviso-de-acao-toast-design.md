# Aviso de resultado de ação é trabalho de toast

Data: 2026-11-20. Branch `claude/operate`, a partir da `main` (`d7dc0a1`, versão 1.15.0). Frente C, item 1, do brief `docs/briefs/2026-11-20-evolucao-devorb.md`. O merge é do dono.

## Intenção

O brief pede fechar a lacuna `visual-direction-arquitetura-clean` e aponta os graders 1 a 3 (o caminho sem pessoa do `guide.md` §2 pulando galerias e fontes). Esse conserto já entrou na 1.15.0 (`53cc252`, `4a966e3`): os graders 1, 2, 3 e 5 passam. O caso segue em 0% de aprovação porque os graders 4 (`sonner` no `package.json`) e 6 (toast do Sonner em `components/newsletter-form.tsx`) falham em todas as rodadas gravadas. O dono redirecionou o item 1 para esses dois graders em 2026-11-20.

Por que importa além do caso: painel, CRM e sistema interno, a maior parte do que a Orbe entrega, mostram "salvo", "enviado" e "falhou" em toda tela. Hoje o agente monta esse aviso à mão, com `useState`, formulário por formulário.

## Causa (rodada de diagnóstico de 2026-11-20, `devorb@d7dc0a1`, 1 rodada, trace guardado)

O agente leu `ui-sources.json` e `sources.md`. A regra do especialista chegou até ele. Ele escreveu no contrato:

> Especialista: nenhum (não há toast, drawer nem menu; o aviso da newsletter fica no próprio formulário, junto do campo).

E no despacho da task: "no specialist (the confirmation is inline, not a toast)".

A spec da fixture diz "a página confirma com um aviso na tela". Na sessão real o agente decide, por gosto, que esse aviso é uma mensagem dentro do formulário, e com isso a regra "o especialista de cada trabalho em vez da versão feita à mão" não se aplica: não há toast.

Três rodadas do mesmo caso, cortadas em 20 turnos logo depois do contrato (2026-11-20, `devorb@d7dc0a1`, US$ 3,28 no total), repetiram a decisão em 3 de 3, com estas justificativas:

> Especialista: nenhum; o aviso da newsletter fica junto do formulário, em texto com `aria-live`, porque um toast some antes de ser lido e o Sonner não está instalado.

> Especialistas: nenhum; o aviso da newsletter é uma mensagem na própria linha do formulário (aria-live), não um toast, então Sonner fica de fora.

> Especialistas: nenhum. O aviso da newsletter fica junto do campo e não vira toast, então o Sonner fica de fora.

Fora da sessão real a decisão é outra: seis subagentes novos, só com a spec e os arquivos da skill, escolheram o Sonner em 6 de 6 e escreveram `sonner` no `package.json`. A regra é entendida; o que falta é ela valer quando o agente, no meio do fluxo inteiro, prefere a mensagem no formulário. Por isso o teste com subagente não serve de laço vermelho, e o laço é o caso real cortado.

O ledger (`fusion/ledger/visual-direction.md`, regra 5) registra a lacuna como "nenhuma regra faz o Sonner entrar sem rede". Esse diagnóstico está errado: o agente nunca chegou a escolher o Sonner. O `README.md` da fixture já diz que dependência nova entra no `package.json` e no código. O caminho sem rede só é exercitado depois que o Sonner for escolhido.

## Decisão do dono (2026-11-20)

O aviso que informa o resultado de uma ação vira toast por regra na skill. A alternativa recusada era reescrever a spec da fixture para dizer "toast": o caso passaria, mas as specs reais continuam dizendo "aviso" e o produto real continuaria com o aviso feito à mão.

## Objetivos

1. Na `visual-direction`, o trabalho é nomeado pelo que acontece na tela, não pela palavra da spec: o aviso que informa o resultado de uma ação (salvou, inscreveu, enviou, falhou no servidor) é o trabalho de toast e usa o especialista da lista.
2. O erro de validação de um campo continua junto do campo. A regra não manda tudo para toast.
3. `visual-direction-arquitetura-clean` com aprovação de 2/3 ou mais no braço `devorb`, em 3 rodadas. `accepted: true` sozinho não basta: a `compare.mjs` também imprime `accepted: true` quando `devorb` e `none` empatam em 0%, porque lacuna não bloqueia.

## Fora

- Mudar a fixture ou o prompt do caso. Dos graders, só o 6 muda, por decisão do dono (abaixo).
- Os outros itens da frente C (tabela densa no `operate.md`, ciclo visual no `implementing`, o reservado `visual-direction-guia-restaurante`).
- Subir a versão e registrar no `CHANGELOG.md`: o brief põe isso depois do merge.
- Rodar a suíte inteira da `visual-direction` ou o reservado para procurar regressão: não cabe no teto. Fica dito no relatório final como não conferido.

## Anti-objetivo

Uma regra que passa no grader e piora o produto: toast para erro de campo, ou toast empilhado em cima de uma mensagem que já está no formulário.

## Onde muda

- `skills/visual-direction/references/sources.md`, seção "Choosing libraries, per job": o texto mínimo que faz o agente classificar o aviso de resultado de ação como trabalho de toast. Se o laço cortado mostrar que o agente decide antes, pela lista, o mesmo sentido entra na regra de stack do `ui-sources.json` ou na descrição da entrada Sonner. Um lugar só, o que o teste mostrar que funciona.
- `fusion/ledger/visual-direction.md`: corrigir o diagnóstico da regra 5, registrar a regra nova como regra do dono com o caso que a justifica, e a linha de resultado com o custo.
- Nenhum `SKILL.md` muda, a não ser que o laço cortado mostre que o texto em `references/` não é lido a tempo. Esta linha foi superada pela seção "Segunda rodada": dois `SKILL.md` mudaram (`implementing` e `verifying`). A `visual-direction` está em 2.027 de 2.500 tokens.

## Testes

- **RED, já existe.** O caso `visual-direction-arquitetura-clean` falha nos graders 4 e 6 em 9 rodadas inteiras, em 5 commits, a última em `devorb@d7dc0a1`, e o contrato sai sem especialista nas 3 rodadas cortadas citadas acima. Nenhum texto de skill foi escrito antes dela.
- **Laço cortado, antes da rodada cheia.** O caso real no harness do `claude plugin eval`, com `max_turns` baixado para 20 só na cópia do braço e `--keep-temp`: para logo depois do contrato e custa perto de US$ 1,10 por rodada. Lê-se a linha `Sources:` no trace. Vermelho hoje em 3 de 3. Verde quando, em 3 de 3, o contrato nomeia o Sonner como especialista do aviso e `sonner` como biblioteca nova, e o erro de e-mail inválido continua junto do campo. O script fica fora do repositório, descartável.
- **GREEN pago.** `node tools/compare.mjs --skill visual-direction-arquitetura --arms devorb,none --runs 3`. Passa com aprovação do `devorb` de 2/3 ou mais e `accepted: true`.
- `npm test` verde.

## Orçamento

Teto pago da frente: US$ 50. Gasto até aqui, contando o custo do juiz: US$ 9,48 (US$ 6,20 da rodada de diagnóstico inteira, cuja estimativa era US$ 2 e que usou 14 subagentes, e US$ 3,28 das três rodadas cortadas). Previsto: US$ 3,30 por volta do laço cortado e perto de US$ 20 pela rodada GREEN de 3 com `none`. Cabe uma rodada GREEN cheia, não duas. Se ela falhar, paro e relato. Custo real informado depois de cada rodada.

## Segunda rodada: três ajustes (decisão do dono, 2026-11-20)

A rodada cheia em `devorb@31f827d` aprovou 1 de 3 (33%), US$ 8,66, abaixo da barra. A regra fez o que mirava (grader 4 em 2 de 3, antes 0 de 9; primeira aprovação do caso), e sobraram três lacunas, descritas no ledger. O dono aprovou os três ajustes e mais uma rodada cheia:

1. **Grader 6 aceita o envio feito por uma função importada.** Na rodada 2 o build estava certo (`toast.success` do Sonner depois da resposta, `<Toaster />` no layout, `sonner` no `package.json`), mas o `fetch` estava em `lib/newsletter.ts`, separado para ser testado sem navegador, como a `devorb:tdd` pede. O grader lê só o formulário e exigia o `fetch` nele. Um grader `llm` lê um arquivo só, então ele não passa a ler o módulo: a condição 2 passa a aceitar a chamada, com `await`, a uma função importada que faz o envio. Limite: o juiz confia nessa função sem vê-la. A condição 1 (aviso do Sonner, nada feito à mão) não muda.
2. **A mensagem final de um trabalho de interface nomeia as fontes.** Em 2 de 3 rodadas a mensagem final não nomeou as fontes (grader 3). A regra está na `visual-direction` §4, mas a mensagem final sai muitos turnos depois, por caminhos diferentes: uma rodada passou pelo `implementing`, a outra só pelo `verifying`. A linha entra nos dois moldes de mensagem final: no `implementing/SKILL.md`, junto das três listas, e no `verifying/SKILL.md`, em "Hand-off". Ao dono eu tinha dito só `implementing`; o trace mostrou que uma das duas rodadas que falharam nunca carregou essa skill.
3. **A regra 6 diz onde o aviso não fica.** Na rodada 3 o agente leu a regra e escreveu "o aviso da newsletter é inline". O texto ganha uma oração: o aviso de resultado usa o especialista e nunca é uma linha de status montada no formulário ou na página.

RED dos três: as rodadas 2 e 3 de `devorb@31f827d`, com as frases e os arquivos citados no ledger. GREEN: uma rodada cheia, a mesma linha de comando, mais a conferência do grader 6 novo contra dois arquivos guardados (o build certo da rodada 2 tem de passar; o aviso feito à mão da rodada 3 tem de falhar). Previsão: perto de US$ 9, total perto de US$ 31. Resultado real: US$ 16,13, total US$ 37,67; 2 de 3 aprovadas; `accepted: false` por causa de uma rodada que estourou os 1200 s; a lacuna do caso (item 1 da frente C) não está fechada pela regra da casa.

## Hipóteses (decididas por mim, corrigíveis)

- "Resultado de uma ação" cobre o sucesso e a falha que vem do servidor depois do envio. Erro que o formulário já sabe antes de enviar (campo vazio, formato) fica junto do campo. O 400 sobre o campo de e-mail é a exceção que o plano e o ledger mantiveram junto do campo, e o texto da regra não diz isso (item em aberto no ledger).
- Com o Sonner escolhido, o agente segue o caminho sem rede que já está em `sources.md` (dependência escrita no `package.json`, código contra ela, aviso de que falta instalar). Se o GREEN mostrar que não segue, esse é um segundo defeito, com o mesmo ciclo.
- O modelo dos evals fica o `claude-opus-5-5` do `fusion/eval-config.json`.

## Com o construtor

Texto de skill em inglês; ledger em português. O formato do texto (regra positiva, condicional observável) sai do que o laço cortado mostrar, pelo `skills/writing-skills/SKILL.md`. Uma `compare.mjs` por HEAD de cada vez.
