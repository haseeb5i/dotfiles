return {
  { "nvim-lua/plenary.nvim" },
  { "folke/which-key.nvim" }, -- move to editor
  { "tpope/vim-sleuth", event = "BufReadPre" },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSCaptureUnderCursor" },
  },
  {
    "RRethy/vim-illuminate", -- move to coding
    enabled = false,
    event = "BufReadPost",
    opts = {
      delay = 200,
      filetypes_denylist = {
        "alpha",
        "NvimTree",
        "lazy",
        "mason",
        "help",
        "TelescopePrompt",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.cmd.highlight "IlluminatedWordText gui=none"
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
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
          "gitcommit",
        },
      }
    end,
  },
}
