-- to run this file :luafile debug.lua
-- local plugin = require("lazy.core.config").spec.plugins["neo-tree.nvim"]

-- local opts = require("lazy.core.plugin").values(plugin, "opts", false)
-- vim.print(opts)

local s = "something.sol"
print(s:match("%.sol$"))
