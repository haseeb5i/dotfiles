local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre"
}

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  local eslint_config_files = { 
	".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" }
function M.config()
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
      code_actions.eslint_d,
      diagnostics.eslint_d.with {
        condition = function(utils)
          return utils.root_has_file(eslint_config_files)
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
