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