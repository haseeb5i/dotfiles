local M = {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
}

-- https://github.com/numToStr/Comment.nvim#configuration-optional
function M.config()
  local integration = require "ts_context_commentstring.integrations.comment_nvim"

  require("Comment").setup {
    ignore = "^$",
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    mappings = {
      basic = true,
      extra = true,
      extended = false,
    },
    pre_hook = integration.create_pre_hook(),
  }
end

local comment_key = "<C-_>"
if vim.g.neovide then
  comment_key = "<C-/>"
end

M.keys = {
  "gc",
  "gb",
  {
    comment_key,
    function()
      return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
        or "<Plug>(comment_toggle_linewise_count)"
    end,
    expr = true,
  },
  {
    comment_key,
    "<Plug>(comment_toggle_linewise_visual)",
    mode = "v",
  },
}

return M
