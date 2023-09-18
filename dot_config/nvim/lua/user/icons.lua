local M = {}

M.lspkind = {
  Array = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Namespace = " ",
  Null = " ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

M.diagnostics = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = " ",
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
    icon = "󰚩",
    name = "robots",
  },
  ttf = {
    icon = "",
    name = "TrueTypeFont",
  },
  woff2 = {
    icon = "",
    name = "WebOpenFontFormat2",
  },
  zip = {
    icon = "",
    name = "zip",
  },
}

return M
