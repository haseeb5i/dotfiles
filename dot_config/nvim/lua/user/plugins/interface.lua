return {
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
            filetype = "NvimTree",
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
}
