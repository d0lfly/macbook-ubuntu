# 系统快捷键梳理（macOS ↔ Ubuntu/GNOME）

> 2026-10-06 实测生成：全部取自本机 `gsettings` / `dconf` 当前值，不是文档推断。
> 环境：Ubuntu 26.04.1 LTS / GNOME Shell 50.1 / Wayland / MacBook
> 修饰键约定：⌘Cmd = Super，⌥Option = Alt，⌃Control = Control
>
> **2026-10-10 重要补充**：本机另有一个内核层键盘重映射服务 **keyd**（`/etc/keyd/default.conf`），它把 `⌘+X` 全局翻译成 `Ctrl+X`，并把 **CapsLock 映射为 Control**（`[main] capslock = layer(control)`）。此前的梳理遗漏了它，导致下文若干结论**不成立**：Ptyxis 的 Super 绑定被 keyd 抢走；`⌃⌘Q` 锁屏、`⇧⌘Q` 注销、`⌃⌘D` 显示桌面、`⇧⌘5` 截图、`⌘`` 切换窗口等系统键因复合层回落而失效。这些已在 keyd 里显式重发修复。完整架构与修正见 [mac-authentic.md](mac-authentic.md)。

## 一、实测现状

### 1. 会话与安全

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 锁屏 | ⌃⌘Q | `media-keys/screensaver` = `⌃⌘Q` + `⌘L`；keyd 显式重发 `⌃⌘Q` → `Super+Control+Q` | ✅ `⌃⌘Q` 已实测生效（keyd→GNOME 全链路，见第四节）；`⌘L` 被 keyd 翻成 `Ctrl+L`（地址栏），**不锁屏**（设计如此） |
| 注销 | ⇧⌘Q | `media-keys/logout` = ⇧⌘Q + ⌃⌥Del | ✅ |
| 关机 / 重启 / 休眠 | 无默认键盘快捷键 | 无绑定；电源键 = 睡眠（`power-button-action=suspend`） | ✅ 与 macOS 一致，无需绑定 |
| 空闲自动锁屏 | 约 2 分钟 | `idle-delay=120`(2min) + `lock-enabled=true` + `lock-delay=0` | ✅ 已按 macOS 默认调整 |
| 休眠恢复后锁屏 | 默认开 | `ubuntu-lock-on-suspend=true` | ✅ |
| 强制退出 | ⌥⌘Esc | 无对应（GNOME 无 force-quit 键） | ✅ 用 `⌥F4` 替代（见三·B） |

### 2. 截图

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 全屏截图 | ⇧⌘3 | Flameshot `flameshot full -p ~/Pictures` **与** GNOME Shell `screenshot` 同键 | ⚠️ 冲突，已释放给 Flameshot |
| 区域截图 | ⇧⌘4 | Flameshot `flameshot gui` **与** GNOME Shell `show-screenshot-ui` 同键 | ⚠️ 冲突，已释放给 Flameshot |
| 截图工具栏 | ⇧⌘5 | Flameshot `flameshot launcher` | ✅ 无冲突 |
| 系统截图 UI | — | `Print` / `⇧Print` | ✅ 保留 |

### 3. 概览 / 启动器 / 窗口

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 启动器 / Spotlight | ⌘Space | `media-keys/search` = ⌘Space | ✅ |
| Mission Control | ⌃↑ | `toggle-overview` = ⌃↑ | ✅ 默认即匹配 |
| App Exposé | ⌃↓ | `toggle-application-view` = ⌃↓ | ✅ 默认即匹配 |
| 切换应用 | ⌘Tab | `switch-applications` = ⌘Tab + ⌥Tab | ✅ |
| 应用内窗口切换 | ⌘` | `switch-group` = ⌘` + ⌥` | ✅ |
| 关闭窗口/标签 | ⌘W | 系统级仅 `⌥F4`（⌘W 交由应用：Chrome 关标签、Ptyxis 关标签） | ✅ 按前次确认执行 |
| 最小化 | ⌘M | `minimize` = ⌘M + ⌘H | ✅ |
| 隐藏应用 | ⌘H | GNOME 50 已移除 `hide` 键，⌘H 复用为最小化 | ⚠️ 语义近似（无法真隐藏） |
| 最大化/还原 | ⌘↑/↓ 绿钮 | `toggle-maximized` = ⌘↑ + ⌥F10 | ✅ |
| 全屏 | ⌃⌘F | `toggle-fullscreen` = ⌃⌘F | ✅ 恰好与 macOS 一致 |
| 显示桌面 | ⌘F3 / F11 | `show-desktop` = ⌃⌘D + ⌃⌥D + `⌘F11` | ✅ 已按 macOS 增加 ⌘F11（见三·C） |
| 打开系统设置 | ⌘, | `activate-window-menu` = ⌥Space（窗口菜单） | ⚠️ 应用内 ⌘, 见应用篇 |

