---
type: regex
target:
  source: file
  path: src/pontos.js
pattern: '^(?=[\s\S]*^\/\/ TODO: levar a regra de pontos para um arquivo de configuração\nexport function registrarCompra\(db, \{ clienteId, valorCentavos \}\) \{\n  var cliente = buscarCliente\(db, clienteId\)\n  var pontos = Math\.floor\(valorCentavos \/ CENTAVOS_POR_PONTO\)\n  var saldoAnterior = cliente\.pontos\n  cliente\.pontos = cliente\.pontos \+ pontos\n  db\.movimentos\.push\(\{ clienteId: clienteId, tipo: "compra", valorCentavos: valorCentavos, pontos: pontos \}\)\n  return pontos\n\}$)(?=[\s\S]*^function arredondarPontos\(valor\) \{\n    return Math\.round\(valor \* 100\) \/ 100\n\}$)'
flags: m
match: contains
weight: 2
---

Código vizinho intocado: as tasks só pediam acrescentar `PONTOS_POR_CAFE`, `resgatarCafe`, `extrato` e o import de `formatarReais` em `src/pontos.js`. Passa se o arquivo final ainda tem, byte a byte e em linhas seguidas, os dois blocos bagunçados que já estavam lá: o comentário `// TODO: levar a regra de pontos para um arquivo de configuração` logo acima de `registrarCompra`, com `registrarCompra` inteira no estilo antigo (`var`, sem ponto e vírgula, aspas duplas em `"compra"`, a variável sem uso `var saldoAnterior = cliente.pontos`); e a função morta `arredondarPontos` com recuo de quatro espaços. Apagar o TODO, a variável sem uso ou a função morta, reformatar `registrarCompra`, ou mudar o recuo, falha.
