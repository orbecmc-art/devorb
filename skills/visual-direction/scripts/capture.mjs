import { parseArgs as parseCli } from 'node:util';
import { mkdirSync, writeFileSync, readdirSync, existsSync, rmSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { headingRatio } from '../../ui-review/scripts/rules.mjs';
import { shootPage } from '../../ui-review/scripts/shoot.mjs';

const USAGE = 'usage: node capture.mjs <url> <projectRoot> [--slug s] [--pw <dir>] [--dry-run]';
const MOVEMENT = 'Movimento observado: <preencher olhando os prints e a página>';
const kebab = (s) => s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
const uniq = (xs) => [...new Set(xs)];

export function slugFromUrl(url) {
  const u = new URL(url);
  const last = u.pathname.split('/').filter(Boolean).at(-1) ?? '';
  const host = u.hostname.replace(/^www\./, '').split('.');
  if (host.length > 1) host.pop(); // drop the TLD
  return kebab(`${host.join(' ')} ${last.replace(/\.\w+$/, '')}`) || 'ref';
}

export function buildTokens(m) {
  const key = (t) => [t.role, t.fontSize, t.lineHeight, t.fontWeight, t.letterSpacing, t.fontFamily].join('|');
  const seen = new Set();
  const type = [];
  for (const { role, fontSize, lineHeight, fontWeight, letterSpacing, fontFamily } of m.text) {
    const t = { role, fontSize, lineHeight, fontWeight, letterSpacing, fontFamily };
    if (!seen.has(key(t))) type.push(t), seen.add(key(t));
  }
  return {
    type,
    textColors: m.textColors,
    sectionBgs: uniq(m.sections.filter((s) => !s.hidden).map((s) => s.bg)),
    spacing: uniq(m.spacing).sort((a, b) => a - b),
    headingRatio: headingRatio(m)
  };
}

export function sectionsMarkdown(m1440, m390) {
  const vis = (m) => m.sections.filter((s) => !s.hidden);
  const share = (xs, i) => {
    const page = xs.at(-1).top + xs.at(-1).height;
    return xs[i] ? `${Math.round((xs[i].height / page) * 100)}%` : '—';
  };
  const [a, b] = [vis(m1440), vis(m390)];
  const rows = a.map((s, i) => `${i + 1}. ${share(a, i)} · fundo ${s.bg} · títulos: ${s.headings.map((h) => `"${h}"`).join(' / ')} · 390: ${b.length ? share(b, i) : '—'}`);
  return [...rows, MOVEMENT].join('\n') + '\n';
}

async function main(argv) {
  const { values: v, positionals: [url, root] } = parseCli({ args: argv, allowPositionals: true, options: { slug: { type: 'string' }, pw: { type: 'string' }, 'dry-run': { type: 'boolean' } } });
  if (!url || !root) {
    console.error(USAGE);
    return 1;
  }
  const base = join(root, 'design', 'referencias');
  const existing = existsSync(base) ? readdirSync(base, { withFileTypes: true }).filter((d) => d.isDirectory()).map((d) => d.name).sort() : [];
  const slug = kebab(v.slug ?? '') || slugFromUrl(url);
  if (existing.length >= 3 && !existing.includes(slug)) {
    console.log(`MAX 3 referências: ${existing.join(', ')}`);
    return 4;
  }
  const dir = join(base, slug);
  const isNew = !existsSync(dir);
  const meta = (m) => {
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, 'url.txt'), url + '\n');
    if (!existsSync(join(dir, 'notas.md'))) writeFileSync(join(dir, 'notas.md'), '## Levar\n\n## Não levar\n'); // keep the user's notes
    writeFileSync(join(dir, 'tokens.json'), m ? JSON.stringify(buildTokens(m[1440]), null, 2) : '{}\n');
    writeFileSync(join(dir, 'secoes.md'), m ? sectionsMarkdown(m[1440], m[390]) : `(dry-run: sem navegador)\n${MOVEMENT}\n`);
  };
  if (v['dry-run']) return meta(null) ?? 0;
  try {
    // a FAIL in the floor checks is not an error here: the reference is data, not under review
    meta(await shootPage(url, dir, { widths: [1440, 390], pw: v.pw }));
    return 0;
  } catch (e) {
    if (isNew) rmSync(dir, { recursive: true, force: true }); // a failed run must not use up a pack slot
    if (e.code !== 'NEED_PLAYWRIGHT') throw e;
    console.log(e.message);
    return 3;
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await main(process.argv.slice(2));
}
