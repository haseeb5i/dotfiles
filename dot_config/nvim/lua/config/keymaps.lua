-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Go to start of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Show [l]ine Diagnostics" })

-- bufferline
map("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer to next" })
map("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer to previous" })
map("n", "<A-p>", "<cmd>BufferLinePick<cr>", { desc = "Pick a buffer" })

-- floating terminal
local lazyutil = require("lazyvim.util")
map({ "n", "t" }, "<c-\\>", function()
  lazyutil.terminal(nil, { cwd = lazyutil.root() })
end, { desc = "Terminal (root dir)" })

-- comments
local toggle_comment = function()
  return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
    or "<Plug>(comment_toggle_linewise_count)"
end
map("n", "<c-/>", toggle_comment, { expr = true, desc = "Toggle linewise comment" })
map("n", "<c-_>", toggle_comment, { expr = true, desc = "which_key_ignore" })
map("x", "<c-/>", "<Plug>(comment_toggle_linewise_visual)")
map("x", "<c-_>", "<Plug>(comment_toggle_linewise_visual)")

-- miscellaneous maps
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })
map("n", "gx", function()
  vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>") }, { detach = true })
end, { desc = "Open link under cursor" })
vim.cmd([[ cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>" ]])
vim.cmd([[ cnoremap <expr>  <C-k>  pumvisible() ? "<C-p>" : "<C-k>" ]])
