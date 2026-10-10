#!/bin/bash
# 让 Flameshot 独占 macOS 风格的截图键：⇧⌘3 全屏 / ⇧⌘4 区域 / ⇧⌘5 工具栏。
#
# 两个坑（2026-10-11 实测，踩过才知道）：
#
#   1. 抢不到键：Ubuntu Dock 扩展默认把 <Shift><Super>1..9 绑给
#      「打开第 N 个应用的（另一个）窗口」——
#          org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-N
#      它占着 ⇧⌘3/4/5，gsd-media-keys 就注册不上，日志里只会看到
#          Failed to grab accelerator for keybinding custom:…/flameshot-*/
#      注意：跟 GNOME Shell 的截图键（已挪到 Print/⇧Print）无关，别再往那边找。
#      解法：只把 app-shift-hotkey-3/4/5 置空，保留 ⌘1..9 切应用（app-hotkey-N）。
#
#   2. 存不下来：gsd-media-keys 用 g_spawn_command_line_async 启动自定义命令，
#      **不经过 shell**，所以 `-p ~/Pictures` 里的 `~` 不会被展开，flameshot 拿到的是
#      字面量 "~/Pictures"，截图会存失败。
#      解法：写入展开后的绝对路径。
#
# 生效：脚本最后会重启 media-keys 并自检。可重复执行（幂等）。
set -e

if ! command -v flameshot >/dev/null 2>&1; then
  echo "未安装 flameshot，正在安装..."
  sudo apt install -y flameshot
fi

MK=org.gnome.settings-daemon.plugins.media-keys
SC=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding
P=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
DOCK=org.gnome.shell.extensions.dash-to-dock

SAVE_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
[ -d "$SAVE_DIR" ] || SAVE_DIR="$HOME"
mkdir -p "$SAVE_DIR"

echo "== 1) 释放 Ubuntu Dock 占用的 ⇧⌘3/4/5 =="
for n in 3 4 5; do
  gsettings set "$DOCK" "app-shift-hotkey-$n" "[]"
  echo "   app-shift-hotkey-$n = $(gsettings get "$DOCK" "app-shift-hotkey-$n")"
done

echo "== 2) 写入 Flameshot 自定义快捷键（全屏截图保存到：$SAVE_DIR）=="
gsettings set "$SC:$P/flameshot-full/"     name    'Flameshot Full Screenshot (⌘+Shift+3)'
gsettings set "$SC:$P/flameshot-full/"     command "flameshot full -p $SAVE_DIR"
gsettings set "$SC:$P/flameshot-full/"     binding '<Super><Shift>3'
gsettings set "$SC:$P/flameshot-area/"     name    'Flameshot Area (⌘+Shift+4)'
gsettings set "$SC:$P/flameshot-area/"     command 'flameshot gui'
gsettings set "$SC:$P/flameshot-area/"     binding '<Super><Shift>4'
gsettings set "$SC:$P/flameshot-launcher/" name    'Flameshot Launcher (⌘+Shift+5)'
gsettings set "$SC:$P/flameshot-launcher/" command 'flameshot launcher'
gsettings set "$SC:$P/flameshot-launcher/" binding '<Super><Shift>5'

echo "== 3) 确保三条都在 custom-keybindings 列表里（保留原有条目，不改顺序）=="
python3 - "$P" <<'PY'
import ast, subprocess, sys
P = sys.argv[1]
MK = 'org.gnome.settings-daemon.plugins.media-keys'
want = [f'{P}/flameshot-full/', f'{P}/flameshot-area/', f'{P}/flameshot-launcher/']
cur = ast.literal_eval(subprocess.check_output(
    ['gsettings', 'get', MK, 'custom-keybindings'], text=True))
out = list(cur)
for w in want:
    if w not in out:
        out.append(w)
if out != cur:
    subprocess.check_call(['gsettings', 'set', MK, 'custom-keybindings',
                           "[" + ", ".join("'%s'" % x for x in out) + "]"])
    print("   已补齐缺失条目")
else:
    print("   列表已完整")
PY

echo "== 4) 重启 media-keys（它是 D-Bus 激活 + RefuseManualStart，只能重启 target）=="
systemctl --user reset-failed org.gnome.SettingsDaemon.MediaKeys.service 2>/dev/null || true
systemctl --user restart org.gnome.SettingsDaemon.MediaKeys.target
sleep 2

echo "== 5) 自检 =="
"$(dirname "$0")/check-media-keys.sh" || true
if journalctl --user -u org.gnome.SettingsDaemon.MediaKeys.service --no-pager --since '15 sec ago' 2>/dev/null \
     | grep -q 'flameshot'; then
  echo "⚠️  仍有 flameshot 抢键失败，检查是否被别的组件占用（见脚本头部注释）"
else
  echo "✅ ⇧⌘3/4/5 已全部抢到（可按 ⌘⇧3 验证）"
fi
