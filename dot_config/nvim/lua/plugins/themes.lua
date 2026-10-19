return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "flexoki",
    },
  },
  {
    "nuvic/flexoki-nvim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "auto",
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
  {
    "Mofiqul/dracula.nvim",
    opts = {
      overrides = function() end,
    },
  },
}
