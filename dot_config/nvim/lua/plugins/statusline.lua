local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local branch = {
  "b:gitsigns_head",
  icon = "",
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_lsp", "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = "  ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = "#98be65" },
    modified = { fg = "#ECBE7B" },
    removed = { fg = "#ec5f67" },
  },
  cond = conditions.buffer_not_empty,
}

local spaces = {
  function()
    return "spaces: " .. vim.bo.shiftwidth
  end,
  cond = conditions.hide_in_width,
}

local fileformat = {
  "fileformat",
  icons_enabled = false,
  cond = conditions.hide_in_width,
}

local filetype = {
  "filetype",
  icons_enabled = true,
}

local lsp = {
  function()
    local msg = "No Active LSP"
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
}

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

local location = { "location", padding = 0 }

return {
  {
    "akinsho/nvim-bufferline.lua",
    version = "v3.*",
    event = "BufAdd",
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
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        always_divide_middle = true,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch },
        lualine_c = { diagnostics, diff },
        lualine_x = { spaces, fileformat, filetype },
        lualine_y = { lsp },
        lualine_z = { location, progress },
      },
      inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "location" },
      },
      winbar = {
        -- lualine_c = { symbols },
      },
      extensions = { "neo-tree", "toggleterm" },
    },
  },
}
