return {
  { "ellisonleao/gruvbox.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "Mofiqul/dracula.nvim",
    opts = {
      italic_comment = true,
      transparent = false,
    },
  },
  {
    "RRethy/vim-illuminate",
    opts = {
      filetypes_denylist = {
        "alpha",
        "neo-tree",
        "lazy",
        "mason",
        "help",
        "TelescopePrompt",
      },
    },
  },
  {
    "akinsho/nvim-bufferline.lua",
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            padding = 1,
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- remove navic from statusline
      table.remove(opts.sections.lualine_c)
      -- remove filename from statusline
      -- table.remove(opts.sections.lualine_c)

      -- opts.winbar = {
      --   lualine_c = {
      --     {
      --       "filename",
      --       path = 1,
      --       symbols = {
      --         modified = "  ",
      --         readonly = "",
      --         unnamed = "",
      --       },
      --     },
      --     {
      --       "navic",
      --       color_correction = nil,
      --       navic_opts = nil,
      --     },
      --   },
      -- }
      --
      -- opts.disabled_filetypes = {
      --   winbar = { "neo-tree" },
      -- }
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        builtin = {
          mappings = { q = "Close" },
          win_options = { winblend = 10 },
        },
        get_config = function(opts)
          if opts.kind == "codeaction" then
            return {
              backend = "builtin",
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
        prevfile = "<c-p",
        nextfile = "<c-n",
      },
    },
  },
  -- { "sindrets/winshift.nvim", enabled = false },
}
