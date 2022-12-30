return {
  "nvim-lua/plenary.nvim",

  -- better neovim
  "folke/which-key.nvim",
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
  {
    "p00f/nvim-ts-rainbow",
    event = { "CursorHold", "CursorHoldI" },
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSCaptureUnderCursor" },
  },

  -- colorschemes
  "navarasu/onedark.nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/dracula.nvim",
}
