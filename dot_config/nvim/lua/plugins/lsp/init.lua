return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
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
      setup = {},
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.eslint_d,
        nls.builtins.formatting.prettierd,
        nls.builtins.diagnostics.eslint_d,
      })
    end,
  },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.python" },
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    config = function()
      local metals_lsp = require("metals")

      local metals_config = metals_lsp.bare_config()
      metals_config.settings = {
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
        showImplicitArguments = true,
      }
      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      metals_config.on_attach = function(_, bufnr)
        vim.keymap.set(
          "n",
          "<leader>cs",
          function() require("metals").hover_worksheet() end,
          { buffer = bufnr, desc = "Hover Worksheet" }
        )
        metals_lsp.setup_dap()
      end

      metals_lsp.initialize_or_attach(metals_config)
    end,
  },
}
