# Dotfiles

## Quick Start (Clean Mac)

1. **Install Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Clone, install packages, link configs**
   ```bash
   # Clone anywhere; install.sh links relative to wherever the repo lives
   git clone https://github.com/owdax/dotfiles.git
   cd dotfiles

   brew bundle install   # tools, apps, zsh theme and plugins
   ./install.sh          # oh-my-zsh + TPM, then symlink every config
   exec zsh
   ```

`./install.sh --dry-run` shows what it would do without changing anything.
It is safe to re-run: links that already point at the repo are left alone,
and anything in the way is moved to `~/.dotfiles-backup-<timestamp>/`.

## What gets linked

| Repo path | Target |
|---|---|
| `.zshrc`, `.zsh_aliases`, `.p10k.zsh` | `~/` |
| `.tmux.conf`, `.gitconfig`, `.gitignore_global` | `~/` |
| `nvim/` | `~/.config/nvim` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `yazi/yazi.toml` | `~/.config/yazi/yazi.toml` |
| `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `ghostty/themes/0x96f` | `~/.config/ghostty/themes/0x96f` |
| `lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `claude/themes/0x96f.json` | `~/.claude/themes/0x96f.json` |

To add a config, put it in the repo and add a line to `LINKS` in `install.sh`.

## After installing

**Note:** Update your name and email in `.gitconfig` before using.

### Tmux plugins
`install.sh` clones TPM. Start `tmux` and press `Ctrl+a` then `I` (capital i) to install the plugins.

### Neovim nightly
The `vim` alias runs `nvim-nightly`. Install it (and update it later) with:
```bash
nvim/scripts/nvim-nightly-update.sh
```

### Claude Code status line
Needs `jq` and a Nerd Font (both in the Brewfile). Add to `~/.claude/settings.json`:
```json
"statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }
```

### 0x96f theme
Ghostty, herdr, Neovim and Claude Code all use [0x96f](https://github.com/0x96f-org).
`ghostty/themes/0x96f` is the upstream palette; it shadows the older copy bundled with Ghostty.
In Claude Code, run `/theme` once and pick **0x96f**.

The Claude Code theme's `base` is `dark-daltonized` on purpose. Claude Code colors inline
code from the base preset and ignores the override, so `dark` leaves it periwinkle, and
`dark-ansi` turns diffs gray.

### macOS Settings
```bash
# Apply macOS configurations (optional; read it first, it uses sudo)
bash .macos
```
