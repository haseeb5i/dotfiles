vim.cmd "set background=dark"

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 99,
    opts = {
      style = "storm",
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
