-- /home/miftah/.config/nvim/lua/config/dashboard-nvim.lua

local api = vim.api
local keymap = vim.keymap
local dashboard = require("dashboard")

---
-- Reads an ASCII art file and returns its content as a table of strings.
-- Each line in the file becomes a separate string in the table.
--
-- @param file_path The absolute path to the text file.
-- @return A table of strings for the header. Returns a fallback header on error.
local function load_header_from_file(file_path)
  local header_lines = {}
  -- pcall runs the function in "protected mode" to catch errors gracefully
  local success, file = pcall(io.open, file_path, "r")

  if not success or not file then
    vim.notify("Dashboard: Could not open header file: " .. file_path, vim.log.levels.WARN)
    -- Return a default fallback header if the file cannot be opened
    return {
      "                                                       ",
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      "                                                       ",
      "           Error: Could not load header file.          ",
      "                                                       ",
    }
  end

  for line in file:lines() do
    table.insert(header_lines, line)
  end
  file:close()

  -- If the file was empty, return a simple message
  if #header_lines == 0 then
    return { "Header file is empty." }
  end

  --- ADDED: Add two empty lines for padding after the header content.
  -- This will apply to both the loaded file and the fallback header.
  table.insert(header_lines, "")
  table.insert(header_lines, "")

  return header_lines
end

local conf = {}

-- Define the path to your header file.
-- This assumes 'donkey_head.txt' is in your nvim/ascii_art directory
-- (e.g., ~/.config/nvim/ascii_art/donkey_head.txt)
-- local fname = "donkey_head"
-- local fname = "death_eater"
-- local fname = "dragon_1"
-- local fname = "shaggy"
local fname = "bikini"
local header_file_path = vim.fn.stdpath("config") .. "/ascii_art/" .. fname .. ".txt"

-- Load the header dynamically from the specified text file
conf.header = load_header_from_file(header_file_path)

conf.center = {
  {
    icon = "󰈞  ",
    desc = "Find  File                              ",
    action = "FzfLua files",
    key = "<Leader> f f",
  },
  {
    icon = "󰈢  ",
    desc = "Recently opened files                   ",
    action = "FzfLua oldfiles",
    key = "<Leader> f e",
  },
  {
    icon = "󰈬  ",
    desc = "Project grep                            ",
    action = "FzfLua live_grep",
    key = "<Leader> f g",
  },
  {
    icon = "  ",
    desc = "Open Nvim config                        ",
    action = "tabnew $MYVIMRC | tcd %:p:h",
    key = "<Leader> e v",
  },
  {
    icon = "  ",
    desc = "New file                                ",
    action = "enew",
    key = "e",
  },
  {
    icon = "󰗼  ",
    desc = "Quit Nvim                               ",
    action = "qa",
    key = "q",
  },
}

dashboard.setup {
  theme = "doom",
  shortcut_type = "number",
  config = conf,
}

api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
  callback = function()
    keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
  end,
})
