#!/bin/bash
set -e

BACKUP_DIR="${HOME}/.config/macbook-ubuntu-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Backing up keybindings to $BACKUP_DIR..."

dconf dump /org/gnome/desktop/wm/keybindings/ > "$BACKUP_DIR/wm-keybindings.dconf" 2>/dev/null || echo "  - wm-keybindings: skipped"
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$BACKUP_DIR/media-keys.dconf" 2>/dev/null || echo "  - media-keys: skipped"
dconf dump /org/gnome/mutter/keybindings/ > "$BACKUP_DIR/mutter-keybindings.dconf" 2>/dev/null || echo "  - mutter-keybindings: skipped"
dconf dump /org/gnome/shell/keybindings/ > "$BACKUP_DIR/shell-keybindings.dconf" 2>/dev/null || echo "  - shell-keybindings: skipped"

echo "Backup completed."
