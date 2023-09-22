vim.cmd "set background=dark"

return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 99,
    opts = {
      style = "night",
      transparent = false,
    },
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    opts = {
      italic_comment = true,
      transparent = false,
    },
    config = function()
      vim.cmd.colorscheme "dracula"
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
      vim.cmd.colorscheme "oxocarbon"
    end,
  },
}
