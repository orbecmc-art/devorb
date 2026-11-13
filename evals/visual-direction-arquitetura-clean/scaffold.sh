#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of a Next.js (App Router)
# site with Tailwind 4 and shadcn/ui (button, input and card in
# components/ui/, default neutral theme in app/globals.css) for Atelier Linha,
# an architecture office in Curitiba, plus the owner's approved spec for a
# "bem clean" landing page with a newsletter signup. The newsletter route
# already exists in app/api/newsletter/route.ts. package.json has no toast
# library. No node_modules: the sandbox has no network, so nothing installs
# and nothing builds; the case judges the files.
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
mkdir -p app/api/newsletter components/ui lib public docs/devorb/specs

cat > package.json <<'__X__'
{
  "name": "atelier-linha",
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
    "next": "15.3.3",
    "react": "^19.1.0",
    "react-dom": "^19.1.0",
    "tailwind-merge": "^3.3.0"
  },
  "devDependencies": {
    "@tailwindcss/postcss": "^4.1.8",
    "@types/node": "^22.15.29",
    "@types/react": "^19.1.6",
    "@types/react-dom": "^19.1.5",
    "tailwindcss": "^4.1.8",
    "tw-animate-css": "^1.3.3",
    "typescript": "^5.8.3"
  }
}
__X__
cat > .gitignore <<'__X__'
node_modules/
.next/
__X__
cat > README.md <<'__X__'
# Atelier Linha

Site do Atelier Linha, escritório de arquitetura em Curitiba. Next.js (App
Router), Tailwind 4 e shadcn/ui.

Este ambiente não tem rede: `npm install` e `npx shadcn add` não funcionam
aqui. Uma dependência nova entra em `package.json` e no código, e quem roda o
projeto instala depois.
__X__
cat > tsconfig.json <<'__X__'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
__X__
cat > next.config.ts <<'__X__'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {};

export default nextConfig;
__X__
cat > postcss.config.mjs <<'__X__'
const config = { plugins: ["@tailwindcss/postcss"] };

export default config;
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
cat > lib/utils.ts <<'__X__'
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
__X__
cat > components/ui/button.tsx <<'__X__'
import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90",
        outline: "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-9 px-4 py-2",
        sm: "h-8 rounded-md gap-1.5 px-3",
        lg: "h-10 rounded-md px-6",
        icon: "size-9",
      },
    },
    defaultVariants: { variant: "default", size: "default" },
  }
);

function Button({
  className,
  variant,
  size,
  asChild = false,
  ...props
}: React.ComponentProps<"button"> &
  VariantProps<typeof buttonVariants> & { asChild?: boolean }) {
  const Comp = asChild ? Slot : "button";
  return (
    <Comp
      data-slot="button"
      className={cn(buttonVariants({ variant, size, className }))}
      {...props}
    />
  );
}

export { Button, buttonVariants };
__X__
cat > components/ui/input.tsx <<'__X__'
import * as React from "react";

import { cn } from "@/lib/utils";

function Input({ className, type, ...props }: React.ComponentProps<"input">) {
  return (
    <input
      type={type}
      data-slot="input"
      className={cn(
        "flex h-9 w-full min-w-0 rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-xs outline-none transition-[color,box-shadow] placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
        "aria-invalid:border-destructive aria-invalid:ring-destructive/20",
        className
      )}
      {...props}
    />
  );
}

export { Input };
__X__
cat > components/ui/card.tsx <<'__X__'
import * as React from "react";

import { cn } from "@/lib/utils";

function Card({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="card"
      className={cn("flex flex-col gap-6 rounded-xl border bg-card py-6 text-card-foreground shadow-sm", className)}
      {...props}
    />
  );
}

function CardHeader({ className, ...props }: React.ComponentProps<"div">) {
  return <div data-slot="card-header" className={cn("grid gap-1.5 px-6", className)} {...props} />;
}

function CardTitle({ className, ...props }: React.ComponentProps<"div">) {
  return <div data-slot="card-title" className={cn("font-semibold leading-none", className)} {...props} />;
}

function CardDescription({ className, ...props }: React.ComponentProps<"div">) {
  return <div data-slot="card-description" className={cn("text-sm text-muted-foreground", className)} {...props} />;
}

function CardContent({ className, ...props }: React.ComponentProps<"div">) {
  return <div data-slot="card-content" className={cn("px-6", className)} {...props} />;
}

