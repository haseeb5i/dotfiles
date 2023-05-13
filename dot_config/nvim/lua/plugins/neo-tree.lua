return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  dependencies = { "MunifTanjim/nui.nvim" },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  opts = {
    close_if_last_window = true,
    hide_root_node = false,
    source_selector = {
      winbar = false,
      content_layout = "center",
      tab_labels = {
        filesystem = "  Files",
        buffers = "  Bufs",
      },
    },
    default_component_configs = {
      indent = { padding = 0, indent_size = 1 },
      icon = { folder_empty = "" },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          ignored = "",
        },
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        never_show = { ".git" },
      },
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      group_empty_dirs = true,
      use_libuv_file_watcher = true,
    },
    window = {
      width = 30,
      mappings = {
        o = "open",
        l = "open",
        h = "close_node",
      },
    },
  },
}
