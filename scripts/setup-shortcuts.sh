#!/bin/bash
set -e

echo "Setting up macOS-like shortcuts..."

# Window management
# - Don't globally bind Super+w to close: apps (Chrome, Ptyxis) handle it
#   themselves (close tab). Alt+F4 closes the window.
# - GNOME 50 has no "hide" key; Super+h maps to minimize as a fallback.
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m', '<Super>h']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up', '<Alt>F10']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super><Control>f']"

# Application/window switching
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab', '<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>grave', '<Alt>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Shift><Super>grave', '<Shift><Alt>Above_Tab']"

# Workspaces —— 已确认保持 A1（⌘⌥←/→、⌃⌥←/→、⌘PageUp/PageDown），见 docs/shortcuts/system-shortcuts.md 三·A
# 不占用全局 ⌃←/→，以免吃掉终端/编辑器的词跳转。A2（与 macOS 完全一致）如需启用再放开：
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control>Left', '<Super><Alt>Left']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control>Right', '<Super><Alt>Right']"

# Show desktop: 保留 ⌃⌘D，按 macOS 习惯增加 ⌘F11
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Primary><Super>d', '<Primary><Alt>d', '<Super>F11']"

# 系统级（锁屏/注销/截图冲突/启动器/自动锁屏）见 scripts/setup-system-shortcuts.sh

if command -v flameshot >/dev/null 2>&1; then
  echo "Flameshot 已安装：⇧⌘3/4/5 已由 setup-system-shortcuts.sh 绑定。"
else
  echo "Flameshot not found. Install with: sudo apt install flameshot"
fi

echo "Done setting base shortcuts."
