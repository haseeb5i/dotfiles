return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "Mofiqul/dracula.nvim",
    opts = {
      overrides = function() end,
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "night",
      transparent = false,
      on_colors = function(colors)
        colors.fg_gutter = "#2E3249"
      end,
    },
  },
}
