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

## lualine.nvim

**Purpose**: Statusline (bottom bar) that displays comprehensive information about your current file and editor state.

**Location**: Bottom of the Neovim window

**Why useful for Go**:
- Shows active LSP server (📡 gopls) to confirm language server is running
- Displays diagnostics (errors, warnings) from gopls in real-time
- Git integration shows branch, ahead/behind status, and file changes
- Trailing whitespace and mixed indent warnings (important for Go formatting)
- File encoding and format status

**Information Displayed** (left to right):
- **Section A**: Filename (with 🔒 for read-only files)
- **Section B**:
  - Git branch name (truncated to 20 characters)
  - Ahead/behind remote: `↑[2]` (2 commits ahead), `↓[3]` (3 commits behind)
  - Git diff: added/modified/removed lines
  - Python virtual env indicator (when editing .py files)
- **Section C**:
  - Macro recording status
  - Spell check status [SPELL]
- **Section X**:
  - Active LSP server (📡 gopls, 📡 lua_ls, etc. or 🚫 if none)
  - Diagnostics: 🆇 errors, ⚠️ warnings, ℹ️ info,  hints
  - Trailing whitespace warning: `[5]trailing` (found on line 5)
  - Mixed indent warning: `MI:12` (mixed indent on line 12)
- **Section Y**:
  - File encoding (UTF-8)
  - File format (unix/win/mac)
  - File type (go, lua, markdown, etc.)
  - IME state [CN] (Chinese input method)
- **Section Z**:
  - Cursor location (line:column)
  - File progress percentage

**No keymaps**: Automatically displays information, no user interaction needed.

**Configuration**: `lua/config/lualine.lua`

---

## bufferline.nvim

**Purpose**: Shows open buffers as tabs at the top of the screen (like browser tabs), making it easy to see and switch between multiple files.

**Location**: Top of the Neovim window

**Why useful for Go**:
- Quickly see all open Go files at a glance
- Visual indication of unsaved changes (● indicator)
- Easy buffer switching without remembering buffer numbers
- Essential when working with multiple files (main.go, handler.go, types.go, etc.)

**Visual Elements**:
- Each open buffer shown as a tab
- `●` indicator for modified/unsaved files
- `` close icon on each buffer
- Current buffer highlighted
- Filters out special buffers (quickfix, fugitive, git)

**Keymaps**:
- `<space>bp` - **Buffer Pick**: Interactive buffer selection (shows letters on each tab, press letter to jump)
- Left mouse click - Switch to buffer
- Click close icon - Close buffer

**Alternative navigation** (from mappings.lua):
- `gb` - Go to next buffer (or buffer number if count provided)
- `gB` - Go to previous buffer
- `\d` - Delete current buffer (keep window open)

**Example workflows**:

*Quick buffer switching:*
1. Press `<space>bp`
2. Each buffer tab shows a letter (a, b, c, etc.)
3. Press the letter to jump to that buffer

*Working with multiple Go files:*
```
┌──────────────────────────────────────────────────┐
│ [main.go●] [handler.go] [types.go] [utils.go]  │
└──────────────────────────────────────────────────┘
```
- `●` on main.go shows unsaved changes
- Click any tab to switch files
- Use `<space>bp` for keyboard navigation

**Configuration**: `lua/config/bufferline.lua`

---

## nvim-ufo

**Purpose**: Advanced code folding plugin that allows you to collapse/expand code blocks (functions, structs, if statements, etc.) for better navigation through large files.

**Why useful for Go**:
- Collapse long functions to see only function signatures
- Fold struct definitions to see just the struct name and type
- Fold import blocks, if/else blocks, for loops
- Navigate large Go files by viewing just the high-level structure
- Preview folded content without opening it
- Essential for understanding large codebases with many functions

**Keymaps**:
- `zR` - **Open all folds** in the current buffer
- `zM` - **Close all folds** in the current buffer
- `zr` - **Open folds except certain kinds** (progressive opening)
- `<leader>K` - **Preview folded content** in floating window (without opening the fold)

**Standard Vim fold commands** (also work):
- `za` - Toggle fold under cursor (open if closed, close if open)
- `zo` - Open fold under cursor
- `zc` - Close fold under cursor
- `zO` - Open all folds recursively under cursor
- `zC` - Close all folds recursively under cursor

