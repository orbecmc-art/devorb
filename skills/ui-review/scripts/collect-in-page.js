// Browser script with no imports: shoot.mjs injects it with page.addScriptTag.
(() => {
  // Copy of findSectionsRoot and sectionNodes from rules.mjs; tests/design-shoot.test.mjs keeps them equal.
  const find = (n, pred) => (pred(n) ? n : n.children.reduce((hit, c) => hit || find(c, pred), null));
  const findSectionsRoot = (tree) => {
    let node = find(tree, (n) => n.tag === 'main' || n.role === 'main') || tree;
    // descend while one child qualifies as a section: small title rows and footers sit beside the content wrapper
    for (let kids = sectionNodes(node); kids.length === 1; kids = sectionNodes(node)) node = kids[0];
    return node;
  };
  const sectionNodes = (root) => root.children.filter((c) => c.rect.w >= 0.5 * root.rect.w && c.rect.h >= 120);

  const visible = (n) => n.rect.w > 0 && n.rect.h > 0;
  const pathTo = (n, target) => {
    if (n === target) return [n];
    for (const c of n.children) {
      const p = pathTo(c, target);
      if (p) return [n, ...p];
    }
    return null;
  };
  const scrolls = (n) => n.scrollHeight > n.clientHeight && (n.overflowY === 'auto' || n.overflowY === 'scroll');
  // app shells scroll an inner box (main or a wrapper), not the window: the sections root or its nearest scrolling ancestor
  const findScroller = (tree) => pathTo(tree, findSectionsRoot(tree)).reverse().find(scrolls) ?? null;

  const toNode = (el) => {
    const r = el.getBoundingClientRect();
    const node = {
      tag: el.tagName.toLowerCase(),
      role: el.getAttribute('role') || undefined,
      rect: { x: r.x + scrollX, y: r.y + scrollY, w: r.width, h: r.height },
      scrollHeight: el.scrollHeight,
      clientHeight: el.clientHeight,
      overflowY: getComputedStyle(el).overflowY,
      children: [...el.children].map(toNode)
    };
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

  // what a visitor sees once the page has revealed itself: closed menus, dialogs and fixed layers stay out
  const OVERLAYS = '[role=dialog], [role=menu], [role=tooltip], [role=listbox]';
  const inFixedLayer = (el) => {
    for (let a = el.parentElement; a && a !== document.body; a = a.parentElement) if (getComputedStyle(a).position === 'fixed') return true;
    return false;
  };
  // textContent, not innerText: innerText is empty under visibility: hidden
  const isContent = (el, cs) => {
    const r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0 && cs.position !== 'fixed' && !el.closest(OVERLAYS) && !!(el.textContent.trim() || el.querySelector('img, svg, video, canvas, picture')) && !inFixedLayer(el);
  };
  const faded = (opacity, cs) => opacity < 0.1 || cs.visibility === 'hidden';
  // content under an effective opacity (its own times its ancestors' down from the section) below 0.1, or hidden
  const hiddenIn = (el, opacity) => [...el.children].reduce((sum, c) => {
    const cs = getComputedStyle(c);
    const own = opacity * px(cs.opacity);
    return sum + (faded(own, cs) && isContent(c, cs) ? 1 : 0) + hiddenIn(c, own);
  }, 0);

  let revealed = 0;
  let revealStyle;
  // finishes each running animation once; an infinite one (marquee, spinner) throws InvalidStateError and keeps running
  const finishAnimations = (done = []) => {
    const all = document.getAnimations();
    for (const a of all) {
      if (done.includes(a)) continue;
      try {
        a.finish();
      } catch {}
    }
    return all;
  };
  window.__devorbReveal = () => {
    const done = finishAnimations();
    const hidden = [...document.querySelectorAll('body *')].filter((el) => {
      const cs = getComputedStyle(el);
      return faded(px(cs.opacity), cs) && isContent(el, cs);
    });
    for (const el of hidden) el.setAttribute('data-devorb-reveal', '');
    if (!revealStyle) {
      revealStyle = document.createElement('style');
      revealStyle.textContent = '[data-devorb-reveal]{opacity:1!important;visibility:visible!important}';
      document.head.appendChild(revealStyle);
    }
    finishAnimations(done); // the reveal style starts opacity and visibility transitions, and a transition outranks !important
    return (revealed = hidden.length);
  };

  let scroller;
  const innerScroller = () => (scroller ??= findScroller(toNode(document.body))?.el ?? null);

  window.__devorbFindSectionsRoot = findSectionsRoot;
  window.__devorbSectionNodes = sectionNodes;
  window.__devorbFindScroller = findScroller;
  window.__devorbScroller = () => innerScroller() ?? document.scrollingElement;
  // let the document carry the inner scroller's full height, so tops are page-relative and fullPage shots see everything
  window.__devorbExpand = () => {
    for (let el = innerScroller(); el; el = el.parentElement) {
      for (const [prop, value] of [['height', 'auto'], ['max-height', 'none'], ['overflow', 'visible']]) el.style.setProperty(prop, value, 'important');
    }
  };
  window.__devorbMetrics = () => {
    const root = findSectionsRoot(toNode(document.body));
    const nodes = sectionNodes(root);
    const sections = nodes.map((n, index) => {
      const cs = getComputedStyle(n.el);
      return {
        index,
        x: Math.round(n.rect.x),
        top: Math.round(n.rect.y),
        height: Math.round(n.rect.h),
        width: Math.round(n.rect.w),
        bg: bgOf(n.el),
        hidden: px(cs.opacity) < 0.1,
        hiddenContent: hiddenIn(n.el, px(cs.opacity)),
        headings: [...n.el.querySelectorAll('h1, h2, h3')].map((h) => h.innerText.replace(/\s+/g, ' ').trim())
      };
    });
    // query and hash can carry a session token or a signed-URL key
    const bare = (url) => url.split(/[?#]/)[0];
    const images = [...document.images].filter((i) => i.getBoundingClientRect().width > 0).map((i) => bare(i.currentSrc || i.src));
    return { url: bare(location.href), width: innerWidth, root: root.tag, sections, revealed, ...collectText(), spacing: collectSpacing(nodes), images };
  };
})();
