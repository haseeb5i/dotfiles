return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "MunifTanjim/nui.nvim" },
    deactivate = function()
      vim.cmd "Neotree close"
    end,
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
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
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
    -- event = "VeryLazy",
    opts = {
      -- filetypes = { "*", "!lazy" },
      -- buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        rgb_fn = true,
        mode = "virtualtext", -- "background"
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
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    enabled = false,
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "Shatur/neovim-session-manager",
    event = "BufWritePost",
    cmd = "SessionManager",
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
          "neo-tree",
          "gitcommit",
        },
      }
    end,
  },
}
-- {
--   "folke/persistence.nvim",
--   event = "BufReadPre",
--   opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
--   -- stylua: ignore
--   keys = {
--     { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
--     { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
--     { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
--   },
-- },
-- { "sindrets/winshift.nvim", enabled = false },
-- { "s1n7ax/nvim-window-picker", opts = { use_winbar = "smart" } },
-- {
--   "mrjones2014/smart-splits.nvim",
--   opts = {
--     ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
--     ignored_buftypes = { "nofile" },
--   },
-- },
