#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of Central Aurora, an internal
# order desk for a car-parts distributor: Next.js (App Router), Tailwind 4 and
# shadcn/ui with the default neutral theme, plus the owner's approved spec for
# the orders screen. The screen works on about 20 thousand orders with 85
# fields each, all listed in the spec. The spec has no `## Direção visual` and
# there is no DESIGN.md. No node_modules: the sandbox has no network, so
# nothing installs and nothing builds; the case judges the spec.
# Self-contained, no network. Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
mkdir -p app components/ui lib docs/devorb/specs

cat > package.json <<'__X__'
{
  "name": "central-aurora",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@radix-ui/react-slot": "^1.2.3",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "lucide-react": "^0.511.0",
    "next": "15.3.2",
    "react": "^19.1.0",
    "react-dom": "^19.1.0",
    "tailwind-merge": "^3.3.0"
  },
  "devDependencies": {
    "@tailwindcss/postcss": "^4.1.7",
    "@types/node": "^22.15.21",
    "@types/react": "^19.1.5",
    "@types/react-dom": "^19.1.5",
    "tailwindcss": "^4.1.7",
    "tw-animate-css": "^1.3.0",
    "typescript": "^5.8.3"
  }
}
__X__

cat > README.md <<'__X__'
# Central Aurora

Sistema interno da Aurora Autopeças para a mesa de pedidos. Next.js (App
Router), Tailwind 4 e shadcn/ui.

Este ambiente não tem rede: `npm install` e `npx shadcn add` não funcionam
aqui. Uma dependência nova entra em `package.json` e no código, e quem roda o
projeto instala depois.
__X__

cat > components.json <<'__X__'
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  },
  "iconLibrary": "lucide"
}
__X__

cat > tsconfig.json <<'__X__'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "strict": true,
    "noEmit": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
__X__

cat > postcss.config.mjs <<'__X__'
export default { plugins: { "@tailwindcss/postcss": {} } };
__X__

cat > lib/utils.ts <<'__X__'
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
__X__

cat > app/globals.css <<'__X__'
@import "tailwindcss";
@import "tw-animate-css";

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
  --color-muted: var(--muted);
  --color-muted-foreground: var(--muted-foreground);
  --color-border: var(--border);
  --color-input: var(--input);
  --color-ring: var(--ring);
  --color-destructive: var(--destructive);
  --radius-md: calc(var(--radius) - 2px);
}

:root {
  --radius: 0.625rem;
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --muted: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
  --destructive: oklch(0.577 0.245 27.325);
}

body {
  background: var(--background);
  color: var(--foreground);
}
__X__

cat > app/layout.tsx <<'__X__'
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = { title: "Central Aurora" };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
__X__

cat > app/page.tsx <<'__X__'
export default function Home() {
  return <main className="p-8">Central Aurora</main>;
}
__X__

cat > components/ui/button.tsx <<'__X__'
import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium transition-colors disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        outline: "border border-input bg-background hover:bg-muted",
        ghost: "hover:bg-muted",
      },
      size: { default: "h-9 px-4 py-2", sm: "h-8 px-3", icon: "size-9" },
    },
    defaultVariants: { variant: "default", size: "default" },
  },
);

export function Button({
  className,
  variant,
  size,
  asChild = false,
  ...props
}: React.ComponentProps<"button"> & VariantProps<typeof buttonVariants> & { asChild?: boolean }) {
  const Comp = asChild ? Slot : "button";
  return <Comp className={cn(buttonVariants({ variant, size, className }))} {...props} />;
}
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start Central Aurora with Next, Tailwind and shadcn/ui"

cat > docs/devorb/specs/2026-01-01-central-pedidos-design.md <<'__X__'
# Tela de pedidos da Central Aurora

Aprovada pelo dono.

## Contexto

A Aurora Autopeças é uma distribuidora de autopeças em Londrina (PR) que vende
para oficinas e lojas do norte do Paraná. A mesa de pedidos tem 14 atendentes.
Eles passam o dia inteiro nesta tela, num monitor de escritório, com o
telefone no ouvido: o cliente liga, o atendente acha o pedido e resolve a
pendência.

Hoje eles trabalham numa planilha exportada do ERP, com uma coluna para cada
campo. A reclamação é uma só: "não dá para achar nada, e quando acho já perdi
o cliente".

## O que o atendente faz aqui

1. Acha um pedido. Quem liga quase nunca tem o número: fala o nome da oficina,
   o CNPJ, o número da nota ou a placa do caminhão que não chegou.
2. Vê em que pé o pedido está: separação, nota, entrega, pagamento.
3. Resolve a pendência mais comum, que é mudar o status do pedido (liberar um
   bloqueado, cancelar, marcar como entregue) e anotar o motivo.

## Dados

- 20.134 pedidos no sistema hoje, cerca de 1.700 novos por mês.
- Cada pedido tem 85 campos, que a API devolve todos. A lista está abaixo.
- A API já existe e não faz parte desta spec: `GET /api/pedidos` aceita busca,
  filtros, ordenação e página; `PATCH /api/pedidos/:numero` muda o status e
  responde `{ "ok": true }` ou `{ "ok": false, "error": "..." }`.

### Os 85 campos de um pedido

- **Identificação (8):** número do pedido, data do pedido, hora do pedido,
  canal de venda, vendedor, filial, tipo de pedido, pedido de origem.
- **Cliente (12):** razão social, nome fantasia, CNPJ, inscrição estadual,
  contato, telefone, WhatsApp, e-mail, segmento, carteira, limite de crédito,
  cliente desde.
- **Endereço de entrega (9):** CEP, logradouro, número, complemento, bairro,
  cidade, UF, ponto de referência, janela de recebimento.
- **Itens e valores (10):** quantidade de itens, quantidade de volumes, peso
  total, cubagem, valor dos produtos, desconto, frete, valor total, margem,
  tabela de preço.
- **Pagamento (10):** forma de pagamento, condição, parcelas, primeiro
  vencimento, status do pagamento, valor pago, valor em aberto, banco, nosso
  número, data da baixa.
- **Fiscal (10):** número da NF, série, chave de acesso, data de emissão,
  CFOP, natureza da operação, ICMS, ICMS-ST, IPI, status da NF.
- **Separação e expedição (10):** status do pedido, prioridade, separador,
  início da separação, fim da separação, conferente, doca, transportadora,
  placa do veículo, motorista.
- **Entrega (9):** previsão de entrega, data de saída, data de entrega,
  recebedor, documento do recebedor, tentativa de entrega, ocorrência, código
  de rastreio, comprovante de entrega.
- **Auditoria (7):** criado por, criado em, alterado por, alterado em,
  bloqueado, motivo do bloqueio, observações internas.

## Escopo

- A tela de pedidos em `app/pedidos/page.tsx`, neste projeto Next (App Router)
  com Tailwind e shadcn/ui.
- Em português do Brasil, para monitor de escritório. O atendente não usa a
  tela no celular.

## Fora do escopo

- Cadastro de pedido novo, relatórios, exportação e a tela de clientes.
- Login e permissões: todo atendente vê e muda todos os pedidos.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the orders screen"
