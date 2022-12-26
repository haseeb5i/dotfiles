local present, nvim_tree = pcall(require, "nvim-tree")
if not present then
  return
end

local devicons = require "nvim-web-devicons"
local icons = require "raven.ui.icons"

devicons.setup { override = icons.devicons }

-- local api = require("nvim-tree.api")

-- local function on_attach(bufnr)
--   vim.keymap.set("n", "<C-P>", function()
--     local node = api.tree.get_node_under_cursor()
--     print(node.absolute_path)
--   end,
-- {buffer = bufnr, noremap = true, silent = true,
-- nowait = true, desc = "print the node's absolute path" })
-- end

-- docs => https://github.com/kyazdani42/nvim-tree.lua#setup
nvim_tree.setup {
  respect_buf_cwd = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      error = icons.diagnostics.error,
      warning = icons.diagnostics.warn,
      hint = icons.diagnostics.hint,
      info = icons.diagnostics.info,
    },
  },
  git = {
    ignore = false,
    -- show_on_dirs = false, -- also removes highlights
  },
  filters = {
    custom = { "^.git$" },
  },
  view = {
    hide_root_folder = true,
    signcolumn = "yes",
    -- TODO: remvoe this in favour of on_attach key
    mappings = {
      list = {
        { key = { "<CR>", "o", "l" }, action = "edit" },
        { key = "h", action = "close_node" },
        { key = "v", action = "vsplit" },
      },
    },
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      glyphs = {
        git = {
          unstaged = "",
          unmerged = "",
          renamed = "➜",
          untracked = "*",
          ignored = "",
        },
      },
    },
  },
}
