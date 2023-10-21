return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "scalameta/nvim-metals",
    },
    opts = {
      diagnostics = {
        virtual_text = false,
        float = {
          show_header = true,
          source = "always",
          border = "single",
          focusable = false,
        },
      },
      inlay_hints = {
        enabled = false,
      },
      servers = require("plugins.lsp.servers"),
      setup = {
        metals = function(_, opts)
          local metals_config = require("metals").bare_config()
          metals_config.init_options.statusBarProvider = "on"
          metals_config.capabilities = opts.capabilities
          metals_config.settings = opts.settings.metals
          metals_config.handlers = {
            ["textDocument/hover"] = vim.lsp.with(
              vim.lsp.handlers.hover,
              { focusable = false }
            ),
          }
          -- TODO: add debug config for scala
          -- metals_config.on_attach = function(_, bufnr)
          --   require("metals").setup_dap()
          -- end

          local nvim_metals_group =
            vim.api.nvim_create_augroup("nvim-metals", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "scala", "sbt", "java" },
            callback = function()
              require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
          })
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {},
    },
  },
}
