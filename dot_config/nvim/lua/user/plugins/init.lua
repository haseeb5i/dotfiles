return {
  "nvim-lua/plenary.nvim",
  -- better neovim
  "folke/which-key.nvim",
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  {
    "p00f/nvim-ts-rainbow",
    event = { "CursorHold", "CursorHoldI" },
  },
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSCaptureUnderCursor" },
  },
  -- colorschemes
  "navarasu/onedark.nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/dracula.nvim",
}
