# Ledger: `debugging`

Primeira skill a passar pelo processo de fusão. Parte do teste de fusão em `docs/spike-devorb-debugging/`, que juntou `systematic-debugging` (Superpowers 7.0.2) e `diagnosing-bugs` (Matt Pocock 1.3.2), e soma ideias de três fontes novas, todas com `textReuse: false`: Trail of Bits (`implement-patch` e `variant-analysis`), Spartan (`service-debugging`) e ECC (`click-path-audit`). O texto dessas três é próprio, escrito a partir das ideias.

Pinos lidos: Superpowers é comparado no commit mais recente, por regra do dono, e em 2026-11-11 a `main` dele estava em `22f0b463e7a5e579904dd6211a520321035526f7`, igual ao `lastAbsorbed`. Matt segue o pino `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. As fontes novas foram lidas nos pinos de `fusion/sources.json`. Os arquivos em `references/` (menos `variant-search.md` e `silent-no-op.md`, que têm texto próprio) e em `scripts/` são cópias sem alteração, conferidas byte a byte contra esses commits.

O caso que justifica as regras próprias é o bug do teste de fusão, hoje `evals/debugging-flaky-payment`: um teste de pagamento instável cuja causa é `store.get()` não enxergar as escritas ainda na fila, e o `refundPayment` sofre do mesmo defeito. Sem a fusão, os agentes usaram `flushNow()` no chamador, o que faz o teste passar e reduz o ganho do batching.

## Origem por parte

| Parte | Origem |
|---|---|
| `description` | Superpowers, ampliada com falha de build, instabilidade e regressão de desempenho, das listas de uso das duas fontes |
| Abertura: causa com evidência, sintoma é falha, "violar a letra é violar o espírito" | Superpowers |
| As duas travas: sem teoria antes do loop vermelho, sem conserto antes da causa | Superpowers (lei de ferro) e Matt (sem loop, sem fase 2) |
| Quando as travas pesam mais | Superpowers ("especialmente quando"), mais a regra própria 4 |
| Ocultar segredos | Matt |
| Comparar segredos por nome, presença ou hash, nunca pelo valor | DevOrb, revisão de 2026-11-11 |
| 1. Orientação: erro inteiro, pilha, mudanças recentes | Superpowers |
| 1. Orientação: antes de culpar o código, listar o que difere entre onde falha e onde funciona (versão publicada, configuração, variáveis de ambiente, infraestrutura, versões de serviço), cada diferença como pista para o loop e não como causa a consertar; ler os logs e guardar o estado antes de reiniciar | Spartan (`service-debugging`), só ideia. Texto reescrito na revisão de 2026-11-11, com as diferenças como pistas para o loop |
| 1. Orientação: `GLOSSARY.md` e ADRs | Matt |
| 1. Log em cada fronteira entre componentes | Superpowers |
| 1. Loop vermelho, 10 formas de construir, apertar, bug não determinístico, quando não há loop, critérios de conclusão | Matt |
| 1. Ponteiros no momento do uso: `find-polluter.sh` na bisseção, `condition-based-waiting.md` ao tornar o bug determinístico, copiar e editar `hitl-loop.template.sh` antes de rodar (como pede o cabeçalho dele), estresse só em ambiente local ou de teste | DevOrb, revisão de 2026-11-11; os arquivos são do Superpowers e do Matt |
| 2. Minimizar | Matt |
| 3. Exemplo que funciona e rastrear o valor para trás | Superpowers |
| 3. Controle que não faz nada e não dá erro: ponteiro para `references/silent-no-op.md` | ECC (`click-path-audit`), só ideia. É a ideia mais fraca da skill, e o ponteiro sai primeiro se ela passar do teto |
| `references/silent-no-op.md`: seguir as chamadas em ordem, anotar o que cada uma grava e zera, achar a que desfaz outra, comparar com o rótulo | ECC (`click-path-audit`), só ideia, com texto próprio. Saiu do corpo da skill na revisão de 2026-11-11 |
| 3. De 3 a 5 hipóteses com previsão, mostradas ao usuário | Matt |
| 4. Uma variável por vez, depurador antes de log, prefixo nos logs, ramo de desempenho | Matt |
| 4. "Não entendo X" | Superpowers |
| 5.1 Nomear a regra quebrada em uma frase e procurar toda violação dela no repositório inteiro | Trail of Bits (`implement-patch`), só ideia |
| 5.1 Buscar no repositório inteiro e, em repositório grande ou com código copiado, abrir `references/variant-search.md` | Trail of Bits (`variant-analysis`), só ideia. A escada de busca saiu do corpo na revisão de 2026-11-11 |
| 5.1 Outros chamadores com o mesmo padrão e conserto uma camada abaixo | Regra própria 1 |
| 5.4 Listar cada lugar onde a regra quebra, o que foi feito ali e por quê | Trail of Bits (`implement-patch`), só ideia, com texto próprio. Saiu do passo 5.1 na revisão de 2026-11-11, para o relato vir depois do teste e do conserto |
| `references/variant-search.md`: partir do caso exato, afrouxar uma coisa por vez, contar acertos e ruído, tentar provar o candidato seguro antes de contá-lo, anotar os descartados | Trail of Bits (`variant-analysis`: `root-cause.md`, `searching.md`, `triage.md` e `reporting.md`), só ideias. Reescrito do zero na revisão de 2026-11-11, só a partir da lista de ideias deste ledger, sem a fonte aberta |
| 5.2 Teste de regressão antes do conserto, na costura correta, e `diff` contra cópia limpa | Matt |
| 5.2 Teste que falha só às vezes não prova nada | Regra própria 2 |
| 5.3 Um conserto só, na causa e nas variantes, sem mais nada junto | Superpowers. "E nas variantes" entrou na revisão de 2026-11-11, para casar com a regra própria 1 |
| 5.3 Mínimo é a menor mudança que restaura a regra, não a de menos linhas | Trail of Bits (`implement-patch`) e spec, "Mudança mínima ou correção na origem" |
| 5.4 Verificar: teste, loop da fase 1 e suíte inteira | Superpowers e Matt |
| 5.4 Dizer o custo do conserto e a alternativa recusada | Regra própria 3 |
| O conserto falhou: contar tentativas, parar em 3 e questionar a arquitetura | Superpowers |
| Causa de fato externa | Superpowers |
| 6. Limpeza | Matt, mais o item das variantes (Trail of Bits, só ideia) e o de logs, dumps e HAR com segredos (DevOrb, revisão de 2026-11-11) |
| Sinais de parada | Superpowers, condensado, com a linha de ler o código antes do loop (Matt), mais a regra própria 4 e a linha "reiniciar para ver" (Spartan, só ideia). Na revisão de 2026-11-11, a linha de reiniciar passou a dizer que reiniciar depois de guardar logs e estado mitiga e não conserta, a abertura passou a permitir conter uma queda, e saíram "a referência é longa" e "um timeout maior", que repetiam o corpo |
| Sinais do usuário de que você está supondo | Superpowers |
| `references/root-cause-tracing.md`, `defense-in-depth.md`, `condition-based-waiting.md`, `condition-based-waiting-example.ts`, `find-polluter.sh` | Superpowers, cópias sem alteração |
| `scripts/hitl-loop.template.sh` | Matt, cópia sem alteração |
| `Connects to` | DevOrb: `devorb:tdd` para o teste de regressão, `devorb:verifying` antes de dizer que está corrigido |

## Conflitos resolvidos

- **Uma hipótese ou várias:** o Superpowers pede uma para evitar consertos em rajada, e o Matt pede de 3 a 5 para evitar ancoragem. A skill gera de 3 a 5 e testa uma variável por vez, o que atende aos dois objetivos.
- **Investigar ou construir o loop primeiro:** a orientação rápida do Superpowers serve só para mirar o loop do Matt. As teorias esperam o vermelho.
- **Teste de regressão sempre ou só com costura correta:** o teste vai na costura correta. Sem ela, isso é registrado como achado e o loop da fase 1 continua como prova.
- **Mínimo ou na origem:** o teste de fusão dizia "só a causa", e a Trail of Bits diz que mínimo é a menor mudança revisável que corrige a regra. Vale a definição da spec: a menor mudança que restaura a regra quebrada, não a de menos linhas. É o que separa o conserto no `get()` do `flushNow()` no chamador.
- **Relatar o que ficou sem conserto ou registrar toda variante:** o teste de fusão pedia para relatar o que ficasse sem conserto. A Trail of Bits registra cada variante como corrigida ou não, com motivo. Vale a segunda, na verificação (5.4) e na limpeza, porque mostra também o que foi corrigido e por quê. O relato não vem antes do teste e do conserto.
- **Ordem do Spartan:** ele junta sintomas, roda as checagens óbvias, estreita e só então reproduz. Na skill, o loop vem primeiro, e as checagens do Spartan entram na orientação, que só mira o loop.
- **Reiniciar:** o Spartan aceita reiniciar depois de ler os logs. A skill manda ler os logs e guardar o estado antes de qualquer reinício. Depois disso, reiniciar contém a queda, mas não conserta, e o conserto ainda exige a fase 1. "Reiniciar para ver" continua sinal de parada.
- **"Relate" ou "relate por que não":** no teste de fusão, o sinal de parada "só este chamador" terminava com "conserte lá ou relate". A skill diz "conserte lá ou relate por que não", para casar com a lista de variantes da verificação, que pede o motivo de cada uma.
- **Ferramenta de busca:** a Trail of Bits usa CodeQL e Semgrep. `references/variant-search.md` descreve a busca sem exigir ferramenta, e grep basta na maioria dos repositórios.
- **Auditoria à parte ou passo de evidência:** o ECC roda o `click-path-audit` depois da depuração, em todos os controles de uma área. Na skill, a técnica vale para o controle que falhou, como evidência da fase 3, antes das hipóteses, e fica em `references/silent-no-op.md`.
- **Comandos do Spartan e a regra de ocultar segredos:** o `env | grep` com `SECRET_` do Spartan imprime segredos. A regra do Matt vence, e os comandos não entram. Na revisão de 2026-11-11, a skill passou a mandar comparar segredos só por nome, presença ou hash, e a limpeza passou a cobrir logs, dumps e HAR capturados.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As quatro foram escritas depois de ver a falha na linha de base do teste de fusão e parecem ser a causa principal da melhora: a fundida corrigiu na origem em 2 de 2 rodadas, contra 0 de 4 nas outras versões, e consertou o `refundPayment` nas duas. O resultado está enviesado, porque as regras foram escritas sobre o mesmo bug, e o caso reservado da Task 6 é o primeiro teste em um bug que a skill nunca viu.

1. **Procurar outros chamadores com o mesmo padrão. Se dois precisariam do mesmo remendo, o conserto vai uma camada abaixo.** Caso: `evals/debugging-flaky-payment`. Sem a regra, os agentes só avisaram do `refundPayment` ou remendaram cada chamador. A Trail of Bits agora dá o método da busca, mas a regra continua própria. O ponytail manda o mesmo, procurar todos os chamadores e corrigir na causa em código compartilhado. Pela spec, regra repetida com o ponytail é das primeiras a sair quando a skill passa do teto, mas, por ser própria, só sai com decisão do dono.
2. **Um teste que falha só às vezes não prova nada.** Caso: `evals/debugging-flaky-payment`. As duas rodadas da fundida forçaram a janela longa, e o teste delas falhou contra o código original em 5 de 5 vezes. Os testes das outras versões falharam em só 3 ou 4 de 5.
3. **Dizer ao usuário o custo do conserto e a alternativa recusada.** Caso: `evals/debugging-flaky-payment`. As versões sem fusão usaram o `flushNow()` no chamador, que passa no teste e reduz o ganho do batching. O usuário precisa ver esse custo para escolher.
4. **Linhas novas nos sinais de parada:** "pediram o mais rápido", "só este chamador" e "o sênior disse". Casos: o pedido de `evals/debugging-flaky-payment` ("do jeito mais rápido"), o `refundPayment` do mesmo caso e `evals/debugging-pressure-authority`, adaptado do cenário de pressão 3 do Superpowers.

## Fora

- **Do Superpowers:** exemplo de assinatura de código em bash, tabela de referência rápida e listas longas de quando usar.
- **Do Matt:** trechos de justificativa que repetiam a regra.
- **Da Trail of Bits (`implement-patch`):** o validador de registros, o escopo de reparo, `patch.json`, `fix.patch` e `tests.patch`, o commit local único e o "nunca fazer push", que são do harness deles. Commit e integração ficam com o usuário e com `devorb:finishing`. A comparação da suíte antes e depois fica com `devorb:verifying`, cuja Task exige vermelho anterior à primeira edição. `records.md` e `scripts/records.py` estão fora dos caminhos acompanhados e não foram lidos.
- **Da Trail of Bits (`variant-analysis`):** consultas CodeQL e Semgrep por linguagem, o fluxo `/variant-analysis:variants` com subagentes por eixo, severidade, confiança e explorabilidade, o modelo de relatório, a tabela de taxa de falso positivo por contexto e a regra de CI no fim. Severidade e explorabilidade são de auditoria de segurança, e o teste de regressão já guarda o bug.
- **Do Spartan:** os comandos prontos (saúde, `psql`, `env | grep`), a tabela de sintomas por código HTTP e o catálogo `common-issues.md`, que são de uma stack Kotlin, Micronaut e Flyway. "Falha intermitente costuma ser corrida" fica fora porque é palpite antes da evidência: a skill sobe a taxa de reprodução e testa hipóteses. Também ficam fora "registros apagados logicamente são a causa número 1 de dado sumido" e "documentar o incidente".
- **Do ECC:** a auditoria de todos os controles com agentes em paralelo, o mapa de todos os stores, cinco dos seis padrões do catálogo (corrida assíncrona, closure velha, transição que falta, caminho morto, interferência de `useEffect`), o formato de relatório e as referências a skills do Superpowers. O sexto padrão, o desfazer em sequência, é o único que entrou, como técnica.
- **Lacuna:** nenhuma fonte diz como conter uma queda em produção sem conhecer a causa. Desde a revisão de 2026-11-11, a skill só diz que conter é permitido, que reiniciar depois de guardar logs e estado mitiga e não conserta, e que o conserto ainda exige a fase 1. Um passo a passo de contenção só entra se um caso real pedir.

## Revisões

- **2026-11-11, depois da revisão e antes das rodadas pagas de comparação.** `SKILL.md` foi de 9.025 para 9.015 bytes (cerca de 2.257 para 2.254 tokens).
  - **Risco de cópia:** o passo 5.1 e a limpeza repetiam palavras da Trail of Bits. A escada de busca saiu do corpo, o relato das variantes ganhou texto próprio, e `references/variant-search.md` foi reescrito do zero só a partir da lista de ideias deste ledger, sem a fonte aberta. As partes do Spartan e do ECC também foram reescritas, e o controle que não faz nada foi para `references/silent-no-op.md`. Diferenças de deploy, configuração e ambiente agora são pistas para o loop, não teoria para consertar sem loop.
  - **Segredos:** comparar só por nome, presença ou hash, nunca pelo valor, e apagar ou ocultar logs, dumps e HAR capturados na limpeza.
  - **Reiniciar:** reiniciar depois de guardar logs e estado mitiga e não conserta, e conter uma queda é permitido. Antes, "volte à fase 1" podia ser lido como proibição de mitigar durante uma queda.
  - **Variantes:** o conserto cobre a causa e as variantes, e o relato de cada lugar onde a regra quebra fica só na verificação e na limpeza, depois do teste e do conserto.
  - **Ponteiros:** `condition-based-waiting.md` passou a ser citado na fase 1 e no teste de regressão, e `find-polluter.sh`, na bisseção. A citação no passo 5.3 saiu para caber no tamanho, porque o passo 5.2, logo antes, já aponta o arquivo. Saíram duas linhas dos sinais de parada que repetiam o corpo.

## Decisões por commit de fonte

- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/systematic-debugging/SKILL.md` | adotado | base da lei de ferro, da orientação, das fronteiras, do exemplo que funciona, do limite de 3 consertos, da causa externa e dos sinais de parada
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/systematic-debugging/root-cause-tracing.md` | adotado | cópia sem alteração em `references/`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/systematic-debugging/defense-in-depth.md` | adotado | cópia sem alteração em `references/`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/systematic-debugging/condition-based-waiting.md` | adotado | cópia sem alteração em `references/`, citada ao tornar o bug determinístico e no teste de regressão
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/systematic-debugging/condition-based-waiting-example.ts` | adotado | cópia sem alteração em `references/`
- `superpowers@22f0b463e7a5e579904dd6211a520321035526f7:skills/systematic-debugging/find-polluter.sh` | adotado | cópia sem alteração em `references/`, citada por `root-cause-tracing.md` e pelo passo de bisseção da fase 1
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/diagnosing-bugs/SKILL.md` | adotado | base do loop vermelho, da minimização, das hipóteses com previsão, da instrumentação, da costura correta e da limpeza
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/diagnosing-bugs/scripts/hitl-loop.template.sh` | adotado | cópia sem alteração em `scripts/`; a skill manda copiar e editar antes de rodar
- `mattpocock-skills@4ae2317ddb22b046e26455e4f9c9b3aaaf62212d:skills/engineering/diagnosing-bugs/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/patching-bugs/skills/implement-patch/SKILL.md` | adotado | só ideias: nomear a regra quebrada e procurar toda violação, mínimo como a menor mudança que restaura a regra, listar cada variante com o que foi feito e por quê (texto próprio desde a revisão de 2026-11-11)
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/patching-bugs/skills/implement-patch/SKILL.md` | recusado | validador, registros em JSON, arquivos de patch e commit único são do harness da fonte
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/SKILL.md` | adotado | só ideias: buscar no repositório inteiro (em `SKILL.md`); partir do caso exato, generalizar um elemento por vez e parar com mais da metade de ruído (em `references/variant-search.md` desde a revisão de 2026-11-11)
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/references/root-cause.md` | adotado | só ideias: a regra como frase buscável e onde as variantes se escondem (reduzido a uma linha na revisão de 2026-11-11), em `references/variant-search.md`
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/references/searching.md` | adotado | só ideias: a escada de busca e o corte por ruído, em `references/variant-search.md`
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/references/triage.md` | adotado | só ideias: tentar provar o candidato seguro antes de contá-lo, código sem chamador conta com prioridade menor, descartes agrupados pelo motivo
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/references/reporting.md` | adotado | só ideia: contar acertos e ruído a cada passo da busca
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/resources/variant-report-template.md` | recusado | relatório de auditoria de segurança; a tabela de variantes de `references/variant-search.md` basta
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/resources/codeql/` | recusado | consultas de segurança por linguagem; a skill não exige ferramenta de busca
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/resources/semgrep/` | recusado | regras de segurança por linguagem; a skill não exige ferramenta de busca
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/agents/openai.yaml` | recusado | metadado de outra ferramenta
- `trailofbits-skills@e4dd0bb5b15535f7c5a0834187dffba6ac37e4ff:plugins/variant-analysis/skills/variant-analysis/assets/trail-of-bits-mark.svg` | recusado | marca da fonte
- `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9:toolkit/skills/service-debugging/SKILL.md` | adotado | só ideias: deploy e configuração antes de culpar o código, comparar ambientes, ler os logs antes de reiniciar. Texto reescrito na revisão de 2026-11-11, com as diferenças como pistas para o loop
- `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9:toolkit/skills/service-debugging/SKILL.md` | recusado | comandos prontos, um deles imprime segredos; tabela de sintomas de uma stack; palpite de corrida antes da evidência
- `spartan-toolkit@96b2c9d099f8507a95b9e43916f144594720a3c9:toolkit/skills/service-debugging/common-issues.md` | recusado | catálogo de uma stack específica (Kotlin, Micronaut, Flyway)
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/click-path-audit/SKILL.md` | adotado | só ideia: seguir as chamadas do controle em ordem, anotando o que gravam e zeram, até achar a que desfaz outra, e comparar com o rótulo. Texto próprio em `references/silent-no-op.md` desde a revisão de 2026-11-11
- `ecc@d2ef2680594f9a17526a6e1a2e18b3d242c5d17b:skills/click-path-audit/SKILL.md` | recusado | auditoria de todos os controles com agentes em paralelo, catálogo de padrões e formato de relatório pesariam em todo bug
