#!/bin/bash
# 安装 kitty 作为默认终端，并应用 macOS 风格键位（⌘C 复制 / ⌘V 粘贴）
# 依赖：sudo apt install kitty
set -e

command -v kitty >/dev/null || { echo "未安装 kitty：sudo apt install kitty"; exit 1; }

REPO="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$HOME/.config/kitty"
cp "$REPO/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# 设为 xdg-terminal-exec 的默认终端（GNOME 的“打开终端”/Ctrl+Alt+T 会用它）
printf 'kitty.desktop\n' > "$HOME/.config/xdg-terminals.list"

echo "kitty 配置已安装：~/.config/kitty/kitty.conf"
echo "默认终端：$(XDG_CURRENT_DESKTOP=ubuntu:GNOME xdg-terminal-exec --print-id 2>/dev/null || echo 'kitty.desktop')"
