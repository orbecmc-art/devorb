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
    return chromium.launch({ headless: true, channel: 'chrome' }).catch(() => null);
  }
}

// scroll-reveal pages only show a section once it has entered the viewport
async function scrollThrough(page) {
  const [height, step] = await page.evaluate(() => [window.__devorbScroller().scrollHeight, innerHeight * 0.8]);
  for (let y = step; y < height; y += step) {
    await page.evaluate((top) => window.__devorbScroller().scrollTo(0, top), y);
    await page.waitForTimeout(300);
  }
  await page.evaluate(() => window.__devorbScroller().scrollTo(0, 0));
}

// throws an Error with code 'NEED_PLAYWRIGHT' when no browser is available
export async function shootPage(url, outDir, { widths = [1440, 1024, 768, 390], mode = 'persuade', scroll = true, pw: pwDir } = {}) {
  const pw = await resolvePlaywright({ dir: pwDir });
  const browser = pw && (await launch(pw.chromium ?? pw.default.chromium));
  if (!browser) throw Object.assign(new Error(NEED), { code: 'NEED_PLAYWRIGHT' });
  const all = {};
  try {
    for (const width of widths) {
      const dir = join(outDir, String(width));
      mkdirSync(dir, { recursive: true });
      const context = await browser.newContext({ viewport: { width, height: 900 } });
      const page = await context.newPage();
      await page.goto(url, { waitUntil: 'load' });
      await page.waitForLoadState('networkidle', { timeout: 5000 }).catch(() => {}); // pages that poll never go idle
      await page.addScriptTag({ path: COLLECTOR });
      if (scroll) await scrollThrough(page);
      await page.evaluate(() => window.__devorbExpand());
      const metrics = await page.evaluate(() => window.__devorbMetrics());
      const pageHeight = await page.evaluate(() => document.documentElement.scrollHeight);
      const { fullClip, perSection } = planShots(pageHeight, metrics.sections);
      await page.screenshot({ path: join(dir, 'full.png'), fullPage: true, clip: { x: 0, y: 0, width, height: fullClip } });
      for (const i of perSection) {
        const s = metrics.sections[i];
        await page.screenshot({ path: join(dir, `section-${i}.png`), fullPage: true, clip: { x: s.x, y: s.top, width: s.width, height: Math.min(s.height, 16000) } });
      }
      writeFileSync(join(dir, 'metrics.json'), JSON.stringify(metrics, null, 2));
      writeFileSync(join(dir, 'checks.json'), JSON.stringify(checkFloor(metrics, mode), null, 2));
      all[width] = metrics;
      await context.close();
    }
  } finally {
    await browser.close();
  }
  return all;
}

async function main(argv) {
  const opts = parseArgs(argv);
  if (!opts.url || !opts.out || !(opts.mode in MODE_MIN_RATIO) || !opts.widths.every((w) => w > 0)) {
    console.error(USAGE);
    return 1;
  }
  try {
    const all = await shootPage(opts.url, opts.out, opts);
    return Object.values(all).some((m) => checkFloor(m, opts.mode).some((c) => c.status === 'FAIL')) ? 2 : 0;
  } catch (e) {
    if (e.code !== 'NEED_PLAYWRIGHT') throw e;
    console.log(NEED);
    return 3;
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await main(process.argv.slice(2));
}