**Visual indicators**:
- Fold column shows `-` for folded lines and `|` for open folds
- Folded lines show: `󰁂 25` (indicates 25 lines are folded)
- Preview shows folded content in floating window

**Example workflow in Go**:

*Before folding (large file):*
```go
package main

import (
    "fmt"
    "net/http"
    "time"
)

func ProcessOrder(order *Order) error {
    if order == nil {
        return errors.New("order is nil")
    }
    // ... 50 more lines ...
    return nil
}

type User struct {
    ID        int
    Name      string
    Email     string
    // ... 20 more fields ...
}

func HandleRequest(w http.ResponseWriter, r *http.Request) {
    // ... 30 lines of implementation ...
}
```

*After pressing `zM` (fold all):*
```go
package main

import (  󰁂 5
}

func ProcessOrder(order *Order) error {  󰁂 50
}

type User struct {  󰁂 20
}

func HandleRequest(w http.ResponseWriter, r *http.Request) {  󰁂 30
}
```

**Example workflows**:

*Navigate large file:*
1. Open a large Go file (e.g., `handlers.go` with 500+ lines)
2. Press `zM` to fold everything → See all function signatures at once
3. Scroll through to find the function you need
4. Place cursor on the function and press `<leader>K` to preview
5. Press `zo` to open that specific fold to edit
6. Press `zc` to close it when done

*Review struct definition:*
1. Place cursor on a folded struct
2. Press `<leader>K` to peek at all fields in a popup
3. Decide if you need to open it or continue browsing

*Progressive code exploration:*
1. Start with `zM` (all folded)
2. Press `zr` multiple times to progressively open outer folds
3. Navigate to interesting sections
4. Use `zo` to open specific inner folds

**Configuration**: `lua/config/nvim_ufo.lua`
- Fold level set to 99 (all folds open by default)
- Fold column width: 1 character
- Custom fold text handler shows fold count

---

## vista.vim

**Purpose**: Tag/symbol viewer that displays an outline of your code in a sidebar window. Shows all functions, types, structs, methods, variables, and constants in the current file.

**Requirements**: Requires `ctags` (universal-ctags) to be installed on the system. Also works with LSP (gopls).

**Why useful for Go**:
- Quick overview of all functions and types in current file
- Jump to any function/struct/method by selecting it in sidebar
- Navigate large Go files without scrolling
- See code structure and organization at a glance
- Understand file contents before diving into details
- Alternative to code folding for navigation

**Keymap**:
- `<space>t` - **Toggle Vista window** (opens/closes the tags sidebar)

**Commands**:
- `:Vista` - Open Vista window
- `:Vista!` - Close Vista window
- `:Vista!!` - Toggle Vista window (same as `<space>t`)

**What Vista displays for Go files**:
- Package name
- Functions (all top-level functions)
- Methods (organized by receiver type)
- Structs and their fields
- Interfaces and their methods
- Type definitions
- Constants and variables

**Example Vista sidebar for Go**:
```
▸ package main
▾ Functions
  ▸ main
  ▸ HandleRequest
  ▸ ProcessOrder
  ▸ ValidateInput
▾ Structs
  ▸ User
  ▸ Order
  ▸ Config
▾ Interfaces
  ▸ Handler
  ▸ Repository
▾ Types
  ▸ UserID
  ▸ OrderStatus
```

**Navigation in Vista window**:
- `j` / `k` - Move down/up in the tag list
- `<Enter>` - Jump to the tag under cursor in main window
- `p` - Preview tag in main window (without moving cursor)
- `q` - Quit/close Vista window
- `<space>t` - Toggle Vista window off

**Example workflows**:

*Explore unfamiliar Go file:*
1. Open a Go file you haven't seen before
2. Press `<space>t` to open Vista sidebar
3. Review all functions and types at a glance
4. Navigate with `j`/`k` to explore structure
5. Press `<Enter>` on interesting functions to jump and read
6. Press `<space>t` to close when done

*Quick function lookup:*
1. Working in a large Go file, need to find `ProcessPayment` function
2. Press `<space>t` → Vista opens
3. Scan the function list visually
4. Press `<Enter>` on `ProcessPayment` → Jump directly to it
5. Press `<space>t` to close Vista

