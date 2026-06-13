#!/bin/bash
# Session picker script for kitty

session_dir="$HOME/.config/kitty/sessions"

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    echo "On Fedora: sudo dnf install fzf"
    read -n 1 -s -r -p "Press any key to exit..."
    exit 1
fi

# List sessions and let user pick with fzf
session=$(find "$session_dir" -maxdepth 1 -type f -name '*.session' -printf '%f\n' 2>/dev/null | sed 's/\.session$//' | fzf --prompt="Select session: " --height=40% --reverse)

# If a session was selected, open it
if [ -n "$session" ]; then
    kitty --session "$session_dir/${session}.session" &
fi