### 4. 工作区 / 虚拟桌面

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 切换左/右桌面 | ⌃← / ⌃→ | **⌘⌃← / ⌘⌃→**（另保留 ⌘⌥←/→、⌃⌥←/→、⌘PageUp/Down） | ✅ 已改为 ⌘⌃←/→（避免占用 ⌃←/→ 词跳转） |
| 移动窗口到左/右桌面 | ⌃⌥←/→ 拖动 | ⌘⇧Home/End、⌘⇧⌥←/→、⌃⇧⌥←/→ 等 | ✅ 同上 |

### 5. 音量 / 亮度 / 媒体

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 音量± / 静音 | F11/F12/F10 | `XF86AudioRaiseVolume/LowerVolume/Mute` | ✅ 硬件键直达 |
| 屏幕亮度 | F1/F2 | `XF86MonBrightnessUp/Down` | ✅ |
| 键盘背光 | F5/F6 | `XF86KbdBrightnessUp/Down` | ✅ |
| 播放/暂停/切歌 | F7/F8/F9 | `XF86AudioPlay/Next/Prev` | ✅ |

> MacBook 键盘需确认「F1–F12 作为标准功能键」还是「媒体键优先」，影响是否要按 Fn。

### 6. 输入法 / 无障碍 / 终端

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 切换输入法 | ⌃Space | `switch-input-source` = ⌃Space | ✅ |
| 打开终端 | 无默认 | `media-keys/terminal` = ⌃⌥T | ✅ Ubuntu 惯例 |
| Emoji | ⌃⌘Space | 自定义 `⌘.` → `~/.local/bin/emoji-picker` | ✅ |
| 放大镜 | ⌃⌘± | ⌥⌘= / ⌥⌘- ；屏幕阅读器 ⌥⌘S | ✅ |
| 终端（kitty） | ⌘T/⌘W/⌘C/⌘V/⌘F | keyd 全局 ⌘→Ctrl + kitty 键位；⌘C 复制、⌘V 粘贴 | ✅ 见 `mac-authentic.md` |
| 微信全局键 | ⌘⇧W / ⌘⇧A | keyd `[meta+shift]` 显式重发 `⌘⇧W/⌘⇧A` → `Super+Shift+W/A`；终端关标签因此改用 `⌘W` | ✅ 已生效 |

## 二、发现的问题

1. **锁屏**：GNOME 默认 `⌘L` 被改成仅 `⌃⌘Q`，按 ⌘L 无反应 —— 这就是「锁屏没设定」的直接原因。已恢复为 `⌘L` + `⌃⌘Q` 双绑定。
2. **截图同键双绑定**：`⇧⌘3/4` 同时注册在 GNOME Shell 与 Flameshot 上，行为不确定（通常 Shell 抢占，Flameshot 不触发）。已释放 Shell 侧，Print 键仍可用系统截图。
3. **`scripts/setup-shortcuts.sh` 不可执行**：脚本引用了本环境不存在的键
   - `org.gnome.desktop.wm.keybindings hide`（GNOME 50 已移除）
   - `org.gnome.settings-daemon.plugins.media-keys screenshot / area-screenshot …`（已迁移到 `org.gnome.shell.keybindings`）
   在 `set -e` 下脚本会在中途退出；且实测 `toggle-maximized`、`switch-to-workspace-*` 等仍是 GNOME 默认值，说明**该脚本此前从未真正生效**（只有 `close`、`search`、Flameshot 三条是单独 gsettings 落地的）。已修复。
4. **（结论已修正）`emoji-picker` 条目非法，是 2026-10-06 起全部媒体键失效的根因。** 此前把它当成「正常条目」是误判：`custom-keybinding:/emoji-picker:` 把 schema 名写进了路径，不是合法的 settings path。`gsd-media-keys` 启动时对它调用 `g_settings_new_with_path()` 断言失败、拿到 NULL 后继续解引用 → **SEGV**，systemd 重启 5 次后放弃。后果是**所有**由它处理的快捷键失效（锁屏/注销/启动器/终端/Flameshot/微信/音量亮度）。已迁移到合法路径并重启服务，详见第四节；
5. dconf 残留 `/org/gnome/xxx-test-nonexistent/…`（38 组测试数据，可能来自某次 dconf 命令测试），不影响功能，已清理（含备份）。
6. `docs/shortcuts/shortcuts-mapping.md` 有过期表述（"Flameshot 未安装"、"搜索键当前为空"），已更新。

## 三、待确认项 → 确认结果（2026-10-10 已执行）

