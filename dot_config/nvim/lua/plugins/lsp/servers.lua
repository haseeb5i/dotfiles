local M = {}

M.lua_ls = {
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
}
-- {
--   "scalameta/nvim-metals",
--   ft = { "scala", "sbt", "java" },
--   config = function()
--     local custom = require "user.plugins.lsp.custom"
--     local metals = require "metals"

--     local config = metals.bare_config()
--     config.settings = {
--       excludedPackages = {
--         "akka.actor.typed.javadsl",
--         "com.github.swagger.akka.javadsl",
--       },
--       showImplicitArguments = true,
--     }

--     -- config.init_options.statusBarProvider = "on"
--     config.capabilities = custom.capabilities
--     config.handlers = custom.handlers
--     config.on_attach = function(client, bufnr)
--       custom.on_attach(client, bufnr)
--       vim.keymap.set("n", "<leader>ws", metals.hover_worksheet, { buffer = bufnr })

--       metals.setup_dap()
--     end

--     metals.initialize_or_attach(config)
--   end,
-- },

return M
