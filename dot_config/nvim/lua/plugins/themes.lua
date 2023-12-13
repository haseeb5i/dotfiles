return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "night",
    },
  },
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
  { "nyoom-engineering/oxocarbon.nvim" },
  { "ellisonleao/gruvbox.nvim" },
}
