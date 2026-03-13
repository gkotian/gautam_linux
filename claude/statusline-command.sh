#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract version and model info
version=$(echo "$input" | jq -r '.version')
model_display=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Simplify model name
case "$model_display" in
    *"Opus 4.5"*) model="Opus 4.5" ;;
    *"Sonnet 4.5"*) model="Sonnet 4.5" ;;
    *"Haiku 4"*) model="Haiku 4" ;;
    *"Opus 4"*) model="Opus 4" ;;
    *"Sonnet 4"*) model="Sonnet 4" ;;
    *"Opus"*) model="Opus" ;;
    *"Sonnet"*) model="Sonnet" ;;
    *"Haiku"*) model="Haiku" ;;
    *) model="$model_display" ;;
esac

# Detect environment
if grep -qi microsoft /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]]; then
    # WSL — check first since pwsh.exe is also on WSL's PATH
    display_dir="$current_dir"
    if [[ "$display_dir" == "$HOME"* ]]; then
        display_dir="~${display_dir#$HOME}"
    fi
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]] || [[ -n "$WINDIR" ]]; then
    # Windows (PowerShell/cmd invoking bash)
    display_dir="$current_dir"
else
    # Native Linux/macOS
    display_dir="$current_dir"
    if [[ "$display_dir" == "$HOME"* ]]; then
        display_dir="~${display_dir#$HOME}"
    fi
fi

# Output the status line
# echo "[v$version:$model:$env] $display_dir"
echo "[v$version:$model] $display_dir"
