return {
  "nvim-lua/plenary.nvim",

  -- various plugins
  "folke/which-key.nvim",
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "danymat/neogen", opts = { snippet_engine = "luasnip" } },
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
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
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = { "terminal", "nofile" },
      char = "│",
      filetype_exclude = {
        "lspinfo",
        "help",
        "checkhealth",
        "dashboard",
        "lazy",
        "man",
        "NvimTree",
      },
      show_current_context = true,
      show_first_indent_level = false,
      use_treesitter = true,
    },
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
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local ufo = require "ufo"
      vim.keymap.set("n", "zR", ufo.openAllFolds)
      vim.keymap.set("n", "zM", ufo.closeAllFolds)

      ufo.setup()
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        auto_preview = false,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
      },
      func_map = {
        prevfile = "<c-k",
        nextfile = "<c-j",
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
