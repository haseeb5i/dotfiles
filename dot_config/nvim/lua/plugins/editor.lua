return {
  { "echasnovski/mini.bufremove" },
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      close_if_last_window = true,
      hide_root_node = false,
      source_selector = {
        winbar = true,
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          with_expanders = false,
        },
        icon = {
          folder_empty = "",
        },
        git_status = {
          symbols = {
            modified = "󱈸",
            deleted = "✘",
            renamed = "»",
            ignored = "",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = { ".git" },
        },
        group_empty_dirs = true,
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 34,
        mappings = {
          ["o"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "alpha",
        "neo-tree",
        "lazy",
        "mason",
        "help",
        "TelescopePrompt",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    enabled = false,
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      -- Using ufo provider need a large value
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
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        rgb_fn = true,
        mode = "virtualtext",
        virtualtext = "■",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
    config = function(_, opts)
      local wk = require "which-key"

      wk.setup(opts)
      wk.register({
        c = { name = "Code" },
        d = { name = "DAP" },
        g = { name = "Git" },
        l = { name = "LSP" },
        p = { name = "Plugins" },
        s = { name = "Search" },
        t = { name = "Terminal" },
        w = { name = "Workspace" },
      }, { prefix = "<leader>" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {},
  },
  {
    "Shatur/neovim-session-manager",
    event = "BufReadPre",
    cmd = "SessionManager",
    opts = function()
      local session_conf = require "session_manager.config"
      return {
        autoload_mode = session_conf.AutoloadMode.Disabled,
        autosave_last_session = true,
        autosave_ignore_dirs = { vim.env.HOME },
        autosave_ignore_filetypes = {
          "alpha",
          "neo-tree",
          "gitcommit",
        },
      }
    end,
  },
  -- { "sindrets/winshift.nvim", enabled = false },
  -- { "s1n7ax/nvim-window-picker", opts = { use_winbar = "smart" } },
  -- {
  --   "mrjones2014/smart-splits.nvim",
  --   opts = {
  --     ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
  --     ignored_buftypes = { "nofile" },
  --   },
  -- },
}
