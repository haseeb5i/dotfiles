-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Go to start of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- bufferline
map("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer to next" })
map("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer to previous" })

-- floating terminal
pcall(vim.keymap.del, "n", "<c-/>")
pcall(vim.keymap.del, "n", "<c-_>")
pcall(vim.keymap.del, "t", "<c-/>")
pcall(vim.keymap.del, "t", "<c-_>")

map({ "n", "t" }, "<c-\\>", function()
  Snacks.terminal.focus(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

-- miscellaneous maps
map("x", "p", "P", { desc = "Paste without yanking" })
-- macos specific
map({ "i", "x", "n" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
