local M = {}

M.lspkind = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = " ",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  Event = " ",
  Table = "",
  Array = "[]",
  Boolean = " ",
  Number = " ",
  Null = "ﳠ",
  Calendar = "",
  Package = "",
  Tag = "",
  Namespace = "",
  TypeParameter = " ",
  Object = " ",
  String = " ",
  Watch = " ",
}

M.diagnostics = {
  error = "",
  warn = "",
  info = "",
  hint = "",
}

M.statusline_separators = {
  default = {
    left = "",
    right = " ",
  },

  round = {
    left = "",
    right = "",
  },

  block = {
    left = "█",
    right = "█",
  },

  arrow = {
    left = "",
    right = "",
  },
}

-- eslint icon from nerd font
M.devicons = {
  c = {
    icon = "",
    name = "c",
  },
  mp4 = {
    icon = "",
    name = "mp4",
  },
  out = {
    icon = "",
    name = "out",
  },
  ["robots.txt"] = {
    icon = "ﮧ",
    name = "robots",
  },
  ttf = {
    icon = "",
    name = "TrueTypeFont",
  },
  woff = {
    icon = "",
    name = "WebOpenFontFormat",
  },
  woff2 = {
    icon = "",
    name = "WebOpenFontFormat2",
  },
  xz = {
    icon = "",
    name = "xz",
  },
  zip = {
    icon = "",
    name = "zip",
  },
}

return M
