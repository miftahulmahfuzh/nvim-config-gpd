# Keymaps Scenarios & Solutions

Practical scenarios and efficient solutions using plugin combinations in this Neovim config.

## Table of Contents

1. [Surround text between commas with quotes](#surround-text-between-commas-with-quotes)

---

## Surround text between commas with quotes

**Scenario**: You have code where a parameter needs to be quoted:

```lua
-- Before
keymap.set("n", <leader>d, "<cmd>bprevious <bar> bdelete #<cr>", {

-- After
keymap.set("n", "<leader>d", "<cmd>bprevious <bar> bdelete #<cr>", {
```

**Goal**: Surround `<leader>d` with double quotes efficiently without manually selecting character by character.

---

### Solution 1: `sai,"` (Recommended)

**Plugins used**: vim-sandwich + targets.vim

**Steps**:
1. Position cursor **anywhere** on `<leader>d` (any character: `<`, `l`, `e`, `a`, `d`, `>`)
2. Type: `sai,"`

**Breakdown**:
- `sa` - sandwich add (surround command)
- `i,` - inside comma (targets.vim separator text object)
- `"` - with double quotes

**Why it works**:
- targets.vim provides `i,` text object that selects content between commas
- Works from any position within the text
- No need to precisely position cursor at start/end
- Automatically finds comma boundaries

**Result**: `<leader>d` becomes `"<leader>d"`

---

### Solution 2: Visual select with `vi,"`

**Plugins used**: targets.vim + vim-sandwich

**Steps**:
1. Position cursor anywhere on `<leader>d`
2. Type: `vi,` - visual select inside commas
3. Type: `sa"` - surround with quotes

**Why use this**:
- Two-step process gives you visual confirmation
- See exactly what will be surrounded before applying
- Useful when unsure about text boundaries

---

### Solution 3: `sa2w"` (word-based motion)

**Plugins used**: vim-sandwich only

**Steps**:
1. Position cursor on `<` (start of text)
2. Type: `sa2w"` - surround 2 words with quotes

**Breakdown**:
- `sa` - sandwich add
- `2w` - two words (motion)
- `"` - with double quotes

**Limitations**:
- Requires cursor at start of text
- Depends on word count (fragile if text changes)
- Less flexible than separator-based approach

**When to use**: Simple cases where you're already at text start

---

### Solution 4: Manual visual selection

**Standard Vim approach** (no plugins):

**Steps**:
1. Position cursor on `<`
2. Type: `v` - enter visual mode
3. Type: `f,` - find comma (moves to comma)
4. Type: `h` - move back one character
5. Type: `sa"` - surround with quotes (vim-sandwich)

**Or without vim-sandwich**:
1. `v` - visual mode
2. `f,h` - find comma, back one char
3. `"` - type quote
4. `Esc` - exit visual
5. `p` - paste
6. `a"` - append quote

**Why not this**:
- Too many steps
- Requires precise cursor movement
- Error-prone
- Slower workflow

---

### Comparison Table

| Solution | Keystrokes | Cursor Position | Flexibility | Best For |
|----------|------------|-----------------|-------------|----------|
| `sai,"` | **4 keys** | Anywhere | High | **Recommended** |
| `vi,` + `sa"` | 5 keys | Anywhere | High | Visual confirmation |
| `sa2w"` | 5 keys | Must be at start | Low | Simple cases |
| Manual | 8+ keys | Precise | Low | Avoid this |

---

### Related Scenarios

**Surround multiple comma-separated items:**

```lua
-- Surround each parameter with quotes
keymap.set("n", <leader>d, "<cmd>bprevious<cr>", {
-- Position on <leader>d
-- Type: sai,"
-- Result: "<leader>d"

-- Use vim-repeat to repeat on other items:
-- Move to next unquoted item, press .
```

**Change separator from comma to pipe:**

```go
// Before
items := "apple, banana, cherry"

// After (replace commas with pipes)
items := "apple | banana | cherry"

// Solution:
// 1. Position on first comma
// 2. f, (find comma)
// 3. sr,| (sandwich replace comma with pipe)
// 4. Press . (repeat) for other commas
```

**Remove quotes from comma-separated items:**

```lua
-- Before
params := {"apple", "banana", "cherry"}

-- After
params := {apple, banana, cherry}

// Solution:
// 1. Position inside first quotes
// 2. sd" (sandwich delete quotes)
// 3. Move to next quoted item
// 4. Press . (repeat with vim-repeat)
```

---

### Key Takeaways

1. **Separator text objects** (`i,` `a,`) from targets.vim are perfect for function arguments
2. **Sandwich add** (`sa`) combined with targets motions = powerful editing
3. **Cursor position doesn't matter** with `i,` - works anywhere in the text
4. **vim-repeat** makes bulk operations fast (use `.` to repeat)
5. **Visual selection** (`vi,`) gives confirmation before surround

---

### Practice Exercise

Try these transformations:

```lua
-- Exercise 1: Add quotes to all unquoted parameters
local result = calculate(x, y, "z", w)
-- Goal: calculate("x", "y", "z", "w")
-- Hint: sai," on x, then move to y and press ., etc.

-- Exercise 2: Change all single quotes to double quotes
local msg = {'error', 'warning', 'info'}
-- Goal: {"error", "warning", "info"}
-- Hint: sr'" inside first quotes, then . for others

-- Exercise 3: Remove unnecessary parentheses around single items
result = (value)
status = (ok)
-- Goal: result = value, status = ok
-- Hint: sd( on each line
```

---
