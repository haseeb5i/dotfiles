local M = {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.0",
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
}

function M.config()
  local telescope = require "telescope"
  local action_layout = require "telescope.actions.layout"

  -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
  telescope.setup {
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
          -- ["<Tab>"] = "move_selection_next",
          -- ["<S-Tab>"] = "move_selection_previous",
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
        find_command = { "rg", "--files", "--color", "never", "--glob", "!**/.git/*" },
        hidden = true, -- injected to the find_command
        -- path_display = function(opts, path) end
      },
      live_grep = {
        -- hidden = true, -- will be supported in next version
        -- glob_pattern = "!**/.git/*",
        -- additional_args = function()
        --   return { "--hidden" }
        -- end,
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

  telescope.load_extension "fzf"
end

return M
