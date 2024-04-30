return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
      },
      servers = {},
      setup = {},
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
