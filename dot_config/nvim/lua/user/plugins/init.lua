return {
  "nvim-lua/plenary.nvim",
  "folke/which-key.nvim",
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- colorschemes
  "navarasu/onedark.nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/dracula.nvim",
}
