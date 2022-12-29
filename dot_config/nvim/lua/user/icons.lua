local M = {}

M.lspkind = {
  Namespace = "",
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = "ﰠ ",
  Variable = " ",
  Class = "ﴯ ",
  Interface = " ",
  Module = " ",
  Property = "ﰠ ",
  Unit = "塞 ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = "פּ ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
  Table = "",
  Object = " ",
  Tag = "",
  Array = "[]",
  Boolean = " ",
  Number = " ",
  Null = "ﳠ",
  String = " ",
  Calendar = "",
  Watch = " ",
  Package = "",
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

M.devicons = {
  default_icon = {
    icon = "",
    name = "Default",
  },
  c = {
    icon = "",
    name = "c",
  },
  deb = {
    icon = "",
    name = "deb",
  },
  mp3 = {
    icon = "",
    name = "mp3",
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
  rpm = {
    icon = "",
    name = "rpm",
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
