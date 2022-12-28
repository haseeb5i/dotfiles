require "user.lazy"
require "user.options"
require "user.colors"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "user.autocmds"
    require "user.keymaps"
  end,
})
