require "user.options"
require "user.lazy"
require "user.colors"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "user.autocmds"
    require "user.keymaps"
  end,
})

-- vim.defer_fn(function()
--   pcall(require, "impatient")
-- end, 0)

-- -- core setup
-- require "raven.autocmds"
-- require "raven.options"
-- require "raven.keymaps"

-- -- plugins setup
-- require "raven.plugins"

-- -- colorscheme setup
-- require "raven.colors"
