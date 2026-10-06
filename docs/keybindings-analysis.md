# 快捷键环境分析与梳理

## 系统环境

- GNOME Shell 50.1, Ubuntu 26.04.1 LTS
- 桌面环境：GNOME
- 硬件：MacBook

## 核心修饰键

- Super (Win/⌘)：默认用于 Overview、窗口操作。建议视作 Cmd(⌘) 主键，贴近 macOS 使用习惯
- Alt (⌥)：菜单、窗口移动
- Ctrl：应用内标准快捷键（Linux 生态保留此语义）
- Shift

## 建议优先级

1. **修饰键语义**：将 Super 映射为 Cmd(⌘)，平衡与 Ctrl 的兼容性
2. **窗口管理**：关闭/最小化/隐藏/切换窗口（⌘+W/Q/H/`/Tab）
3. **剪贴板/编辑**：统一编辑类快捷键思路（保持应用原生最佳实践）
4. **截图**：⌘+Shift+3/4/5 → Flameshot（推荐）
5. **启动器**：⌘+Space → Spotlight 替代（需评估与输入法切换冲突）
6. **应用专项**：Terminal、VS Code、Chrome、微信

## 备份建议

执行前备份 dconf 配置：

```bash
./scripts/backup-keybindings.sh
```

或手动导出：

```bash
dconf dump /org/gnome/desktop/wm/keybindings/ > wm-keybindings.bak
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > media-keys.bak
dconf dump /org/gnome/mutter/keybindings/ > mutter-keybindings.bak
dconf dump /org/gnome/shell/keybindings/ > shell-keybindings.bak
```

## 风险点

- Super+Space 可能与 IBus/Fcitx 输入法切换冲突
- Super 与 GNOME Overview 冲突（可通过扩展或配置缓解）
- Electron 应用（微信、VS Code 部分场景）需单独处理快捷键
