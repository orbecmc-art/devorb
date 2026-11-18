export const MODE_MIN_RATIO = { persuade: 2.5, operate: 1.6, read: 2.0, experience: 2.0 };
export const MODE_TARGET_RATIO = { persuade: 4.0 };
// below this width the headline shrinks and the body stays: h1 of 32px over a 16px body is a sound phone page
export const DESKTOP_MIN_WIDTH = 1024;
export const NARROW_RATIO_FACTOR = 0.8;

const median = (xs) => {
  const s = [...xs].sort((a, b) => a - b);
  const i = s.length >> 1;
  return s.length % 2 ? s[i] : (s[i - 1] + s[i]) / 2;
};
const sizes = (m, role) => m.text.filter((t) => t.role === role).map((t) => t.fontSize);
const distinct = (xs) => new Set(xs).size;

export function headingRatio(m) {
  // h1 can be a small page title; the real headline may be an h2
  const top = Math.max(...sizes(m, 'h1'), ...sizes(m, 'h2'));
  return top / median(sizes(m, 'body'));
}

// shortcut: rgb hues are HSL and oklch hues are OKLCH, which sit some degrees apart; switch to one space when a real page counts wrong
export function accentHues(colors) {
  const hues = [];
  for (const c of colors) {
    const rgb = /^rgba?\(([^)]*)\)$/.exec(c);
    const lch = /^oklch\(\s*([\d.]+)%?\s+([\d.]+)(%?)\s+([\d.]+)(?:deg)?\s*(?:\/\s*([\d.]+)(%?))?\s*\)$/.exec(c);
    if (rgb) {
      const [r, g, b, a = 1] = rgb[1].split(/[\s,/]+/).filter(Boolean).map(Number);
      if (!(a > 0.1)) continue;
      const [R, G, B] = [r / 255, g / 255, b / 255];
      const max = Math.max(R, G, B), min = Math.min(R, G, B), d = max - min, l = (max + min) / 2;
      const s = d === 0 ? 0 : d / (1 - Math.abs(2 * l - 1));
      if (!(s >= 0.35 && l >= 0.15 && l <= 0.9)) continue;
      const h = max === R ? (G - B) / d : max === G ? (B - R) / d + 2 : (R - G) / d + 4;
      hues.push((h * 60 + 360) % 360);
    } else if (lch) {
      const chroma = Number(lch[2]) * (lch[3] ? 0.004 : 1); // 100% chroma is 0.4
      const alpha = lch[5] === undefined ? 1 : Number(lch[5]) / (lch[6] ? 100 : 1);
      if (chroma >= 0.08 && alpha > 0.1) hues.push(Number(lch[4]) % 360);
    }
  }
  // hues less than 30° apart, chained, make one group; the last group joins the first across 0°
  const sorted = hues.sort((a, b) => a - b);
  const groups = sorted.filter((h, i) => i === 0 || h - sorted[i - 1] >= 30);
  if (groups.length > 1 && sorted[0] + 360 - sorted.at(-1) < 30) groups.pop();
  return groups;
}

