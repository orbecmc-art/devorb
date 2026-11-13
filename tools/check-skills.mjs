import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const MAX_BYTES = 20000;
const ALWAYS_ON_CAP = 706;
const LEGACY_NAMES = ['superpowers:', '/grill-me', 'setup-matt-pocock', 'docs/agents/', 'ready-for-agent', '.scratch/', '.superpowers/', 'docs/superpowers'];

export const approxTokens = (text) => Math.ceil(Buffer.byteLength(text, 'utf8') / 4);

const stripQuotes = (s) => s.trim().replace(/^(["'])(.*)\1$/, '$2');

function frontmatter(text) {
  const block = /^---\r?\n([\s\S]*?)\r?\n---/.exec(text)?.[1] ?? '';
  const field = (key) => {
    const m = new RegExp(`^${key}:[ \\t]*(.*)$`, 'm').exec(block);
    return m ? stripQuotes(m[1]) : undefined;
  };
  return {
    name: field('name'),
    description: field('description'),
    noModelInvocation: /^disable-model-invocation:[ \t]*true[ \t]*$/m.test(block),
  };
}

// Files that get scanned: every file in the skill folder, recursively.
function scannedFiles(dir) {
  const files = [];
  const walk = (sub, rel) => {
    for (const e of readdirSync(sub, { withFileTypes: true })) {
      const r = rel ? `${rel}/${e.name}` : e.name;
      if (e.isDirectory()) walk(join(sub, e.name), r);
      else files.push({ rel: r, path: join(sub, e.name) });
    }
  };
  walk(dir, '');
  return files;
}

export function checkSkills(root, registry) {
  const errors = [];
  const skillsDir = join(root, 'skills');
  const folders = existsSync(skillsDir)
    ? readdirSync(skillsDir, { withFileTypes: true }).filter((e) => e.isDirectory()).map((e) => e.name)
    : [];

  // Own keys only: `constructor` or `__proto__` must not look registered.
  const registered = (name) => Object.hasOwn(registry, name);

  for (const name of Object.keys(registry)) {
    if (registry[name].status === 'done' && !folders.includes(name)) {
      errors.push(`${name}: status done but folder missing`);
    }
    if (!Number.isFinite(registry[name].ceilingTokens)) errors.push(`${name}: missing ceilingTokens in registry`);
  }

  let alwaysOn = 0;
  for (const name of folders) {
    const entry = registered(name) ? registry[name] : undefined;
    if (!entry) {
      errors.push(`${name}: folder not in registry`);
      continue;
    }
    const skillPath = join(skillsDir, name, 'SKILL.md');
    if (!existsSync(skillPath)) {
      errors.push(`${name}: SKILL.md missing`);
      continue;
    }
    const text = readFileSync(skillPath, 'utf8');
    const fm = frontmatter(text);

    if (fm.name !== name) errors.push(`${name}: frontmatter name differs from folder`);

    const bytes = Buffer.byteLength(text, 'utf8');
    if (bytes >= MAX_BYTES) errors.push(`${name}: SKILL.md >= ${MAX_BYTES} bytes`);
    const tokens = approxTokens(text);
    if (tokens > entry.ceilingTokens) errors.push(`${name}: ${tokens} tokens > ${entry.ceilingTokens}`);

    if (!/^#{1,6}[ \t]+Connects to\b/m.test(text)) errors.push(`${name}: missing "Connects to" section`);

    if (entry.invocation === 'auto' && !(fm.description ?? '').startsWith('Use when')) {
      errors.push(`${name}: automatic skill description must start with "Use when"`);
    }
    if (entry.invocation === 'auto' && fm.noModelInvocation) {
      errors.push(`${name}: automatic skill must not set disable-model-invocation`);
    }
    if (entry.invocation === 'manual' && !fm.noModelInvocation) {
      errors.push(`${name}: manual skill needs disable-model-invocation: true`);
    }
    if (entry.invocation !== 'manual') alwaysOn += approxTokens((fm.name ?? '') + (fm.description ?? ''));

    const legacyFound = new Set();
    const refsFound = new Set();
    for (const f of scannedFiles(join(skillsDir, name))) {
      if (!existsSync(f.path)) continue;
      const content = readFileSync(f.path, 'utf8');
      if (f.rel !== 'references/legacy-names.md') {
        for (const l of LEGACY_NAMES) if (content.includes(l)) legacyFound.add(l);
      }
      for (const m of content.matchAll(/devorb:([a-z0-9-]+)/g)) refsFound.add(m[1]);
    }
    for (const l of legacyFound) errors.push(`${name}: legacy name ${l}`);
    for (const r of refsFound) if (!registered(r)) errors.push(`${name}: devorb:${r} not in registry`);
  }

  if (alwaysOn > ALWAYS_ON_CAP) errors.push(`always-on: ${alwaysOn} tokens > ${ALWAYS_ON_CAP}`);
  return errors;
}
