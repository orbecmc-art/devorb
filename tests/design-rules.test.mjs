import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { headingRatio, checkFloor, accentHues, compareStructure, findSections, findSectionsRoot, sectionNodes } from '../skills/ui-review/scripts/rules.mjs';
const load = (f) => JSON.parse(readFileSync(new URL(`./fixtures/design/${f}`, import.meta.url)));
const status = (checks, id) => checks.find((c) => c.id === id).status;

test('Pilot warns on the persuade ratio target, Ligare fails the 2.5 floor', () => {
  assert.ok(Math.abs(headingRatio(load('metrics-pilot.json')) - 3.2) < 0.05);
  const pilot = checkFloor(load('metrics-pilot.json'), 'persuade');
  assert.equal(status(pilot, 'heading-ratio'), 'WARN');
  assert.equal(status(pilot, 'body-size'), 'PASS');
  const ligare = checkFloor(load('metrics-ligare.json'), 'persuade');
  assert.equal(status(ligare, 'heading-ratio'), 'FAIL');
  assert.equal(status(ligare, 'body-size'), 'PASS');
});
test('read warns on a 13px body', () => {
  assert.equal(status(checkFloor(load('metrics-ligare.json'), 'read'), 'body-size'), 'WARN');
});
// a page of one heading and three body samples
const page = (heading, body, extra = {}) => {
  const m = load('metrics-pilot.json');
  m.text = [{ role: 'h1', fontSize: heading, fontWeight: 400, letterSpacing: 0 }, ...[body, body, body].map((fontSize) => ({ role: 'body', fontSize, lineChars: 60 }))];
  return Object.assign(m, extra);
};
test('a 12.5px body fails in persuade', () => {
  assert.equal(status(checkFloor(page(60, 12.5), 'persuade'), 'body-size'), 'FAIL');
});
test('ratio 2.9 warns and 4.2 passes in persuade', () => {
  assert.equal(status(checkFloor(page(29, 10), 'persuade'), 'heading-ratio'), 'WARN');
  assert.equal(status(checkFloor(page(42, 10), 'persuade'), 'heading-ratio'), 'PASS');
});
test('below 1024 persuade fails under 2.0 and warns under 2.5; a page without a width is desktop', () => {
  const ratio = (heading, width) => status(checkFloor(page(heading, 10, { width }), 'persuade'), 'heading-ratio');
  assert.equal(ratio(22, 390), 'WARN');
  assert.equal(ratio(19, 390), 'FAIL');
  assert.equal(ratio(26, 390), 'PASS');
  assert.equal(ratio(22, 1440), 'FAIL');
  assert.equal(ratio(22, 1024), 'FAIL');
  assert.equal(ratio(22, undefined), 'FAIL');
});
test('below 1024 the other modes fail under 0.8 of their minimum, with no warning', () => {
  const ratio = (heading, width) => status(checkFloor(page(heading, 10, { width }), 'read'), 'heading-ratio');
  assert.equal(ratio(17, 390), 'PASS');
  assert.equal(ratio(15, 390), 'FAIL');
  assert.equal(ratio(17, 1440), 'FAIL');
});
test('a ratio on the narrow minimum is not a FAIL', () => {
  assert.equal(status(checkFloor(page(20, 10, { width: 390 }), 'persuade'), 'heading-ratio'), 'WARN');
  assert.notEqual(status(checkFloor(page(12.8, 10, { width: 390 }), 'operate'), 'heading-ratio'), 'FAIL');
});
test('display-weight warns only on heavy, untracked display type', () => {
  const display = (fontSize, fontWeight, letterSpacing) => {
    const m = page(fontSize, 16);
    Object.assign(m.text[0], { fontWeight, letterSpacing });
    return status(checkFloor(m, 'persuade'), 'display-weight');
  };
  assert.equal(display(72, 700, 0), 'WARN');
  assert.equal(display(72, 500, -3.6), 'PASS');
  assert.equal(display(46, 900, 0), 'PASS');
});
test('accentHues counts saturated hue groups, not neutrals or unknown formats', () => {
  assert.equal(accentHues(['rgb(151, 142, 255)', 'rgb(10, 10, 10)', 'rgb(255, 255, 255)', 'rgb(115, 115, 115)']).length, 1);
  const rgb = ['rgb(255, 0, 0)', 'rgb(0, 255, 0)', 'rgb(0, 0, 255)'];
  assert.equal(accentHues(rgb).length, 3);
  assert.equal(status(checkFloor(page(64, 16, { textColors: rgb }), 'persuade'), 'accent-count'), 'WARN');
  assert.equal(accentHues(['hsl(0 0% 0%)', 'rgb(51, 119, 255)', 'rgb(51, 85, 255)']).length, 1); // 220° and 230°
  assert.equal(accentHues(['oklch(0.62 0.19 260)']).length, 1);
  assert.deepEqual(accentHues(['color(display-p3 1 0 0)']), []);
});
test('accentHues groups across 0°, skips near-transparent and low-chroma colours, reads oklch % and alpha', () => {
  assert.equal(accentHues(['rgb(255, 0, 43)', 'rgb(255, 43, 0)']).length, 1); // 350° and 10°
  assert.deepEqual(accentHues(['rgba(255, 0, 0, 0.1)', 'oklch(0.7 0.02 30)']), []);
  assert.equal(accentHues(['oklch(62% 0.19 260 / 0.5)', 'oklch(0.62 0.19 140)']).length, 2);
  assert.ok(accentHues(['oklch(0.62 0.19 260)', 'rgb(255, 0, 0)']).every(Number.isFinite));
  assert.equal(accentHues(['rgb(255 0 0 / 50%)', 'rgb(0 0 255 / 5%)']).length, 1);
});
test('operate accepts a 2.0 ratio', () => {
  const ligare = checkFloor(load('metrics-ligare.json'), 'operate');
  assert.equal(status(ligare, 'heading-ratio'), 'PASS');
  assert.equal(status(ligare, 'body-size'), 'PASS');
});
test('every check id is present once', () => {
  const ids = checkFloor(load('metrics-pilot.json'), 'persuade').map((c) => c.id);
  assert.deepEqual(ids, ['heading-ratio', 'body-size', 'measure', 'spacing-grid', 'font-sizes', 'button-styles', 'text-colors', 'photo-repeat', 'display-weight', 'accent-count']);
});
test('Pilot passes every check in persuade except two warnings', () => {
  const warned = { 'heading-ratio': 'WARN', 'display-weight': 'WARN' };
  for (const c of checkFloor(load('metrics-pilot.json'), 'persuade')) assert.equal(c.status, warned[c.id] ?? 'PASS', c.id);
});
test('warning checks trip on their limits', () => {
  const m = load('metrics-pilot.json');
  m.text.push({ ...m.text.find((x) => x.role === 'body'), lineChars: 90 });
  m.spacing = [5, 7, 9, 8];
  m.text.push(...[10, 11, 12, 14, 15, 19, 21, 22, 23, 25].map((fontSize) => ({ role: 'h3', fontSize, lineHeight: 20, fontWeight: 400, letterSpacing: 0, fontFamily: 'x', lineChars: 0 })));
  m.buttons = ['a', 'b', 'c', 'd'];
  m.textColors = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  m.images = ['/a.jpg', '/a.jpg'];
  const c = checkFloor(m, 'persuade');
  for (const id of ['measure', 'spacing-grid', 'font-sizes', 'button-styles', 'text-colors', 'photo-repeat']) assert.equal(status(c, id), 'WARN', id);
});
test('ligare vs pilot is a gross fail with both reasons', () => {
  const r = compareStructure(load('metrics-ligare.json'), load('metrics-pilot.json'));
  assert.equal(r.grossFail, true);
  assert.equal(r.reasons.length, 2);
});
test('identical metrics give no deviation', () => {
  const p = load('metrics-pilot.json');
  assert.deepEqual(compareStructure(p, p), { grossFail: false, reasons: [], deviations: [] });
});
test('a taller section is listed as a deviation by index', () => {
  const p = load('metrics-pilot.json');
  const b = structuredClone(p);
  b.sections[2].height = 1400;
  const r = compareStructure(b, p);
  assert.equal(r.grossFail, false);
  assert.ok(r.deviations.some((d) => d.includes('section 2')));
});
test('sections come from content, not the sidebar', () => {
  const root = findSectionsRoot(load('dom-app-shell.json'));
  assert.equal(root.tag, 'main');
  assert.equal(sectionNodes(root).length, 3);
});
test('sections go past small title rows beside the content wrapper', () => {
  assert.equal(sectionNodes(findSectionsRoot(load('dom-ligare-shell.json'))).length, 3);
});
test('a small footer beside the content wrapper does not hide its sections', () => {
  const node = (tag, y, h, children = []) => ({ tag, rect: { x: 0, y, w: 1174, h }, children });
  const sections = [0, 1, 2, 3].map((i) => node('section', i * 1400, 1400));
  const tree = node('main', 0, 5793, [node('div', 0, 5754, sections), node('footer', 5754, 39)]);
  assert.equal(sectionNodes(findSectionsRoot(tree)).length, 4);
});
test('the second rule finds the sections behind a wrapper with no box', () => {
  const t = load('dom-billow-shape.json');
  assert.ok(sectionNodes(findSectionsRoot(t)).length <= 1);
  assert.deepEqual(findSections(t).nodes.map((n) => n.rect.y), [0, 1637, 2583, 5837, 6635]);
});
test('the second rule picks the level with most full-width blocks', () => {
  const node = (tag, y, w, h, children = []) => ({ tag, rect: { x: 0, y, w, h }, children });
  const blocks = (n, from) => Array.from({ length: n }, (_, i) => node('section', (from + i) * 600, 1440, 600));
  const tree = node('body', 0, 1440, 3600, [node('main', 0, 1440, 3600, [node('div', 0, 0, 0, blocks(4, 0)), node('div', 0, 0, 0, blocks(2, 4))])]);
  assert.equal(findSections(tree).nodes.length, 4);
});
test('the first rule wins when it already finds two or more', () => {
  const { root, nodes } = findSections(load('dom-app-shell.json'));
  assert.equal(root.tag, 'main');
  assert.equal(nodes.length, 3);
});
test('a build with no visible sections is a gross fail, not a crash', () => {
  const b = load('metrics-pilot.json');
  b.sections = [];
  const r = compareStructure(b, load('metrics-pilot.json'));
  assert.equal(r.grossFail, true);
  assert.ok(r.reasons.some((x) => x.includes('section count')));
});
test('body-size fails closed with no body samples', () => {
  const m = load('metrics-pilot.json');
  m.text = m.text.filter((t) => t.role !== 'body');
  assert.equal(status(checkFloor(m, 'persuade'), 'body-size'), 'FAIL');
});
