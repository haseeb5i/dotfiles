local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
}

M.config = {
  size = 20,
  open_mapping = [[<C-\>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  persist_mode = false,
  direction = "float",
  float_opts = {
    border = "curved",
    winblend = 0,
  },
}

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<c-x>", [[<C-\><C-n>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

--[[
-- local float_handler = function(term)
-- 	 -- remove mappings to escape to normal mode
-- 	 vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
--   vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
-- end

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new {
  cmd = "lazygit",
  hidden = true,
  -- on_open = float_handler,
}
function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

local btop = Terminal:new { cmd = "btop", hidden = true }
function _BTOP_TOGGLE()
  btop:toggle()
end

local node = Terminal:new { cmd = "node", hidden = true }
function _NODE_TOGGLE()
  node:toggle()
end

local python = Terminal:new { cmd = "python3", hidden = true }
function _PYTHON_TOGGLE()
  python:toggle()
end
]]

return M
