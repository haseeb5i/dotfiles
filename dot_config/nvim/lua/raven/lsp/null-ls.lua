local present, null_ls = pcall(require, "null-ls")
if not present then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local eslint_config_files = { ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" }

null_ls.setup {
  debug = false,
  border = "rounded",
  sources = {
    -- python
    diagnostics.flake8,
    formatting.black,

    -- js/ts
    code_actions.eslint_d,
    diagnostics.eslint_d.with {
      condition = function(utils)
        --     return utils.root_matches(".eslintrc.*")
        return utils.root_has_file(eslint_config_files)
      end,
    },
    formatting.prettierd,

    -- lua
    formatting.stylua,
    -- diagnostics.luacheck,
  },
}
