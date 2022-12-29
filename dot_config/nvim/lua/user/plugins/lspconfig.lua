local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "b0o/SchemaStore.nvim",
    "jose-elias-alvarez/typescript.nvim",
    -- { "folke/neodev.nvim", config = true },
    -- "j-hui/fidget.nvim",
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

  local handlers = require "user.lsp.handlers"

  handlers.setup_diagnostics()
  handlers.setup_handlers()

  local function on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    handlers.setup_keymaps(bufnr)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

  local lspconfig = require "lspconfig"
  local server_opts = require "user.lsp.settings"

  local options = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  for _, lsp in ipairs(servers) do
    local opts = vim.tbl_extend("force", options, server_opts[lsp] or {})
    if lsp == "tsserver" then
      require("typescript").setup { server = opts }
    else
      lspconfig[lsp].setup(opts)
    end
  end
end

return M
