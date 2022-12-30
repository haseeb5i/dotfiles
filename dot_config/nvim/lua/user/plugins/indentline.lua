local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
}

M.config = {
  buftype_exclude = { "terminal", "nofile" },
  char = "│",
  filetype_exclude = {
    "lspinfo",
    "help",
    "checkhealth",
    "startify",
    "dashboard",
    "packer",
    "man",
    "neogitstatus",
    "NvimTree",
  },
  show_current_context = true,
  show_first_indent_level = false,
  use_treesitter = true,
  use_treesitter_scope = false,
}

return M
