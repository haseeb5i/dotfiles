local present, lualine = pcall(require, "lualine")
if not present then
  return
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
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
  sources = { "nvim_diagnostic" },
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
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end,
  cond = conditions.hide_in_width,
}

local encoding = {
  "o:encoding",
  cond = conditions.hide_in_width,
}

local fileformat = {
  "fileformat",
  icons_enabled = true,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  cond = conditions.hide_in_width,
}

local lsp = {
  function()
    local msg = "No Active Lsp"
    local buf_ft = vim.bo.filetype
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = " LSP:",
  color = { fg = "#ffffff", gui = "bold" },
}

local progress = function()
  local current_line = vim.fn.line "."
  local total_lines = vim.fn.line "$"
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
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local location = { "location", padding = 0 }

lualine.setup {
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
    lualine_x = { spaces, encoding, fileformat, filetype },
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
  extensions = { "nvim-tree", "toggleterm" },
}
