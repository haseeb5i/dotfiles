local M = {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      config = { override = require("user.icons").devicons },
    },
  },
}

-- docs => https://github.com/kyazdani42/nvim-tree.lua#setup
M.config = function()
  local icons = require "user.icons"
  local api = require "nvim-tree.api"

  local function on_attach(bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set("n", "l", api.node.open.edit, opts)
    vim.keymap.set("n", "v", api.node.open.vertical, opts)
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
  end

  require("nvim-tree").setup {
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    on_attach = on_attach,
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
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      icons = {
        glyphs = {
          git = {
            deleted = "✘",
            ignored = "",
            renamed = "➜",
            unmerged = "",
            unstaged = "", -- !
            untracked = "*", -- ?
          },
        },
      },
    },
    actions = {
      open_file = {
        window_picker = {
          exclude = {
            buftype = { "terminal", "help" },
          },
        },
      },
    },
  }
end

return M
