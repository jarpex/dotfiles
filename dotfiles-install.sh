#!/bin/bash
set -euo pipefail

# Path to your dotfiles repository
DOTFILES_DIR="$HOME/Documents/Repos/dotfiles"
# Backup directory for existing files
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Create a symbolic link from $1 (source relative to DOTFILES_DIR)
# to $2 (absolute target path in home directory)
link_file() {
    local source="$DOTFILES_DIR/$1"
    local target="$HOME/$2"

    # Ensure the target's parent directory exists
    mkdir -p "$(dirname "$target")"

    # If the target exists
    if [ -L "$target" ]; then
        # If it's already the correct symlink
        if [ "$(readlink "$target")" = "$source" ]; then
            echo "✔ Symlink already exists: $target → $source"
            return
        else
            echo "⚠️ Conflicting symlink found. Backing up."
            mkdir -p "$BACKUP_DIR"
            mv "$target" "$BACKUP_DIR/"
        fi
    elif [ -e "$target" ]; then
        # If it's a regular file or directory
        echo "⚠️ File or directory exists at $target. Backing up."
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi

    # Create symbolic link
    ln -s "$source" "$target"
    echo "✅ Linked: $target → $source"
}

# skhd config
link_file ".config/skhd/skhdrc" ".config/skhd/skhdrc"
link_file ".config/ghostty/config" ".config/ghostty/config"