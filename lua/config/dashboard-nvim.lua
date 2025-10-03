-- /home/miftah/.config/nvim/lua/config/dashboard-nvim.lua
-- Custom minimal dashboard - shows only ASCII art on startup

local api = vim.api

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

-- Define the ASCII art file to display
-- local fname = "donkey_head"
-- local fname = "death_eater"
-- local fname = "dragon_1"
-- local fname = "shaggy"
local fname = "bikini"
local header_file_path = vim.fn.stdpath("config") .. "/ascii_art/" .. fname .. ".txt"

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

---
-- Reads an ASCII art file and returns its content as a table of strings.
-- @param file_path The absolute path to the text file.
-- @return A table of strings for the header.
local function load_ascii_art(file_path)
  local lines = {}
  local success, file = pcall(io.open, file_path, "r")

  if not success or not file then
    -- Return a default fallback header
    return {
      "                                                       ",
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      "                                                       ",
    }
  end

  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  return lines
end

---
-- Creates and displays the dashboard buffer in a split window
-- @param split_mode Optional: "right" to open in vertical split on right
local function create_dashboard(split_mode)
  local buf = api.nvim_create_buf(false, true)

  -- Set buffer options
  api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(buf, "buftype", "nofile")
  api.nvim_buf_set_option(buf, "swapfile", false)
  api.nvim_buf_set_option(buf, "filetype", "dashboard")

  -- Load ASCII art
  local lines = load_ascii_art(header_file_path)

  -- Find the longest line for horizontal centering
  local max_width = 0
  for _, line in ipairs(lines) do
    max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
  end

  -- Get window dimensions
  local win_height = api.nvim_win_get_height(0)
  local win_width = api.nvim_win_get_width(0)

  -- Calculate vertical padding (center vertically)
  local content_height = #lines
  local top_padding = math.max(0, math.floor((win_height - content_height) / 2))

  -- Calculate horizontal padding (center horizontally)
  local left_padding = math.max(0, math.floor((win_width - max_width) / 2))
  local padding_str = string.rep(" ", left_padding)

  -- Add top padding
  local padded_lines = {}
  for _ = 1, top_padding do
    table.insert(padded_lines, "")
  end

  -- Add content with horizontal centering
  for _, line in ipairs(lines) do
    table.insert(padded_lines, padding_str .. line)
  end

  -- Set buffer content
  api.nvim_buf_set_lines(buf, 0, -1, false, padded_lines)
  api.nvim_buf_set_option(buf, "modifiable", false)

  -- Open in appropriate window
  if split_mode == "right" then
    -- Create vertical split on right side
    vim.cmd("rightbelow vsplit")
    api.nvim_win_set_buf(0, buf)

    -- Move cursor to end of line to show full ASCII art
    vim.schedule(function()
      vim.cmd("normal! $")
    end)
  else
    -- Switch to the dashboard buffer (original behavior)
    api.nvim_win_set_buf(0, buf)
  end

  -- Set window options
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.cursorline = false
  vim.opt_local.cursorcolumn = false
  vim.opt_local.colorcolumn = ""
  vim.opt_local.list = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.foldcolumn = "0"
  vim.opt_local.statuscolumn = ""

  -- Set keymaps
  local opts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set("n", "q", ":qa<CR>", opts)
  vim.keymap.set("n", "e", ":enew<CR>", opts)
  vim.keymap.set("n", "<space>s", require("nvim-tree.api").tree.toggle, opts)
end

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

-- Show dashboard on startup if no files are opened
api.nvim_create_autocmd("VimEnter", {
  group = api.nvim_create_augroup("CustomDashboard", { clear = true }),
  callback = function()
    -- Only show dashboard if we started with no files
    if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
      create_dashboard()
    end
  end,
})

-- Clean up when leaving dashboard for a real file
api.nvim_create_autocmd("BufLeave", {
  group = api.nvim_create_augroup("CustomDashboardCleanup", { clear = true }),
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype == "dashboard" then
      -- Only wipe dashboard when opening a real file, not special buffers like nvim-tree
      vim.schedule(function()
        local current_ft = vim.bo.filetype
        -- Don't wipe if we're going to a special buffer
        if current_ft ~= "NvimTree" and current_ft ~= "qf" and current_ft ~= "vista" then
          if api.nvim_buf_is_valid(args.buf) then
            vim.cmd("bwipeout! " .. args.buf)
          end
        end
      end)
    end
  end,
})

-- ============================================================================
-- GLOBAL FUNCTION & KEYMAP
-- ============================================================================

-- Create a global function to show ASCII art in split
_G.show_ascii_art_split = function()
  create_dashboard("right")
end

-- Set keymap to show ASCII art in right split
vim.keymap.set("n", "<leader>b", _G.show_ascii_art_split, {
  silent = true,
  desc = "Show ASCII art in right split"
})
