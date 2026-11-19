import { parseArgs as parseCli } from 'node:util';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const USAGE = 'usage: node draw.mjs --fits <id,…> --count <n> [--specs <dir>]';
const REFS = fileURLToPath(new URL('../references/', import.meta.url));
const HEADER = /^### `(hero|section):([a-z0-9-]+)`/gm;
const ID = /\b(hero|section):[a-z0-9-]+/g;

export const patternIds = (markdown) => [...markdown.matchAll(HEADER)].map((m) => `${m[1]}:${m[2]}`);

// texts in chronological order; an id moves to the end each time it appears again
export function usedIds(texts) {
  const order = new Set();
  for (const id of texts.flatMap((t) => t.match(ID) ?? [])) order.delete(id), order.add(id);
  return [...order];
}

export function draw(fits, used, count, rand = Math.random) {
  const fresh = fits.filter((id) => !used.includes(id));
  for (let i = fresh.length - 1; i > 0; i--) {
    const j = Math.floor(rand() * (i + 1));
    [fresh[i], fresh[j]] = [fresh[j], fresh[i]];
  }
  return [...fresh, ...used.filter((id) => fits.includes(id))].slice(0, count);
}

function main(argv) {
  const { values: v } = parseCli({ args: argv, options: { fits: { type: 'string' }, count: { type: 'string' }, specs: { type: 'string', default: 'docs/devorb/specs' } } });
  const count = Number(v.count);
  if (!v.fits || !Number.isInteger(count) || count < 1) {
    console.error(USAGE);
    return 1;
  }
  const fits = v.fits.split(',').map((s) => s.trim()).filter(Boolean);
  const known = ['hero-patterns.md', 'section-patterns.md'].flatMap((f) => patternIds(readFileSync(REFS + f, 'utf8')));
  const unknown = fits.filter((id) => !known.includes(id));
  if (unknown.length) {
    for (const id of unknown) console.error(`UNKNOWN: ${id}`);
    return 1;
  }
  const files = existsSync(v.specs) ? readdirSync(v.specs, { withFileTypes: true }).filter((d) => d.isFile() && d.name.endsWith('.md')).map((d) => d.name).sort() : [];
  const used = usedIds(files.map((f) => readFileSync(join(v.specs, f), 'utf8')));
  for (const id of draw(fits, used, count)) console.log(id);
  return 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = main(process.argv.slice(2));
}