export function checkFloor(m, mode) {
  const ratio = headingRatio(m);
  // a page measured without a width counts as desktop
  const narrow = m.width < DESKTOP_MIN_WIDTH;
  const min = MODE_MIN_RATIO[mode] * (narrow ? NARROW_RATIO_FACTOR : 1);
  // narrow, the warning sits at the desktop minimum: 2.0 to 2.5 warns on Persuade
  const target = MODE_TARGET_RATIO[mode] && (narrow ? MODE_MIN_RATIO[mode] : MODE_TARGET_RATIO[mode]);
  const bodyMedian = median(sizes(m, 'body'));
  const wide = m.text.filter((t) => t.role === 'body' && t.lineChars > 75).length;
  const off = m.spacing.filter((s) => s % 4 !== 0).length;
  const dupes = m.images.length - distinct(m.images);
  const heavy = m.text.filter((t) => (t.role === 'h1' || t.role === 'h2') && t.fontSize >= 48 && t.fontWeight >= 700 && t.letterSpacing >= 0);
  const accents = accentHues([...m.textColors, ...(m.fills ?? []), ...m.sections.map((s) => s.bg)]);
  const check = (id, bad, level, detail) => ({ id, status: bad ? level : 'PASS', detail });
  const ratioCheck = check('heading-ratio', !(ratio >= min), 'FAIL', `ratio ${ratio.toFixed(2)}, min ${+min.toFixed(2)}${target ? `, target ${target}` : ''} for ${mode}${narrow ? ` below ${DESKTOP_MIN_WIDTH}px` : ''}`);
  const bodyCheck = check('body-size', !(bodyMedian >= 13) && (mode === 'persuade' || mode === 'read'), 'FAIL', `body median ${bodyMedian}px`);
  return [
    ratioCheck.status === 'PASS' && ratio < target ? { ...ratioCheck, status: 'WARN' } : ratioCheck,
    bodyCheck.status === 'PASS' && mode === 'read' && bodyMedian < 14 ? { ...bodyCheck, status: 'WARN' } : bodyCheck,
    check('measure', wide > 0, 'WARN', `${wide} body samples above 75 chars per line`),
    check('spacing-grid', off > 0.2 * m.spacing.length, 'WARN', `${off} of ${m.spacing.length} spacings off the 4px grid`),
    check('font-sizes', distinct(m.text.map((t) => t.fontSize)) > 12, 'WARN', `${distinct(m.text.map((t) => t.fontSize))} distinct font sizes`),
    check('button-styles', distinct(m.buttons) > 3, 'WARN', `${distinct(m.buttons)} button signatures`),
    check('text-colors', distinct(m.textColors) > 8, 'WARN', `${distinct(m.textColors)} text colors`),
    check('photo-repeat', dupes > 0, 'WARN', `${dupes} repeated image sources`),
    check('display-weight', heavy.length > 0, 'WARN', `h1 or h2 of 48px+ at weight 700+ and tracking 0+: ${[...new Set(heavy.map((t) => `${t.fontSize}px`))].join(', ') || 'none'}`),
    check('accent-count', accents.length > 2, 'WARN', `saturated hues: ${accents.map(Math.round).join(', ') || 'none'}`)
  ];
}

export function compareStructure(build, ref) {
  const vis = (m) => m.sections.filter((s) => !s.hidden);
  const [b, r] = [vis(build), vis(ref)];
  const reasons = [];
  if (b.length !== r.length) reasons.push(`section count ${b.length} differs from reference ${r.length}`);
  if (headingRatio(build) < 0.8 * headingRatio(ref)) reasons.push(`heading ratio ${headingRatio(build).toFixed(2)} is below 80% of reference ${headingRatio(ref).toFixed(2)}`);
  const page = (xs) => (xs.length ? xs.at(-1).top + xs.at(-1).height : 0);
  const differs = (x, y) => Math.max(x, y) > 0 && Math.abs(x - y) / Math.max(x, y) > 0.25;
  const deviations = [];
  const [pb, pr] = [page(b), page(r)];
  for (let i = 0; i < Math.min(b.length, r.length); i++) {
    if (differs(b[i].height / pb, r[i].height / pr)) deviations.push(`section ${i}: height share ${(b[i].height / pb).toFixed(2)} vs ${(r[i].height / pr).toFixed(2)}`);
    if (i + 1 < Math.min(b.length, r.length)) {
      const gap = (xs) => xs[i + 1].top - (xs[i].top + xs[i].height);
      if (differs(gap(b), gap(r))) deviations.push(`section ${i}: gap to next ${gap(b)}px vs ${gap(r)}px`);
    }
  }
  return { grossFail: reasons.length > 0, reasons, deviations };
}

const find = (n, pred) => (pred(n) ? n : n.children.reduce((hit, c) => hit || find(c, pred), null));

export function findSectionsRoot(tree) {
  let node = find(tree, (n) => n.tag === 'main' || n.role === 'main') || tree;
  // descend while one child qualifies as a section: small title rows and footers sit beside the content wrapper
  for (let kids = sectionNodes(node); kids.length === 1; kids = sectionNodes(node)) node = kids[0];
  return node;
}

export function sectionNodes(root) {
  return root.children.filter((c) => c.rect.w >= 0.5 * root.rect.w && c.rect.h >= 120);
}

export function findSections(tree) {
  const root = findSectionsRoot(tree);
  const nodes = sectionNodes(root);
  if (nodes.length >= 2) return { root, nodes };
  // wrappers with no box (display: contents) hide the sections: take the level with most full-width blocks, first on a tie
  const start = find(tree, (n) => n.tag === 'main' || n.role === 'main') || tree;
  let best = { root: start, nodes: [] };
  const visit = (n) => {
    const blocks = n.children.filter((c) => c.rect.w >= 0.9 * start.rect.w && c.rect.h >= 120);
    if (blocks.length > best.nodes.length) best = { root: n, nodes: blocks };
    n.children.forEach(visit);
  };
  visit(start);
  return best.nodes.length >= 2 ? best : { root, nodes };
}
