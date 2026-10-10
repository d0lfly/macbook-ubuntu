#!/bin/bash
set -e

echo "== 系统级快捷键（macOS 习惯）=="

# 锁屏：macOS ⌃⌘Q；同时保留 Ubuntu 习惯 ⌘L
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l', '<Super><Control>q']"

# 注销：macOS ⇧⌘Q，保留 ⌃⌥Del
gsettings set org.gnome.settings-daemon.plugins.media-keys logout "['<Super><Shift>q', '<Control><Alt>Delete']"

# 启动器 / Spotlight 替代：⌘Space（与 IBus ⌃Space 不冲突）
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>space']"

# 打开终端（Ubuntu 惯例，macOS 无对应）
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']"

# 截图：⇧⌘3/4/5 交给 Flameshot 独占，释放 GNOME Shell 的同键绑定
# （Print / ⇧Print 仍可调出系统截图 UI）
if command -v flameshot >/dev/null 2>&1; then
  gsettings set org.gnome.shell.keybindings screenshot "['<Shift>Print']"
  gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Print>']"
else
  echo "flameshot 未安装，保留 GNOME Shell 截图绑定（⇧⌘3/4）"
fi

# 自动锁屏：空闲 2 分钟锁屏（对齐 macOS 默认），锁屏立即生效，休眠恢复需解锁
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.desktop.session idle-delay 120
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend true

echo "== 当前系统级绑定 =="
gsettings get org.gnome.settings-daemon.plugins.media-keys screensaver
gsettings get org.gnome.settings-daemon.plugins.media-keys logout
gsettings get org.gnome.settings-daemon.plugins.media-keys search
gsettings get org.gnome.shell.keybindings screenshot
gsettings get org.gnome.shell.keybindings show-screenshot-ui

# 收尾体检：gsd-media-keys 挂了会让以上所有系统键一起失效
# （2026-10-06~10-11 实际发生过，见 docs/shortcuts/system-shortcuts.md 第四节）
"$(dirname "$0")/check-media-keys.sh" || true

echo "完成。"
