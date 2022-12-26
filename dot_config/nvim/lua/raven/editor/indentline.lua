local status_ok, indentline = pcall(require, "indent_blankline")
if not status_ok then
  return
end

indentline.setup {
  buftype_exclude = { "terminal", "nofile" },
  char = "▏",
  filetype_exclude = {
    "lspinfo",
    "help",
    "checkhealth",
    "startify",
    "dashboard",
    "packer",
    "man",
    "neogitstatus",
    "NvimTree",
  },
  show_current_context = true,
  show_current_context_start = false,
  show_first_indent_level = false,
  show_trailing_blankline_indent = true,
  use_treesitter = true,
  use_treesitter_scope = false,
}

-- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = "99999"
