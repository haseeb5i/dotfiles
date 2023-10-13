local plugin = require("lazy.core.config").spec.plugins["mini.surround"]

local opts = require("lazy.core.plugin").values(plugin, "opts", false)
vim.inspect(opts)
