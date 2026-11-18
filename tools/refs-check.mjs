import { parseArgs } from 'node:util';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { isAbsolute, join, relative, resolve, sep } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { MODE_MIN_RATIO } from '../skills/ui-review/scripts/rules.mjs';

const ROOT = fileURLToPath(new URL('..', import.meta.url));
const SHOOT = join(ROOT, 'skills', 'ui-review', 'scripts', 'shoot.mjs');
const WIDTHS = [1440, 1024, 768, 390];

export function parseUrls(text) {
  const refs = [];
  text.split('\n').forEach((line, i) => {
    const [slug, url, mode = 'persuade'] = line.trim().split(/\s+/);
    if (!slug || slug.startsWith('#')) return;
    if (!Object.hasOwn(MODE_MIN_RATIO, mode)) throw new Error(`line ${i + 1}: unknown mode ${mode}`);
    if (refs.some((r) => r.slug === slug)) throw new Error(`line ${i + 1}: duplicate slug ${slug}`);
    refs.push({ slug, url, mode });
  });
  return refs;
}

// exit 2 is a floor FAIL, a result to judge from checks.json, not a crash
export function judgeSite({ dir, widths, exit, stderr = '' }) {
  const reasons = [];
  const warns = [];
  const shotErrors = [];
  if (exit === null) reasons.push('timeout');
  else if (exit !== 0 && exit !== 2) reasons.push(`run failed (exit ${exit}): ${stderr.trim().split('\n').pop()}`);
  for (const w of widths) {
    const metricsFile = join(dir, String(w), 'metrics.json');
    if (!existsSync(metricsFile)) {
      reasons.push(`no metrics at ${w}`);
      continue;
    }
    const m = JSON.parse(readFileSync(metricsFile, 'utf8'));
    const checks = JSON.parse(readFileSync(join(dir, String(w), 'checks.json'), 'utf8'));
    for (const c of checks) {
      if (c.status === 'FAIL') reasons.push(`FAIL ${c.id} at ${w}`);
      if (c.status === 'WARN') warns.push(`${c.id} at ${w}`);
    }
    const visible = m.sections.filter((s) => !s.hidden).length;
    if (visible < 2) reasons.push(`${visible} sections at ${w}`);
    const hidden = m.sections.reduce((n, s) => n + (s.hiddenContent ?? 0), 0);
    if (hidden > 0) reasons.push(`hidden content ${hidden} at ${w}`);
    for (const e of m.shotErrors ?? []) shotErrors.push(`${w}/${e.shot}: ${e.error}`);
  }
  return { status: reasons.length ? 'FAIL' : 'PASS', reasons, warns, shotErrors };
}

export function report(results) {
  const lines = [];
  for (const r of results) {
    lines.push(`- ${r.slug} (${r.mode}): ${r.status}${r.reasons.length ? ` — ${r.reasons.join('; ')}` : ''}`);
    if (r.warns.length) lines.push(`  WARN: ${r.warns.join(', ')}`);
    if (r.shotErrors.length) lines.push(`  shotErrors: ${r.shotErrors.join(', ')}`);
  }
  lines.push(`refs-check: ${results.filter((r) => r.status === 'PASS').length}/${results.length} PASS`);
  return lines.join('\n');
}

function main(argv) {
  const { values: v } = parseArgs({
    args: argv,
    options: { urls: { type: 'string' }, out: { type: 'string' }, only: { type: 'string' }, widths: { type: 'string' }, pw: { type: 'string' } }
  });
  const out = resolve(v.out ?? join(tmpdir(), 'devorb-refs-check'));
  // shots and reports of other people's sites never land in the repo
  const rel = relative(ROOT, out);
  if (rel === '' || !(rel === '..' || rel.startsWith(`..${sep}`) || isAbsolute(rel))) {
    console.error(`OUT INSIDE REPO: ${out}`);
    return 1;
  }
  const widths = v.widths ? v.widths.split(',').map(Number) : WIDTHS;
  const only = v.only?.split(',');
  const refs = parseUrls(readFileSync(v.urls ?? join(ROOT, 'docs/specs/2026-11-18-referencias/urls.txt'), 'utf8')).filter((r) => !only || only.includes(r.slug));
  const results = [];
  for (const { slug, url, mode } of refs) {
    const dir = join(out, slug);
    const args = [SHOOT, url, dir, '--mode', mode, '--widths', widths.join(','), ...(v.pw ? ['--pw', v.pw] : [])];
    const started = Date.now();
    const r = spawnSync(process.execPath, args, { encoding: 'utf8', timeout: 600000 });
    if (r.status === 3) {
      console.log(r.stdout.trim());
      return 3;
    }
    console.log(`${slug}: exit ${r.status} in ${Math.round((Date.now() - started) / 1000)}s`);
    results.push({ slug, mode, ...judgeSite({ dir, widths, exit: r.status, stderr: r.stderr }) });
  }
  const text = report(results);
  mkdirSync(out, { recursive: true });
  writeFileSync(join(out, 'report.md'), `${text}\n`);
  console.log(text);
  return results.every((r) => r.status === 'PASS') ? 0 : 1;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = main(process.argv.slice(2));
}
