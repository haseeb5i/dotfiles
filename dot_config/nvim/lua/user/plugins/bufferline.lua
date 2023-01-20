local M = {
  "akinsho/nvim-bufferline.lua",
  version = "v3.*",
  event = "BufAdd",
  dependencies = { "moll/vim-bbye" },
  opts = {
    options = {
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",
      max_name_length = 15,
      max_prefix_length = 12,
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "Directory",
          padding = 1,
        },
        {
          filetype = "packer",
          text = "Packer",
          highlight = "PanelHeading",
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
}

return M
