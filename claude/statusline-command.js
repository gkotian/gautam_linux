const fs = require('fs');
const os = require('os');

const data = JSON.parse(fs.readFileSync(0, 'utf8'));
const version = data.version;
const displayName = data.model.display_name;
const currentDir = data.workspace.current_dir;

const patterns = [
  'Opus 4.6', 'Opus 4.5', 'Sonnet 4.6', 'Sonnet 4.5',
  'Haiku 4.5', 'Opus 4', 'Sonnet 4', 'Opus', 'Sonnet',
  'Haiku'
];
const model =
  patterns.find(p => displayName.includes(p)) || displayName;

const home = os.homedir();
let dir = currentDir;
if (os.platform() !== 'win32') {
  if (dir.startsWith(home)) {
    dir = '~' + dir.slice(home.length);
  }
}

const ctx = data.context_window;
const ctxStr = ctx && ctx.remaining_percentage != null
  ? ` <ctx: ${100 - ctx.remaining_percentage}% used>` : '';
const qmd = fs.existsSync('/tmp/.qmd-running')
  ? ' [QMD query active]' : '';
console.log(`[v${version}:${model}]${ctxStr}${qmd} ${dir}`);
