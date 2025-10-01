# Git Keymaps & Plugin Usage Description

This file contains detailed descriptions of Git-related plugin keymaps and usage patterns for quick reference.

---

## vim-fugitive

**Purpose**: Comprehensive Git interface for Vim - your main tool for git operations within Neovim.

**Why useful for Go**:
- Perform all git operations without leaving Neovim
- Stage, commit, and push changes while coding
- Create and manage branches during feature development
- Blame code to see who wrote what
- Ideal for rapid iteration and commit cycles

**Keymaps**:
- `<leader>gs` - **Git status** - Opens interactive git status window
- `<leader>gw` - **Git add** - Stage current file
- `<leader>gc` - **Git commit** - Open commit message editor
- `<leader>gpl` - **Git pull** - Pull changes from remote
- `<leader>gpu` - **Git push** - Push changes to remote (opens in split)
- `<leader>gbn` - **Git branch new** - Create new branch (prompts for name)
- `<leader>gbd` - **Git branch delete** - Delete branch (prompts for name)
- `<leader>gf` - **Git fetch** - Fetch from remote (prompts for options)
- `<leader>gb` - **Git blame** - Show blame for selected lines (visual mode)

**Commands** (type `:Git` followed by any git command):
- `:Git` - Git status (same as `<leader>gs`)
- `:Git add %` - Stage current file
- `:Git commit` - Commit staged changes
- `:Git log` - View commit history
- `:Git diff` - View changes
- `:Git blame` - Blame current file
- `:Git branch` - List branches
- Any standard git command works after `:Git`

**Interactive Git Status Window**:

When you press `<leader>gs`, you get an interactive status window:

```
# On branch main
# Your branch is up to date with 'origin/main'.
#
# Changes not staged for commit:
#   modified:   handlers.go
#   modified:   types.go
#
# Untracked files:
#   new_feature.go
```

**Navigation in status window**:
- `s` - Stage file/hunk under cursor
- `u` - Unstage file/hunk under cursor
- `=` - Toggle inline diff
- `-` - Toggle file fold
- `cc` - Create commit
- `ca` - Amend last commit
- `P` - Push to remote
- `p` - Pull from remote
- `g?` - Show help

**Example workflows**:

*Standard commit workflow:*
1. Make changes to `handler.go`
2. Press `<leader>gs` → Git status opens
3. Move cursor to `handler.go`, press `s` → File staged
4. Press `cc` → Commit message editor opens
5. Type commit message, save and close (`:wq`)
6. Press `<leader>gpu` → Push to remote

*Create feature branch:*
1. Press `<leader>gbn` → Prompt appears
2. Type branch name: `feature/add-logging`
3. Press Enter → Branch created and checked out
4. Make changes and commit
5. Press `<leader>gpu` → Push feature branch

*Review blame:*
1. Open `handler.go`
2. Visual select lines you want to blame
3. Press `<leader>gb` → Blame info shows who wrote those lines

**Configuration**: `lua/config/fugitive.lua`
- Auto-converts `git` to `Git` in command mode

---

## gitsigns.nvim

**Purpose**: Shows git changes (added, modified, deleted lines) in the sign column with visual indicators and provides hunk navigation.

**Why useful for Go**:
- Instantly see which lines changed since last commit
- Navigate between changes quickly
- Preview changes without opening full diff
- Essential for code review and understanding what you modified
- Integrates with lualine to show file change stats

**Visual indicators in sign column**:
- `+` - Added lines (green)
- `~` - Modified lines (yellow/blue)
- `_` - Deleted lines (red)
- `‾` - Top deleted lines
- `│` - Changed and deleted

**Keymaps**:
- `]c` - **Next hunk** - Jump to next change
- `[c` - **Previous hunk** - Jump to previous change
- `<leader>hp` - **Preview hunk** - Show diff in floating window
- `<leader>hb` - **Blame line** - Show git blame for current line

**What's a "hunk"?**
A hunk is a continuous block of changed lines. For example:
```go
func ProcessOrder(order *Order) {
+   if order == nil {           // ← hunk 1 (added)
+       return errors.New("nil")
+   }

    // process order
~   return order.Process()      // ← hunk 2 (modified)
}
```

**Example workflows**:

*Navigate through changes:*
1. Editing `handler.go`, made several changes
2. Want to review all changes
3. Press `]c` → Jump to first changed section
4. Press `<leader>hp` → Preview shows what changed
5. Press `]c` → Jump to next change
6. Continue with `]c` to review all changes

*Quick blame check:*
1. See a suspicious line in code
2. Move cursor to that line
3. Press `<leader>hb` → Floating window shows: "John Doe, 2 months ago, feat: add validation"
4. Now you know who to ask about it

