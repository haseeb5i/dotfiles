return {
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

      local ts_utils = require "nvim-treesitter.ts_utils"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"

      require("cmp").event:on("confirm_done", function(evt)
        local tsnode = ts_utils.get_node_at_cursor()
        if not tsnode or tsnode:type() ~= "named_imports" then
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
        "alpha",
        "checkhealth",
        "help",
        "lspinfo",
        "lazy",
        "man",
        "neo-tree",
      },
      show_current_context = true,
      show_first_indent_level = false,
      use_treesitter = true,
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = {
      delay = 200,
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
}
