import { parseArgs } from 'node:util';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { isAbsolute, join, relative, resolve, sep } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { parseUrls } from './refs-check.mjs';
import { resolvePlaywright } from '../skills/ui-review/scripts/shoot.mjs';

const ROOT = fileURLToPath(new URL('..', import.meta.url));
const IN_PAGE = fileURLToPath(new URL('./motion-in-page.js', import.meta.url));
const SITES = ['aave', 'hoy', 'vercel', 'framer', 'raycast-keyboard'];
const READ_AFTER = 100;
const NEED = 'NEED: npm i --prefix <temp dir> playwright && npx --prefix <temp dir> playwright install chromium, then pass --pw <dir> with that folder';

const median = (xs) => {
  if (!xs.length) return null;
  const s = [...xs].sort((a, b) => a - b);
  const m = s.length >> 1;
  return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2;
};

export function staggerOf(delays) {
  const unique = [...new Set(delays)].sort((a, b) => a - b);
  if (unique.length < 2) return null;
  return median(unique.slice(1).map((d, i) => d - unique[i]));
}

export function summarize(samples) {
  const durations = samples.map((s) => s.duration);
  const counts = new Map();
  for (const s of samples) counts.set(s.easing, (counts.get(s.easing) ?? 0) + 1);
  return {
    count: samples.length,
    duration: { min: durations.length ? Math.min(...durations) : null, median: median(durations), max: durations.length ? Math.max(...durations) : null },
    easings: [...counts].sort((a, b) => b[1] - a[1]).slice(0, 5),
    staggerMs: staggerOf(samples.map((s) => s.delay))
  };
}

async function launch(chromium) {
  try {
    return await chromium.launch({ headless: true });
  } catch (e) {
    // no bundled browser: use the system Google Chrome instead of a 150 MB download
    if (!/Executable doesn't exist/i.test(e.message)) throw e;
    return chromium.launch({ headless: true, channel: 'chrome' }).catch(() => null);
  }
}

async function study(browser, url) {
  const context = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  await context.addInitScript({ path: IN_PAGE });
  const page = await context.newPage();
  const samples = [];
  const read = async (source) => samples.push(...(await page.evaluate((s) => window.__devorbMotion(s), source)));
  try {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
    // entrance animations start and end while the page loads: read often for the first 3 seconds
    for (let t = 0; t < 3000; t += READ_AFTER) {
      await read('load');
      await page.waitForTimeout(READ_AFTER);
    }
    // the wheel, not scrollTo, so smooth-scroll libraries and scroll-linked scripts see a real scroll
    for (let step = 0, last = -1; step < 80; step++) {
      const [y, end] = await page.evaluate(() => [scrollY, scrollY + innerHeight >= document.documentElement.scrollHeight - 2]);
      if (end || y === last) break;
      last = y;
      await page.mouse.wheel(0, 900 * 0.8);
      await page.waitForTimeout(READ_AFTER);
      await read('scroll');
    }
    await page.evaluate(() => scrollTo({ top: 0, behavior: 'instant' }));
    const targets = await page.evaluate(() => window.__devorbHoverTargets());
    for (const { x, y } of targets) {
      const top = await page.evaluate((t) => (scrollTo({ top: t, behavior: 'instant' }), scrollY), Math.max(0, y - 450));
      await page.mouse.move(x, y - top);
      await page.waitForTimeout(READ_AFTER);
      await read('hover');
    }
    return { url, libs: await page.evaluate(() => window.__devorbMotionLibs()), hoverTargets: targets.length, samples, summary: summarize(samples) };
  } finally {
    await context.close();
  }
}

// a spring comes out as linear() with dozens of stops: name it by its stop count
const short = (e) => (e.startsWith('linear(') ? `linear(${e.split(',').length} stops)` : e);

const line = (slug, r) => {
  if (r.error) return `- ${slug}: ERROR ${r.error}`;
  const { count, duration: d, easings, staggerMs } = r.summary;
  const bySource = ['load', 'scroll', 'hover'].map((s) => `${s} ${r.samples.filter((x) => x.source === s).length}`).join(', ');
  return `- ${slug}: ${count} samples (${bySource}); duration min ${d.min} median ${d.median} max ${d.max} ms; stagger ${staggerMs ?? '-'} ms; easings ${easings.map(([e, n]) => `${short(e)} ×${n}`).join(', ') || '-'}; libs ${r.libs.join(', ') || '-'}; hover targets ${r.hoverTargets}`;
};

async function main(argv) {
  const { values: v } = parseArgs({ args: argv, options: { only: { type: 'string' }, out: { type: 'string' }, pw: { type: 'string' } } });
  const out = resolve(v.out ?? join(tmpdir(), 'devorb-motion-study'));
  // studies of other people's sites never land in the repo
  const rel = relative(ROOT, out);
  if (rel === '' || !(rel === '..' || rel.startsWith(`..${sep}`) || isAbsolute(rel))) {
    console.error(`OUT INSIDE REPO: ${out}`);
    return 1;
  }
  const only = v.only?.split(',') ?? SITES;
  const refs = parseUrls(readFileSync(join(ROOT, 'docs/specs/2026-11-18-referencias/urls.txt'), 'utf8')).filter((r) => only.includes(r.slug));
  if (!refs.length) {
    console.error('no reference selected');
    return 1;
  }
  const pw = await resolvePlaywright({ dir: v.pw });
  const browser = pw && (await launch(pw.chromium ?? pw.default.chromium));
  if (!browser) {
    console.log(NEED);
    return 3;
  }
  mkdirSync(out, { recursive: true });
  const lines = [];
  try {
    for (const { slug, url } of refs) {
      const r = await study(browser, url).catch((e) => ({ url, error: e.message.split('\n')[0] }));
      writeFileSync(join(out, `${slug}.json`), JSON.stringify(r, null, 2));
      lines.push(line(slug, r));
      console.log(lines.at(-1));
    }
  } finally {
    await browser.close();
  }
  writeFileSync(join(out, 'summary.md'), `${lines.join('\n')}\n`);
  return lines.some((l) => l.includes(': ERROR ')) ? 1 : 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const code = await main(process.argv.slice(2));
  // system Chrome leaves helpers holding the browser's stderr pipe, which keeps node alive for minutes: exit once stdout is flushed
  process.stdout.write('', () => process.exit(code));
}
