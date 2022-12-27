local M =  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
        "b0o/SchemaStore.nvim",
        "hrsh7th/cmp-nvim-lsp",
        --   "jose-elias-alvarez/typescript.nvim",

  }
}
function M.config()
  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_installation = true,
  })
end