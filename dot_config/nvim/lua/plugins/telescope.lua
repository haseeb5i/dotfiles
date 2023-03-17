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
  keys = {
    -- search
    -- stylua: ignore start
    { "<leader>b",  "<cmd> Telescope buffers theme=dropdown previewer=false <cr>",    desc = "Find Buffers", },
    { "<leader>f",  "<cmd> Telescope find_files theme=dropdown previewer=false <cr>", desc = "Find Files", },
    { "<leader>F",  "<cmd> Telescope live_grep theme=ivy <CR>",                       desc = "Live grep", },
    { "<leader>sc", "<cmd>Telescope colorscheme<cr>",                                 desc = "Colorscheme", },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                   desc = "Find Help", },
    { "<leader>sr", "<cmd>Telescope oldfiles<cr>",                                    desc = "Open Recent File", },
    { "<leader>sR", "<cmd>Telescope registers<cr>",                                   desc = "Registers", },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                     desc = "Keymaps", },
    { "<leader>sC", "<cmd>Telescope commands<cr>",                                    desc = "Commands", },
    { "<leader>sw", "<cmd>Telescope grep_string theme=ivy<cr>",                       desc = "Search Word", },
    -- git
    { "<leader>gf", "<cmd>Telescope git_files<cr>",                                   desc = "Search git files", },
    { "<leader>go", "<cmd>Telescope git_status<cr>",                                  desc = "Open changed files", },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>",                                desc = "Checkout branch", },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>",                                 desc = "Checkout commit", },
    -- stylua: ignore end
  },
}

return M
