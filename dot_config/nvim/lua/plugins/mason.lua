-- loaded by lsp.lua
return {
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
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
  -- called inside lsp, which loads this and mason 
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
}
