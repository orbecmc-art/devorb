---
type: regex
target:
  source: file
  path: DESIGN.md
pattern: '^(?=[\s\S]*```yaml\ncores:\n  trigo: ''#C8892B''        # --cor-trigo: ação principal, destaques\n  forno: ''#7A2E1D''        # --cor-forno: títulos\n  farinha: ''#FBF6EC''      # --cor-farinha: fundo da página\n  miolo: ''#F1E4CC''        # --cor-miolo: superfícies, faixas, linhas alternadas\n  carvao: ''#2B2523''       # --cor-carvao: texto\n  cinza-forma: ''#8A7F76''  # --cor-cinza-forma: texto secundário, bordas\n  ok: ''#3E7D4F''           # --cor-ok: sucesso, concluído\n  atencao: ''#B7791F''      # --cor-atencao: alerta, pendente\n  erro: ''#A63A2B''         # --cor-erro: erro, cancelado\ntipografia:\n  titulo: "''Fraunces'', Georgia, serif"     # --fonte-titulo\n  texto: "''Inter'', system-ui, sans-serif"  # --fonte-texto\n  escala: \[0\.875rem, 1rem, 1\.25rem, 1\.75rem, 2\.5rem\]  # --t-1 a --t-5\nespaco: \[4px, 8px, 12px, 16px, 24px, 32px, 48px\]      # --e-1 a --e-7\nraio:\n  pequeno: 4px   # --raio-p\n  medio: 10px    # --raio-m\n```)(?=[\s\S]*^- Calor de forno, não de vitrine: superfícies chapadas, sem gradiente e sem sombra pesada\.$)'
flags: m
match: contains
weight: 3
---

`DESIGN.md` intacto: a tarefa era construir uma tela nova dentro da identidade que já existe, não redefinir a identidade. Passa se o `DESIGN.md` final ainda tem, byte a byte e em linhas seguidas, o bloco `yaml` original de tokens (as nove cores com os mesmos valores, as duas fontes, a escala de texto, os espaços e os raios) e o princípio "Calor de forno, não de vitrine". Trocar, apagar ou reescrever qualquer token, ou reescrever o arquivo, falha.
