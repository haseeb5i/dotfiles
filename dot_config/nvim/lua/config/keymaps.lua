-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Go to start of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- map("n", "gl", vim.diagnostic.open_float, { desc = "Show [l]ine Diagnostics" })

-- bufferline
map("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer to next" })
map("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer to previous" })
map("n", "<A-p>", "<cmd>BufferLinePick<cr>", { desc = "Pick a buffer" })

-- floating terminal
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")
map("n", "<c-\\>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<c-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- miscellaneous maps
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })
-- open link under the cursor in browser
map("n", "gx", function()
  vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>") }, { detach = true })
end, { desc = "Open link under cursor" })

-- macos specific
map("i", "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("x", "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
