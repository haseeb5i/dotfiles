local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufRead",
}

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
M.config = function()
  local null_ls = require "null-ls"

  local code_actions = null_ls.builtins.code_actions
  local diagnostics = null_ls.builtins.diagnostics
  local formatting = null_ls.builtins.formatting

  null_ls.setup {
    border = "rounded",
    sources = {
      -- python
      diagnostics.flake8,
      formatting.black,

      -- js/ts
      -- require("typescript.extensions.null-ls.code-actions"),
      code_actions.eslint_d,
      diagnostics.eslint_d.with {
        condition = function(utils)
          return utils.root_has_file_matches "^.eslintrc*"
        end,
      },
      formatting.prettierd,

      -- lua
      formatting.stylua,
      -- diagnostics.luacheck,
    },
  }
end

return M
