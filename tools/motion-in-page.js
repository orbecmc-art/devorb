// Browser script with no imports: motion-study.mjs injects it before the page's own scripts.
(() => {
  // an animation is reported once, by the first read that sees it
  const seen = new WeakSet();
  const describe = (el) => (el ? `${el.tagName.toLowerCase()}${el.id ? `#${el.id}` : ''}${[...el.classList].slice(0, 2).map((c) => `.${c}`).join('')}` : '');

  window.__devorbMotion = (source) =>
    document.getAnimations().filter((a) => !seen.has(a) && seen.add(a)).map((a) => {
      const t = a.effect.getTiming();
      const frames = a.effect.getKeyframes();
      const transition = 'transitionProperty' in a;
      // a CSS animation keeps its curve on the keyframes, its timing says linear
      const easing = t.easing === 'linear' && frames[0]?.easing ? frames[0].easing : t.easing;
      const property = transition ? a.transitionProperty : a.animationName ?? Object.keys(frames[0] ?? {}).filter((k) => !['offset', 'computedOffset', 'easing', 'composite'].includes(k)).join(',');
      return { source, kind: transition ? 'transition' : 'animation', property, duration: Number(t.duration) || 0, delay: t.delay, easing, target: describe(a.effect.target) };
    });

  // ',' at the top level splits a selector list; inside :is() or :not() it does not
  const splitList = (text) => {
    const parts = [];
    let depth = 0;
    let start = 0;
    for (let i = 0; i < text.length; i++) {
      if (text[i] === '(') depth++;
      else if (text[i] === ')') depth--;
      else if (text[i] === ',' && depth === 0) parts.push(text.slice(start, i)), (start = i + 1);
    }
    return [...parts, text.slice(start)].map((s) => s.trim());
  };

  window.__devorbHoverTargets = (max = 20) => {
    const selectors = new Set();
    const walk = (rules) => {
      for (const r of rules) {
        if (r.selectorText) splitList(r.selectorText).filter((s) => s.includes(':hover')).map((s) => s.replaceAll(':hover', '')).filter(Boolean).forEach((s) => selectors.add(s));
        if (r.cssRules) walk(r.cssRules);
      }
    };
    for (const sheet of document.styleSheets) {
      try {
        walk(sheet.cssRules);
      } catch {} // a sheet from another origin throws SecurityError on cssRules
    }
    const elements = new Set();
    for (const s of selectors) {
      try {
        document.querySelectorAll(s).forEach((el) => elements.add(el));
      } catch {} // a selector this browser does not parse
    }
    const targets = [];
    for (const el of elements) {
      const r = el.getBoundingClientRect();
      // a closed menu's items have a box but cannot be hovered
      if (r.width > 0 && r.height > 0 && el.checkVisibility?.({ opacityProperty: true, visibilityProperty: true }) !== false) targets.push({ x: window.scrollX + r.left + r.width / 2, y: window.scrollY + r.top + r.height / 2 });
      if (targets.length >= max) break;
    }
    return targets;
  };

  window.__devorbMotionLibs = () =>
    [
      ['gsap', !!window.gsap],
      ['ScrollTrigger', !!window.ScrollTrigger],
      ['lenis', !!window.lenis || document.documentElement.classList.contains('lenis')],
      ['framer', !!document.querySelector('[data-framer-name], [data-framer-component-type], [data-framer-appear-id]')]
    ].filter(([, present]) => present).map(([name]) => name);
})();
