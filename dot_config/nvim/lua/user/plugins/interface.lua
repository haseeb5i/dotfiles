return {
  { "MunifTanjim/nui.nvim" },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = require("user.icons").devicons,
      default = true,
    },
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }

      dashboard.section.header.opts.hl = "Include"

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("s", "  Session", ":SessionManager load_session<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.section.footer.val = "Raven Redstain"
      dashboard.section.footer.opts.hl = "Type"

      dashboard.opts.opts.noautocmd = true

      require("alpha").setup(dashboard.opts)
    end,
  },
  {
    "akinsho/nvim-bufferline.lua",
    version = "v3.*",
    event = "BufAdd",
    dependencies = { "moll/vim-bbye" },
    opts = {
      options = {
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        max_name_length = 15,
        max_prefix_length = 12,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            padding = 1,
          },
        },
        diagnostics_indicator = function(count, level)
          local icon = level:match "error" and " " or " "
          return " " .. icon .. count
        end,
        separator_style = "thin",
        always_show_bufferline = false,
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "builtin" },
        builtin = {
          win_options = {
            winblend = 0,
          },
        },
        get_config = function(opts)
          if opts.kind == "codeaction" then
            return {
              builtin = {
                relative = "cursor",
                min_height = 0,
              },
            }
          end
        end,
      },
    },
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
    "SmiteshP/nvim-navic",
    enabled = false,
    opts = {
      separator = " ",
      highlight = true,
      depth_limit = 5,
    },
  },
}
