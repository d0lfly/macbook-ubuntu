#!/bin/bash
# 保持系统默认终端 Ptyxis，并将其快捷键还原为原生默认（Ctrl+Shift+…），
# 仅把「关闭标签」改为 ⌘W（Ctrl+W，macOS 语义）。
# 配合 keyd：⌘⇧C / ⌘⇧V 复制粘贴、⌘⇧T 新标签、⌘⇧F 搜索。
# 注意：⌘⇧W / ⌘⇧A 已让给微信全局键（显示/隐藏窗口、截图）。
set -e

gsettings reset-recursively org.gnome.Ptyxis.Shortcuts
gsettings set org.gnome.Ptyxis.Shortcuts close-tab '<ctrl>w'

echo "Ptyxis 快捷键（配合 keyd 的 ⌘… 使用）："
for k in new-tab close-tab copy-clipboard paste-clipboard search select-all; do
  printf '  %-18s %s\n' "$k" "$(gsettings get org.gnome.Ptyxis.Shortcuts "$k")"
done
