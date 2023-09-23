-- move to editor group
return {
  "nvim-telescope/telescope.nvim",
  commit = vim.fn.has "nvim-0.9.0" == 0 and "057ee0f8783" or nil,
  version = false, -- using latest version
  cmd = "Telescope",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = function()
    local actions = require "telescope.actions"
    local action_layout = require "telescope.actions.layout"
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "absolute" },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            -- causes problems with tab completion in cmdline
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
            ["<M-p>"] = action_layout.toggle_preview,
          },
          n = {
            ["q"] = actions.close,
            ["<M-p>"] = action_layout.toggle_preview,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = false,
        },
        grep_string = {},
        live_grep = {
          glob_pattern = "!**/.git/*",
          additional_args = { "--hidden" },
        },
      },
      extensions = {
        fzf = {
          case_mode = "smart_case",
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)
    telescope.load_extension "fzf"
  end,
}
