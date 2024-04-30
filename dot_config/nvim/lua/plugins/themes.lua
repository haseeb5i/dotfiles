return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    opts = {
      overrides = function(colors)
        return {
          Special = {
            fg = colors.green,
            italic = false,
            nocombine = true,
          },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "night",
    },
  },
}
