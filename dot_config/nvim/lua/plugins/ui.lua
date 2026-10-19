return {
  {
    "akinsho/bufferline.nvim",
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

      opts.sections.lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      }
      opts.sections.lualine_z = {
        { progress },
      }

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
        prevfile = "<c-p>",
        nextfile = "<c-n>",
      },
    },
  },
}
