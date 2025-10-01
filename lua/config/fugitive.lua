local keymap = vim.keymap

keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git: show status" })
keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git: add file" })
keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git: commit changes" })
keymap.set("n", "<leader>gpl", "<cmd>Git pull<cr>", { desc = "Git: pull changes" })
keymap.set("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", { desc = "Git: push changes" })
keymap.set("v", "<leader>gb", ":Git blame<cr>", { desc = "Git: blame selected line" })

-- Diffview integration
keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git: open diffview" })
keymap.set("n", "<leader>gdd", "<cmd>DiffviewClose<cr>", { desc = "Git: close diffview" })

-- convert git to Git in command line mode
vim.fn["utils#Cabbrev"]("git", "Git")
