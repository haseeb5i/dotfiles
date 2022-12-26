local M = {}

function M.session()
  require("session_manager").setup {
    autosave_last_session = true,
    autosave_ignore_not_normal = true,
    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
    autosave_ignore_filetypes = {
      "NvimTree",
      "gitcommit",
      "alpha",
    },
  }
end

M.illuminate = function()
  vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
  vim.api.nvim_set_keymap(
    "n",
    "<a-n>",
    '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
    { noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<a-p>",
    '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
    { noremap = true }
  )
end

function M.hexokinase()
  vim.g.Hexokinase_highlighters = { "virtual" }
  vim.g.Hexokinase_optInPatterns = {
    "full_hex",
    "triple_hex",
    "rgb",
    "rgba",
    "hsl",
    "hsla",
    "colour_names",
  }
end

function M.copilot()
  vim.g.copilot_filetypes = {
    ["*"] = false,
    html = true,
    css = true,
    javascript = true,
    typescript = true,
    javascriptreact = true,
    typescriptreact = true,
    python = true,
    lua = true,
    rust = true,
  }

  vim.cmd [[
    imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true
  ]]
end

return M
