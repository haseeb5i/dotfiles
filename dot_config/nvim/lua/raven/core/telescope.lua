local present, telescope = pcall(require, "telescope")
if not present then
  return
end

local action_layout = require "telescope.actions.layout"

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    file_ignore_patterns = {},
    mappings = {
      i = {
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
    },
    grep_string = {
      -- could be a table in next version
      additional_args = function()
        return { "--hidden", "--glob", "!**/.git/*" }
      end,
    },
    live_grep = {
      -- hidden = true, -- will be supported in next version
      -- glob_pattern = "!**/.git/*", -- supported
      additional_args = function()
        return { "--hidden", "--glob", "!**/.git/*" }
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

telescope.load_extension "fzf"
