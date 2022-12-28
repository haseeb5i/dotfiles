local M = {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt", "java" },
}

function M.config()
  local metals = require "metals"
  local config = metals.bare_config()

  config.settings = {
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
    },
    showImplicitArguments = true,
  }

  config.capabilities = require("cmp_nvim_lsp").default_capabilities()
  config.on_attach = function(client, bufnr)
    require("user.lsp.handlers").setup_keymaps(bufnr)
    vim.keymap.set("n", "<leader>ws", metals.hover_worksheet, { buffer = bufnr })
    metals.setup_dap()
  end

  metals.initialize_or_attach(config)
end

return M
