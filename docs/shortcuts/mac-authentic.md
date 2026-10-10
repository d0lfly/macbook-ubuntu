# macOS 手感最佳方案（架构与决策）

> 2026-10-10 落地。目标：在 Ubuntu 26.04 / GNOME 50 / Wayland / MacBook 上，尽可能还原 macOS 的快捷键手感。

## 一、三层架构

| 层 | 组件 | 作用 |
|---|---|---|
| 内核层 | **keyd** | 把物理 `⌘+X` 翻译成应用认得的 `Ctrl+X`；`Super` 本体保留给 GNOME |
| 终端层 | **kitty** | 终端是唯一「Ctrl 有特殊含义」的应用，单独配置 |
| 桌面层 | **GNOME (gsettings)** | 系统级快捷键对齐 macOS |

### 为什么必须分层

- Linux 的 GUI 应用（Chrome / VS Code / 微信）只认 `Ctrl` 快捷键，不认 `Super`；而 macOS 用 `⌘`。keyd 在 evdev 层统一把 `⌘+键` 翻译成 `Ctrl+键`，一次性覆盖所有 GUI 应用。
- **终端是唯一例外**：终端里 `Ctrl+C` 是中断信号（SIGINT），复制/粘贴是 `Ctrl+Shift+C/V`。keyd 的全局翻译会把 `⌘C` 变成 `Ctrl+C`（中断），所以终端必须单独处理。
- keyd 在 Wayland 下**无法按应用区分**（`keyd-application-mapper` 仅支持 X11），因此不能用「只在终端里换一套映射」的做法 —— 只能换一个「能配合 `Ctrl` 使用的终端」。

## 二、终端：为什么换成 kitty

| 方案 | `⌘C` 复制 | `Ctrl+C` 中断 | 结论 |
|---|---|---|---|
| Ptyxis（GNOME 默认） | ✗（只能 `⌘⇧C`） | ✓ | Ptyxis 没有 `copy_or_interrupt` 动作，做不到 `⌘C` 复制 |
| **kitty** | ✓ | ✓（无选区时） | ✅ 采用 |

kitty 的 `copy_or_interrupt`：**有选区时复制，无选区时发送中断** —— 最贴近 macOS Terminal 的行为。

### kitty 键位（配合 keyd）

| macOS 习惯 | keyd 实际发送 | kitty 行为 |
|---|---|---|
| `⌘C` / `⌘V` | `Ctrl+C` / `Ctrl+V` | 复制 / 粘贴 |
| `⌘⇧C` / `⌘⇧V` | `Ctrl+Shift+C/V` | 复制 / 粘贴 |
| `⌘⇧T` / `⌘⇧W` / `⌘⇧N` | `Ctrl+Shift+T/W/N` | 新标签 / 关标签 / 新窗口 |
| `⌘1`…`⌘9` | `Ctrl+1`…`9` | 切到第 N 个标签 |
| `⌘⇧[` / `⌘⇧]` | `Ctrl+Shift+[` / `]` | 上 / 下个标签 |
| `⌘⇧F` | `Ctrl+Shift+F` | 搜索回滚 |
| `⌘⇧K` | `Ctrl+Shift+K` | 清屏（含回滚） |
| `⌘-` / `⌘=` / `⌘0` | `Ctrl+-` / `Ctrl+=` / `Ctrl+0` | 缩小 / 放大 / 重置字号 |
| `⌃⌘F` | `Ctrl+Super+F` | 全屏 |

> **设计取舍 —— 保留 readline**：终端函数统一放在 `⌘⇧…`，把 `Ctrl+A/E/K/W/U/R/L` 等留给 shell/readline。
> 代价：`⌘T`/`⌘W` 不能直接开/关标签（需 `⌘⇧T`/`⌘⇧W`）。这是 keyd 全局翻译下无法两全的取舍 ——
> 若改成 `⌘T` 开标签，就会吃掉 readline 的 `Ctrl+T`（transpose）。

## 三、keyd 映射要点

配置见 `config/keyd/default.conf`，脚本 `scripts/setup-keyd.sh`。

- `[meta]`：`⌘+字母` → `Ctrl+字母`（GUI 应用）。
- `[meta+shift]`：`⌘⇧+字母` → `Ctrl+Shift+字母`（终端函数，以及 GUI 的 `Ctrl+Shift` 系）。
- `[meta+alt]` / `[control+meta]`：需要交还给 GNOME 的组合显式重发（截图 `⇧⌘3/4`、全屏 `⌃⌘F`）。
- **坑**：复合层未绑定的键会回落到 `[meta]` 并**丢掉 Shift**，所以需要 Shift 的组合必须显式写出。
- **坑**：注释必须独占一行；注释里不要用 `⌘` 等符号。改完用 `sudo systemctl restart keyd`（不要 `reload`）。

## 四、系统级快捷键（GNOME）

见 `docs/shortcuts/system-shortcuts.md`。当前已对齐：锁屏 `⌘L` / `⌃⌘Q`、注销 `⇧⌘Q`、启动器 `⌘Space`、截图 `⇧⌘3/4/5`（Flameshot）、Mission Control `⌃↑`、App Exposé `⌃↓`、切换应用 `⌘Tab`、应用内窗口 `⌘``、最小化 `⌘M`、全屏 `⌃⌘F`、显示桌面 `⌘F11`、自动锁屏 2 分钟。

## 五、已知取舍 / 待定

1. **终端 `⌘T`/`⌘W` 需带 Shift**（见上，保留 readline 的代价）。
2. **工作区切换**仍是 `⌘⌥←/→`（macOS 是 `⌃←/→`）。改成 `⌃←/→` 会全局吃掉应用的 `Ctrl+←/→` 词跳转；若要完全一致，需同时把词跳转改到 `⌥←/→`（但会影响浏览器 `⌥←` 后退）。
3. **`⌘Q` 退出应用**：GNOME 无对应系统键，依赖应用自身（keyd 已把 `⌘Q` → `Ctrl+Q`）。
4. **`⌘H` 隐藏**：GNOME 50 已移除 `hide` 键，退回「最小化」，语义近似。

## 六、应用方式

```bash
sudo ./scripts/setup-keyd.sh            # 内核层 ⌘ → Ctrl
./scripts/setup-terminal.sh             # kitty 键位 + 设为默认终端
./scripts/setup-system-shortcuts.sh     # 系统级：锁屏/注销/截图/启动器/自动锁屏
./scripts/setup-shortcuts.sh            # 窗口级：最小化/切换/全屏等
```
