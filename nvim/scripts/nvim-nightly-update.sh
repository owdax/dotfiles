#!/bin/bash
set -euo pipefail
DEST=/opt/homebrew/opt/nvim-macos-arm64
LINK=/opt/homebrew/bin/nvim-nightly
TMP=$(mktemp -d)
if [ -x "$DEST/bin/nvim" ]; then
  echo "==> Current: $($DEST/bin/nvim --version | head -1)"
else
  echo "==> No nightly installed yet, doing a fresh install"
fi
echo "==> Downloading latest nightly"
curl -fL --progress-bar -o "$TMP/nvim.tar.gz" \
  https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
echo "==> Verifying checksum against GitHub's release digest"
EXPECTED=$(gh api repos/neovim/neovim/releases/tags/nightly \
  --jq '.assets[] | select(.name=="nvim-macos-arm64.tar.gz") | .digest' | sed 's/^sha256://')
ACTUAL=$(shasum -a 256 "$TMP/nvim.tar.gz" | awk '{print $1}')
[ -n "$EXPECTED" ] && [ "$EXPECTED" = "$ACTUAL" ] || { echo "checksum mismatch ($EXPECTED vs $ACTUAL)"; exit 1; }
xattr -c "$TMP/nvim.tar.gz"   # avoid macOS "unknown developer" quarantine
tar -xzf "$TMP/nvim.tar.gz" -C "$TMP"
echo "==> Installing"
rm -rf "$DEST.old"
[ -d "$DEST" ] && mv "$DEST" "$DEST.old"
mv "$TMP/nvim-macos-arm64" "$DEST"
ln -sf "$DEST/bin/nvim" "$LINK"   # `vim` alias in .zsh_aliases runs nvim-nightly
echo "==> New: $($DEST/bin/nvim --version | head -1)"
echo "==> NIGHTLY DONE"
if [ -d "$DEST.old" ]; then echo "    previous build kept at $DEST.old"; fi
