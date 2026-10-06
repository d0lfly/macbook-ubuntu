# macbook-ubuntu

macOS 快捷键习惯在 Ubuntu 环境下的配置记录与自动化脚本。

## 概览

本仓库用于记录 MacBook 上安装 Ubuntu 系统后的配置修订，包含系统快捷键、应用快捷键等各类配置方案和可执行脚本。每个功能点的调整都会在此仓库中留存历史。

## 快速开始

### 1. 备份当前快捷键配置（推荐）

```bash
./scripts/backup-keybindings.sh
```

### 2. 应用 macOS 风格快捷键

```bash
./scripts/setup-shortcuts.sh
```

> 建议在执行前先备份，并逐项验证配置是否符合个人习惯。

## 目录结构

```text
.
├── README.md
├── CHANGELOG.md                # 仓库修订历史
├── .gitignore
├── docs/
│   └── shortcuts/
│       ├── shortcuts-mapping.md     # 系统及应用快捷键映射方案
│       └── keybindings-analysis.md  # 当前环境分析、风险点与建议
├── scripts/
│   ├── setup-shortcuts.sh       # 应用 macOS 风格快捷键
│   └── backup-keybindings.sh    # 备份当前 dconf 配置
└── examples/
    └── README.md                # 配置示例
```

## 相关文档

- [快捷键映射方案](docs/shortcuts/shortcuts-mapping.md)
- [环境分析与梳理](docs/shortcuts/keybindings-analysis.md)
- [变更记录](CHANGELOG.md)
