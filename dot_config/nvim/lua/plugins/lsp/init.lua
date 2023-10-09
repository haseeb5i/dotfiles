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
    },
  },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
}
