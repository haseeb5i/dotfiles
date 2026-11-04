return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme(vim.o.background == "light" and "rose-pine" or "dracula")
      end,
    },
  },
  { "rose-pine/neovim", name = "rose-pine" },
  { "nuvic/flexoki-nvim", name = "flexoki" },
  { "Mofiqul/dracula.nvim" },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },
}
