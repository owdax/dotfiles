# Dotfiles

## Quick Start (Clean Mac)

1. **Install Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Clone & Install**
   ```bash
   # Clone repository
   git clone https://github.com/owdax/dotfiles.git
   cd dotfiles

   # Install everything
   brew bundle install
   ```

## Additional Setup

### Symlink Dotfiles
```bash
# Link configuration files
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.zsh_aliases ~/.zsh_aliases
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global

# Link nvim config directory
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Link herdr config
mkdir -p ~/.config/herdr
ln -sf ~/dotfiles/herdr/config.toml ~/.config/herdr/config.toml

# Link Ghostty config
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
ln -sf ~/dotfiles/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Link yazi config
mkdir -p ~/.config/yazi
ln -sf ~/dotfiles/yazi/yazi.toml ~/.config/yazi/yazi.toml

# Link lazygit config
mkdir -p ~/Library/Application\ Support/lazygit
ln -sf ~/dotfiles/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml

# Link Claude Code status line (needs jq + a Nerd Font)
mkdir -p ~/.claude
ln -sf ~/dotfiles/claude/statusline.sh ~/.claude/statusline.sh
# then add to ~/.claude/settings.json:
#   "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }

# Reload shell
source ~/.zshrc
```

**Note:** Update your name and email in `.gitconfig` before using.

### Tmux Plugin Manager (TPM)
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins
tmux
# Press: Ctrl+a + I (capital i) to install plugins
```

### macOS Settings
```bash
# Apply macOS configurations (optional)
cd ~/dotfiles
chmod +x .macos
./.macos
```