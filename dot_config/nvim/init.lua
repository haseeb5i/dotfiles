vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

-- core setup
require "raven.autocmds"
require "raven.options"
require "raven.keymaps"

-- plugins setup
require "raven.plugins"

-- colorscheme setup
require "raven.colors"
