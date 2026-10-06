#!/bin/bash
set -e

echo "Setting up macOS-like shortcuts..."

# Window management
# Note: Don't globally bind Super+w to close window so apps (like Chrome)
# can handle it themselves (close tab). Use Alt+F4 to close window globally.
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
gsettings set org.gnome.desktop.wm.keybindings hide "['<Super>h']"

# Application/window switching
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>grave']"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Shift><Super>grave']"

# Workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Shift><Super>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Shift><Super>Right']"

if command -v flameshot >/dev/null 2>&1; then
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip '[]'
  echo "Flameshot detected; consider binding ⌘+Shift+3/4/5 to flameshot in keyboard shortcuts."
else
  echo "Flameshot not found. Install with: sudo apt install flameshot"
fi

echo "Done setting base shortcuts."
