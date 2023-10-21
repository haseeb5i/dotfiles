return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      on_highlights = function(hl, c)
        -- hl.IblIndent = { fg = "#404040" }
      end,
    },
  },
  {
    "Mofiqul/dracula.nvim",
    event = "VeryLazy",
    opts = {
      italic_comment = true,
      transparent = false,
    },
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "ellisonleao/gruvbox.nvim" },
}
