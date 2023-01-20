local M = {
  "github/copilot.vim",
  event = "VeryLazy",
}

M.config = function()
  -- b:copilot_enabled (can be used in statusline)
  vim.g.copilot_filetypes = {
    markdown = false,
  }
  -- vim.g.copilot_node_command
  vim.g.copilot_no_tab_map = true
  vim.cmd [[ imap <silent><script><expr> <C-l> copilot#Accept("\<CR>") ]]
  -- <C=]> <Plug>(copilot-dismiss)
  -- <M-]> <Plug>(copilot-next)
  -- <M-[> <Plug>(copilot-previous)
  -- <M-\> <Plug>(copilot-suggest)
end

return M