*Understand package structure:*
1. Open main package file
2. Press `<space>t` → See all exported functions and types
3. Get overview of package API
4. Use this to understand what the package provides

**Configuration**: `viml_conf/plugins.vim` (lines 37-47)
- `g:vista_echo_cursor = 0` - Don't echo messages on command line
- `g:vista_stay_on_open = 0` - Focus moves to Vista window when opened

---

## UltiSnips

**Purpose**: Snippet engine that lets you insert code templates (snippets) quickly by typing abbreviations and expanding them into full code structures.

**Dependencies**: Includes `vim-snippets` package with pre-built snippets for many languages including Go.

**Why useful for Go**:
- Quickly insert common Go patterns (if/else, for loops, functions, structs, interfaces)
- Fill in placeholders for function names, parameters, types
- Saves typing repetitive code structures
- Reduces syntax errors with template-based code insertion
- Speeds up boilerplate code writing

**Keymaps** (Insert mode):
- `<Ctrl-j>` - **Expand snippet** (when on trigger word) OR **jump to next placeholder**
- `<Ctrl-k>` - **Jump to previous placeholder**

**How it works**:
1. Type a snippet trigger word (e.g., `for`, `if`, `func`)
2. Press `<Ctrl-j>` to expand it into full code template
3. Type to fill in the current placeholder
4. Press `<Ctrl-j>` to jump to next placeholder
5. Repeat until all placeholders filled

**Common Go snippets** (from vim-snippets):
- `func` - Function definition
- `main` - Main function
- `if` - If statement
- `ife` - If-else statement
- `for` - For loop
- `forr` - For-range loop
- `st` - Struct definition
- `int` - Interface definition
- `switch` - Switch statement
- `case` - Case statement
- `err` - Error handling pattern (`if err != nil`)
- `errn` - Error return pattern
- `json` - JSON struct tags
- `make` - Make slice/map/channel

**Example workflows**:

*Insert a for loop:*
1. In insert mode, type `for`
2. Press `<Ctrl-j>` → Expands to:
   ```go
   for i := 0; i < count; i++ {

   }
   ```
3. Type variable name to replace `i`
4. Press `<Ctrl-j>` → Jump to start value (replace `0`)
5. Press `<Ctrl-j>` → Jump to condition (replace `count`)
6. Press `<Ctrl-j>` → Jump to loop body
7. Type your code

*Insert a function with error handling:*
1. Type `func`
2. Press `<Ctrl-j>` → Expands to function template
3. Fill in: function name → parameters → return type
4. Press `<Ctrl-j>` between each placeholder

*Insert error check:*
1. Type `err`
2. Press `<Ctrl-j>` → Expands to:
   ```go
   if err != nil {
       return err
   }
   ```

*Insert a struct with JSON tags:*
1. Type `st`
2. Press `<Ctrl-j>` → Get struct template
3. Fill in struct name
4. Add fields, use `json` snippet for tags

**Integration with nvim-cmp**:
- Snippets appear in completion menu automatically
- Select snippet with `<Tab>` and accept with `<Enter>`
- Or type trigger word and press `<Ctrl-j>` to expand directly
- Snippet source shown in completion menu

**Custom snippets**:
Add your own Go snippets in `~/.config/nvim/my_snippets/go.snippets`

Example custom snippet format:
```snippets
snippet hf "HTTP handler function" b
func ${1:HandlerName}(w http.ResponseWriter, r *http.Request) {
    ${0}
}
endsnippet
```

**Snippet directories**:
- Built-in: `vim-snippets` package (includes Go snippets)
- Custom: `~/.config/nvim/my_snippets/` (create `go.snippets` for Go)

**Configuration**: `viml_conf/plugins.vim` (lines 19-32)
- Expand trigger: `<Ctrl-j>`
- Jump forward: `<Ctrl-j>`
- Jump backward: `<Ctrl-k>`
- Custom snippet directories: `['UltiSnips', 'my_snippets']`

---

## vim-mundo

**Purpose**: Visual undo history browser that displays your edit history as a tree, allowing you to navigate through different versions of your file and recover any previous state.

**Why useful for Go**:
- Recover from accidental changes or deletions
- See complete edit history with timestamps
- Navigate to any previous version of your code
- Experiment with changes knowing you can always go back to any state
- Explore branching edits (when you undo and make new changes)
- Better than simple undo/redo because you can see the entire history tree
- Essential for code refactoring experimentation

