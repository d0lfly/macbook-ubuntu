#!/bin/bash
# 保持系统默认终端 Ptyxis，并将其快捷键还原为原生默认（Ctrl+Shift+…）。
# 配合 keyd 的 [meta+shift] 层，即可用 ⌘⇧C / ⌘⇧V 复制粘贴、⌘⇧T / ⌘⇧W 开关标签。
set -e

gsettings reset-recursively org.gnome.Ptyxis.Shortcuts

echo "Ptyxis 快捷键已还原为原生默认（配合 keyd 的 ⌘⇧… 使用）："
for k in copy-clipboard paste-clipboard new-tab close-tab search select-all; do
  printf '  %-18s %s\n' "$k" "$(gsettings get org.gnome.Ptyxis.Shortcuts "$k")"
done