*Review before commit:*
1. Press `<leader>gs` (fugitive status)
2. See `handler.go` is modified
3. Open `handler.go`
4. Sign column shows `+`, `~`, `_` indicators
5. Press `]c` to jump between changes
6. Press `<leader>hp` to preview each hunk
7. Decide if ready to commit

**Integration with other plugins**:
- Works with **lualine**: Shows `+2 ~3 -1` in statusline
- Works with **fugitive**: Stage hunks from gitsigns, commit with fugitive
- Works with **vim-fugitive** diff mode

**Configuration**: `lua/config/gitsigns.lua`
- Sign text customization
- Hunk navigation keymaps
- Blame display settings

---

## git-conflict.nvim

**Purpose**: Helps resolve merge conflicts with visual markers and commands, making conflict resolution easier.

**Why useful for Go**:
- Visual conflict markers in the buffer
- Easy commands to choose versions (ours/theirs/both)
- Lists all conflicts in quickfix window
- Essential when merging branches or pulling with conflicts

**When it activates**:
Automatically when you open a file with merge conflicts:
```go
<<<<<<< HEAD (Current Change)
func ProcessOrder(order *Order) error {
    return order.Process()
}
=======
func ProcessOrder(order *Order) (int, error) {
    return order.ID, order.Process()
}
>>>>>>> feature/add-order-id (Incoming Change)
```

**Commands**:
- `:GitConflictChooseOurs` - Keep current change (HEAD)
- `:GitConflictChooseTheirs` - Keep incoming change
- `:GitConflictChooseBoth` - Keep both changes
- `:GitConflictChooseNone` - Delete both changes
- `:GitConflictNextConflict` - Jump to next conflict
- `:GitConflictPrevConflict` - Jump to previous conflict
- `:GitConflictListQf` - List all conflicts in quickfix

**Default keymaps** (when conflict detected):
- `co` - Choose ours
- `ct` - Choose theirs
- `cb` - Choose both
- `c0` - Choose none
- `]x` - Next conflict
- `[x` - Previous conflict

**Example workflow**:

*Resolve merge conflict:*
1. Pull from remote: `<leader>gpl`
2. Conflict detected in `handler.go`
3. Open `handler.go` → Conflict markers visible
4. Move cursor to first conflict
5. Read both versions
6. Press `co` → Keep current version (yours)
7. Press `]x` → Jump to next conflict
8. Press `ct` → Keep incoming version (theirs)
9. Save file, commit resolved changes

*List all conflicts:*
1. Multiple files have conflicts
2. Run `:GitConflictListQf`
3. Quickfix window shows all conflicts
4. Navigate with `:cnext` / `:cprev`
5. Resolve each one

**Visual highlighting**:
- Current change highlighted in one color
- Incoming change highlighted in another color
- Clear visual separation between versions

**Configuration**: `lua/config/git-conflict.lua`
- Auto-updates quickfix list when conflicts resolved

---

## gitlinker.nvim

**Purpose**: Generate permalinks to GitHub, GitLab, or Azure DevOps for current file/line/selection. Perfect for sharing code in PRs or documentation.

**Why useful for Go**:
- Share specific code lines with team members
- Create permanent links that don't break when code moves
- Open repository in browser quickly
- Essential for code reviews and documentation

**Keymaps**:
- `<leader>gl` - **Get permalink** - Copy permalink for current line or selection (works in normal and visual mode)
- `<leader>gbr` - **Browse repo** - Open current repository in browser

**How it works**:

*Normal mode* (single line):
1. Place cursor on line 42 in `handler.go`
2. Press `<leader>gl`
3. Link copied to clipboard: `https://github.com/user/repo/blob/abc123/handler.go#L42`

*Visual mode* (range of lines):
1. Visual select lines 42-50
2. Press `<leader>gl`
3. Link copied: `https://github.com/user/repo/blob/abc123/handler.go#L42-L50`

**Supported platforms**:
- GitHub
- GitLab
- Bitbucket
- Azure DevOps (custom configuration included)

**Example workflows**:

*Share code in PR comment:*
1. Review PR, find issue in `handler.go:125`
2. Open `handler.go` in your local copy
3. Navigate to line 125
4. Press `<leader>gl` → Link copied
5. Paste in PR comment: "Issue here: [link]"
6. Teammate clicks link → Jumps to exact line

*Document code reference:*
1. Writing documentation
2. Need to reference specific function
3. Open `service.go`, go to function
4. Visual select the entire function
5. Press `<leader>gl` → Link copied
6. Paste in docs: "See implementation: [link]"

