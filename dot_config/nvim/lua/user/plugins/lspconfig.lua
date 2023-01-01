local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    "b0o/SchemaStore.nvim",
    "jose-elias-alvarez/typescript.nvim",
    {
      "folke/neodev.nvim",
      config = {
        library = { plugins = false },
        setup_jsonls = false,
      },
    },
    {
      "j-hui/fidget.nvim",
      config = {
        window = { blend = 0 },
        sources = {
          ["null-ls"] = { ignore = true },
        },
      },
    },
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

  -- TODO: update name of this handlers file
  local handlers = require "user.lsp.handlers"
  local settings = require "user.lsp.settings"

  handlers.setup()

  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }

  require("mason-lspconfig").setup_handlers {
    function(server_name)
      local merged_opts = vim.tbl_extend("force", opts, settings[server_name] or {})
      require("lspconfig")[server_name].setup(merged_opts)
    end,
    tsserver = function()
      require("typescript").setup { server = opts }
    end,
  }
end

return M
