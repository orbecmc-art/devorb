import { pathToFileURL } from 'node:url';

const USAGE = 'usage: node fluid-scale.mjs --min-width <n> --max-width <n> --min-base <n> --max-base <n> --min-ratio <n> --max-ratio <n> --steps <a>..<b>';
const n = (x) => Number(x.toFixed(4));

// one type step grows linearly from minWidth to maxWidth, held at both ends by clamp()
export function fluidScale({ minWidth, maxWidth, minBase, maxBase, minRatio, maxRatio, steps }) {
  return steps.map((step) => {
    const minPx = minBase * minRatio ** step;
    const maxPx = maxBase * maxRatio ** step;
    const slope = (maxPx - minPx) / (maxWidth - minWidth);
    const intercept = minPx - slope * minWidth;
    const clamp = `clamp(${n(Math.min(minPx, maxPx) / 16)}rem, ${n(intercept / 16)}rem + ${n(slope * 100)}vw, ${n(Math.max(minPx, maxPx) / 16)}rem)`;
    return { step, minPx, maxPx, clamp };
  });
}

const NAMES = { '--min-width': 'minWidth', '--max-width': 'maxWidth', '--min-base': 'minBase', '--max-base': 'maxBase', '--min-ratio': 'minRatio', '--max-ratio': 'maxRatio' };

// hand-rolled because util.parseArgs refuses a value that starts with a dash, like --steps -1..0
function parse(argv) {
  const o = {};
  for (let i = 0; i < argv.length; i += 2) {
    const [flag, value] = [argv[i], argv[i + 1]];
    if (flag === '--steps') {
      const m = /^(-?\d+)\.\.(-?\d+)$/.exec(value ?? '');
      if (!m || Number(m[1]) > Number(m[2])) return null;
      o.steps = Array.from({ length: m[2] - m[1] + 1 }, (_, k) => Number(m[1]) + k);
    } else if (NAMES[flag] && value?.trim() && Number.isFinite(Number(value))) o[NAMES[flag]] = Number(value);
    else return null;
  }
  const ok = o.steps && Object.values(NAMES).every((k) => k in o) && o.maxWidth > o.minWidth && o.minBase > 0 && o.maxBase > 0 && o.minRatio > 0 && o.maxRatio > 0;
  return ok ? o : null;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const o = parse(process.argv.slice(2));
  if (!o) {
    console.error(USAGE);
    process.exit(1);
  }
  for (const s of fluidScale(o)) console.log(`--step-${s.step}: ${s.clamp};`);
}
