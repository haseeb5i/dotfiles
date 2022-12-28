local M = {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
}

M.config = {
  auto_enable = true,
  preview = {
    auto_preview = false,
    win_height = 12,
    win_vheight = 12,
    delay_syntax = 80,
    border_chars = {
      "│",
      "│",
      "─",
      "─",
      "╭",
      "╮",
      "╰",
      "╯",
      "█",
    },
  },
  func_map = {
    vsplit = "",
    open = "<CR>",
    prevfile = "<c-k",
    nextfile = "<c-j",
  },
}

return M
