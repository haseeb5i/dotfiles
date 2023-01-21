local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = { ui = { border = "rounded" } },
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          library = { plugins = false },
          jsonls = false,
        },
      },
      "b0o/SchemaStore.nvim",
      "jose-elias-alvarez/typescript.nvim",
    },
    config = function()
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
          local merged_opts =
            vim.tbl_extend("force", opts, settings[server_name] or {})
          require("lspconfig")[server_name].setup(merged_opts)
        end,
        tsserver = function()
          require("typescript").setup { server = opts }
        end,
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufRead",
    opts = function()
      local s = require("null-ls").builtins

      return {
        border = "rounded",
        sources = {
          -- ts/js
          s.formatting.prettierd,
          s.code_actions.eslint_d,
          s.diagnostics.eslint_d.with {
            condition = function(utils)
              return utils.root_has_file_matches "^.eslintrc*"
            end,
          },
          -- python
          s.formatting.black,
          -- lua
          s.formatting.stylua,
        },
      }
    end,
  },
}

return M
