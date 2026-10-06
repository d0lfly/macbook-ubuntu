# 系统快捷键梳理（macOS ↔ Ubuntu/GNOME）

> 2026-10-06 实测生成：全部取自本机 `gsettings` / `dconf` 当前值，不是文档推断。
> 环境：Ubuntu 26.04.1 LTS / GNOME Shell 50.1 / Wayland / MacBook
> 修饰键约定：⌘Cmd = Super，⌥Option = Alt，⌃Control = Control

## 一、实测现状

### 1. 会话与安全

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 锁屏 | ⌃⌘Q | `media-keys/screensaver` = ⌃⌘Q（**⌘L 已失效**，被覆盖） | ⚠️ 已补回 ⌘L，双绑定 |
| 注销 | ⇧⌘Q | `media-keys/logout` = ⇧⌘Q + ⌃⌥Del | ✅ |
| 关机 / 重启 / 休眠 | 无默认键盘快捷键 | 无绑定；电源键 = 睡眠（`power-button-action=suspend`） | ✅ 与 macOS 一致，无需绑定 |
| 空闲自动锁屏 | 约 2 分钟 | `idle-delay=300`(5min) + `lock-enabled=true` + `lock-delay=0` | ✅ 可调时长 |
| 休眠恢复后锁屏 | 默认开 | `ubuntu-lock-on-suspend=true` | ✅ |
| 强制退出 | ⌥⌘Esc | 无对应（GNOME 无 force-quit 键） | ⏸ 待确认（见三·B） |

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
| 显示桌面 | ⌘F3 / F11 | `show-desktop` = ⌃⌘D | ⏸ 可选（见三·C） |
| 打开系统设置 | ⌘, | `activate-window-menu` = ⌥Space（窗口菜单） | ⚠️ 应用内 ⌘, 见应用篇 |

### 4. 工作区 / 虚拟桌面

| 功能 | macOS | 本机当前绑定 | 结论 |
|---|---|---|---|
| 切换左/右桌面 | ⌃← / ⌃→ | ⌘⌥← / ⌃⌥← / ⌘PageUp；⌘⌥→ / ⌃⌥→ / ⌘PageDown | ⏸ 不一致，待确认（见三·A） |
| 移动窗口到左/右桌面 | ⌃⌥←/→ 拖动 | ⌘⇧Home/End、⌘⇧⌥←/→、⌃⇧⌥←/→ 等 | ⏸ 同上 |

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
| Ptyxis（终端） | ⌘T/⌘W/⌘C/⌘V/⌘F/⌘, | `Ptyxis/Shortcuts` 已全为 Super 系 | ✅ 已是 macOS 风格 |
| 微信全局键 | ⌘⇧W / ⌘⇧A | `⌘⇧W` 显示/隐藏窗口、`⌘⇧A` 截图 | ✅ 与 macOS 微信一致 |

## 二、发现的问题

1. **锁屏**：GNOME 默认 `⌘L` 被改成仅 `⌃⌘Q`，按 ⌘L 无反应 —— 这就是「锁屏没设定」的直接原因。已恢复为 `⌘L` + `⌃⌘Q` 双绑定。
2. **截图同键双绑定**：`⇧⌘3/4` 同时注册在 GNOME Shell 与 Flameshot 上，行为不确定（通常 Shell 抢占，Flameshot 不触发）。已释放 Shell 侧，Print 键仍可用系统截图。
3. **`scripts/setup-shortcuts.sh` 不可执行**：脚本引用了本环境不存在的键
   - `org.gnome.desktop.wm.keybindings hide`（GNOME 50 已移除）
   - `org.gnome.settings-daemon.plugins.media-keys screenshot / area-screenshot …`（已迁移到 `org.gnome.shell.keybindings`）
   在 `set -e` 下脚本会在中途退出；且实测 `toggle-maximized`、`switch-to-workspace-*` 等仍是 GNOME 默认值，说明**该脚本此前从未真正生效**（只有 `close`、`search`、Flameshot 三条是单独 gsettings 落地的）。已修复。
4. `custom-keybindings` 列表里存在 name/binding/command 全空的 `emoji-picker` 占位项（真正生效的是另一个 `Super+period` 条目）。
5. dconf 残留 `/org/xxx-test-nonexistent/…` 测试数据（约 30 组），不影响功能。
6. `docs/shortcuts/shortcuts-mapping.md` 有过期表述（"Flameshot 未安装"、"搜索键当前为空"），已更新。

## 三、待确认项（回复后我立即执行）

**A. 工作区（虚拟桌面）切换组合** —— 唯一一处与 macOS 明显不一致的系统键

| 方案 | 绑定 | 优点 | 代价 |
|---|---|---|---|
| A1（推荐） | 保持现状 ⌘⌥←/→、⌃⌥←/→ | 不占用任何全局 Ctrl 组合，终端/编辑器 `⌃←` 词跳转不受影响 | 与 macOS ⌃←/→ 不同，需记两套 |
| A2 | 全局占用 ⌃← / ⌃→ | 与 macOS 完全一致 | 终端、VS Code、Chrome 地址栏等 Linux 应用的 `⌃←/→`（词跳转/行首尾）会被系统吃掉，对开发影响大 |
| A3 | ⌘← / ⌘→ | 单手好按 | 与 Chrome 前进/后退、终端行首行尾等应用内键位冲突，风险最高 |

**B. 强制退出（⌥⌘Esc）**：GNOME 无对应系统键。可选 ①不绑定，用 `⌥F4` 或系统监视器；②绑定到打开系统监视器。

**C. 显示桌面**：当前 `⌃⌘D`。是否额外加 `⌘F11`（macOS 习惯）？F11 在部分键盘是音量键，需确认。

**D. 自动锁屏时长**：当前空闲 5 分钟即锁屏，是否调整（macOS 默认约 2 分钟/立即）？

**E. 清理**：删除空的 `emoji-picker` 自定义项与 `/org/xxx-test-nonexistent/` 残留。

## 四、执行方式

```bash
./scripts/backup-keybindings.sh        # 备份
./scripts/setup-system-shortcuts.sh    # 系统级：锁屏/注销/截图冲突/启动器/自动锁屏
./scripts/setup-shortcuts.sh           # 窗口级：最小化/切换/全屏等（工作区部分为注释，待确认后放开）
```
