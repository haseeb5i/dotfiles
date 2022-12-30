local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    "b0o/SchemaStore.nvim",
    "folke/neodev.nvim",
    "jose-elias-alvarez/typescript.nvim",
  },
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
      icons = {
        package_installed = " ",
        package_pending = " ",
        package_uninstalled = " ",
      },
      keymaps = {
        cancel_installation = "<C-c>",
      },
    },
    max_concurrent_installers = 5,
  }

  require("mason-lspconfig").setup {
    ensure_installed = {
      "jsonls",
      "sumneko_lua",
      "tsserver",
    },
    automatic_installation = false,
  }

  require("neodev").setup {
    library = {
      plugins = false,
    },
    setup_jsonls = false,
  }

  local handlers = require "user.lsp.handlers"
  local settings = require "user.lsp.settings"
  local lspconfig = require "lspconfig"

  handlers.setup()

  local servers = {
    "tsserver",
    "html",
    "cssls",
    "jsonls",
    "graphql",
    "rust_analyzer",
    "pyright",
    "sumneko_lua",
  }

  local common_opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }

  for _, lsp in ipairs(servers) do
    local overrides = settings[lsp] or {}
    local opts = vim.tbl_extend("force", common_opts, overrides)

    if lsp == "tsserver" then
      require("typescript").setup { server = opts }
    else
      lspconfig[lsp].setup(opts)
    end
  end
end

return M
