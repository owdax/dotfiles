#!/usr/bin/env bash

# Easier navigation
alias ..="cd .."
alias ~="cd ~" 
alias -- ="cd -"

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"
alias g="git"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, ""); print }'"

# Recursively delete `.DS_Store` files
alias dsstoredelete="find . -type f -name '*.DS_Store' -ls -delete"

# Show/hide hidden files in Finder
alias showhidden="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Grep color and show the line number for each match:
alias grep="grep -n --color"

# Ping stop after 5 pings
alias ping="ping -c 5"

# Make vim neovim
alias vim="nvim"

# fzf nvim
alias vifzf='selected_file=$(fzf --preview="bat --color=always {}"); [[ -n "$selected_file" ]] && nvim "$selected_file"'
