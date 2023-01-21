return {
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
    config = function()
      local ts_utils = require "nvim-treesitter.ts_utils"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"

      require("cmp").event:on("confirm_done", function(evt)
        local tsnode = ts_utils.get_node_at_cursor()
        if tsnode:type() ~= "named_imports" then
          cmp_autopairs.on_confirm_done()(evt)
        end
      end)
    end,
  },
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
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
}
