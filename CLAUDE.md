# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive Neovim configuration **optimized for Go development** on Linux (WSL2). The configuration is maintained for **Neovim 0.11.4** (latest stable). Plugin management is handled via [lazy.nvim](https://github.com/folke/lazy.nvim).

**Development Focus**: Primary language is **Go**, with secondary support for Lua, Bash, YAML, and markdown. Python-specific tooling has been or will be removed.

## Configuration Structure

The configuration follows a modular structure:

### Entry Points
- `init.lua` - Main configuration entry point for terminal Nvim
- `ginit.vim` - Additional configuration for GUI clients
- `keymaps_description.md` - Detailed plugin keymaps and usage descriptions (add plugin documentation here)

### Directory Organization
- `lua/` - Lua configuration modules (35+ files)
  - `lua/plugin_specs.lua` - Plugin definitions and lazy.nvim setup
  - `lua/config/` - Individual plugin configurations
  - `lua/globals.lua` - Global settings and variables
  - `lua/mappings.lua` - All user-defined key mappings
  - `lua/utils.lua` - Utility functions used throughout config
  - `lua/colorschemes.lua` - Colorscheme management
  - `lua/diagnostic-conf.lua` - LSP diagnostics configuration
  - `lua/lsp_utils.lua` - LSP-related utility functions
  - `lua/custom-autocmd.lua` - Custom autocommands
- `viml_conf/` - VimScript configuration files
  - `viml_conf/options.vim` - Vim options and settings
  - `viml_conf/plugins.vim` - VimScript plugin configurations
- `after/lsp/` - LSP server-specific configurations (pyright, ruff, lua_ls, clangd, ltex)
- `after/ftplugin/` - Filetype-specific settings
- `plugin/command.lua` - Custom user commands
- `my_snippets/` - User-defined UltiSnips snippets

### Configuration Loading Order
1. `init.lua` loads in this sequence:
   - `lua/globals.lua` - Global settings
   - `viml_conf/options.vim` - Vim options
   - `lua/custom-autocmd.lua` - Autocommands
   - `lua/mappings.lua` - Key mappings
   - `viml_conf/plugins.vim` - Plugin configurations
   - `lua/diagnostic-conf.lua` - Diagnostics
   - `lua/colorschemes.lua` - Colorscheme setup

## Key Features & Plugins

### Language Server Protocol (LSP)
- Configuration: `lua/config/lsp.lua`
- Server-specific configs: `after/lsp/*.lua`
- **Primary LSP**: gopls (Go language server)
- Other enabled servers: lua_ls, vimls, bashls, yamlls
- LSP servers are only enabled if their executable is found on the system
- Custom handling for duplicate definitions in Lua files
- Document highlighting on CursorHold

**Note**: Python LSP servers (pyright, ruff) are being removed as Go is the primary development language.

### Code Completion
- Engine: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Configuration: `lua/config/nvim-cmp.lua`
- Sources: LSP, path, buffer, omni, cmdline, UltiSnips

