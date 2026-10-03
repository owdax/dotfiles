#!/usr/bin/env bash
# Symlink these dotfiles into $HOME and install the shell prerequisites.
#
# Usage: ./install.sh [--dry-run]
#
# Safe to re-run: links that already point here are left alone, and any
# existing file in the way is moved to ~/.dotfiles-backup-<timestamp>/
# instead of being overwritten.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
APP_SUPPORT="$HOME/Library/Application Support"
DRY_RUN=0

case "${1:-}" in
  --dry-run) DRY_RUN=1 ;;
  "") ;;
  *) echo "usage: $0 [--dry-run]" >&2; exit 2 ;;
esac

# repo path -> target path
LINKS=(
  ".zshrc|$HOME/.zshrc"
  ".zsh_aliases|$HOME/.zsh_aliases"
  ".p10k.zsh|$HOME/.p10k.zsh"
  ".tmux.conf|$HOME/.tmux.conf"
  ".gitconfig|$HOME/.gitconfig"
  ".gitignore_global|$HOME/.gitignore_global"
  "nvim|$HOME/.config/nvim"
  "herdr/config.toml|$HOME/.config/herdr/config.toml"
  "yazi/yazi.toml|$HOME/.config/yazi/yazi.toml"
  "ghostty/config|$APP_SUPPORT/com.mitchellh.ghostty/config"
  "lazygit/config.yml|$APP_SUPPORT/lazygit/config.yml"
  "claude/statusline.sh|$HOME/.claude/statusline.sh"
)

run() {
  if (( DRY_RUN )); then echo "    would run: $*"; else "$@"; fi
}

backup() {
  local target=$1
  local dest="$BACKUP_DIR${target#"$HOME"}"
  echo "  backup  $target -> $dest"
  run mkdir -p "$(dirname "$dest")"
  run mv "$target" "$dest"
}

link() {
  local src="$REPO/$1" target=$2
  if [[ ! -e $src ]]; then
    echo "  MISSING $src (skipped)" >&2
    return
  fi
  if [[ -L $target && "$(readlink "$target")" == "$src" ]]; then
    echo "  ok      $target"
    return
  fi
  if [[ -e $target || -L $target ]]; then
    backup "$target"
  fi
  echo "  link    $target -> $src"
  run mkdir -p "$(dirname "$target")"
  run ln -s "$src" "$target"
}

clone_if_missing() {
  local url=$1 dir=$2
  if [[ -d $dir ]]; then
    echo "  ok      $dir"
  else
    echo "  clone   $url -> $dir"
    run git clone --depth 1 "$url" "$dir"
  fi
}

(( DRY_RUN )) && echo "Dry run: nothing will be changed."
echo "Dotfiles repo: $REPO"

echo "Prerequisites:"
if ! command -v brew >/dev/null 2>&1; then
  echo "  Homebrew is not installed. Install it first: https://brew.sh" >&2
  exit 1
fi
echo "  ok      Homebrew ($(brew --prefix))"
clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "Links:"
for entry in "${LINKS[@]}"; do
  link "${entry%%|*}" "${entry#*|}"
done

# Ghostty reads config.ghostty as well as config; move a stray one aside so
# the linked config is the only one in effect.
stray_ghostty="$APP_SUPPORT/com.mitchellh.ghostty/config.ghostty"
if [[ -e $stray_ghostty ]]; then
  backup "$stray_ghostty"
fi

echo
echo "Done.$([[ -d $BACKUP_DIR ]] && echo " Replaced files are in $BACKUP_DIR")"
cat <<'EOF'
Next steps:
  brew bundle install                  # tools, apps and zsh theme/plugins
  exec zsh                             # reload the shell
  tmux, then prefix + I                # install tmux plugins
  nvim/scripts/nvim-nightly-update.sh  # install nvim-nightly (the `vim` alias)
  Add to ~/.claude/settings.json:
    "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }
EOF
