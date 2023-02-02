local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = { border = "rounded" },
        },
      },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {
            "jsonls",
            "tsserver",
            "sumneko_lua",
          },
          automatic_installation = false,
        },
      },
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
      require("user.plugins.lsp.diagnostics").setup()

      local custom = require "user.plugins.lsp.custom"
      local settings = require "user.plugins.lsp.settings"

      local opts = {
        on_attach = custom.on_attach,
        capabilities = custom.capabilities,
        handlers = custom.handlers,
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
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    config = function()
      local custom = require "user.plugins.lsp.custom"
      local metals = require "metals"

      local config = metals.bare_config()
      config.settings = {
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
        showImplicitArguments = true,
      }

      -- config.init_options.statusBarProvider = "on"
      config.capabilities = custom.capabilities
      config.handlers = custom.handlers
      config.on_attach = function(client, bufnr)
        custom.on_attach(client, bufnr)
        vim.keymap.set("n", "<leader>ws", metals.hover_worksheet, { buffer = bufnr })

        metals.setup_dap()
      end

      metals.initialize_or_attach(config)
    end,
  },
}

return M
