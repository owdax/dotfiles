#!/bin/bash
set -euo pipefail
DEST=/opt/homebrew/opt/nvim-macos-arm64
TMP=$(mktemp -d)
echo "==> Current: $($DEST/bin/nvim --version | head -1)"
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
mv "$DEST" "$DEST.old"
mv "$TMP/nvim-macos-arm64" "$DEST"
echo "==> New: $($DEST/bin/nvim --version | head -1)"
echo "==> NIGHTLY DONE (previous build kept at $DEST.old)"
