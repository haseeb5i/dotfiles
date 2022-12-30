local M = {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt", "java" },
}

function M.config()
  local metals = require "metals"
  local handlers = require "user.lsp.handlers"

  local config = metals.bare_config()
  config.settings = {
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
    },
    showImplicitArguments = true,
  }

  config.capabilities = handlers.capabilities

  config.on_attach = function(client, bufnr)
    handlers.on_attach(client, bufnr)
    -- set this on handlers on_attach
    vim.keymap.set("n", "<leader>ws", metals.hover_worksheet, { buffer = bufnr })

    metals.setup_dap()
  end

  metals.initialize_or_attach(config)
end

return M
