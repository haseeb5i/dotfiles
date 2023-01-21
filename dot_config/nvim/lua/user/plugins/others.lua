return {
  "nvim-lua/plenary.nvim",
  "folke/which-key.nvim",
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "danymat/neogen", opts = { snippet_engine = "luasnip" } },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSCaptureUnderCursor" },
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
      vim.g.copilot_filetypes = {
        ["*"] = false,
        python = true,
        lua = true,
        typescript = true,
        typescriptreact = true,
        css = true,
        scala = true,
      }

      vim.cmd [[ imap <silent><script><expr> <C-l> copilot#Accept("\<CR>") ]]
      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        mode = "background",
        virtualtext = "■",
      },
    },
  },
  {
    "RRethy/vim-illuminate",
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
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  { "michaelb/sniprun", build = "bash ./install.sh" },
  { "sindrets/winshift.nvim", enabled = false },

  -- colorschemes
  "navarasu/onedark.nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/dracula.nvim",
  "folke/tokyonight.nvim",
}
