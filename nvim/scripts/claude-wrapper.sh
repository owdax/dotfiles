#!/bin/bash
# Run Claude inside Neovim's terminal with a plain terminal identity.
# Claude would otherwise detect the outer terminal (Ghostty, iTerm2, ...) from
# the inherited env and emit escape sequences (e.g. styled underlines) that
# Neovim's built-in terminal can't render.
export TERM="xterm-256color"
export COLORTERM=""
export TERM_PROGRAM=""
export LC_TERMINAL=""
export ITERM_SESSION_ID=""
export TERM_FEATURES=""
exec claude "$@"
