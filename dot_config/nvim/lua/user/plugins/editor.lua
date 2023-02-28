return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = { "Neotree" },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      hide_root_node = true,
      default_component_configs = {
        icon = {
          folder_empty = "",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
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
        follow_current_file = true,
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    cond = function()
      vim.fn.system("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse")
      return vim.v.shell_error == 0
    end,
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
      },
      preview_config = { border = "rounded" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = true,
  },
  { "akinsho/git-conflict.nvim", config = true },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      local integration = require "ts_context_commentstring.integrations.comment_nvim"

      return {
        ignore = "^$",
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
        pre_hook = integration.create_pre_hook(),
      }
    end,
    keys = {
      "gc",
      "gb",
      {
        vim.g.neovide and "<C-/>" or "<C-_>",
        function()
          return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
            or "<Plug>(comment_toggle_linewise_count)"
        end,
        expr = true,
      },
      {
        vim.g.neovide and "<C-/>" or "<C-_>",
        "<Plug>(comment_toggle_linewise_visual)",
        mode = "v",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
      },
      fast_wrap = {
        map = "<M-e>",
        highlight = "PmenuSel",
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local ts_utils = require "nvim-treesitter.ts_utils"

      require("cmp").event:on("confirm_done", function(evt)
        local tsnode = ts_utils.get_node_at_cursor()
        if tsnode:type() ~= "named_imports" then
          cmp_autopairs.on_confirm_done()(evt)
        end
      end)
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
        "neo-tree",
      },
      show_current_context = true,
      show_first_indent_level = false,
      use_treesitter = true,
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    enabled = false,
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
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    enabled = false,
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
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  { "sindrets/winshift.nvim", enabled = false },
}
