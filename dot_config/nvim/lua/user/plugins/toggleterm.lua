local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
}

M.config = function()
  require("toggleterm").setup {
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

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      local opts = { buffer = 0, noremap = true }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<c-x>", [[<C-\><C-n>]], opts)
      -- same in insert mode
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
    end,
  })

  local Terminal = require("toggleterm.terminal").Terminal

  -- lazygit
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    on_open = function(term)
      -- remove mappings to escape to normal mode
      vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
      vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
    end,
  }
  function _LAZYGIT_TOGGLE()
    lazygit:toggle()
  end

  -- btop
  local btop = Terminal:new { cmd = "btop", hidden = true }
  function _BTOP_TOGGLE()
    btop:toggle()
  end

  -- python
  local python = Terminal:new { cmd = "python3", hidden = true }
  function _PYTHON_TOGGLE()
    python:toggle()
  end

  -- node
  local node = Terminal:new { cmd = "node", hidden = true }
  function _NODE_TOGGLE()
    node:toggle()
  end
end

return M
