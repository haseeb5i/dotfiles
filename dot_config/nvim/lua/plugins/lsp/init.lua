
local M = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/SchemaStore.nvim",
      "jose-elias-alvarez/typescript.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          library = { plugins = false },
        },
      },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        severity_sort = true,
        underline = true,
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
    },
    config = function(_, opts)
      -- diagnostics
      local signs = require("user.icons").diagnostics
      for name, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. name
        vim.fn.sign_define(hl, { textsidebars = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- if client.supports_method "textDocument/inlayHint" then
      --   vim.lsp.inlay_hint(buffer, true)
      -- end

      local custom = require "plugins.lsp.custom"
      local settings = require "plugins.lsp.settings"
      local server_opts = {
        on_attach = custom.on_attach,
        capabilities = custom.capabilities,
        handlers = custom.handlers,
      }

      require("mason-lspconfig").setup_handlers {
        function(server_name)
          local merged_opts =
            vim.tbl_extend("force", server_opts, settings[server_name] or {})
          require("lspconfig")[server_name].setup(merged_opts)
        end,
        tsserver = function()
          require("typescript").setup { server = server_opts }
        end,
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufRead",
    opts = function()
      local nls = require("null-ls").builtins

      return {
        border = "rounded",
        sources = {
          -- ts/js
          nls.formatting.prettierd,
          nls.code_actions.eslint_d,
          nls.diagnostics.eslint_d,
          -- nls.diagnostics.eslint_d.with {
          --   condition = function(utils)
          --     return utils.root_has_file_matches "^.eslintrc*"
          --   end,
          -- },
          -- python
          nls.formatting.black,
          -- lua
          nls.formatting.stylua,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    keys = {
      { "<leader>m", "<cmd> Mason <cr>", desc = "Mason Info" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    opts = {
      ensure_installed = {
        "jsonls",
        "lua_ls",
        "tsserver",
      },
      automatic_installation = false,
    },
  },
  -- {
  --   "scalameta/nvim-metals",
  --   ft = { "scala", "sbt", "java" },
  --   config = function()
  --     local custom = require "user.plugins.lsp.custom"
  --     local metals = require "metals"

  --     local config = metals.bare_config()
  --     config.settings = {
  --       excludedPackages = {
  --         "akka.actor.typed.javadsl",
  --         "com.github.swagger.akka.javadsl",
  --       },
  --       showImplicitArguments = true,
  --     }

  --     -- config.init_options.statusBarProvider = "on"
  --     config.capabilities = custom.capabilities
  --     config.handlers = custom.handlers
  --     config.on_attach = function(client, bufnr)
  --       custom.on_attach(client, bufnr)
  --       vim.keymap.set("n", "<leader>ws", metals.hover_worksheet, { buffer = bufnr })

  --       metals.setup_dap()
  --     end

  --     metals.initialize_or_attach(config)
  --   end,
  -- },
}

return M
