return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = { enabled = false },
      diagnostics = { underline = true },
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
