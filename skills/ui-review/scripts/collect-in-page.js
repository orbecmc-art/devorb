// Browser script with no imports: shoot.mjs injects it with page.addScriptTag.
(() => {
  // Copy of findSectionsRoot and sectionNodes from rules.mjs; tests/design-shoot.test.mjs keeps them equal.
  const visible = (n) => n.rect.w > 0 && n.rect.h > 0;
  const find = (n, pred) => (pred(n) ? n : n.children.reduce((hit, c) => hit || find(c, pred), null));
  const findSectionsRoot = (tree) => {
    let node = find(tree, (n) => n.tag === 'main' || n.role === 'main') || tree;
    for (let kids = node.children.filter(visible); kids.length === 1; kids = node.children.filter(visible)) node = kids[0];
    return node;
  };
  const sectionNodes = (root) => root.children.filter((c) => c.rect.w >= 0.5 * root.rect.w && c.rect.h >= 120);

  const toNode = (el) => {
    const r = el.getBoundingClientRect();
    const node = { tag: el.tagName.toLowerCase(), role: el.getAttribute('role') || undefined, rect: { x: r.x + scrollX, y: r.y + scrollY, w: r.width, h: r.height }, children: [...el.children].map(toNode) };
    Object.defineProperty(node, 'el', { value: el }); // not enumerable, so the node keeps the DomNode shape
    return node;
  };

  const px = (v) => parseFloat(v) || 0;
  const transparent = (c) => c === 'transparent' || c === 'rgba(0, 0, 0, 0)';
  // a section without its own background shows the nearest painted ancestor's
  const bgOf = (el) => {
    for (; el; el = el.parentElement) if (!transparent(getComputedStyle(el).backgroundColor)) return getComputedStyle(el).backgroundColor;
    return 'rgb(255, 255, 255)';
  };
  const ownText = (el) => [...el.childNodes].filter((n) => n.nodeType === 3).map((n) => n.textContent).join('').trim();

  const roleOf = (el, cs) => {
    const tag = el.tagName.toLowerCase();
    if (/^h[1-3]$/.test(tag)) return tag;
    const filled = !transparent(cs.backgroundColor) || px(cs.borderTopWidth) > 0;
    if (tag === 'button' || el.getAttribute('role') === 'button' || (tag === 'a' && filled)) return 'button';
    // eyebrow: small uppercase label with tracking, read from its own text only
    if (cs.textTransform === 'uppercase' && px(cs.letterSpacing) > 0 && px(cs.fontSize) <= 14 && ownText(el)) return 'eyebrow';
    if (tag === 'p' || tag === 'li') return 'body';
    return null;
  };

  const collectText = () => {
    const text = [];
    const buttons = [];
    const textColors = new Set();
    for (const el of document.querySelectorAll('body *')) {
      const r = el.getBoundingClientRect();
      const words = el.innerText?.trim();
      if (!r.width || !r.height || !words) continue;
      const cs = getComputedStyle(el);
      const role = roleOf(el, cs);
      if (!role) continue;
      const fontSize = px(cs.fontSize);
      const lineHeight = cs.lineHeight === 'normal' ? fontSize * 1.2 : px(cs.lineHeight);
      const lines = Math.max(1, Math.round(r.height / lineHeight));
      text.push({ role, fontSize, lineHeight, fontWeight: Number(cs.fontWeight), letterSpacing: px(cs.letterSpacing), fontFamily: cs.fontFamily.split(',')[0].replace(/["']/g, '').trim(), lineChars: Math.round(words.length / lines) });
      textColors.add(cs.color);
      if (role === 'button') buttons.push([fontSize, lineHeight, cs.fontWeight, cs.color, cs.backgroundColor, cs.borderTopLeftRadius].join('|'));
    }
    return { text, buttons, textColors: [...textColors] };
  };

  // Vertical paddings of each section and gaps between its children, below single-child wrappers.
  const collectSpacing = (nodes) => {
    const spacing = [];
    for (const n of nodes) {
      const cs = getComputedStyle(n.el);
      spacing.push(px(cs.paddingTop), px(cs.paddingBottom));
      let box = n;
      for (let kids = box.children.filter(visible); kids.length === 1; kids = box.children.filter(visible)) box = kids[0];
      const kids = box.children.filter(visible).sort((a, b) => a.rect.y - b.rect.y);
      for (let i = 1; i < kids.length; i++) spacing.push(kids[i].rect.y - (kids[i - 1].rect.y + kids[i - 1].rect.h));
    }
    return spacing.map(Math.round).filter((s) => s > 0);
  };

  window.__devorbFindSectionsRoot = findSectionsRoot;
  window.__devorbSectionNodes = sectionNodes;
  window.__devorbMetrics = () => {
    const root = findSectionsRoot(toNode(document.body));
    const nodes = sectionNodes(root);
    const sections = nodes.map((n, index) => {
      const cs = getComputedStyle(n.el);
      return {
        index,
        top: Math.round(n.rect.y),
        height: Math.round(n.rect.h),
        width: Math.round(n.rect.w),
        bg: bgOf(n.el),
        hidden: px(cs.opacity) < 0.1,
        headings: [...n.el.querySelectorAll('h1, h2, h3')].map((h) => h.innerText.trim())
      };
    });
    const images = [...document.images].filter((i) => i.getBoundingClientRect().width > 0).map((i) => i.currentSrc || i.src);
    return { url: location.href, width: innerWidth, root: root.tag, sections, ...collectText(), spacing: collectSpacing(nodes), images };
  };
})();
