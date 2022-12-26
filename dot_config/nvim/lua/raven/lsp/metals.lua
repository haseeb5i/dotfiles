local M = {}

function M.setup()
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
    require("raven.lsp.handlers").set_lsp_keymaps(bufnr)
    vim.keymap.set("n", "<leader>ws", metals.hover_worksheet, { buffer = bufnr })

    pcall(require("illuminate").on_attach, client)
    metals.setup_dap()
  end

  metals.initialize_or_attach(config)
end

return M
