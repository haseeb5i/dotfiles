return {
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-sleuth", event = "BufReadPre" },
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        registers = true,
        presets = {
          operators = false,
          nav = false,
          windows = false,
        },
      },
      window = { border = "single" },
      layout = { spacing = 4 },
    },
  },
  {
    "Shatur/neovim-session-manager",
    event = "VeryLazy",
    opts = function()
      local session_conf = require "session_manager.config"

      return {
        autoload_mode = session_conf.AutoloadMode.Disabled,
        autosave_last_session = true,
        autosave_ignore_dirs = {
          vim.env.HOME,
        },
        autosave_ignore_filetypes = {
          "alpha",
          "NvimTree",
          "neo-tree",
          "gitcommit",
        },
      }
    end,
  },
}
