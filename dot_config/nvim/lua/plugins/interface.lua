return {
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
      -- remove navic from statusline
      table.remove(opts.sections.lualine_c)

      opts.sections.lualine_y = {
        {
          function()
            local msg = "no active lsp"
            local clients = vim.lsp.get_active_clients() -- pass bufnr
            if not next(clients) then return msg end
            local buf_ft = vim.bo.filetype
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              -- stylua: ignore
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
              end
            end
            return msg
          end,
          icon = " ",
          color = { fg = "#ffffff", gui = "bold" },
        },
      }

      opts.sections.lualine_z = {
        { "location", padding = 0, separator = "" },
        {
          function()
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local curr_line = vim.api.nvim_win_get_cursor(0)[1]
            local total_lines = vim.api.nvim_buf_line_count(0)
            local line_ratio = curr_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
          end,
        },
      }
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
