local present, wk = pcall(require, "which-key")
if not present then
  return
end

-- https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
wk.setup {
  plugins = {
    presets = {
      operators = false,
      nav = false,
      windows = false,
    },
  },
  window = {
    border = "single",
  },
  layout = {
    spacing = 4,
  },
}

wk.register {
  ["<leader>t"] = { name = "Terminal" },
  ["<leader>p"] = { name = "Packer" },
  ["<leader>d"] = { name = "DAP" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>l"] = { name = "LSP" },
  ["<leader>s"] = { name = "Search" },
}
