# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `docs/shortcuts/system-shortcuts.md`：系统级快捷键实测梳理（锁屏、注销、截图、概览、工作区、音量亮度、输入法），含冲突清单与待确认项
- `scripts/setup-system-shortcuts.sh`：系统级快捷键配置脚本（锁屏、注销、启动器、截图冲突释放、自动锁屏）

### Fixed
- 锁屏：恢复 Ubuntu 默认 `⌘L`（此前被覆盖为仅 `⌃⌘Q`，导致按 ⌘L 无反应），现为 `⌘L` + `⌃⌘Q` 双绑定
- 截图：`⇧⌘3/4` 同时绑定 GNOME Shell 与 Flameshot 导致冲突，释放 Shell 侧（保留 `Print`/`⇧Print`），由 Flameshot 独占
- `scripts/setup-shortcuts.sh`：删除本环境不存在的 `wm.keybindings hide`、`media-keys screenshot*` 键（`set -e` 下脚本会在中途退出）；改用 `toggle-maximized`；工作区改动改为注释（待确认）

### Changed
- 更新 `docs/shortcuts/shortcuts-mapping.md` 中过期表述（Flameshot 已安装并绑定、启动器已生效）
- 更新 `README.md` 目录结构与快速开始

### 用户确认项执行（2026-10-10）
- 显示桌面：新增 `⌘F11`（保留 ⌃⌘D / ⌃⌥D）
- 自动锁屏：空闲 5 分钟 → 2 分钟（对齐 macOS 默认），`idle-delay=120`
- 工作区切换：确认保持 A1 现状（⌘⌥←/→ 等），不占用全局 ⌃←/→
- 强制退出：确认用 `⌥F4`（`close`）替代，不另设系统键
- 清理 dconf 测试残留 `/org/gnome/xxx-test-nonexistent/`（已备份）
- `docs/shortcuts/system-shortcuts.md`：更正 emoji-picker 判定（实为正常条目，"待确认项" → "确认结果"）
- `scripts`：同步 `idle-delay=120`、`show-desktop` 增加 `⌘F11`

## [2026-10-06] - 初版快捷键梳理与结构调整

### Added
- 快捷键映射方案 `docs/shortcuts/shortcuts-mapping.md`
- 环境分析与风险梳理 `docs/shortcuts/keybindings-analysis.md`
- 快捷键配置脚本 `scripts/setup-shortcuts.sh`
- 配置备份脚本 `scripts/backup-keybindings.sh`
- 配置示例 `examples/README.md`
- 变更记录文件 `CHANGELOG.md`

### Changed
- 调整仓库目录结构：按 `docs/shortcuts/`、`scripts/`、`examples/` 分类组织
- 完善顶层 `README.md`，明确仓库定位（记录 macbook-ubuntu 所有修订内容）

