import { parseArgs as parseCli } from 'node:util';
import { mkdirSync, writeFileSync, readFileSync, readdirSync, existsSync, rmSync, renameSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { headingRatio } from '../../ui-review/scripts/rules.mjs';
import { shootPage } from '../../ui-review/scripts/shoot.mjs';

const USAGE = 'usage: node capture.mjs <url> <projectRoot> [--slug s] [--pw <dir>] [--dry-run]';
const MOVEMENT = 'Movimento observado: <preencher olhando os prints e a página>';
const DRY_SECOES = `(dry-run: sem navegador)\n${MOVEMENT}\n`;
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

// line N is section N, the same N as section-N.png, even past a hidden section
export function sectionsMarkdown(m1440, m390) {
  const share = (m, s) => {
    if (!s || s.hidden) return '—';
    const last = m.sections.at(-1);
    return `${Math.round((s.height / (last.top + last.height)) * 100)}%`;
  };
  const titles = (s) => s.headings.map((h) => `"${h.replace(/\s+/g, ' ').trim()}"`).join(' / ');
  const rows = m1440.sections.filter((s) => !s.hidden).map((s) => `${s.index}. ${share(m1440, s)} · fundo ${s.bg} · títulos: ${titles(s)} · 390: ${share(m390, m390.sections[s.index])}`);
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
  const urlFile = join(dir, 'url.txt');
  const oldUrl = existsSync(urlFile) ? readFileSync(urlFile, 'utf8').trim() : url;
  if (oldUrl !== url) {
    console.log(`SLUG OCUPADO: ${slug} guarda ${oldUrl}, não ${url}; use outro --slug`);
    return 5;
  }
  // write the pack files without clobbering hand-written work: notes and section lines stay, a dry run keeps tokens
  const meta = (m) => {
    mkdirSync(dir, { recursive: true });
    writeFileSync(urlFile, url + '\n');
    const keep = (name) => existsSync(join(dir, name));
    if (!keep('notas.md')) writeFileSync(join(dir, 'notas.md'), '## Levar\n\n## Não levar\n');
    if (m || !keep('tokens.json')) writeFileSync(join(dir, 'tokens.json'), m ? JSON.stringify(buildTokens(m[1440]), null, 2) : '{}\n');
    const secoes = join(dir, 'secoes.md');
    if (!keep('secoes.md') || (m && readFileSync(secoes, 'utf8') === DRY_SECOES)) writeFileSync(secoes, m ? sectionsMarkdown(m[1440], m[390]) : DRY_SECOES);
  };
  if (v['dry-run']) return meta(null) ?? 0;
  const tmp = join(dir, '.shoot-tmp'); // shots land here, and replace 1440/ and 390/ only once all of them succeed
  try {
    // a FAIL in the floor checks is not an error here: the reference is data, not under review
    const m = await shootPage(url, tmp, { widths: [1440, 390], pw: v.pw });
    for (const w of ['1440', '390']) {
      rmSync(join(dir, w), { recursive: true, force: true });
      renameSync(join(tmp, w), join(dir, w));
    }
    meta(m);
    return 0;
  } catch (e) {
    if (isNew) rmSync(dir, { recursive: true, force: true }); // a failed run must not use up a pack slot
    if (e.code !== 'NEED_PLAYWRIGHT') throw e;
    console.log(e.message);
    return 3;
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await main(process.argv.slice(2));
}
