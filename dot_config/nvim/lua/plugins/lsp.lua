return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = { underline = false },
      servers = {
        ["*"] = {
          keys = {
            -- from zed
            { "gh", vim.lsp.buf.hover, desc = "Hover" },
            { "cd", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            { "g.", vim.lsp.buf.code_action, desc = "Code Action", has = "codeAction" },
            -- "g B": "editor::BlameHover",
          },
        },
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
