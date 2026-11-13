# Playwright check script

A Node script for `devorb:browser-testing` when the project has Playwright and no browser tests of its own. Copy it to a scratch path, edit `STEPS`, run it with `node check.mjs http://localhost:3000/`. For Python projects, the same calls exist in `playwright.sync_api` with snake_case names.

```js
import { chromium } from 'playwright';

const url = process.argv[2];
const problems = [];

const browser = await chromium.launch({ headless: true });
try {
  for (const viewport of [
    { name: 'desktop', width: 1280, height: 800 },
    { name: 'mobile', width: 375, height: 812, hasTouch: true, isMobile: true },
  ]) {
    const { name, hasTouch = false, isMobile = false, ...size } = viewport;
    const context = await browser.newContext({ viewport: size, hasTouch, isMobile });
    const page = await context.newPage();
    page.on('console', (m) => { if (m.type() === 'error') problems.push(`[${name}] console: ${m.text()}`); });
    page.on('pageerror', (e) => problems.push(`[${name}] page error: ${e.message}`));
    page.on('requestfailed', (r) => problems.push(`[${name}] request failed: ${r.method()} ${r.url()} ${r.failure()?.errorText}`));
    page.on('response', (r) => { if (r.status() >= 400) problems.push(`[${name}] HTTP ${r.status()}: ${r.request().method()} ${r.url()}`); });

    await page.goto(url, { waitUntil: 'domcontentloaded' });

    // Look first: what is on the page.
    console.log(`[${name}] buttons:`, await page.getByRole('button').allInnerTexts());
    console.log(`[${name}] links:`, await page.locator('a[href]').evaluateAll((as) => as.map((a) => a.getAttribute('href'))));
    console.log(`[${name}] inputs:`, await page.locator('input, select, textarea').evaluateAll((es) => es.map((e) => e.name || e.id)));

    // Act: one block per user action. Wait for the result the user would see.
    // Example for a form:
    //   await page.getByLabel('Nome').fill('Ana Souza');
    //   await page.getByLabel('E-mail').fill('ana@exemplo.com');
    //   const save = page.getByRole('button', { name: 'Salvar' });
    //   await save.waitFor({ state: 'visible' });
    //   const sent = page.waitForResponse((r) => r.request().method() === 'POST', { timeout: 5000 }).catch(() => null);
    //   await save.click();
    //   const resp = await sent;
    //   if (!resp) problems.push(`[${name}] save sent no request`);
    //   else console.log(`[${name}] save ->`, resp.status(), resp.url());
    //   await page.getByText('Cliente salvo').waitFor({ timeout: 3000 }).catch(() => problems.push(`[${name}] no success message`));

    const hScroll = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
    if (hScroll) problems.push(`[${name}] horizontal scroll`);

    if (problems.some((p) => p.startsWith(`[${name}]`))) {
      const shot = `browser-check-${name}-${Date.now()}.png`;
      await page.screenshot({ path: shot, fullPage: true });
      console.log(`[${name}] screenshot: ${shot}`);
    }
    await context.close();
  }
} finally {
  await browser.close();
}

console.log(problems.length ? `FAIL\n${problems.join('\n')}` : 'PASS');
process.exitCode = problems.length ? 1 : 0;
```

## Server lifecycle

```bash
PORT=4173 npm start > /tmp/app.log 2>&1 &
APP_PID=$!
for i in $(seq 1 60); do curl -s -o /dev/null "http://localhost:4173/" && break; sleep 0.5; done
node check.mjs http://localhost:4173/
kill "$APP_PID"
```

If the port never answers, read `/tmp/app.log` before anything else.