*Quick repo browse:*
1. Working in `handler.go`
2. Want to see repo on GitHub
3. Press `<leader>gbr` → Browser opens to repo
4. Navigate GitHub UI as needed

**Permalink vs regular link**:
- **Regular link**: Points to current branch (changes as code changes)
- **Permalink**: Points to specific commit SHA (permanent, never breaks)
- This plugin creates permalinks using commit SHA

**Configuration**: `lua/config/git-linker.lua`
- Custom Azure DevOps URL handling
- Browser opening action

---

## vim-flog

**Purpose**: Beautiful, interactive git log viewer that shows commit history as a graph with branches.

**Why useful for Go**:
- Visualize branch structure and merges
- See complete project history
- Find when specific changes were made
- Understand git history before merging/rebasing

**Command**:
- `:Flog` - Open git log viewer

**What you see**:
```
* abc1234 (HEAD -> main) feat: add order processing
* def5678 Merge branch 'feature/validation'
|\
| * ghi9012 feat: add input validation
|/
* jkl3456 fix: handle nil pointer
* mno7890 Initial commit
```

**Navigation in Flog window**:
- `<Enter>` - Open commit details
- `q` - Quit Flog
- `j`/`k` - Navigate through commits
- Standard Vim navigation works

**Example workflows**:

*Review feature development:*
1. Run `:Flog`
2. See branch graph showing feature branches
3. Navigate to merge commit
4. Press `<Enter>` → See what was merged
5. Understand how feature was developed

*Find when bug was introduced:*
1. Bug in `handler.go`
2. Run `:Flog`
3. Navigate through commits
4. Look for changes to `handler.go`
5. Find commit that introduced bug
6. Check commit message and author

*Understand project history:*
1. New to project
2. Run `:Flog`
3. See all branches and merges
4. Navigate to key commits
5. Understand development flow

**No custom configuration** - works out of the box

---

## diffview.nvim

**Purpose**: Enhanced diff viewing with split windows, file panel, and better navigation. Shows git diffs beautifully.

**Why useful for Go**:
- Better diff visualization than built-in
- See all changed files in one view
- Compare branches side-by-side
- Review changes before committing

**Command**:
- `:DiffviewOpen` - Open diff view for current changes
- `:DiffviewOpen HEAD~1` - Compare with previous commit
- `:DiffviewOpen main...feature` - Compare branches
- `:DiffviewClose` - Close diff view

**What you see**:
```
┌────────────────┬────────────────┐
│ File Panel     │                │
│  M handler.go  │  Diff View     │
│  M types.go    │  (side-by-side)│
│  A new.go      │                │
└────────────────┴────────────────┘
```

**Navigation**:
- `<Tab>` - Switch between file panel and diff
- `]c` / `[c` - Next/previous change (in diff)
- `<Enter>` - Open file from file panel
- `q` - Close diffview

**Example workflows**:

*Review changes before commit:*
1. Made changes to multiple files
2. Run `:DiffviewOpen`
3. File panel shows: `handler.go`, `types.go`, `utils.go`
4. Click `handler.go` → Diff shows changes
5. Review each file's changes
6. Close with `:DiffviewClose`
7. Stage and commit

*Compare branches:*
1. On `main` branch
2. Want to see what's in `feature/validation`
3. Run `:DiffviewOpen main...feature/validation`
4. See all differences between branches
5. Review before merging

*Review last commit:*
1. Want to see what you committed
2. Run `:DiffviewOpen HEAD~1`
3. See side-by-side diff of last commit
4. Verify all changes

**Integration**:
- Used as dependency by neogit (though we removed neogit)
- Works standalone for diff viewing
- Can be invoked from fugitive

**No custom configuration** - works with default settings

---

## Summary Table

| Plugin | Primary Use | Key Bindings | When to Use |
|--------|-------------|--------------|-------------|
| **vim-fugitive** | Git operations | `<leader>gs/gc/gpl/gpu` | Daily git workflow |
| **gitsigns.nvim** | Visual indicators | `]c [c <leader>hp/hb` | See changes, navigate hunks |
| **git-conflict.nvim** | Merge conflicts | `co ct cb ]x [x` | Resolve conflicts |
| **gitlinker.nvim** | Share code links | `<leader>gl <leader>gbr` | Share code with team |
| **vim-flog** | History viewer | `:Flog` | Understand git history |
| **diffview.nvim** | Enhanced diffs | `:DiffviewOpen` | Review changes visually |

## Typical Workflow

```
1. Check status:        <leader>gs
2. Review changes:      ]c (gitsigns) → <leader>hp
3. Stage files:         s (in fugitive status window)
4. Commit:              cc (in fugitive status window)
5. Push:                <leader>gpu
6. Share code:          <leader>gl (gitlinker)
```

---