### Fuzzy Finding
- Primary: [fzf-lua](https://github.com/ibhagwan/fzf-lua) - `lua/config/fzf-lua.lua`
- Fallback: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- Key mappings (where `<leader>` is `,`):
  - `<leader>ff` - Fuzzy file search
  - `<leader>fh` - Fuzzy help search
  - `<leader>fg` - Project-wide grep
  - `<leader>ft` - Buffer tag search
  - `<leader>fb` - Buffer switch

### Git Integration
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Main git commands
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Sign column indicators
- [gitlinker.nvim](https://github.com/ruifm/gitlinker.nvim) - Generate permalinks
- [neogit](https://github.com/NeogitOrg/neogit) - Magit-like interface
- Git key mappings:
  - `<leader>gs` - Git status
  - `<leader>gw` - Git add current file
  - `<leader>gc` - Git commit
  - `<leader>gpl` - Git pull
  - `<leader>gpu` - Git push

### Syntax & Highlighting
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Configuration: `lua/config/treesitter.lua`
- Auto-installation for treesitter parsers

## Important Key Mappings

### Leader Key
The leader key is `,` (comma)

### Essential Mappings
- `;` - Enter command mode (saves pressing Shift)
- `jk` - Exit insert mode (via better-escape.vim)
- `<leader>w` - Save buffer
- `<leader>q` - Save and quit current window
- `<leader>Q` - Quit all windows
- `<leader>ev` - Edit init.lua in new tab
- `<leader>sv` - Reload configuration

### LSP Mappings (when LSP is attached)
- `gd` - Go to definition (handles duplicates intelligently)
- `<C-]>` - Jump to definition
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<space>rn` - Rename variable
- `<space>ca` - Code action

### Navigation
- `<space>s` - Toggle file explorer (nvim-tree)
- `<space>t` - Toggle tags window (vista)
- `<space>u` - Toggle undo tree (mundo)
- `f` - Fast buffer jump (hop.nvim)
- `\x` - Close quickfix/location list
- `\d` - Delete current buffer (keep window)
- `\D` - Delete all other buffers

## Custom Commands

These are defined in `plugin/command.lua`:

- `:CopyPath {type}` - Copy file path to clipboard
  - `nameonly` - Just filename
  - `relative` - Relative to project root
  - `absolute` - Full absolute path
- `:JSONFormat` - Format JSON file or selection
- `:Datetime [timestamp]` - Print current date/time or convert Unix timestamp
- `:Edit <pattern>` - Edit multiple files (supports globs)
- `:Redir <command>` - Capture command output in new tabpage

## Plugin Manager Commands

Lazy.nvim shortcuts (defined as command abbreviations):
- `:pi` → `:Lazy install`
- `:pud` → `:Lazy update`
- `:pc` → `:Lazy clean`
- `:ps` → `:Lazy sync`

## Platform-Specific Features

The config uses global variables to detect platform:
- `vim.g.is_linux` - Linux detection
- `vim.g.is_mac` - macOS detection
- `vim.g.is_win` - Windows detection

Some plugins and features are conditionally enabled based on:
- Platform (e.g., markdown-preview only on Windows/macOS)
- Executable availability (e.g., vimtex requires `latex`, vista requires `ctags`)
- Environment (e.g., firenvim for browser integration)

## Development Workflow

**Primary Focus**: Most configuration changes will be made in `lua/plugin_specs.lua` - this is the central file for plugin management and should be the main focus for modifications.

### Testing Configuration Changes
1. Edit configuration: `<leader>ev`
2. Reload configuration: `<leader>sv`
3. Check health: `:checkhealth`

### Adding New Plugins
1. Add plugin spec to `lua/plugin_specs.lua` (main file for all plugin definitions)
2. Create config file in `lua/config/<plugin-name>.lua` if needed
3. Restart Nvim or run `:Lazy install`

### LSP Server Configuration
1. Check if server executable exists on system
2. Add server to `enabled_lsp_servers` table in `lua/config/lsp.lua`
3. For server-specific settings, create `after/lsp/<server-name>.lua`

### Custom Snippets
Add snippets to `my_snippets/` directory. The configuration automatically includes this directory via UltiSnips settings.

### Documenting Plugin Usage
When asked to describe plugin usage or keymaps, add the documentation to `keymaps_description.md` for easy reference.

## Dependencies

Required executables (configuration checks for availability):
- `git` - Required by lazy.nvim
- `rg` (ripgrep) - Used by fzf-lua and grep plugins
- **Go toolchain**: `go`, `gopls` (Go language server), `gofmt`, `goimports`
- Language servers: `lua-language-server`, `vim-language-server`, `bash-language-server`, `yaml-language-server`
- Optional: `ctags`, `tmux`

## Plugins to Remove

The following plugins are marked for removal as they're not needed for Go development:
- **AI Assistants**: CopilotChat.nvim, copilot.lua (Claude Code is used instead)
- **Python-specific**: pyright, ruff LSP configurations
- **LaTeX/Academic**: vimtex, vim-grammarous, vim-markdownfootnotes
- **Unused languages**: vlime (Lisp), firenvim (browser editing)

## Notes
- This configuration is heavily documented in the source files
- The config uses both Lua and VimScript; prefer Lua for new features
- Random colorscheme is loaded on startup via `colorschemes.rand_colorscheme()`
- All key mappings use `silent = true` to avoid command echoing
- **Environment**: WSL2 on Windows, primarily used for Go development
