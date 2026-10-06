# 快捷键映射方案

基于 macOS 快捷键习惯，在 Ubuntu (GNOME) 上进行系统级和应用级快捷键映射方案。

## 目标

将 macOS 常用快捷键映射到 Ubuntu GNOME 环境，重点覆盖：
- 系统快捷键（窗口、桌面、剪贴板、截图等）
- 应用快捷键（终端 Terminal、Chrome/Chromium、VS Code、微信 WeChat 等）

## 环境信息

- OS: Ubuntu 26.04.1 LTS (GNOME Shell 50.1)
- 硬件: MacBook
- 参考: macOS 系统快捷键习惯

## 方案概览

### 1. 系统快捷键映射（GNOME Settings + dconf/gsettings）

macOS 常用修饰键：Cmd(⌘)=Super, Option(⌥)=Alt, Ctrl=Control。Ubuntu 默认 Super 用于活动概览（Overview/Dash），需要调整以贴近 macOS 使用习惯。

| macOS 快捷键 | 功能 | Ubuntu 映射建议 | 实现方式 |
|---|---|---|---|
| ⌘+Space | Spotlight/启动器 | Super+Space（或自定义） | GNOME Settings > Keyboard > Keyboard Shortcuts |
| ⌘+Tab | 应用切换 | Super+Tab（Alt+Tab） | 默认已支持，可调整切换行为 |
| ⌘+` | 应用内窗口切换 | Super+` | GNOME 支持窗口切换 |
| ⌘+Q | 退出应用 | Super+Q | 设置应用快捷键或窗口关闭 |
| ⌘+W | 关闭窗口/标签 | Super+W | 默认关闭窗口 |
| ⌘+M | 最小化 | Super+M | 最小化窗口 |
| ⌘+H | 隐藏应用 | Super+H | 隐藏窗口（自定义） |
| ⌘+Shift+M | 最大化/还原 | Super+Up / Super+Down | GNOME 窗口操作 |
| ⌘+C/V/X/A/Z | 复制/粘贴/剪切/全选/撤销 | Ctrl+C/V/X/A/Z | 保持通用 |
| ⌘+S | 保存 | Ctrl+S | 保持 |
| ⌘+F | 查找 | Ctrl+F | 保持 |
| ⌘+P | 打印 | Ctrl+P | 保持 |
| ⌘+N | 新建 | Ctrl+N | 保持 |
| ⌘+T | 新标签 | Ctrl+T | 保持 |
| ⌘+Shift+N | 新窗口/文件夹 | Ctrl+Shift+N | 保持 |
| ⌘+R | 刷新 | Ctrl+R/F5 | 保持 |
| ⌘+,+ | 偏好设置 | Ctrl+, | 大部分应用 |
| ⌘+Shift+3/4/5 | 截图 | PrintScreen/Shift+PrintScreen/自定义 | Flameshot/截图工具或 GNOME Screenshot |
| ⌘+L | 地址栏聚焦（浏览器） | Ctrl+L | 保持 |
| ⌘+←/→ | 行首/行尾 | Ctrl+←/→（词）或 Home/End | 可按习惯调整 |
| ⌘+Delete | 删除到行首 | Ctrl+Backspace/自定义 | 终端/编辑器差异 |

### 2. 修饰键映射（最关键）

推荐将键盘修饰键映射：Cmd(Super) 与 Ctrl 的语义需平衡。
- GNOME Settings > Keyboard > Keyboard Layout > Options > Modifier Keys
- 推荐：将 Left Super 映射为 Primary（⌘），保留 Ctrl 语义以兼容 Linux 应用

### 3. 应用快捷键

#### Terminal（GNOME Terminal / Tilix / Kitty）
| macOS | 功能 | 建议映射 |
|---|---|---|
| ⌘+T | 新标签 | Ctrl+Shift+T 或 Super+T（自定义） |
| ⌘+W | 关闭标签 | Ctrl+Shift+W 或 Super+W |
| ⌘+N | 新窗口 | Ctrl+Shift+N |
| ⌘+K | 清屏 | Ctrl+Shift+K / Ctrl+L |
| ⌘+Shift+C/V | 复制/粘贴（终端） | Ctrl+Shift+C/V（默认）或 Super+C/V（自定义） |
| ⌘+F | 查找 | Ctrl+Shift+F |
| ⌘+↑/↓ | 滚动到顶/底 | Ctrl+Shift+Home/End 或 PgUp/PgDn |

#### Chrome/Chromium
| macOS | 功能 | 映射 |
|---|---|---|
| ⌘+Shift+N | 无痕窗口 | Ctrl+Shift+N |
| ⌘+Option+I | 开发者工具 | Ctrl+Shift+I/F12 |
| ⌘+Shift+R | 强制刷新 | Ctrl+Shift+R |
| ⌘+L | 地址栏 | Ctrl+L |
| ⌘+1-9 | 切换标签 | Ctrl+1-9 |

#### VS Code
建议使用 VS Code 的 macOS Keymap 扩展，或结合 keybindings.json 自定义 Super 作为 Cmd 的映射方式。

#### 微信（WeChat）
Linux 版微信（Electron）快捷键可通过系统级快捷键覆盖或应用内设置处理，重点关注 ⌘+Q/⌘+W/⌘+F/⌘+V。

## 实施方式

1. **dconf + gsettings** - 系统级快捷键持久化
2. **GNOME Extensions** - 增强（如 "Forge", "Tiling Assistant"）
3. **Flameshot** - 截图工具（更贴近 macOS ⌘+Shift+4/5）
4. **输入法与修饰键** - Tweaks（gnome-tweaks）+ keyboard options
5. **应用配置** - 各应用内快捷键或配置文件

## 注意事项

- Super 键与 GNOME Overview 冲突：可通过设置或扩展调整
- 部分应用（Electron）需单独处理
- 建议先备份当前配置再应用
