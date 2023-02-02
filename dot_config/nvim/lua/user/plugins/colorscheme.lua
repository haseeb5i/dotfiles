vim.cmd "set background=dark"

return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      italic_comment = true,
      transparent = false,
    },
    config = function()
      vim.cmd.colorscheme "dracula"
    end,
  },
  {
    "navarasu/onedark.nvim",
    opts = { style = "darker" },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      undercurl = true,
      underline = true,
      bold = false,
      italic = false,
      invert_signs = false,
      invert_tabline = false,
    },
    config = function()
      vim.cmd.colorscheme "gruvbox"
    end,
  },
}
