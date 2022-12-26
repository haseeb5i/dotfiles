local present, bufferline = pcall(require, "bufferline")
if not present then
  return
end

bufferline.setup {
  options = {
    numbers = "none",
    close_command = "Bdelete! %d",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = "▎",
      style = "icon",
    },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 15,
    max_prefix_length = 12,
    tab_size = 15,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
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
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = false,
  },
  highlights = {},
}
