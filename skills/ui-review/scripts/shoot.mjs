import { parseArgs as parseCli } from 'node:util';
import { createRequire } from 'node:module';
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { checkFloor, MODE_MIN_RATIO } from './rules.mjs';

const COLLECTOR = fileURLToPath(new URL('./collect-in-page.js', import.meta.url));
const REVEAL_INIT = fileURLToPath(new URL('./reveal-init.js', import.meta.url));
const USAGE = 'usage: node shoot.mjs <url> <outDir> [--widths a,b] [--mode persuade|operate|read|experience] [--no-scroll] [--pw <dir>] (exit 2: a floor check FAILed, see <width>/checks.json)';
const NEED = 'NEED: npm i --prefix <temp dir> playwright && npx --prefix <temp dir> playwright install chromium, then pass --pw <dir> with that folder (or, inside the project: npm i -D playwright && npx playwright install chromium)';

export function parseArgs(argv) {
  const { values: v, positionals: [url, out] } = parseCli({
    args: argv,
    allowPositionals: true,
    options: { widths: { type: 'string' }, mode: { type: 'string' }, 'no-scroll': { type: 'boolean' }, pw: { type: 'string' } }
  });
  const widths = v.widths ? v.widths.split(',').map(Number) : [1440, 1024, 768, 390];
  return { url, out, widths, mode: v.mode ?? 'persuade', scroll: !v['no-scroll'], pw: v.pw };
}

// Chromium cannot encode a PNG taller than about 16384px: a section below the full-page image is shot alone, scrolled into the window
export function planShots(pageHeight, sections, viewportHeight = 900) {
  const fullClip = Math.min(pageHeight, 16000);
  const perSection = [];
  const skipped = [];
  for (const s of sections) {
    if (s.hidden) skipped.push({ index: s.index, reason: 'hidden' });
    else if (s.width < 1 || s.height < 1) skipped.push({ index: s.index, reason: 'empty' });
    else {
      const height = Math.min(s.height, pageHeight - s.top);
      if (s.top + height <= fullClip) perSection.push({ index: s.index, scrollTo: null, clip: { x: s.x, y: s.top, width: s.width, height } });
      else perSection.push({ index: s.index, scrollTo: s.top, clip: { x: s.x, y: 0, width: s.width, height: Math.min(s.height, viewportHeight) } });
    }
  }
  return { fullClip, perSection, skipped };
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
      await context.addInitScript({ path: REVEAL_INIT });
      const page = await context.newPage();
      await page.goto(url, { waitUntil: 'domcontentloaded' });
      await page.waitForLoadState('networkidle', { timeout: 5000 }).catch(() => {}); // pages that poll never go idle
      await page.addScriptTag({ path: COLLECTOR });
      if (scroll) await scrollThrough(page);
      await page.evaluate(() => window.__devorbReveal());
      await page.evaluate(() => window.__devorbExpand());
      const metrics = await page.evaluate(() => window.__devorbMetrics());
      const pageHeight = await page.evaluate(() => document.documentElement.scrollHeight);
      const { fullClip, perSection, skipped } = planShots(pageHeight, metrics.sections);
      const shotErrors = skipped.map(({ index, reason }) => ({ shot: `section-${index}`, error: `skipped: ${reason}` }));
      // a heavy page can time out or fail once; a shot that fails twice is logged and the run goes on
      const shoot = async (shot, opts) => {
        const o = { path: join(dir, `${shot}.png`), animations: 'disabled', timeout: 60000, ...opts };
        try {
          await page.screenshot(o);
        } catch {
          await page.screenshot({ ...o, caret: 'hide' }).catch((e) => shotErrors.push({ shot, error: e.message.split('\n')[0] }));
        }
      };
      await shoot('full', { fullPage: true, clip: { x: 0, y: 0, width, height: fullClip } });
      for (const { index, scrollTo, clip } of perSection) {
        if (scrollTo === null) {
          await shoot(`section-${index}`, { fullPage: true, clip });
          continue;
        }
        // the window stops short of a section near the page end, so shift the clip by what it could not scroll
        const offset = await page.evaluate((top) => (window.scrollTo(0, top), top - window.scrollY), scrollTo);
        await shoot(`section-${index}`, { fullPage: false, clip: { ...clip, y: clip.y + offset } });
      }
      metrics.shotErrors = shotErrors;
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
  if (!opts.url || !opts.out || !Object.hasOwn(MODE_MIN_RATIO, opts.mode) || !opts.widths.every((w) => w > 0)) {
    console.error(USAGE);
    return 1;
  }
  try {
    const all = await shootPage(opts.url, opts.out, opts);
    const failed = opts.widths.map((w) => [w, checkFloor(all[w], opts.mode).filter((c) => c.status === 'FAIL').map((c) => c.id)]).filter(([, ids]) => ids.length);
    if (!failed.length) return 0;
    console.log(`FAIL: ${[...new Set(failed.flatMap(([, ids]) => ids))].join(', ')} at ${failed.map(([w]) => w).join(', ')}`);
    return 2;
  } catch (e) {
    if (e.code !== 'NEED_PLAYWRIGHT') throw e;
    console.log(NEED);
    return 3;
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await main(process.argv.slice(2));
}