| 项 | 建议 | 结果 |
|---|---|---|
| A. 工作区切换 | 改用 ⌘⌃←/→（keyd 在 `[control+meta]` 显式重发为 `Super+Control+←/→`），保留 ⌘⌥←/→、⌃⌥←/→、⌘PageUp/Down | ✅ 已执行（2026-10-10 续） |
| B. 强制退出 | 用 `⌥F4` 替代（`close=['<Alt>F4']`），不另绑系统监视器 | ✅ 确认，保持现状 |
| C. 显示桌面 | 增加 macOS 习惯 `⌘F11` | ✅ 已加：`show-desktop = ['⌃⌘D', '⌃⌥D', '⌘F11']` |
| D. 自动锁屏时长 | 对齐 macOS 约 2 分钟 | ✅ 已改：`idle-delay=120`（原 300） |
| E. 清理残留 | 删除 `xxx-test-nonexistent` dconf 测试数据（已先备份到 `~/.config/macbook-ubuntu-backup-*/`） | ✅ 已清理 |

## 四、2026-10-11 事故与修复：gsd-media-keys 崩溃 → 全部媒体键失效

### 症状
按 `⌃⌘Q` / `⌘L` 锁屏毫无反应；`⌘Space` 启动器、`⇧⌘3/4/5` Flameshot、微信 `⇧⌘W/⇧⌘A`、音量/亮度键一并失效。

### 根因
`custom-keybindings` 列表里有一条非法路径（把 schema 名写进了路径，且不以 `/` 开头）：

```
'custom-keybinding:/emoji-picker:'
```

`gsd-media-keys` 启动时会对列表每一项调用 `g_settings_new_with_path()`：

```
g_settings_new_with_path: assertion 'path_is_valid (path)' failed
invalid (NULL) pointer instance
g_signal_connect_data: assertion 'G_TYPE_CHECK_INSTANCE (instance)' failed
g_settings_get_value / g_variant_get_string / g_variant_unref: assertion 'value != NULL' failed
→ SEGV (core dumped)
```

systemd `Restart=on-failure` 连续重启 5 次后报 “Start request repeated too quickly”，服务进入 failed 且**不再自启**。自 2026-10-06 10:34:38 会话启动起，本机 media-keys 一直是死的。

> 关键点：`gsd-media-keys` 不只是「媒体键」服务 —— **锁屏、注销、启动器、终端、所有自定义快捷键都归它管**。它挂了，等于所有系统级快捷键一起挂。

合法的 settings path 规则（GLib 实测）：以 `/` 开头、以 `/` 结尾、不能有空段（`//`）；字符本身不限（`-`、`_`、`.`、`:`、空格都行）。所以坏例里真正的错是「不以 `/` 开头」。

### 修复
1. 备份 dconf（`~/.config/macbook-ubuntu-backup-*/media-keys.before.dconf`）。
2. emoji 条目迁到合法路径，并删掉坏条目：
   - 合法：`/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emoji-picker/`
   - 删除：`dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-keybinding:/emoji-picker:/`
3. 重启服务（它是 D-Bus 激活 + `RefuseManualStart`，不能直接 start/restart，只能重启 target）：
   ```bash
   systemctl --user reset-failed org.gnome.SettingsDaemon.MediaKeys.service
   systemctl --user restart    org.gnome.SettingsDaemon.MediaKeys.target
   ```
4. 新增 `scripts/check-media-keys.sh` 做体检（`--fix` 自动备份 + 清理 + 重启），避免同类问题再次静默发生。

### 实测验证（2026-10-11）
用 uinput 虚拟键盘注入按键、并重启 keyd 让它接管该设备，验证**全链路**（keyd → GNOME）：

| 注入按键 | keyd 实际输出 | 命中 | 结论 |
|---|---|---|---|
| `Super+L`（⌘L） | `Ctrl+L` | `<Control>l` 探针 | ⌘L = 地址栏，**不锁屏**（设计如此） |
| `Ctrl+Super+Q`（⌃⌘Q） | `Super+Ctrl+Q` | `<Super><Control>q` 探针 | 命中 `screensaver` 绑定 → **锁屏可用** |

### 顺带发现（未改动，待确认）：Flameshot ⇧⌘3/4/5 抢不到键
服务稳定报 `Failed to grab accelerator for keybinding custom:…/flameshot-*/`。实测把绑定换成 `⌘⇧F10` 就能抢到，说明 `⌘⇧1..9` 被 **mutter 内置的「移动窗口到工作区 N」**占着（`org.gnome.desktop.wm.keybindings move-to-workspace-3/4/5` 即使已清空也无效）。因此 ⇧⌘3/4/5 目前给不了 Flameshot —— 此前「截图冲突已释放」的结论不完整，需要另选组合或接受该冲突。

## 五、执行方式

```bash
./scripts/backup-keybindings.sh        # 备份
./scripts/setup-system-shortcuts.sh    # 系统级：锁屏/注销/截图冲突/启动器/自动锁屏
./scripts/check-media-keys.sh          # 体检：锁屏等媒体键是否正常（--fix 自动修复）
./scripts/setup-shortcuts.sh           # 窗口级：最小化/切换/全屏等（工作区部分为注释，待确认后放开）
```
