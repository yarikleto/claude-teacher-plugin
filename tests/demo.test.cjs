const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { test } = require('node:test');

const template = fs.readFileSync(path.join(__dirname, '../skills/demo/template.html'), 'utf8');
const script = [...template.matchAll(/<script>([\s\S]*?)<\/script>/g)].at(-1)[1];

// Execute the actual shipped helpers without loading a CDN or a browser.
function load({ stored = null, denied = false, offline = false, pathname = '/lesson-a.html', content = '' } = {}) {
  const app = { textContent: 'Loading' };
  const writes = [];
  const storage = {
    getItem(key) { if (denied) throw Error('Storage denied'); writes.push(['read', key]); return stored; },
    setItem(key, value) { if (denied) throw Error('Storage denied'); writes.push(['write', key, value]); },
  };
  const sandbox = {
    window: { location: { pathname } }, localStorage: storage,
    document: { getElementById: () => app, documentElement: {} },
    getComputedStyle: () => ({ getPropertyValue: () => '#abcdef' }),
  };
  if (!offline) {
    sandbox.preact = sandbox.window.preact = { h() {}, render() {} };
    sandbox.preactHooks = sandbox.window.preactHooks = {};
    sandbox.htm = sandbox.window.htm = { bind: () => () => ({}) };
  }
  vm.createContext(sandbox);
  const instrumented = script.replace('// __CONTENT_END__', content + '\n// __CONTENT_END__').replace('    })();', '    window.testHelpers = { readSavedStep, saveStep };\n    })();');
  vm.runInContext(instrumented, sandbox);
  return { api: sandbox.window, writes, app };
}

test('template inline JavaScript parses', () => {
  assert.doesNotThrow(() => new vm.Script(script));
});

test('denied local storage does not crash a local-file demo', () => {
  const { api } = load({ denied: true });
  assert.equal(api.testHelpers.readSavedStep(), 0);
  assert.doesNotThrow(() => api.testHelpers.saveStep(0));
});

test('each lesson persists its own step and rejects invalid stored indices', () => {
  const a = load({ pathname: '/lesson-a.html' });
  const b = load({ pathname: '/lesson-b.html' });
  a.api.testHelpers.saveStep(0);
  b.api.testHelpers.saveStep(0);
  assert.notEqual(a.writes[0][1], b.writes[0][1]);
  for (const stored of ['-1', '3', 'not-a-number', '0.5']) {
    assert.equal(load({ stored }).api.testHelpers.readSavedStep(), 0);
  }
});

test('a CDN failure leaves an actionable message instead of a blank demo', () => {
  const { api, app } = load({ offline: true });
  assert.match(app.textContent, /could not load/);
  assert.match(app.textContent, /Markdown/);
  assert.equal(api.testHelpers, undefined);
});

test('pills restore canvas state and honor opacity for both shape and text', () => {
  const { api } = load();
  const stack = [], alpha = [];
  const ctx = {
    font: 'original font', globalAlpha: 0.7,
    save() { stack.push({ font: this.font, globalAlpha: this.globalAlpha }); },
    restore() { Object.assign(this, stack.pop()); },
    measureText() { return { width: 20 }; },
    beginPath() {}, roundRect() {},
    fill() { alpha.push(this.globalAlpha); },
    fillText() { alpha.push(this.globalAlpha); },
  };
  api.drawPill(ctx, 'label', 0, 0, { opacity: 0.25 });
  assert.deepEqual(alpha, [0.25, 0.25]);
  assert.equal(ctx.font, 'original font');
  assert.equal(ctx.globalAlpha, 0.7);
  assert.equal(stack.length, 0);
});

test('named background and overlay callbacks remain available to the engine', () => {
  const { api } = load({ content: "function drawBackground() { return 'background'; } function drawOverlay() { return 'overlay'; }" });
  assert.equal(api.drawBackground(), 'background');
  assert.equal(api.drawOverlay(), 'overlay');
});
