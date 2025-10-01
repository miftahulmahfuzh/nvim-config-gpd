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

## nvim-autopairs

**Purpose**: Automatic bracket/quote pairing plugin that inserts closing characters and provides smart pair management.

**Why useful for Go**:
- Automatically pairs parentheses in function calls: `()`
- Pairs braces for structs, functions, if/for blocks: `{}`
- Pairs brackets for slices, arrays, maps: `[]`
- Pairs quotes for strings: `""`
- Reduces typing and prevents mismatched brackets
- Auto-indents code blocks on Enter
- Essential for fast, error-free typing

**No keymaps needed**: This plugin works **completely automatically**. Just type normally!

**Automatic behavior**:

| You type | Plugin inserts | Cursor position |
|----------|----------------|-----------------|
| `(` | `()` | Between: `(│)` |
| `{` | `{}` | Between: `{│}` |
| `[` | `[]` | Between: `[│]` |
| `"` | `""` | Between: `"│"` |
| `'` | `''` | Between: `'│'` |
| `` ` `` | `` `` `` | Between: `` `│` `` |

**Smart features**:

1. **Auto-delete pairs**:
   - Type `(` → Get `()`
   - Press `<Backspace>` → Deletes both `()` at once

2. **Skip closing character**:
   - Have: `fmt.Println("test│")`
   - Type `"` → Cursor jumps over: `fmt.Println("test")│` (doesn't duplicate `"`)

3. **Auto-indent on Enter**:
   - Have: `func main() {│}`
   - Press `<Enter>` → Get:
     ```go
     func main() {
         │
     }
     ```

4. **Context-aware**:
   - Understands when you're inside strings, comments
   - Behaves intelligently based on context

**Example workflows in Go**:

*Function call:*
1. Type `fmt.Println(` → Automatically get `fmt.Println(│)`
2. Type `"hello"` → Get `fmt.Println("hello│")`
3. Type `"` → Jump over closing quote: `fmt.Println("hello")│`
4. Type `)` → Jump over closing paren: `fmt.Println("hello")│`

*Struct literal:*
1. Type `User{` → Get `User{│}`
2. Type `Name: "John"`
3. Press `<Enter>` → Auto-indent:
   ```go
   User{
       Name: "John",│
   }
   ```

*Slice declaration:*
1. Type `[]string{` → Get `[]string{│}`
2. Type `"a", "b", "c"`
3. Type `}` → Jump over: `[]string{"a", "b", "c"}│`

*Map declaration:*
1. Type `map[string]int{` → Get `map[string]int{│}`
2. Type key-value pairs
3. Press `<Enter>` → Auto-indent
4. Type `}` → Jump over

*Nested structures:*
1. Type `if x > 0 {` → Get `if x > 0 {│}`
2. Press `<Enter>` → Auto-indent
3. Type `return []int{` → Get nested pairs: `return []int{│}`
4. All closing characters handled automatically

*Delete pair:*
1. Accidentally type `(` → Get `(│)`
2. Press `<Backspace>` → Both `()` deleted, back to clean state

**Common scenarios**:

*Function definition:*
```go
func ProcessOrder(│)     // Type '(' → auto-closes
                 ↓
func ProcessOrder(order *Order│)   // Fill params, type ')' → jumps over
                                 ↓
func ProcessOrder(order *Order) {│}  // Type '{' → auto-closes
```

*Error handling:*
```go
if err != nil {│}        // Type '{' → auto-closes
               ↓
if err != nil {          // Press Enter → auto-indents
    return err│
}
```

*String formatting:*
```go
fmt.Sprintf("│")         // Type '"' → auto-closes
            ↓
fmt.Sprintf("%s│")       // Fill format, type '"' → jumps over
                   ↓
fmt.Sprintf("%s", name│) // Continue typing
```

**Configuration**: Uses default settings (`config = true` in `lua/plugin_specs.lua`)
- No custom configuration needed
- Works out of the box with sensible defaults

---
