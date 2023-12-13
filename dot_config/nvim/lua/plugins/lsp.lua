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
          border = "single",
          focusable = false,
          show_header = true,
          source = "always",
        },
      },
      inlay_hints = { enabled = false },
      servers = {
        metals = {
          keys = {
            {
              "<leader>cs",
              -- stylua: ignore
              function() require("metals").hover_worksheet() end,
              desc = "Hover Worksheet",
            },
          },
          settings = {
            metals = {
              excludedPackages = {
                "akka.actor.typed.javadsl",
                "com.github.swagger.akka.javadsl",
              },
              showImplicitArguments = true,
            },
          },
        },
      },
      setup = {
        metals = function(_, opts)
          local metals_config = require("metals").bare_config()
          metals_config.init_options.statusBarProvider = "on"
          metals_config.capabilities = opts.capabilities
          metals_config.settings = opts.settings.metals
          -- metals_config.handlers = {
          --   ["textDocument/hover"] = vim.lsp.with(
          --     vim.lsp.handlers.hover,
          --     { focusable = false }
          --   ),
          -- }

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

          return true
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
