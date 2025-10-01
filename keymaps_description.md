# Keymaps & Plugin Usage Description

This file contains detailed descriptions of plugin keymaps and usage patterns for quick reference.

---

## glance.nvim

**Purpose**: Provides a prettier, floating window interface for viewing LSP information (definitions, references, implementations).

**Why useful for Go**: Essential for navigating Go codebases, especially for:
- Finding where functions/types are defined
- Seeing all places where a function/variable is used
- Finding all implementations of an interface (crucial for Go's interface-based design)

**Keymaps**:
- `<space>gd` - View **definitions** of symbol under cursor
- `<space>gr` - View **references** (where it's used) of symbol under cursor
- `<space>gi` - View **implementations** of interface/type under cursor

**Example workflow**:
1. Place cursor on an interface name (e.g., `io.Reader`)
2. Press `<space>gi` to see all types that implement that interface
3. Navigate through the floating window to jump to any implementation

**Configuration**: `lua/config/glance.lua`

---

## nvim-hlslens

**Purpose**: Enhances the search experience by showing match count and index (e.g., `[2/5]` means you're on match 2 out of 5 total matches).

**Why useful for Go**:
- Quickly see how many times a variable/function appears in a file
- Navigate between all occurrences easily
- When refactoring, see at a glance if you've updated all instances
- Essential for code review and understanding variable scope

**Keymaps**:
- `*` - Search forward for word under cursor (stays at current position, shows total count)
- `#` - Search backward for word under cursor (stays at current position, shows total count)
- `n` - Jump to next match (shows which match you're on: e.g., `[3/8]`)
- `N` - Jump to previous match (shows which match you're on)

**Example workflow**:
1. Place cursor on a variable name (e.g., `userID`)
2. Press `*` to search for all occurrences → Shows `[1/8]` (8 total matches)
3. Press `n` to jump to next occurrence → Shows `[2/8]`
4. Continue with `n`/`N` to navigate through all matches
5. Use for refactoring: verify you've updated all instances of a variable

**Configuration**: `lua/config/hlslens.lua`

---

## nvim-cmp

**Purpose**: Autocompletion engine that shows intelligent suggestions as you type. Essential for productive coding.

**Why essential for Go**:
- Auto-completes Go function names, types, and variables from gopls LSP
- Shows function signatures and documentation in popup
- Suggests struct fields as you type `structName.`
- Path completion for import statements
- Snippets for common Go patterns (if, for, func, struct, etc.)
- Buffer word completion for variable names

**Completion Sources** (in priority order):
1. **LSP** (`nvim_lsp`) - Language server completions (gopls for Go)
2. **UltiSnips** - Code snippets
3. **Path** - File path completion
4. **Buffer** - Words from current buffer (min 2 characters)

**Keymaps** (Insert mode, when completion menu is visible):
- `<Tab>` - Select next completion item
- `<Shift-Tab>` - Select previous completion item
- `<Enter>` - Accept/confirm selected completion
- `<Ctrl-e>` - Abort/cancel completion
- `<Esc>` - Close completion menu
- `<Ctrl-d>` - Scroll documentation up (in popup)
- `<Ctrl-f>` - Scroll documentation down (in popup)

**Example workflows**:

*Go function completion:*
1. Type `fmt.Prin` → popup shows `Printf`, `Println`, `Print`
2. Press `<Tab>` to select `Printf`
3. Press `<Enter>` to accept
4. View function signature in documentation window

*Struct field completion:*
1. Have a struct: `user := User{}`
2. Type `user.` → popup shows all fields: `Name`, `Email`, `ID`, etc.
3. Navigate with `<Tab>`, accept with `<Enter>`

*Import path completion:*
1. Type `import "github.com/` → path suggestions appear
2. Navigate and accept to complete the import path

**Special behavior**:
- Completion menu appears automatically after typing
- Shows icons indicating completion type (function, variable, field, etc.)
- For LaTeX files (`.tex`), uses omni completion instead of LSP
- Command-line completion enabled for `/` search and `:` commands

**Configuration**: `lua/config/nvim-cmp.lua`

---
