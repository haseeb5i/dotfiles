return {
  {
    "akinsho/bufferline.nvim",
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
      local progress = function()
        local chars = {
          "__",
          "▁▁",
          "▂▂",
          "▃▃",
          "▄▄",
          "▅▅",
          "▆▆",
          "▇▇",
          "██",
        }
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)
        local line_ratio = curr_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
      end

      table.remove(opts.sections.lualine_y, 1)
      opts.sections.lualine_z = {
        { progress },
      }

      table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("codeium"))
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
}
