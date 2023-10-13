-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Go to start of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- miscellaneous maps
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map ("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })
map(
  "n",
  "gx",
  function()
    vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>") }, { detach = true })
  end,
  { desc = "Open link under cursor" }
)

-- TODO: fix this
-- vim.cmd [[ cnoremap <expr>  <C-j>  pumvisible() ? "<C-n>" : "<C-j>" ]] 



-- neogen
-- map {
--   {
--     "<leader>cf",
--     "<cmd>lua require'neogen'.generate{type = 'func'}<cr>",
--     desc = "Function Annotation",
--   },
--   {
--     "<leader>cc",
--     "<cmd>lua require'neogen'.generate{type = 'class'}<cr>",
--     desc = "Class Annotation",
--   },
--   {
--     "<leader>ct",
--     "<cmd>lua require'neogen'.generate{type = 'type'}<cr>",
--     desc = "Type Annotation",
--   },
--   {
--     "<leader>cF",
--     "<cmd>lua require'neogen'.generate{type = 'file'}<cr>",
--     desc = "File Annotation",
--   },
-- }

