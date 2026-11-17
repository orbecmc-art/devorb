import { parseArgs as parseCli } from 'node:util';
import { createRequire } from 'node:module';
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { checkFloor, MODE_MIN_RATIO } from './rules.mjs';

const COLLECTOR = fileURLToPath(new URL('./collect-in-page.js', import.meta.url));
const USAGE = 'usage: node shoot.mjs <url> <outDir> [--widths a,b] [--mode persuade|operate|read|experience] [--no-scroll] [--pw <dir>]';
const NEED = 'NEED: npm i -D playwright && npx playwright install chromium (or, to keep it out of the project: npm i --prefix <temp dir> playwright, then pass --pw <dir> with that folder)';

export function parseArgs(argv) {
  const { values: v, positionals: [url, out] } = parseCli({
    args: argv,
    allowPositionals: true,
    options: { widths: { type: 'string' }, mode: { type: 'string' }, 'no-scroll': { type: 'boolean' }, pw: { type: 'string' } }
  });
  const widths = v.widths ? v.widths.split(',').map(Number) : [1440, 1024, 768, 390];
  return { url, out, widths, mode: v.mode ?? 'persuade', scroll: !v['no-scroll'], pw: v.pw };
}

// Chromium cannot encode a PNG taller than about 16384px
export function planShots(pageHeight, sections) {
  return { fullClip: Math.min(pageHeight, 16000), perSection: sections.filter((s) => !s.hidden).map((s) => s.index) };
}

// Node resolves a bare import next to the importing file, so look in the user's folders instead
export async function resolvePlaywright({ importer = (u) => import(u), cwd = process.cwd(), dir = process.env.DEVORB_PLAYWRIGHT_DIR } = {}) {
  for (const base of [cwd, dir].filter(Boolean)) {
    try {
      return await importer(pathToFileURL(createRequire(join(base, '/')).resolve('playwright')).href);
    } catch {}
  }
  return null;
}

async function launch(chromium) {
  try {
    return await chromium.launch({ headless: true });
  } catch (e) {
    // no bundled browser: use the system Google Chrome instead of a 150 MB download
    if (!/Executable doesn't exist/i.test(e.message)) throw e;
    return chromium.launch({ headless: true, channel: 'chrome' });
  }
}

// scroll-reveal pages only show a section once it has entered the viewport
async function scrollThrough(page) {
  const [height, step] = await page.evaluate(() => [document.documentElement.scrollHeight, innerHeight * 0.8]);
  for (let y = step; y < height; y += step) {
    await page.evaluate((top) => scrollTo(0, top), y);
    await page.waitForTimeout(300);
  }
  await page.evaluate(() => scrollTo(0, 0));
}

async function main(argv) {
  const opts = parseArgs(argv);
  if (!opts.url || !opts.out || !(opts.mode in MODE_MIN_RATIO) || !opts.widths.every((w) => w > 0)) {
    console.error(USAGE);
    return 1;
  }
  const pw = await resolvePlaywright({ dir: opts.pw });
  if (!pw) {
    console.log(NEED);
    return 3;
  }
  const browser = await launch(pw.chromium ?? pw.default.chromium);
  let failed = false;
  try {
    for (const width of opts.widths) {
      const dir = join(opts.out, String(width));
      mkdirSync(dir, { recursive: true });
      const context = await browser.newContext({ viewport: { width, height: 900 } });
      const page = await context.newPage();
      await page.goto(opts.url, { waitUntil: 'load' });
      if (opts.scroll) await scrollThrough(page);
      await page.addScriptTag({ path: COLLECTOR });
      const metrics = await page.evaluate(() => window.__devorbMetrics());
      const pageHeight = await page.evaluate(() => document.documentElement.scrollHeight);
      const { fullClip, perSection } = planShots(pageHeight, metrics.sections);
      await page.screenshot({ path: join(dir, 'full.png'), fullPage: true, clip: { x: 0, y: 0, width, height: fullClip } });
      for (const i of perSection) {
        const s = metrics.sections[i];
        await page.screenshot({ path: join(dir, `section-${i}.png`), fullPage: true, clip: { x: 0, y: s.top, width, height: Math.min(s.height, 16000) } });
      }
      const checks = checkFloor(metrics, opts.mode);
      failed ||= checks.some((c) => c.status === 'FAIL');
      writeFileSync(join(dir, 'metrics.json'), JSON.stringify(metrics, null, 2));
      writeFileSync(join(dir, 'checks.json'), JSON.stringify(checks, null, 2));
      await context.close();
    }
  } finally {
    await browser.close();
  }
  return failed ? 2 : 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await main(process.argv.slice(2));
}
