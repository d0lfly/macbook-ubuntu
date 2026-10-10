# macOS 手感最佳方案（架构与决策）

> 2026-10-10 落地。目标：在 Ubuntu 26.04 / GNOME 50 / Wayland / MacBook 上，尽可能还原 macOS 的快捷键手感。

## 一、三层架构

| 层 | 组件 | 作用 |
|---|---|---|
| 内核层 | **keyd** | 把物理 `⌘+X` 翻译成应用认得的 `Ctrl+X`；`Super` 本体保留给 GNOME |
| 终端层 | **Ptyxis（系统默认）** | 终端是唯一「Ctrl 有特殊含义」的应用，单独处理键位 |
| 桌面层 | **GNOME (gsettings)** | 系统级快捷键对齐 macOS |

### 为什么必须分层

- Linux 的 GUI 应用（Chrome / VS Code / 微信）只认 `Ctrl` 快捷键，不认 `Super`；而 macOS 用 `⌘`。keyd 在 evdev 层统一把 `⌘+键` 翻译成 `Ctrl+键`，一次性覆盖所有 GUI 应用。
- **终端是唯一例外**：终端里 `Ctrl+C` 是中断信号（SIGINT），复制/粘贴是 `Ctrl+Shift+C/V`。keyd 的全局翻译会把 `⌘C` 变成 `Ctrl+C`（中断），所以终端不能用 `⌘C` 复制。
- keyd 在 Wayland 下**无法按应用区分**（`keyd-application-mapper` 仅支持 X11），因此不能用「只在终端里换一套映射」的做法。

## 二、终端：保留系统默认的 Ptyxis

**不引入第三方终端**，继续使用系统默认的 Ptyxis。做法是让 Ptyxis 保持**原生默认键位**（`Ctrl+Shift+…`），再借 keyd 的 `[meta+shift]` 层，用 `⌘⇧…` 触发：

| macOS 习惯 | keyd 实际发送 | Ptyxis 行为 |
|---|---|---|
| `⌘⇧C` / `⌘⇧V` | `Ctrl+Shift+C/V` | 复制 / 粘贴 |
| `⌘⇧T` / `⌘⇧W` | `Ctrl+Shift+T/W` | 新标签 / 关标签 |
| `⌘⇧N` | `Ctrl+Shift+N` | 新窗口 |
| `⌘⇧F` | `Ctrl+Shift+F` | 搜索回滚 |
| `⌘⇧A` | `Ctrl+Shift+A` | 全选 |
| `⌘⇧O` | `Ctrl+Shift+O` | 标签总览 |
| `⌃⌘F` | `Ctrl+Super+F` | 全屏 |

> **为什么终端复制不是 `⌘C`**：Ptyxis 没有「有选区复制、无选区中断」（`copy_or_interrupt`）这类动作，而 keyd 在 Wayland 下无法按应用区分，`⌘C` 只能等于 `Ctrl+C`（中断）。所以终端复制统一用 `⌘⇧C`。
> 物理 `Ctrl+Shift+C/V` 同样可用（终端通用约定）。
> （备选方案 kitty 支持 `copy_or_interrupt`、可做到 `⌘C` 复制，但按要求不引入。）

## 三、keyd 映射要点

配置见 `config/keyd/default.conf`，脚本 `scripts/setup-keyd.sh`。

- `[meta]`：`⌘+字母` → `Ctrl+字母`（GUI 应用）。
- `[meta+shift]`：`⌘⇧+字母` → `Ctrl+Shift+字母`（终端函数，以及 GUI 的 `Ctrl+Shift` 系）。
- `[meta+alt]` / `[control+meta]`：其他组合。
- **交还给 GNOME 的系统键必须显式重发**（两个坑叠加）：
  1. `[meta]` 会把 `⌘+字母` 抢成 `Ctrl+字母`；
  2. 复合层里未绑定的键会**回落到 `[meta]` 并丢掉修饰键**。

  所以凡是要交给 GNOME 的系统键，都得在对应层显式写 `M-` / `M-S-` / `M-C-`：
  - `[control+meta]`：`q = M-C-q`（锁屏 `⌃⌘Q`）、`d = M-C-d`（显示桌面 `⌃⌘D`）、`f = M-C-f`（全屏 `⌃⌘F`）、`left/right = M-C-left/right`（工作区 `⌘⌃←/→`）
  - `[meta+shift]`：`q = M-S-q`（注销 `⇧⌘Q`）、`3/4/5 = M-S-3/4/5`（截图 `⇧⌘3/4/5`）、`grave = M-S-grave`（反向切换窗口 `⇧⌘\``）
  - `[meta]`：`grave = M-grave`（切换同应用窗口 `⌘\``）
  - 例外：`⌘L` 保持 `Ctrl+L`（浏览器地址栏，与 macOS 一致），所以 GNOME 的 `<Super>l` 锁屏不触发，锁屏统一用 `⌃⌘Q`。
- **坑**：注释必须独占一行；注释里不要用 `⌘` 等符号。改完用 `sudo systemctl restart keyd`（不要 `reload`）。

## 四、系统级快捷键（GNOME）

见 `docs/shortcuts/system-shortcuts.md`。当前已对齐：锁屏 `⌘L` / `⌃⌘Q`、注销 `⇧⌘Q`、启动器 `⌘Space`、截图 `⇧⌘3/4/5`（Flameshot）、Mission Control `⌃↑`、App Exposé `⌃↓`、切换应用 `⌘Tab`、应用内窗口 `⌘``、最小化 `⌘M`、全屏 `⌃⌘F`、显示桌面 `⌘F11`、自动锁屏 2 分钟。

## 五、已知取舍 / 待定

1. **终端复制/粘贴用 `⌘⇧C/V`**（见上，Ptyxis 的固有限制）。
2. **工作区切换**用 `⌘⌃←/→`（macOS 是 `⌃←/→`）：加 `⌘` 是为了不占用应用的 `Ctrl+←/→` 词跳转。keyd 在 `[control+meta]` 里把它显式重发为 `Super+Control+←/→`（不显式写会回落到 `[meta]` 变成 `Ctrl+←`）。
3. **`⌘Q` 退出应用**：GNOME 无对应系统键，依赖应用自身（keyd 已把 `⌘Q` → `Ctrl+Q`）。
4. **`⌘H` 隐藏**：GNOME 50 已移除 `hide` 键，退回「最小化」，语义近似。

## 六、应用方式

```bash
sudo ./scripts/setup-keyd.sh            # 内核层 ⌘ → Ctrl
./scripts/setup-terminal.sh             # 保持系统默认终端 Ptyxis，还原其原生键位
./scripts/setup-system-shortcuts.sh     # 系统级：锁屏/注销/截图/启动器/自动锁屏
./scripts/setup-shortcuts.sh            # 窗口级：最小化/切换/全屏等
```
