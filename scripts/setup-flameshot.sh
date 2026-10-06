#!/bin/bash
set -e

# Install and configure Flameshot for macOS-like shortcuts
if ! command -v flameshot >/dev/null 2>&1; then
  echo "Installing flameshot..."
  sudo apt install -y flameshot
fi

echo "Flameshot installed."
echo "To bind macOS-like shortcuts (⌘+Shift+3/4/5):"
echo "  Settings > Keyboard > Custom Shortcuts > +"
echo "  - Name: Flameshot Full Screenshot (⌘+Shift+3)"
echo "    Command: flameshot full -p ~/Pictures"
echo "    Shortcut: <Super><Shift>3"
echo "  - Name: Flameshot Area (⌘+Shift+4)"
echo "    Command: flameshot gui"
echo "    Shortcut: <Super><Shift>4"
echo "  - Name: Flameshot Launcher (⌘+Shift+5)"
echo "    Command: flameshot launcher"
echo "    Shortcut: <Super><Shift>5"
