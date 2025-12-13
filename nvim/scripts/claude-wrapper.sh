#!/bin/bash
# Wrapper script to run Claude with clean terminal env
# Prevents iTerm2 fancy underlines that Neovim can't render
export TERM="xterm-256color"
export COLORTERM=""
export TERM_PROGRAM=""
export LC_TERMINAL=""
export ITERM_SESSION_ID=""
export TERM_FEATURES=""
exec claude "$@"
