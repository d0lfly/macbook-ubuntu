#!/bin/bash
# 安装 macOS 风格 keyd 配置（内核层把 ⌘+X 翻译成 Ctrl+X）
# 需要 root：sudo ./scripts/setup-keyd.sh
set -e

[ "$(id -u)" -eq 0 ] || { echo "请用 sudo 运行：sudo $0"; exit 1; }

SRC="$(cd "$(dirname "$0")/.." && pwd)/config/keyd/default.conf"
command -v keyd.rvaiya >/dev/null || { echo "未安装 keyd：sudo apt install keyd"; exit 1; }

[ -f /etc/keyd/default.conf ] && cp -a /etc/keyd/default.conf "/etc/keyd/default.conf.bak-$(date +%Y%m%d-%H%M%S)"
install -Dm644 "$SRC" /etc/keyd/default.conf
systemctl daemon-reload
systemctl restart keyd
echo "keyd 配置已安装并重启：/etc/keyd/default.conf"
