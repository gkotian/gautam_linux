# Claude Code Configuration

This repo contains shared Claude Code configuration files. Symlink them
into `~/.claude/` (Linux/WSL) or `%USERPROFILE%\.claude\` (Windows) so
both environments stay in sync.

## Files

```
claude/
  CLAUDE.md                  # Global user instructions
  settings.json              # Plugins, hooks, status line
  settings.local.linux.json   # Permission overrides (Linux/WSL)
  settings.local.windows.json # Permission overrides (Windows)
  commands/note-save.md      # Custom slash command
  hooks/user-prompt-qmd.sh   # QMD knowledge-base hook
  statusline-command.js       # Status line (Node)
  statusline-command.sh       # Status line (Bash)
```

## WSL / Linux Setup

```bash
REPO="$HOME/play/gautam_linux/claude"
CLAUDE="$HOME/.claude"

ln -sf "$REPO/CLAUDE.md"                "$CLAUDE/CLAUDE.md"
ln -sf "$REPO/settings.json"            "$CLAUDE/settings.json"
ln -sf "$REPO/settings.local.linux.json" "$CLAUDE/settings.local.json"
ln -sf "$REPO/statusline-command.js"    "$CLAUDE/statusline-command.js"
ln -sf "$REPO/statusline-command.sh"    "$CLAUDE/statusline-command.sh"
ln -sf "$REPO/commands/note-save.md"    "$CLAUDE/commands/note-save.md"
ln -sf "$REPO/hooks/user-prompt-qmd.sh" "$CLAUDE/hooks/user-prompt-qmd.sh"
```

The QMD hook has two configuration variables at the top of
`hooks/user-prompt-qmd.sh`:

- `QMD_EVERY_PROMPT` — set to `true` to query on every prompt, `false`
  for trigger-only mode (default: `false`)
- `QMD_TRIGGER` — the character sequence that triggers a QMD query when
  `QMD_EVERY_PROMPT` is `false` (default: `?qmd`)

With the defaults, include `?qmd` in your prompt to trigger a vault
query. Without it the hook exits immediately (no overhead).

## Windows Setup

From an elevated PowerShell prompt:

```powershell
$Repo = "C:\Users\kotian\play\gautam_linux\claude"
$Claude = "$env:USERPROFILE\.claude"

New-Item -ItemType SymbolicLink -Path "$Claude\CLAUDE.md"                -Target "$Repo\CLAUDE.md"              -Force
New-Item -ItemType SymbolicLink -Path "$Claude\settings.json"            -Target "$Repo\settings.json"          -Force
New-Item -ItemType SymbolicLink -Path "$Claude\settings.local.json"      -Target "$Repo\settings.local.windows.json" -Force
New-Item -ItemType SymbolicLink -Path "$Claude\statusline-command.js"    -Target "$Repo\statusline-command.js"  -Force
New-Item -ItemType SymbolicLink -Path "$Claude\statusline-command.sh"    -Target "$Repo\statusline-command.sh"  -Force
New-Item -ItemType SymbolicLink -Path "$Claude\commands\note-save.md"    -Target "$Repo\commands\note-save.md"  -Force
New-Item -ItemType SymbolicLink -Path "$Claude\hooks\user-prompt-qmd.sh" -Target "$Repo\hooks\user-prompt-qmd.sh" -Force
```

On Windows the GPU is available, so QMD can run on every prompt without
the performance penalty seen in WSL. Set `QMD_EVERY_PROMPT=true` at the
top of `hooks/user-prompt-qmd.sh` to enable this.
