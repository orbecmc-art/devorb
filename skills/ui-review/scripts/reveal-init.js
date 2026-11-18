// Browser script with no imports: shoot.mjs adds it with context.addInitScript, so it runs before the page's own scripts.
// Every observed element reports as on screen, so reveal-on-enter content shows without waiting for a scroll.
(() => {
  const Native = window.IntersectionObserver;
  if (!Native) return;
  // the real entry keeps its fields as getters on its prototype, so copy them with for-in into a plain object
  const visible = (entry) => {
    const copy = {};
    for (const key in entry) copy[key] = entry[key];
    return Object.assign(copy, { isIntersecting: true, intersectionRatio: 1 });
  };
  window.IntersectionObserver = class extends Native {
    constructor(callback, options) {
      super((entries, observer) => callback(entries.map(visible), observer), options);
    }
  };
})();
