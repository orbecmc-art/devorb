# Teste de fusão: depuração

Teste descartável. Junta `systematic-debugging` (Superpowers 7.0.2) e `diagnosing-bugs` (Matt Pocock 1.3.2) em uma skill só, a [SKILL.md](SKILL.md). Ela não faz parte de nenhum plugin ainda.

## Resultado no bug real

Cada agente recebeu o mesmo pedido, com pressão de tempo: um teste de pagamento instável e "só faz parar de falhar, do jeito mais rápido". A causa real é que `store.get()` não enxerga as escritas ainda na fila. O `refundPayment` sofre do mesmo defeito.

A pontuação foi medida depois, com um teste oculto, sem depender do relatório do agente.

| Versão | Rodadas | Corrigiu na origem | Consertou `refundPayment` | Falhas dos testes contra o código original |
|---|---:|---:|---:|---|
| Sem skill | 1 | 0 de 1 | 0 de 1 (só avisou) | 3 de 5 |
| Superpowers | 2 | 0 de 2 | 0 de 2 (só avisou) | 3 de 5 e 4 de 5 |
| Matt | 1 | 0 de 1 | 1 de 1 (nos dois chamadores) | 4 de 5 |
| Fundida | 2 | 2 de 2 | 2 de 2 | 5 de 5 e 5 de 5 |

As versões sem fusão usaram `flushNow()` no chamador, o que faz o teste passar mas reduz o ganho do batching. As duas rodadas da fundida corrigiram o `get()` e forçaram a janela longa para o teste falhar sempre.

## Resultado sob pressão

Cenários do próprio repositório do Superpowers, em que a opção A é a esperada.

| Cenário | Fundida | Superpowers |
|---|---|---|
| Autoridade: engenheiro sênior manda aplicar o conserto | A | não rodado |
| Queda em produção: US$ 15 mil por minuto | C e C | C |

No cenário de queda, nenhuma das duas escolheu o retry às cegas (opção B). As respostas propõem cerca de 5 minutos de verificação e reverter se aparecer uma mudança culpada.

## Tamanho

| Versão | Linhas | Palavras |
|---|---:|---:|
| Superpowers | 283 | 1.444 |
| Matt | 138 | 1.427 |
| Fundida | 120 | 1.333 |

As contagens são só do `SKILL.md`. Os arquivos de apoio (680 linhas) continuam na pasta, mas só são lidos quando a skill aponta para eles.

## De onde veio cada parte

| Parte da fundida | Origem |
|---|---|
| Regra de ferro, "violar a letra é violar o espírito" | Superpowers |
| Orientação rápida: erro completo e mudanças recentes | Superpowers |
| Log em cada fronteira entre componentes | Superpowers |
| Loop vermelho como primeira etapa, 10 formas de construir, critérios de conclusão | Matt |
| Minimizar a reprodução | Matt |
| Exemplo que funciona e rastrear o valor para trás | Superpowers |
| 3 a 5 hipóteses com previsão, mostradas ao usuário | Matt |
| Logs com prefixo, ramo de performance, limpeza final, ocultar segredos | Matt |
| Costura correta para o teste de regressão | Matt |
| Parar após 3 consertos e questionar a arquitetura | Superpowers |
| Saída para causa externa | Superpowers |
| Sinais do usuário de que você está supondo | Superpowers |
| Tabela de sinais de parada | Superpowers (19 itens viraram 12 linhas), mais os itens novos abaixo |

### Conflitos resolvidos

- **Uma hipótese ou várias:** o Superpowers pede uma para evitar consertos em rajada, e o Matt pede de 3 a 5 para evitar ancoragem. A fundida gera de 3 a 5 e testa uma variável por vez, o que atende aos dois objetivos.
- **Investigar ou construir o loop primeiro:** a orientação rápida do Superpowers serve só para mirar o loop do Matt. As teorias esperam o vermelho.
- **Teste de regressão sempre ou só com costura correta:** o teste vai na costura correta. Sem ela, isso é registrado como achado e o loop da fase 1 continua como prova.

### O que não está em nenhuma das fontes

Escrevi estes itens depois de ver a falha na linha de base. Eles parecem ser a causa principal da melhora.

- Procurar outros chamadores com o mesmo padrão. Se dois precisariam do mesmo remendo, o conserto vai uma camada abaixo.
- Um teste que falha só às vezes não prova nada.
- Dizer ao usuário o custo do conserto e a alternativa rejeitada.
- Linhas novas na tabela: "pediram o mais rápido", "só este chamador" e "o sênior disse".

### O que ficou de fora

- Do Superpowers: exemplo de assinatura de código em bash, tabela de referência rápida, listas longas de quando usar.
- Do Matt: trechos de justificativa que repetiam a regra.

## Limites deste teste

- **Poucas rodadas:** um único bug, de uma a duas rodadas por versão, modelo Sonnet. Indica, não prova.
- **Viés:** as regras novas foram escritas depois de ver a falha neste mesmo bug. Falta testar em um bug que a skill nunca viu.
- **Sem o ponytail:** os agentes rodaram sem ele. O ponytail já manda procurar todos os chamadores e corrigir a causa em código compartilhado, então parte do ganho pode já existir no Mac. Falta comparar com ele ligado.
- **Fases puladas, ao que parece:** os relatórios da fundida não mostram a lista de hipóteses. Em um bug pequeno, o agente foi direto da reprodução à causa.
- **Conexões ainda fictícias:** `devorb:tdd` e `devorb:verifying` são nomes reservados, e essas skills não existem.
- **Lacuna:** nenhuma das fontes diz como conter uma queda em produção sem conhecer a causa, e a fundida também não.
- **Custo:** foram 10 agentes e cerca de 830 mil tokens, a maior parte contexto fixo de cada agente.

## Licenças

As duas fontes são MIT. Os textos estão em [LICENSES](LICENSES). Os arquivos em `references/` e `scripts/` são cópias sem alteração.
