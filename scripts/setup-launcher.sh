#!/bin/bash
set -e

echo "Configuring launcher shortcut (⌘+Space)..."
# IBus uses Ctrl+Space for input method switch; Super+Space is free
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>space']"
echo "Set org.gnome.settings-daemon.plugins.media-keys search to ['<Super>space']"
echo "Done."
