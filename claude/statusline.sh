#!/bin/bash
# Claude Code statusLine script
# Centerpiece: tokens used (burnt) in the current session context window.
# Small extras: current directory, git branch.

input=$(cat)

# --- Token usage (centerpiece) ---------------------------------------------
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$((total_input + total_output))

format_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    awk -v n="$n" 'BEGIN{printf "%.1fM", n/1000000}'
  elif [ "$n" -ge 1000 ]; then
    awk -v n="$n" 'BEGIN{printf "%.1fk", n/1000}'
  else
    echo "$n"
  fi
}
tokens_fmt=$(format_tokens "$total_tokens")

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
pct_info=""
if [ -n "$used_pct" ]; then
  pct_info=$(printf " (%.0f%%)" "$used_pct")
fi

# Traffic-light color by context usage: green (safe) -> yellow (getting full) -> red (nearly full)
token_color="\033[1;38;5;38m"   # bold teal/cyan when usage is unknown
if [ -n "$used_pct" ]; then
  pct_int=${used_pct%.*}
  if [ "$pct_int" -ge 80 ]; then
    token_color="\033[1;38;5;203m"  # bold red
  elif [ "$pct_int" -ge 50 ]; then
    token_color="\033[1;38;5;214m"  # bold amber
  else
    token_color="\033[1;38;5;114m"  # bold green
  fi
fi
token_info=$(printf "${token_color}⛁ %s%s\033[0m" "$tokens_fmt" "$pct_info")

# --- Extras: current directory ----------------------------------------------
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
short_dir=$(echo "$cwd" | sed "s|^$HOME|~|")
dir_info=$(printf "\033[1;38;5;75m %s\033[0m" "$short_dir")

# --- Extras: git branch (optional locks skipped for safety) ----------------
git_info=""
if git -C "$cwd" --no-optional-locks rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_info=$(printf "\033[1;38;5;149m 󰊢 %s\033[0m" "$branch")
  fi
fi

# --- Extras: current model (dimmed) -----------------------------------------
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
model_info=""
if [ -n "$model_name" ]; then
  model_info=$(printf "\033[2;38;5;245m%s\033[0m" "$model_name")
fi

sep=$(printf "\033[38;5;238m │\033[0m")

line="$dir_info"
[ -n "$git_info" ] && line="$line $sep$git_info"
line="$line $sep $token_info"
[ -n "$model_info" ] && line="$line $sep $model_info"

printf "%s\n" "$line"