export { Card, CardHeader, CardTitle, CardDescription, CardContent };
__X__
cat > app/globals.css <<'__X__'
@import "tailwindcss";
@import "tw-animate-css";

@custom-variant dark (&:is(.dark *));

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --font-sans: var(--font-geist-sans);
  --color-card: var(--card);
  --color-card-foreground: var(--card-foreground);
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
  --color-secondary: var(--secondary);
  --color-secondary-foreground: var(--secondary-foreground);
  --color-muted: var(--muted);
  --color-muted-foreground: var(--muted-foreground);
  --color-accent: var(--accent);
  --color-accent-foreground: var(--accent-foreground);
  --color-destructive: var(--destructive);
  --color-border: var(--border);
  --color-input: var(--input);
  --color-ring: var(--ring);
  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 4px);
}

:root {
  --radius: 0.625rem;
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --card: oklch(1 0 0);
  --card-foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.97 0 0);
  --secondary-foreground: oklch(0.205 0 0);
  --muted: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --accent: oklch(0.97 0 0);
  --accent-foreground: oklch(0.205 0 0);
  --destructive: oklch(0.577 0.245 27.325);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
}

@layer base {
  * {
    @apply border-border outline-ring/50;
  }
  body {
    @apply bg-background text-foreground;
  }
}
__X__
cat > app/layout.tsx <<'__X__'
import type { Metadata } from "next";
import { Geist } from "next/font/google";
import "./globals.css";

const geistSans = Geist({ variable: "--font-geist-sans", subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Atelier Linha",
  description: "Escritório de arquitetura em Curitiba.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="pt-BR">
      <body className={`${geistSans.variable} antialiased`}>{children}</body>
    </html>
  );
}
__X__
cat > app/page.tsx <<'__X__'
export default function Home() {
  return (
    <main className="p-8">
      <p>Atelier Linha: site em construção.</p>
    </main>
  );
}
__X__
cat > app/api/newsletter/route.ts <<'__X__'
import { NextResponse } from "next/server";

// Signs an e-mail up to the monthly newsletter. The office's e-mail service
// reads the list; this route only validates and accepts.
export async function POST(request: Request) {
  const body = await request.json().catch(() => ({}));
  const email = typeof body?.email === "string" ? body.email.trim() : "";
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return NextResponse.json({ ok: false, error: "E-mail inválido." }, { status: 400 });
  }
  return NextResponse.json({ ok: true });
}
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the site with Next, Tailwind and shadcn/ui"

cat > docs/devorb/specs/2026-01-01-atelier-linha-design.md <<'__X__'
# Landing page do Atelier Linha

Aprovada pelo dono.

## Contexto

O Atelier Linha é um escritório de arquitetura residencial em Curitiba (PR),
das arquitetas Helena Prado e Marina Okada. Ele quer uma landing page que
apresente o escritório e os projetos a quem pensa em construir ou reformar a
casa.

O pedido do cliente, nas palavras dele: "quero um site bem clean, sóbrio, que
deixe os projetos falarem".

## Conteúdo confirmado

- Serviços: projeto residencial, reforma de interiores e acompanhamento de
  obra.
- Projetos (as fotos ainda não chegaram; chegam depois):
  - Casa Araucária, residência, 2024, 320 m².
  - Apartamento Batel, reforma de interiores, 2025, 140 m².
  - Casa do Lago, residência de campo, 2023, 410 m².
- Contato: contato@atelierlinha.example e Instagram @atelierlinha.

## Newsletter

Inscrição na newsletter "Cadernos do Atelier", um e-mail por mês. O formulário
pede só o e-mail e envia para `POST /api/newsletter` com o corpo
`{ "email": "..." }`. A rota já existe em `app/api/newsletter/route.ts`:
responde `{ "ok": true }` quando aceita e `{ "ok": false, "error": "..." }`
com status 400 quando o e-mail é inválido. Quando a inscrição dá certo, a
página confirma com um aviso na tela. Quando dá errado, diz o motivo.

O formulário fica em `components/newsletter-form.tsx`.

## Escopo

- A landing em `app/page.tsx`, neste projeto Next (App Router) com Tailwind e
  shadcn/ui.
- Em português do Brasil, funciona no celular e no computador.

## Fora do escopo

- Páginas internas de cada projeto, blog e área do cliente.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the landing page"