**Keymap**:
- `<space>u` - **Toggle Mundo window** (opens/closes the undo tree viewer)

**Commands**:
- `:MundoToggle` - Toggle Mundo window (same as `<space>u`)
- `:MundoShow` - Show Mundo window

**Mundo window layout**:

When you press `<space>u`, a sidebar opens with two sections:

```
┌─────────────────────────────────┐
│ Undo Tree (top section)         │
│   @  ← Current state (18:34)    │
│   │                              │
│   o  (18:30) +5/-2               │
│   ├─o  (18:25) +3/-1  (branch)  │
│   │                              │
│   o  (18:20) +10/-0              │
│   │                              │
│   o  (18:15) +2/-5               │
├─────────────────────────────────┤
│ Diff Preview (bottom section)   │
│ + func ProcessOrder() {          │
│ -     // old code                │
│ +     // new code                │
└─────────────────────────────────┘
```

**Navigation in Mundo window**:
- `j` / `k` - Move down/up through undo history
- `<Enter>` - Revert file to selected state
- `p` - Preview diff of selected state (without applying)
- `q` - Close Mundo window
- `<space>u` - Toggle Mundo window off

**Understanding the tree**:
- `@` - Current state marker
- `o` - Previous states (undo nodes)
- `│` - Linear history
- `├─` - Branch point (when you undid and made different changes)
- Time stamps show when each change was made
- `+5/-2` means 5 lines added, 2 lines removed

**Undo tree vs linear undo**:

*Traditional linear undo/redo:*
```
edit1 → edit2 → edit3
       ↑
    (undo only goes back linearly)
```

*Mundo undo tree:*
```
edit1 → edit2 → edit3
          ↓
        edit2a → edit2b
        ↑
    (can explore both branches!)
```

**Example workflows**:

*Recover from accidental deletion:*
1. You delete a function in `handler.go`
2. Make more edits, then realize you need that function back
3. Press `<space>u` → Mundo opens
4. Navigate up with `k` to state before deletion
5. Press `p` to preview → Confirm it has your function
6. Press `<Enter>` → Function is restored
7. Press `<space>u` to close Mundo

*Explore different approaches:*
1. Write a Go function one way
2. Undo it (`u` in normal mode)
3. Write it differently (creates a branch in undo tree)
4. Later, want to compare both versions
5. Press `<space>u` → See both branches in tree
6. Navigate between branches with `j`/`k`
7. Press `p` to preview each version
8. Press `<Enter>` on the version you want

*Time travel through edits:*
1. Working on `service.go` for an hour
2. Want to see what the code looked like 30 minutes ago
3. Press `<space>u` → See all edit states with timestamps
4. Find the timestamp ~30 min ago
5. Navigate to it and press `p` → Preview the old code
6. Press `<Enter>` if you want to revert to that state

*Rescue code from experimental branch:*
1. You're refactoring and create multiple edit branches
2. Main line: `edit1 → edit2 → edit3`
3. Side branch: `edit2 → edit2a` (alternative approach)
4. Continue on main line, but want code from side branch
5. Press `<space>u` → Navigate to `edit2a` branch
6. Press `p` → Preview that code
7. Copy the parts you want, navigate back to current state

**Common scenarios**:

*Before/after comparison:*
1. Make significant changes to a Go struct
2. Want to see what it looked like before
3. Press `<space>u` → Navigate to previous state
4. Press `p` → Preview shows diff of all changes
5. Review changes, press `q` to close

*Undo mistake without losing recent work:*
1. Made 5 edits, but edit #3 was wrong
2. Press `<space>u` → See all 5 edits in tree
3. Navigate to edit #2 (before the mistake)
4. Press `<Enter>` → Reverts to that state
5. Edit #3, #4, #5 are still in tree as a branch
6. Make correct edit #3
7. Can still access old #4 and #5 from tree if needed

**Visual indicators**:
- `@` marks your current position in the tree
- Timestamps help identify when changes were made
- `+X/-Y` shows lines added/removed in each change
- Branches show where you undid and took different paths
- Preview pane shows actual diff (what changed)

**Configuration**: `viml_conf/plugins.vim` (lines 49-53)
- Undo tree window width: 80 characters
- Verbose graph disabled for cleaner view

---
