return {
  -- require("lazyvim.util").telescope("")
  { "tpope/vim-sleuth", event = "BufReadPre" }, -- maybe use builtin editorconfig
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      default_component_configs = {
        git_status = {
          symbols = {
            ignored = "",
            unstaged = "",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = { ".git" },
        },
        group_empty_dirs = true,
      },
      source_selector = {
        winbar = false,
      },
      window = {
        mappings = {
          ["o"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
        },
        width = 34,
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader><space>",
        "<cmd>Telescope find_files theme=dropdown previewer=false<cr>",
        desc = "Find Files (root dir)",
      },
      {
        "<leader>,",
        "<cmd>Telescope buffers theme=dropdown previewer=false<cr>",
        desc = "Find Buffers",
      },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<esc>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    config = true,
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
    enabled = false,
  },
}
