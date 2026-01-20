# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库概览

这是一个个人配置目录 (`~/.config`)，主要包含基于 LazyVim 启动模板的 Neovim 配置。主要配置位于 `nvim/` 目录中。

## 目录结构

```
.config/
├── nvim/                    # Neovim 主配置（基于 LazyVim）
│   ├── init.lua            # 入口文件 - 引导 lazy.nvim
│   ├── lua/
│   │   ├── config/         # 核心配置模块
│   │   │   ├── lazy.lua    # Lazy.nvim 插件管理器设置
│   │   │   ├── options.lua # Vim 选项（从 .vimrc 迁移）
│   │   │   ├── keymaps.lua # 自定义键位映射
│   │   │   └── autocmds.lua # 自动命令
│   │   └── plugins/        # 插件规格说明
│   │       └── example.lua # 插件配置模板（当前已禁用）
│   ├── lazy-lock.json      # 插件版本锁定文件
│   └── lazyvim.json        # LazyVim 配置
├── nvim.backup.*/          # 备份目录（忽略这些）
├── claude/                 # 空目录
└── test/                   # 空目录
```

## 架构

### 插件管理
- **Lazy.nvim** 作为插件管理器（安装在 `vim.fn.stdpath("data") .. "/lazy/lazy.nvim"`）
- LazyVim 提供基础发行版和合理的默认配置
- 自定义插件通过 `lua/plugins/` 中的文件添加
- 插件规格使用声明式 Lua 表格，支持懒加载

### 配置分层
1. **LazyVim 默认配置** - 来自 LazyVim 发行版的基础配置
2. **自定义选项** (`lua/config/options.lua`) - 从 `.vimrc` 迁移的用户偏好设置
3. **自定义键位映射** (`lua/config/keymaps.lua`) - 用户键位绑定
4. **自定义自动命令** (`lua/config/autocmds.lua`) - 自动命令
5. **插件覆盖** (`lua/plugins/*.lua`) - 插件特定的自定义配置

### 关键架构决策
- **UTF-8 编码** 强制启用
- **Tab 宽度**: 4 个空格（而非 LazyVim 默认的 2 个）
- **中文注释**: 配置文件包含中文注释，解释从 `.vimrc` 迁移的设置
- **持久化撤销** 启用，使用专用目录（`~/.undodir`）
- **折叠方法**: 使用标记（`{{{`, `}}}`）

## 常用命令

### Neovim 配置管理

```bash
# 打开 Neovim
nvim

# 检查 Neovim 健康状态
nvim +checkhealth

# 打开 LazyVim 插件管理器界面
# （在 Neovim 内部执行）
:Lazy

# 更新所有插件
:Lazy update

# 检查插件状态
:Lazy check

# 同步插件（安装缺失的、更新现有的、清理未使用的）
:Lazy sync

# 查看插件安装目录
:lua print(vim.fn.stdpath("data") .. "/lazy")
```

### 代码格式化

```bash
# 使用 stylua 格式化 Lua 文件（根据 stylua.toml 配置）
stylua .

# 格式化特定的 Lua 文件
stylua lua/config/options.lua
```

### 测试配置更改

```bash
# 以最小配置启动 Neovim（用于调试）
nvim --noplugin

# 启动 Neovim 并显示启动时间
nvim --startuptime startup.log

# 查看启动日志
cat startup.log
```

## 关键自定义配置

### 自定义键位映射 (lua/config/keymaps.lua:16-111)

**模式切换:**
- `jk` (插入模式) → 退出插入模式
- `nn` (可视模式) → 退出可视模式
- `<Esc>` / `jk` (终端模式) → 退出终端模式

**光标移动:**
- `H` (普通模式) → 跳转到行首 (0)
- `L` (普通模式) → 跳转到行尾 ($)
- `<S-h>` (可视模式) → 跳转到行首
- `<S-l>` (可视模式) → 跳转到行尾

**代码折叠:**
- `fo` → 切换光标下折叠的打开/关闭
- `ff` → 打开所有折叠
- `FF` → 关闭所有折叠

**快速操作:**
- `<Space><Space>` → 保存并退出 (`:wq`)
- `<F10>` → 切换粘贴模式
- `<F5>` → 在终端中运行当前 Python 文件

**终端:**
- `<leader>tr` → 在右侧打开终端（垂直分割）
- `<leader>tb` → 在底部打开终端（水平分割，15 行）

**窗口导航:**
- `<C-h>` → 移动到左侧窗口
- `<C-l>` → 移动到右侧窗口

### 重要选项 (lua/config/options.lua:1-58)

- **行号**: 绝对行号（非相对行号）
- **当前行高亮**: 已启用
- **Tab/缩进**: 4 个空格（而非 LazyVim 默认的 2 个）
- **搜索**: 忽略大小写，除非包含大写字母，带高亮
- **鼠标**: 在所有模式下启用
- **撤销**: 持久化，使用专用 `~/.undodir` 目录
- **配色方案**: 启用 24 位真彩色

### 自动命令 (lua/config/autocmds.lua:1-44)

- **光标位置恢复**: 重新打开文件时恢复到上次编辑位置
- **禁用自动注释**: 防止在新行自动继续注释

## 使用此配置

### 添加新插件

1. 在 `lua/plugins/` 中创建新文件（例如 `lua/plugins/myplugin.lua`）
2. 使用 LazyVim 插件规格格式:
```lua
return {
  "author/plugin-name",
  opts = {
    -- 插件选项
  },
}
```
3. 重启 Neovim 或运行 `:Lazy sync`

### 修改键位映射

编辑 `lua/config/keymaps.lua`:
```lua
local map = vim.keymap.set
map("n", "<key>", "<action>", { desc = "描述" })
```

### 更改 Vim 选项

编辑 `lua/config/options.lua`:
```lua
vim.opt.option_name = value
```

### 添加自动命令

编辑 `lua/config/autocmds.lua`:
```lua
vim.api.nvim_create_autocmd("Event", {
  group = vim.api.nvim_create_augroup("group_name", { clear = true }),
  pattern = "*",
  callback = function() -- 操作 end,
})
```

## 迁移说明

此配置从 `.vimrc` 设置迁移到 LazyVim。配置文件中的中文注释记录了哪些设置来自原始 `.vimrc`。迁移旨在保留用户工作流程，同时采用 LazyVim 的现代插件生态系统。

## 文件编辑约定

- 所有 Lua 文件应按照 `stylua.toml` 使用 `stylua` 格式化
- 保持现有的中文注释以保留迁移文档
- 键位绑定应包含 `desc` 参数以便与 Which-key 集成
- 自动命令组应使用描述性的 snake_case 命名
