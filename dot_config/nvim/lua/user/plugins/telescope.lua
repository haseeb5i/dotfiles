local M = {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.0",
  version = false, -- using latest version
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = function()
    local action_layout = require "telescope.actions.layout"
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "absolute" },
        file_ignore_patterns = {},
        mappings = {
          i = {
            ["<esc>"] = "close",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<Tab>"] = "move_selection_next",
            ["<S-Tab>"] = "move_selection_previous",
            ["<Down>"] = "cycle_history_next",
            ["<Up>"] = "cycle_history_prev",
            ["<M-p>"] = action_layout.toggle_preview,
          },
          n = {
            ["q"] = "close",
            ["<M-p>"] = action_layout.toggle_preview,
          },
        },
      },
      -- make sure rg is available
      pickers = {
        find_files = {
          find_command = {
            "rg",
            "--files",
            "--color",
            "never",
            "--glob",
            "!**/.git/*",
          },
          hidden = true, -- injected to the find_command
        },
        live_grep = {
          glob_pattern = "!**/.git/*",
          -- hidden = true, -- will be supported in next version
          additional_args = function()
            return { "--hidden" }
          end,
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

return M
