return {
  "nvim-telescope/telescope.nvim",
  -- tag = "0.1.1",
  version = false, -- using latest version
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = function()
    local actions = require "telescope.actions"
    local action_layout = require "telescope.actions.layout"
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "absolute" },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            -- causes problems with tab completion in cmdline
            -- ["<Tab>"] = actions.move_selection_next,
            -- ["<S-Tab>"] = actions.move_selection_previous,
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
      -- :help telescope.builtin
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
        -- live_grep = {
        --   glob_pattern = "!**/.git/*",
        --   additional_args = { "--hidden" },
        -- },
        -- grep_string = {},
      },
      extensions = {
        -- TODO: check if these are default
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
