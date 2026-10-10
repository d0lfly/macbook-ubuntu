#!/bin/bash
# 校验 GNOME media-keys 的自定义快捷键（custom-keybindings），并检查 gsd-media-keys 是否存活。
#
# 为什么需要它（2026-10-11 实际踩坑）：
#   custom-keybindings 列表里只要出现一个【非法路径】，gsd-media-keys 在启动时就会：
#       g_settings_new_with_path: assertion 'path_is_valid (path)' failed
#       → 返回 NULL settings → g_signal_connect_data / g_settings_get_value /
#         g_variant_unref 在 NULL 上继续执行 → SEGV
#   systemd 按 Restart=on-failure 连着重启 5 次，最后 "Start request repeated too quickly"
#   彻底放弃。结果是【所有】媒体键一起失效（这些键全部由 gsd-media-keys 处理）：
#       锁屏 ⌘L / ⌃⌘Q、注销 ⇧⌘Q、启动器 ⌘Space、终端 ⌃⌥T、
#       Flameshot ⇧⌘3/4/5、微信全局键 ⇧⌘W/⇧⌘A、音量/亮度/播放键……
#   典型坏例：把 schema 名误写进路径 —— 'custom-keybinding:/emoji-picker:'
#   合法路径形如：/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/<name>/
#
# 服务本身是 D-Bus 激活 + RefuseManualStart，不能直接 start/restart，
# 修好配置后要重启 target：
#       systemctl --user reset-failed org.gnome.SettingsDaemon.MediaKeys.service
#       systemctl --user restart    org.gnome.SettingsDaemon.MediaKeys.target
#
# 用法：
#   ./scripts/check-media-keys.sh          # 只检查，不改动
#   ./scripts/check-media-keys.sh --fix    # 先备份，再删除非法条目并重启服务
set -u

MK=org.gnome.settings-daemon.plugins.media-keys
SVC=org.gnome.SettingsDaemon.MediaKeys.service
TGT=org.gnome.SettingsDaemon.MediaKeys.target
FIX=0
[ "${1:-}" = "--fix" ] && FIX=1

echo "== media-keys 自定义快捷键校验 =="

LIST="$(gsettings get "$MK" custom-keybindings 2>/dev/null || echo '[]')"
echo "   当前列表：$LIST"

read -r -d '' PY_CHECK <<'PY'
import ast, re, sys
pat = re.compile(r'^/([^/]+/)*$')
try:
    items = ast.literal_eval(sys.argv[1])
except Exception:
    items = []
if isinstance(items, str):
    items = [items]
for p in items:
    if not isinstance(p, str) or not pat.match(p):
        print(p)
PY

INVALID="$(python3 -c "$PY_CHECK" "$LIST" 2>/dev/null)"

if [ -z "$INVALID" ]; then
    echo "   ✅ 列表里全部是合法的 D-Bus object path"
else
    echo "   ❌ 发现非法路径（会让 gsd-media-keys 崩溃，进而所有媒体键失效）："
    echo "$INVALID" | sed 's/^/      - /'
    if [ "$FIX" = 1 ]; then
        BACKUP="$HOME/.config/macbook-ubuntu-backup-$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP"
        dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$BACKUP/media-keys.dconf" 2>/dev/null
        echo "      已备份：$BACKUP/media-keys.dconf"
        read -r -d '' PY_FIX <<'PY'
import ast, re, sys
pat = re.compile(r'^/([^/]+/)*$')
try:
    items = ast.literal_eval(sys.argv[1])
except Exception:
    items = []
if isinstance(items, str):
    items = [items]
valid = [p for p in items if isinstance(p, str) and pat.match(p)]
print("[" + ", ".join("'%s'" % p for p in valid) + "]")
PY
        NEW="$(python3 -c "$PY_FIX" "$LIST")"
        gsettings set "$MK" custom-keybindings "$NEW"
        echo "      已清理非法条目，新列表：$NEW"
        systemctl --user reset-failed "$SVC" 2>/dev/null
        systemctl --user restart "$TGT" 2>/dev/null
        sleep 2
    else
        echo "      → 执行 ./scripts/check-media-keys.sh --fix 可自动备份并清理"
    fi
fi

echo
echo "== gsd-media-keys 服务状态 =="
STATE="$(systemctl --user is-active "$SVC" 2>/dev/null || true)"
echo "   $SVC = ${STATE:-unknown}"
if [ "$STATE" != "active" ]; then
    echo "   ❌ 未运行：锁屏/启动器/截图/音量等所有媒体键都会失效。"
    echo "      日志：journalctl --user -u $SVC --no-pager | tail -30"
    echo "      修复：systemctl --user reset-failed $SVC"
    echo "            systemctl --user restart    $TGT"
    exit 1
fi
echo "   ✅ 运行中（PID $(pgrep -x gsd-media-keys | head -1)）"

# 抓取失败的告警：说明该加速键被别的组件（GNOME Shell / mutter / 扩展）占了
# hibernate / playback-repeat 是 GNOME 默认项，本机本来就抢不到，噪声太大，排除掉
GRAB_RAW="$(journalctl --user -u "$SVC" --no-pager --since '5 min ago' 2>/dev/null \
    | grep 'Failed to grab accelerator' \
    | grep -v 'settings:hibernate' | grep -v 'settings:playback-repeat' || true)"
GRAB="$(printf '%s\n' "$GRAB_RAW" | grep -c . || true)"
if [ "${GRAB:-0}" -gt 0 ]; then
    echo
    echo "   ⚠️  近 5 分钟有 $GRAB 条 'Failed to grab accelerator'（加速键被占用），最近几条："
    printf '%s\n' "$GRAB_RAW" | tail -5 | sed 's/^/      /'
fi
