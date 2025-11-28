# Keymaps & Plugin Usage Description

This file contains detailed descriptions of plugin keymaps and usage patterns for quick reference.

## Table of Contents

1. [glance.nvim](#glancenvim) - LSP definitions, references, implementations viewer
2. [nvim-ufo](#nvim-ufo) - Advanced code folding
3. [vista.vim](#vistavim) - Tag/symbol viewer sidebar
4. [UltiSnips](#ultisnips) - Snippet engine
5. [vim-mundo](#vim-mundo) - Visual undo history tree
6. [vim-repeat](#vim-repeat) - Repeat plugin operations with `.`
7. [targets.vim](#targetsvim) - Extended text objects (separators, arguments, seeking)
8. [vim-sandwich](#vim-sandwich) - Add/delete/replace surrounding pairs
9. [vim-matchup](#vim-matchup) - Enhanced `%` navigation for matching pairs
10. [vim-scriptease](#vim-scriptease) - Config debugging tools

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

**Integration with blink.cmp**:
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

## vim-repeat

**Purpose**: Support plugin that enhances Vim's `.` (dot) command to work with plugin mappings, making plugin operations repeatable.

**Why useful for Go**:
- Makes plugin commands repeatable with `.` (dot)
- Speeds up repetitive editing tasks
- Works silently in the background
- Essential for efficient workflow with commenting, surrounding, and other plugin operations
- Reduces keystrokes for repetitive refactoring

**No keymaps needed**: This plugin works **automatically**. Just use the normal `.` (dot) command!

**The `.` (dot) command**:

In normal mode, `.` repeats your last change:
- `dd` (delete line) → press `.` → deletes another line
- `ciw` (change word) → press `.` → changes another word
- `x` (delete char) → press `.` → deletes another char

**What vim-repeat adds**:

**Without vim-repeat:**
- `.` only repeats native Vim commands
- Plugin mappings can't be repeated ❌

**With vim-repeat:**
- `.` now works with plugin operations too! ✅
- Any plugin that supports vim-repeat becomes repeatable

**Plugins that benefit** (in your config):

1. **vim-commentary** (commenting):
   - `gcc` to comment a line
   - Move to another line, press `.` → Comments it
   - Keep pressing `.` to comment multiple lines quickly

2. **vim-sandwich** (surround text):
   - `saiw"` to surround word with quotes
   - Move to another word, press `.` → Surrounds it with quotes
   - Works with any surround operation

**Example workflows**:

*Comment multiple lines:*
```go
func ProcessOrder() {      // Press gcc → commented
    validateInput()        // Move here, press . → commented
    processPayment()       // Move here, press . → commented
    sendConfirmation()     // Move here, press . → commented
}
```

*Surround multiple function calls with parentheses:*
```go
order.Status            // Press saiw) → (order.Status)
user.Email              // Move here, press . → (user.Email)
product.Price           // Move here, press . → (product.Price)
```

*Delete multiple lines:*
```go
// Old approach without repeat:
dd  // delete line
dd  // type again
dd  // type again

// With repeat:
dd  // delete line
.   // repeat (delete another line)
.   // repeat (delete another line)
```

**Common scenarios**:

*Refactoring - add error checks:*
1. Add error check after first function call: `o` then type `if err != nil { return err }`
2. Move to next function call that needs error check
3. Press `.` → Inserts same error check
4. Repeat for all function calls

*Clean up imports:*
1. Delete unused import line: `dd`
2. Move to next unused import
3. Press `.` → Deletes it
4. Continue with `.` for all unused imports

*Change variable names:*
1. Change first occurrence: `ciwNewName<Esc>`
2. Move to next occurrence (use `*` to find)
3. Press `.` → Changes to NewName
4. Repeat with `n` and `.` for all occurrences

**Visual feedback**:
- No visual changes - works transparently
- You just notice that `.` now works with more commands
- Increases editing efficiency without learning new keymaps

**Technical note**:
- Plugins must explicitly support vim-repeat
- Both vim-commentary and vim-sandwich support it
- vim-repeat provides the API for plugins to hook into `.` command

**Configuration**: None needed - works automatically once loaded (`event = "VeryLazy"` in `lua/plugin_specs.lua`)

---

## targets.vim

**Purpose**: Extends Vim's text objects with additional powerful selections, particularly for separators, arguments, and seeking operations.

**Why useful for Go**:
- Edit function arguments without precise cursor positioning
- Work with separator-delimited content (commas, colons, pipes)
- Seek forward/backward to next text object automatically
- Essential for fast editing of function calls, struct literals, and complex expressions
- Reduces cursor movement for common editing tasks

**No dedicated keymaps**: Extends existing text object syntax!

**Core concepts**:

1. **Text objects**: `i` (inside) and `a` (around)
2. **Modifiers**: `n` (next), `l` (last), `N` (count)
3. **Separators**: `,` `.` `;` `:` `+` `-` `=` `~` `_` `*` `#` `/` `|` `\` `&` `$`

**Text object syntax**:

Standard Vim: `ci(` - change inside parentheses (cursor must be inside)
Targets: `cin(` - change inside **next** parentheses (works from anywhere)

**Key features**:

**1. Separator text objects:**

Works with any delimiter character to select content between separators.

Syntax: `ci<separator>` or `ca<separator>`

Go examples:
```go
// Function arguments (separated by commas)
processOrder(userID, orderID, timestamp)
//           ^ cursor anywhere on line
// ci, → selects "userID" (inside first comma pair)
// ca, → selects "userID," (including comma)
// c2i, → selects "orderID" (second comma-separated item)

// Struct field tags (separated by colons)
type User struct {
    Name string `json:"name" db:"user_name"`
    //          ^ cursor here
    // ci: → selects "name"
    // cin: → selects "user_name" (next colon pair)
}

// Error messages (separated by colons)
fmt.Errorf("user: not found: %s", userID)
//         ^ cursor here
// ci: → selects "user"
// cin: → selects "not found"
```

**2. Argument text objects:**

Special handling for function arguments and list items.

Syntax: `cia` (inside argument) or `caa` (around argument, includes separator)

```go
// Function call
ProcessPayment(userID, amount, currency, timestamp)
//                     ^ cursor here
// cia → selects "amount"
// caa → selects ", amount"
// daa → deletes ", amount" (including separator)

// Slice literal
items := []string{"apple", "banana", "cherry"}
//                         ^ cursor here
// cia → selects "banana"
// caa → selects ", \"banana\""
// via → visual select "banana"

// Method chain
user.WithName("John").WithAge(25).WithEmail("j@ex.com")
//            ^ cursor here
// cia → selects content inside first argument
```

**3. Seeking (next/last modifiers):**

Find and operate on text objects without moving cursor first.

- `n` modifier: next occurrence (forward)
- `l` modifier: last occurrence (backward)
- Number: nth occurrence

```go
// Parentheses seeking
result := calculate(add(x, y), multiply(a, b))
//        ^ cursor at start of line
// cin( → selects "x, y" (next parentheses)
// cil( → selects "a, b" (last parentheses)
// ci2( → selects "a, b" (second parentheses)
// cin) → same as cin(

// Quote seeking
log.Printf("user: %s", "error: not found", "status: 404")
//         ^ cursor here
// cin" → selects content of next quoted string
// ci2" → selects "error: not found"
// ci3" → selects "status: 404"

// Brace seeking
data := map[string]int{"count": 42, "total": 100}
//      ^ cursor here
// cin{ → selects everything inside next braces
// cin} → same as cin{
```

**4. Pair text objects (enhanced):**

Works with all bracket types: `()` `[]` `{}` `<>` and quotes: `"` `'` `` ` ``

```go
// Multiple parentheses levels
if (user.Active && (user.Role == "admin" || user.Level > 5)) {
//                  ^ cursor here
    // ci( → selects current parentheses content
    // cin( → selects next parentheses (if outside current)
    // ca( → selects including parentheses
}

// Nested brackets
users := []map[string][]int{{"counts": []int{1, 2, 3}}}
//       ^ cursor here
// ci[ → selects entire map content
// cin] → seeks to next bracket
// ci{ → selects map content
```

**5. Quote objects (seeking):**

```go
// Multiple strings
msg := fmt.Sprintf("user: %s, order: %s, status: %s", user, order, status)
//                 ^ cursor here
// ci" → selects "user: %s, order: %s, status: %s"
// cin" → selects next string (after cursor)
// cil" → selects last string (before cursor)
```

**Common operations**:

| Operation | Meaning | Example |
|-----------|---------|---------|
| `ci,` | Change inside commas | Function arguments |
| `ca,` | Change around commas | Include separator |
| `di,` | Delete inside commas | Remove item |
| `da,` | Delete around commas | Remove item + separator |
| `vi,` | Visual select inside | Highlight item |
| `cin(` | Change in next parens | Seek forward |
| `cil)` | Change in last parens | Seek backward |
| `cia` | Change inside argument | Function arg |
| `daa` | Delete an argument | Remove arg + comma |
| `ci:` | Change inside colons | Struct tags |
| `cin"` | Change in next quotes | Next string |

**Example workflows**:

*Refactor function arguments:*
```go
// Remove middle argument
ProcessOrder(userID, orderID, timestamp)
//                   ^ cursor here
// daa → Result: ProcessOrder(userID, timestamp)

// Change argument value
CreateUser("John", 25, "admin")
//                 ^ cursor here
// cia → Select "25", type "30" → Result: CreateUser("John", 30, "admin")
```

*Edit struct tags:*
```go
type User struct {
    Name string `json:"name" db:"user_name"`
    //                       ^ cursor here
    // cin: → Select "user_name"
    // Type "username" → Result: `json:"name" db:"username"`
}
```

*Work with nested structures:*
```go
config := Config{
    Server: ServerConfig{
        Host: "localhost",
        Port: 8080,
    },
}
// Cursor on "Config" line
// cin{ → Select outer struct content
// cin{ (again) → Select inner struct content
```

*Modify error messages:*
```go
return fmt.Errorf("validation error: field: %s: value too short", field)
//                                  ^ cursor here
// ci: → Select "field"
// cin: → Select "%s"
// ci3: → Select "value too short"
```

**Integration with other plugins**:
- Works with vim-repeat: Use `.` to repeat targets operations
- Works with vim-sandwich: Combine seeking with surround operations
- Works with vim-commentary: Comment text objects found with seeking

**Configuration**: None needed - works out of the box (`event = "VeryLazy"` in `lua/plugin_specs.lua`)

---

## vim-sandwich

**Purpose**: Add, delete, or replace surrounding pairs (quotes, brackets, parentheses, tags) around text. Essential for manipulating delimiters quickly.

**Why useful for Go**:
- Quickly add quotes around strings or identifiers
- Change quote styles (double to single, to backticks)
- Wrap expressions in parentheses for precedence
- Add/remove brackets around slice/array literals
- Surround code blocks with braces
- Works seamlessly with targets.vim for powerful text manipulation
- Integrates with vim-repeat for efficient repetitive operations

**Core operations**:
- `sa{motion}{char}` - **Add** surrounding (sandwich add)
- `sd{char}` - **Delete** surrounding (sandwich delete)
- `sr{old}{new}` - **Replace** surrounding (sandwich replace)

**Keymaps**:

**Add surrounding (`sa`):**

Syntax: `sa{motion}{char}`
- `sa` = sandwich add command
- `{motion}` = Vim motion (what to surround)
- `{char}` = Character to surround with

Common motions:
- `iw` - inner word
- `aw` - a word (includes whitespace)
- `i"` - inside quotes
- `$` - to end of line
- `ip` - inner paragraph
- `a)` - around parentheses

Common characters:
- `"` - double quotes
- `'` - single quotes
- `` ` `` - backticks
- `(` or `)` - parentheses (with/without spaces)
- `[` or `]` - square brackets
- `{` or `}` - curly braces
- `<` or `>` - angle brackets
- `t` - HTML/XML tags

**Delete surrounding (`sd`):**

Syntax: `sd{char}`
- Cursor must be inside or on the surrounding pair
- Automatically finds and removes both delimiters

**Replace surrounding (`sr`):**

Syntax: `sr{old}{new}`
- Replace one type of surrounding with another
- Cursor must be inside the surrounding pair

**Go-specific examples:**

**1. Add quotes to identifiers:**
```go
// Add double quotes
userID
// saiw" → "userID"

// Add backticks (for raw strings)
C:\Users\path
// saiw` → `C:\Users\path`

// Add single quotes (for runes)
a
// saiw' → 'a'
```

**2. Wrap expressions in parentheses:**
```go
// Simple expression
order.Total > 100
// sa$) → (order.Total > 100)

// With spaces
order.Total
// saiw( → ( order.Total )

// Without spaces
order.Total
// saiw) → (order.Total)

// Multiple words
user != nil && user.Active
// Visual select, then sa) → (user != nil && user.Active)
```

**3. Add brackets for slices:**
```go
// Convert args to slice literal
"apple", "banana", "cherry"
// Visual select all, sa] → ["apple", "banana", "cherry"]

// Add outer array type
string{"test"}
// sa$] before the string → []string{"test"}
```

**4. Change string quote styles:**
```go
// Double quotes to backticks (for raw strings)
path := "C:\Users\name"
// Cursor in string, sr"` → path := `C:\Users\name`

// Backticks to double quotes
msg := `hello world`
// sr`" → msg := "hello world"

// Double to single (for rune)
char := "a"
// sr"' → char := 'a'
```

**5. Delete surrounding pairs:**
```go
// Remove quotes
name := "John"
// Cursor in string, sd" → name := John

// Remove parentheses
result := (x + y)
// Cursor inside, sd( → result := x + y

// Remove brackets
items := [3]int{1, 2, 3}
// Cursor on/in brackets, sd[ → items := 3]int{1, 2, 3}
// (may need manual fixing)

// Remove struct braces
User{Name: "John"}
// sd{ → Name: "John"
```

**6. Wrap return values:**
```go
// Add parentheses to return
return err
// sa$) → return (err)

// Wrap multiple values
return nil, err
// sa$) → return (nil, err)
```

**7. Add braces around statements:**
```go
// Convert single-line if to block
if err != nil return err
// Position cursor, sa${ → if err != nil {return err}
// (then format manually)

// Wrap code block
validateInput()
processOrder()
// Visual select both lines, sa{ →
// {
//     validateInput()
//     processOrder()
// }
```

**8. Function call wrapping:**
```go
// Wrap variable in function
userID
// saiw)fmt.Println → fmt.Println(userID)
// (requires typing function name)

// Add parentheses to expression
user.ID
// sa$) → (user.ID)
```

**Common workflows:**

*Quick variable quoting:*
```go
// Original
log.Println(userID)
// Cursor on userID, saiw" → log.Println("userID")
```

*Change error format:*
```go
// From formatted to raw string
err := fmt.Errorf("path: %s\n", path)
// sr"` → err := fmt.Errorf(`path: %s\n`, path)
```

*Wrap condition for grouping:*
```go
// Add precedence with parentheses
if a && b || c
// Visual select "a && b", sa) → if (a && b) || c
```

*Remove unnecessary wrapping:*
```go
// Clean up over-parenthesized code
return (user.IsValid())
// sd( → return user.IsValid()
```

*Batch surround with vim-repeat:*
```go
// Surround multiple variables with quotes
userID
orderID
productID
// On first: saiw"
// On second: . (repeat)
// On third: . (repeat)
// Result: "userID", "orderID", "productID"
```

**Visual mode:**

Select text first, then use `sa{char}` to surround:

```go
// Multi-line selection
func ProcessOrder() {
    validateInput()
    checkInventory()
}
// Visual select function body, sa{ to add outer braces
// (useful for wrapping in control structures)

// Inline selection
name email age
// Visual select, sa" → "name email age"
```

**Integration with targets.vim:**

Combine targets seeking with sandwich:

```go
// Select next string and change quotes
log.Printf("user: %s", "error: not found")
// Type: cin"sr"`
// Result: selects "error: not found", changes to backticks
// → log.Printf("user: %s", `error: not found`)

// Surround next parentheses content
result := calculate(x + y)
// Type: vina)sa[ → select "(x + y)" content and add brackets
// → result := calculate([x + y])
```

**Integration with vim-repeat:**

Repeat sandwich operations with `.`:

```go
// Add quotes to multiple identifiers
userID    // saiw"
orderID   // move here, press . → "orderID"
itemID    // move here, press . → "itemID"

// Remove quotes from multiple strings
"apple"   // sd"
"banana"  // move here, press . → banana
"cherry"  // move here, press . → cherry
```

**Tips:**

1. **Spacing in parentheses:**
   - `sa{motion}(` adds spaces: `( text )`
   - `sa{motion})` no spaces: `(text)`

2. **Visual selection:**
   - Select text first, then `sa{char}` to surround

3. **Cursor position:**
   - For `sd` and `sr`, cursor can be anywhere inside/on the pair

4. **Motion combinations:**
   - `sa$"` - surround from cursor to end of line with quotes
   - `saiw(` - surround inner word with parentheses (with spaces)
   - `saip}` - surround paragraph with braces

5. **Undo:**
   - `u` undoes the sandwich operation like any edit

**Common operations table:**

| Operation | Command | Example Input | Result |
|-----------|---------|---------------|--------|
| Quote word | `saiw"` | `hello` | `"hello"` |
| Wrap in parens | `saiw)` | `value` | `(value)` |
| Change quotes | `sr"'` | `"text"` | `'text'` |
| Remove parens | `sd(` | `(value)` | `value` |
| Quote to backtick | `sr"`  | `"path"` | `` `path` `` |
| Surround to EOL | `sa$)` | `x + y` | `(x + y)` |
| Add brackets | `sa$]` | `1, 2, 3` | `[1, 2, 3]` |

**Configuration**: None needed - works automatically (`event = "VeryLazy"` in `lua/plugin_specs.lua`)

**Plugin support**: Integrates with vim-repeat for `.` repetition

---

## vim-matchup

**Purpose**: Enhanced `%` motion for navigating between matching pairs. Extends Vim's built-in `%` to work with language-specific keywords (if/else, for/end, func/return) and provides better highlighting and navigation for nested structures.

**Why useful for Go**:
- Navigate between matching braces in functions, structs, if/else blocks
- Jump between `if` and its closing brace
- Jump between `for` loop start and end
- Navigate nested structures (maps, slices, function calls)
- Visual highlighting of matching pairs
- Essential for understanding code structure and scope
- Faster than manual scrolling to find matching braces

**Keymaps**:

**Basic navigation:**
- `%` - **Jump to matching pair** (opening ↔ closing)
- `g%` - **Jump backwards** to matching pair (reverse direction)
- `[%` - **Jump to previous outer match** (go to opening of outer scope)
- `]%` - **Jump to next outer match** (go to closing of outer scope)

**Visual selection:**
- `v%` - Visual select from cursor to matching pair
- `V%` - Linewise visual select to matching pair

**Text objects:**
- `i%` - Inside the nearest block (between matching pairs)
- `a%` - Around the nearest block (including matching pairs)

**What it matches:**

**1. Brackets and braces:**
- `()` - Parentheses
- `[]` - Square brackets
- `{}` - Curly braces
- `<>` - Angle brackets

**2. Go language keywords:**
- `func` ↔ closing `}`
- `if` ↔ `else` ↔ closing `}`
- `for` ↔ closing `}`
- `switch` ↔ `case` ↔ closing `}`
- `select` ↔ `case` ↔ closing `}`

**Go-specific examples:**

**1. Navigate function blocks:**
```go
func ProcessOrder(order *Order) error {  // cursor on "func"
    if order == nil {                     // press %
        return errors.New("nil order")
    }
    return nil
}  // jumps to closing brace
```

**2. Navigate if/else blocks:**
```go
if err != nil {     // cursor on "if", press %
    return err      // jumps to closing }
} else {            // press % again on "else"
    return nil      // jumps to its closing }
}
```

**3. Navigate nested structures:**
```go
// Outer to inner navigation
func HandleRequest() {           // cursor here, press %
    for _, item := range items { // jumps to outer closing }
        if item.Valid {          // use [% to go to outer opening
            process(item)
        }
    }
}

// Press % on opening { → jump to closing }
// Press % on closing } → jump back to opening {
```

**4. Navigate parentheses in function calls:**
```go
result := CalculateTotal(
    GetPrice(item),              // cursor on opening (
    GetTax(location),            // press %
    GetDiscount(coupon)          // jumps to closing )
)
```

**5. Navigate map/slice literals:**
```go
users := map[string]User{      // cursor on {
    "john": User{               // press %
        Name: "John",
        Age:  25,
    },
    "jane": User{
        Name: "Jane",
        Age:  30,
    },
}  // jumps to closing }

// Press % on inner { → jump to its }
// Press [% → jump to outer opening {
```

**6. Navigate complex nested brackets:**
```go
data := []map[string][]int{     // cursor on [
    {                           // press %
        "counts": []int{1, 2, 3},
    },
}  // jumps to matching ]

// Navigate through nested levels:
// - % on [ jumps to ]
// - % on { jumps to }
// - [% goes to previous outer opening
// - ]% goes to next outer closing
```

**Example workflows:**

*Check scope of function:*
```go
func ProcessPayment() {  // cursor on opening {
    // ... 200 lines of code ...
}
// Press % → jump to closing }
// Press % again → jump back to opening {
```

*Select entire block:*
```go
if err != nil {
    log.Error(err)
    return err
}
// Cursor on "if", press v% → visually select entire if block
// Press d → delete entire block
```

*Navigate nested if statements:*
```go
if user != nil {           // cursor on outer "if"
    if user.Active {       // press ]% → jump to outer closing }
        process(user)
    }
}
// Use [% to jump back to outer opening
```

*Find matching brace in complex code:*
```go
switch orderType {         // cursor on "switch"
    case TypeA:            // press % cycles through
        handleA()          // switch → case → closing }
    case TypeB:
        handleB()
    default:
        handleDefault()
}  // lands here
```

*Visual select function body:*
```go
func ValidateUser(user *User) error {
    // validation logic
    return nil
}
// Cursor on opening {, press v%
// → Selects entire function body
// Press y → yank, d → delete, etc.
```

**Advanced usage:**

**Text objects with motions:**
```go
// Delete inside matching pairs
func Process() {
    data := []int{1, 2, 3}
}
// Cursor on function, di% → delete inside function body

// Change around matching pairs
if condition {
    doSomething()
}
// Cursor on if, ca% → change entire if block including braces
```

**Jump to outer scope:**
```go
func Outer() {
    func Inner() {
        if true {
            // cursor here
            // Press [% repeatedly to jump to:
            // 1. if opening {
            // 2. Inner() opening {
            // 3. Outer() opening {
        }
    }
}
```

**Highlighting:**
- When cursor is on a bracket/keyword, matching pairs are highlighted
- Makes it easy to see scope boundaries
- Configurable highlight colors

**Common patterns:**

| Task | Command | Example |
|------|---------|---------|
| Find closing brace | `%` | `func() {` → `}` |
| Select block | `v%` | Select if/for/func body |
| Delete block content | `di%` | Delete inside braces |
| Change entire block | `ca%` | Change including braces |
| Jump to outer scope | `[%` | Go to parent block |
| Jump to next scope | `]%` | Go to closing of parent |

**Integration with other features:**

*With vim-sandwich:*
```go
// Delete surrounding braces from block
if condition {
    code()
}
// Cursor on {, press sd{ → removes braces
// Or use matchup: cursor on {, press % then delete
```

*With text objects:*
```go
// Combine with targets.vim
func Process(a, b, c int) {
    // Complex nesting
}
// % to navigate, cia to change arguments
```

**Tips:**

1. **Double press**: Press `%` twice to return to original position
2. **Visual selection**: `v%` is great for yanking/deleting entire blocks
3. **Nested navigation**: Use `[%` and `]%` to jump between nesting levels
4. **Highlighted matches**: Look for highlighted pairs to understand scope
5. **Works in insert mode**: Can use `<C-\>%` in insert mode (if configured)

**Difference from default Vim `%`:**

| Feature | Default `%` | vim-matchup |
|---------|-------------|-------------|
| Braces `{}` | ✅ | ✅ |
| Brackets `[]` | ✅ | ✅ |
| Keywords (if/else) | ❌ | ✅ |
| Highlighting | ❌ | ✅ |
| Text objects | ❌ | ✅ `i%` `a%` |
| Outer navigation | ❌ | ✅ `[%` `]%` |

**Configuration**: Works automatically on load (`event = "BufRead"` in `lua/plugin_specs.lua`)

---

## vim-scriptease

**Purpose**: Development and debugging tools for Vim/Neovim configuration. Provides commands for viewing loaded scripts, message history, and verbose output. Essential for **maintaining and debugging your Neovim config**, not for Go development.

**Why useful**:
- Debug Neovim configuration errors
- Find which file sets a specific option or keymap
- View message history in a scrollable buffer
- List all loaded scripts and plugins
- Troubleshoot plugin conflicts
- Essential for config customization and maintenance

**Commands**:

**`:Scriptnames`** - List all loaded Vim scripts

Shows numbered list of all loaded configuration files and plugins:
```
  1: ~/.config/nvim/init.lua
  2: ~/.config/nvim/lua/plugin_specs.lua
  3: ~/.config/nvim/lua/config/lsp.lua
  4: ~/.local/share/nvim/lazy/lazy.nvim/init.lua
  5: ~/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/init.lua
  ...
```

**Usage:**
- See load order of scripts
- Verify a plugin actually loaded
- Find file path of a plugin
- Debug "script not found" errors

**`:Messages`** - View message history in a buffer

Opens a new buffer with all Vim messages (better than `:messages`):
- Scrollable like a normal buffer
- Search with `/`
- Copy error messages
- Review startup errors
- See plugin loading messages

**Usage:**
```vim
:Messages
" Scroll through with j/k
" Search for errors: /Error
" Copy error message: yy
" Close: :q
```

**`:Verbose {level} {command}`** - Run command with verbose output

Shows detailed information about where settings were last changed:

```vim
" Find where a setting was configured
:Verbose set expandtab?
" Output: expandtab
"         Last set from ~/.config/nvim/lua/settings.lua line 15

" Find where a keymap was defined
:Verbose nmap <space>t
" Output: <space>t  :Vista!!<CR>
"         Last set from ~/.config/nvim/lua/config/vista.lua line 8

" See all autocmds
:Verbose autocmd BufRead
" Shows: BufRead
"        *  call s:LoadConfig()
"        Last set from ~/.config/nvim/init.lua line 23
```

**Verbose levels:**
- `:Verbose 1 {cmd}` - Basic info
- `:Verbose 5 {cmd}` - Moderate detail
- `:Verbose 15 {cmd}` - Very detailed (shows function calls)

**Example workflows:**

**1. Debug config startup error:**
```vim
" You see error on nvim startup but it disappears
:Messages
" Scroll through to find the error
" Look for 'Error' or 'Failed'
" Example: "Error executing lua: ...config/lsp.lua:42: attempt to index nil"
" Now you know: lsp.lua line 42 has the error
```

**2. Find which file set an option:**
```vim
" You want to change tabstop but don't remember where it's set
:Verbose set tabstop?
" Output: tabstop=4
"         Last set from ~/.config/nvim/lua/settings.lua line 8
" Now open that file and change it
```

**3. Find keymap conflict:**
```vim
" Your keymap <space>f doesn't work
:Verbose nmap <space>f
" Output: <space>f  <cmd>FzfLua files<CR>
"         Last set from ~/.config/nvim/lua/config/fzf-lua.lua line 15
" Ah, fzf-lua already uses <space>f
```

**4. Check if plugin loaded:**
```vim
" Plugin not working, check if it loaded
:Scriptnames
" Search for plugin: /fugitive
" If not found, plugin didn't load
" Check plugin_specs.lua for conditions
```

**5. Debug autocommand:**
```vim
" LSP not attaching to Go files
:Verbose autocmd FileType go
" Shows which autocmds run for *.go files
" Can see if LSP attach command is there
```

**6. Review plugin installation:**
```vim
" After installing new plugin
:Messages
" See: "lazy.nvim: Installed plugin-name"
" Or: "Error installing plugin-name: ..."
```

**Common scenarios:**

*Config not reloading:*
```vim
:Messages
" Look for: "Error detected while processing..."
" Find the problematic file and line number
```

*Keymap not working:*
```vim
:Verbose nmap <leader>gs
" See: where it's defined, what it does
" If multiple definitions, last one wins
```

*Plugin seems disabled:*
```vim
:Scriptnames
" Ctrl-F to search: /plugin-name
" If not found, check enabled = function() in plugin_specs.lua
```

*Option keeps getting overridden:*
```vim
:Verbose set background?
" See which file sets it last
" Move your setting after that file
```

**Tips:**

1. **Search Messages**: Use `:Messages` then `/Error` to find errors quickly
2. **Copy errors**: In Messages buffer, use `yy` to yank error lines for searching/reporting
3. **Check load order**: `:Scriptnames` shows order - later scripts override earlier ones
4. **Debug keymaps**: `:Verbose nmap` (no argument) shows ALL normal mode mappings with sources
5. **Plugin debugging**: After `:Lazy sync`, use `:Messages` to see what happened

**Useful command combinations:**

```vim
" See all settings and where they're from
:Verbose set all

" See all keymaps for a mode
:Verbose nmap    " Normal mode
:Verbose imap    " Insert mode
:Verbose vmap    " Visual mode

" See specific option
:Verbose set number?
:Verbose set colorscheme?

" See all autocmds for event
:Verbose autocmd BufRead
:Verbose autocmd LspAttach
```

**When to use:**

✅ **Use when:**
- Config errors on startup
- Keymap doesn't work as expected
- Need to find where option is set
- Plugin not loading
- Debugging autocmds
- Verifying plugin installation

❌ **Don't use for:**
- Go development (use LSP, gopls)
- Code debugging (use debugger)
- File searching (use fzf-lua, grep)

**Configuration**: Lazy-loaded by commands (`cmd = { "Scriptnames", "Messages", "Verbose" }` in `lua/plugin_specs.lua`)

**Note**: This plugin is for **config maintenance**, not Go coding. Keep it for when you need to debug or modify your Neovim setup.

---
