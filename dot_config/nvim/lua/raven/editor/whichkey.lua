local present, wk = pcall(require, "which-key")
if not present then
  return
end

wk.setup {
  icons = {
    breadcrumb = "»",
    separator = "  ",
    group = "+",
  },
  plugins = {
    presets = {
      operators = false,
      nav = false,
      windows = false,
    },
  },
  operators = { gc = "Comments" },
  window = {
    border = "single",
    winblend = 0,
  },
  layout = {
    spacing = 4,
  },

  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  triggers = "auto",
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
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
