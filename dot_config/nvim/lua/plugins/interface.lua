return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      -- local icons = require "user.icons"

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand "%:t") ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          -- component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha" },
          },
        },
        extensions = { "neo-tree", "lazy", "toggleterm" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              sections = { "error", "warn" },
              symbols = { error = " ", warn = " " },
            },
            {
              "diff",
              symbols = { added = "  ", modified = " ", removed = " " },
              cond = conditions.buffer_not_empty,
            },
          },
          lualine_x = {
            {
            -- stylua: ignore
              function() return "  " .. require("dap").status() end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              -- color = Util.fg "Debug",
            },
            {
              -- stylua: ignore
              function() return "spaces: " .. vim.bo.shiftwidth end,
              cond = conditions.hide_in_width,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              -- color = Util.fg "Special",
            },
          },
          lualine_y = {
            {
              function()
                local msg = "no active lsp"
                local clients = vim.lsp.get_active_clients() -- pass bufnr
                if not next(clients) then
                  return msg
                end
                local buf_ft = vim.bo.filetype
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end,
              icon = " ",
              color = { fg = "#ffffff", gui = "bold" },
            },
            {
              -- stylua: ignore
              function() return " " end,
              cond = function()
                local ok, clients =
                  pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
                return ok and #clients > 0
              end,
              color = { fg = "#ffffff", gui = "bold" },
            },
          },
          lualine_z = {
            {
              function()
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
              end,
            },
            { "location", padding = 0 },
          },
        },
      }
    end,
  },
  {
    "akinsho/nvim-bufferline.lua",
    version = "v3.*",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete non-pinned buffers",
      },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
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
        dashboard.button("s", "  Session", ""),
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "  Restore Session", ":SessionManager load_session<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.section.footer.val = "Raven Redstain"
      dashboard.section.footer.opts.hl = "Type"

      dashboard.opts.opts.noautocmd = true

      require("alpha").setup(dashboard.opts)
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    -- init = function()
    --   ---@diagnostic disable-next-line: duplicate-set-field
    --   vim.ui.select = function(...)
    --     require("lazy").load({ plugins = { "dressing.nvim" } })
    --     return vim.ui.select(...)
    --   end
    --   ---@diagnostic disable-next-line: duplicate-set-field
    --   vim.ui.input = function(...)
    --     require("lazy").load({ plugins = { "dressing.nvim" } })
    --     return vim.ui.input(...)
    --   end
    -- end,
    opts = {
      select = {
        backend = { "builtin", "nui" },
        nui = {
          win_options = { winblend = 3 },
        },
        builtin = {
          win_options = { winblend = 0 },
          mappings = { q = "Close" },
        },
        get_config = function(opts)
          if opts.kind == "codeaction" then
            return {
              builtin = { relative = "cursor", min_height = 0 },
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
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      --     buftype_exclude = { "terminal", "nofile" },
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "man",
        "notify",
        "toggleterm",
        "lazyterm",
        "checkhealth",
        "lspinfo",
      },
      show_first_indent_level = false,
      show_current_context = false,
      show_trailing_blankline_indent = false,
      --     use_treesitter = true,
    },
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          ---@diagnostic disable-next-line: inject-field
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
  },
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.g.navic_silence = true
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("user.icons").lspkind,
      }
    end,
  },
}
